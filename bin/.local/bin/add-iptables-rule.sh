#!/bin/bash
# Add an iptables INPUT rule to a list of nodes, live and persisted, then
# verify it actually took.
#
# For each node this:
#   1. adds the rule live with `iptables -A` (skipped if already present)
#   2. adds the same rule to /var/lib/iptables/rules-save so it survives a
#      reboot (skipped if already present)
#   3. re-checks both and prints PRESENT/MISSING for each
#
# Safe to re-run: every step checks first, so nothing is added twice.
#
# Usage:
#   ./add-iptables-rule.sh -r "<rule args>" -n "host1 host2 host3"
#   ./add-iptables-rule.sh -r "<rule args>" -f nodes.txt
#
# The rule is everything iptables needs *after* "-A INPUT", exactly as you'd
# type it by hand. Quote it as one argument.
#
# Example:
#   ./add-iptables-rule.sh \
#     -r '-p udp -d 96.9.121.16/32 --dport 3478 -j ACCEPT -m comment --comment "INFRA2-14371 stunner turn public"' \
#     -n "s599 s600 s601"
#
# nodes.txt format: one short hostname per line, blank lines and "#" comments ignored.
#
# Env overrides:
#   SSH_KEY     path to the ssh key            (default: ~/.ssh/brivo)
#   NODE_DOMAIN domain suffix appended to hosts (default: eencloud.com)
#   RULES_FILE  persisted rules file on the node (default: /var/lib/iptables/rules-save)

set -euo pipefail

SSH_KEY="${SSH_KEY:-$HOME/.ssh/brivo}"
NODE_DOMAIN="${NODE_DOMAIN:-eencloud.com}"
RULES_FILE="${RULES_FILE:-/var/lib/iptables/rules-save}"
CHAIN="INPUT"
RULE=""
HOSTS=""
HOSTS_FILE=""

usage() {
  sed -n '2,29p' "$0" | sed 's/^# \{0,1\}//'
  exit 1
}

while getopts "r:n:f:c:h" opt; do
  case "$opt" in
    r) RULE="$OPTARG" ;;
    n) HOSTS="$OPTARG" ;;
    f) HOSTS_FILE="$OPTARG" ;;
    c) CHAIN="$OPTARG" ;;
    h) usage ;;
    *) usage ;;
  esac
done

[ -n "$RULE" ] || usage

if [ -n "$HOSTS_FILE" ]; then
  [ -f "$HOSTS_FILE" ] || { echo "no such file: $HOSTS_FILE" >&2; exit 1; }
  HOSTS="$(grep -vE '^\s*(#|$)' "$HOSTS_FILE" | tr '\n' ' ')"
fi
[ -n "$HOSTS" ] || usage

SSH="ssh -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8 -i $SSH_KEY"

log() {
  # log LEVEL message...
  local level="$1"; shift
  printf '%s [%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$level" "$*"
}

# The rule may contain spaces and quotes (e.g. -m comment --comment "some text").
# Passing it as an ssh command-line argument is a trap: ssh joins remote argv
# into one string before the remote shell re-parses it, silently word-splitting
# anything with spaces. Base64-encoding it sidesteps that entirely.
RULE_B64="$(printf '%s' "$RULE" | base64 -w0)"

host_count=0
for _ in $HOSTS; do host_count=$((host_count + 1)); done
i=0
ok_count=0
failed_hosts=()
failed_reasons=()
for host in $HOSTS; do
  i=$((i + 1))
  log INFO "[$i/$host_count] $host: connecting..."

  set +e
  $SSH "core@${host}.${NODE_DOMAIN}" bash -s -- "$CHAIN" "$RULE_B64" "$RULES_FILE" <<'REMOTE'
set -euo pipefail
CHAIN="$1"
RULE="$(printf '%s' "$2" | base64 -d)"
FILE="$3"

# eval re-parses RULE through the shell, so quoted pieces (like a multi-word
# --comment) stay together as one argument instead of being split on spaces.
CHECK="sudo iptables -C $CHAIN $RULE"
ADD="sudo iptables -A $CHAIN $RULE"

if eval "$CHECK" 2>/dev/null; then
  echo "live: already present"
else
  eval "$ADD"
  echo "live: added"
fi

LINE="-A ${CHAIN} ${RULE}"
# "--" tells grep the pattern is done being an option, even though the rule
# starts with "-A" (which grep would otherwise read as its own -A/context flag)
if sudo grep -qxF -- "$LINE" "$FILE"; then
  echo "persisted: already present"
else
  # append just before the *filter table's closing COMMIT (the first one in the file)
  sudo awk -v line="$LINE" '!done && /^COMMIT$/ { print line; done=1 } { print }' "$FILE" \
    | sudo tee "${FILE}.tmp" >/dev/null
  sudo mv "${FILE}.tmp" "$FILE"
  echo "persisted: added"
fi

echo -n "verify live: "; eval "$CHECK" 2>/dev/null && echo PRESENT || echo MISSING
echo -n "verify persisted: "; sudo grep -qxF -- "$LINE" "$FILE" && echo PRESENT || echo MISSING
REMOTE
  rc=$?
  set -e

  if [ "$rc" -eq 0 ]; then
    log INFO "[$i/$host_count] $host: OK"
    ok_count=$((ok_count + 1))
  elif [ "$rc" -eq 255 ]; then
    log ERROR "[$i/$host_count] $host: SSH connection/authentication failed (exit 255) — check network reachability, host key, and that this key is authorized on $host"
    failed_hosts+=("$host")
    failed_reasons+=("$host: ssh connection/auth failure (exit 255)")
  else
    log ERROR "[$i/$host_count] $host: remote script failed (exit $rc) — see output above for how far it got"
    failed_hosts+=("$host")
    failed_reasons+=("$host: remote script error (exit $rc)")
  fi
  echo
done

log INFO "finished: $ok_count/$host_count hosts OK"
if [ "${#failed_hosts[@]}" -gt 0 ]; then
  log ERROR "hosts needing attention: ${failed_hosts[*]}"
  printf '  %s\n' "${failed_reasons[@]}"
  exit 1
fi
log INFO "all hosts OK"
