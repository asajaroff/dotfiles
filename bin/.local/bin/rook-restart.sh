#!/usr/bin/env bash

set -euo pipefail

CONTEXT="${1:-}"
NODE="${2:-}"
NAMESPACE="rook-ceph"
KUBECTL=(kubectl --context "${CONTEXT}" -n "${NAMESPACE}")
RESTART_DELAY=20    # seconds to wait between OSD restarts
ROLLOUT_TIMEOUT=300 # seconds to wait for a single OSD deployment to roll out
POLL_INTERVAL=5     # seconds between rollout status polls

usage() {
    echo "Usage: $0 <context> <node-name>"
    echo "  context:   kubectl context to use (e.g. aus1cm1)"
    echo "  node-name: Kubernetes node whose OSDs will be restarted"
    exit 1
}

unset_maintenance_flags() {
    echo "Unsetting OSD maintenance flags..."
    "${KUBECTL[@]}" exec deployment/rook-ceph-tools -- ceph osd unset noout
    "${KUBECTL[@]}" exec deployment/rook-ceph-tools -- ceph osd unset norebalance
    "${KUBECTL[@]}" exec deployment/rook-ceph-tools -- ceph osd unset nobackfill
}

# Polls `kubectl get` (not `rollout status --watch`) so it can't get stuck on
# the client-go informer "event bookmark expired" watch bug, and enforces its
# own timeout regardless of what the watch API is doing.
wait_for_rollout() {
    local deployment="$1"
    local elapsed=0
    local desired updated ready available

    echo "Waiting for deployment/${deployment} to roll out (timeout: ${ROLLOUT_TIMEOUT}s)..."
    while (( elapsed < ROLLOUT_TIMEOUT )); do
        # `read < <(cmd)` fails (and would abort the script under `set -e`) if
        # the kubectl call has a transient hiccup and produces no output, OR
        # if jsonpath's output has no trailing newline (it doesn't, by
        # default) — the trailing {"\n"} avoids the latter; the `if !` still
        # guards against genuine transient failures.
        if ! read -r desired updated ready available < <(
            "${KUBECTL[@]}" get deployment "${deployment}" \
                -o jsonpath='{.spec.replicas} {.status.updatedReplicas} {.status.readyReplicas} {.status.availableReplicas}{"\n"}'
        ); then
            echo "  WARNING: could not query deployment/${deployment} status, retrying (${elapsed}s elapsed)..."
            sleep "${POLL_INTERVAL}"
            elapsed=$(( elapsed + POLL_INTERVAL ))
            continue
        fi
        updated="${updated:-0}"; ready="${ready:-0}"; available="${available:-0}"

        if [[ "${desired}" == "${updated}" && "${desired}" == "${ready}" && "${desired}" == "${available}" ]]; then
            echo "deployment/${deployment} successfully rolled out (${elapsed}s)"
            return 0
        fi

        printf "  ready=%s/%s updated=%s/%s available=%s/%s (%ss elapsed)\n" \
            "${ready}" "${desired}" "${updated}" "${desired}" "${available}" "${desired}" "${elapsed}"
        sleep "${POLL_INTERVAL}"
        elapsed=$(( elapsed + POLL_INTERVAL ))
    done

    echo "ERROR: timed out waiting for deployment/${deployment} to roll out after ${ROLLOUT_TIMEOUT}s"
    return 1
}

if [[ -z "${CONTEXT}" || -z "${NODE}" ]]; then
    usage
fi

printf "Context  : %s\n" "${CONTEXT}"
printf "Namespace: %s\n" "${NAMESPACE}"
printf "Node     : %s\n" "${NODE}"
printf "\nAbout to rollout all OSDs from <%s>\n" "${NODE}"

# Pre-flight: verify cluster health
health="$("${KUBECTL[@]}" exec deployment/rook-ceph-tools -- ceph -s | grep 'health: ' | awk '{print $2}')"
echo "health: ${health}"
if [[ "${health}" != "HEALTH_OK" ]]; then
    echo "ERROR: cluster health is '${health}', expected HEALTH_OK. Resolve this before restarting OSDs."
    exit 1
fi

# Pre-flight: verify node exists
if ! "${KUBECTL[@]}" get node "${NODE}" &>/dev/null; then
    echo "ERROR: node '${NODE}' not found in context '${CONTEXT}'"
    exit 1
fi
echo "Node ${NODE} exists"

# Pre-flight: check if maintenance flags are already set
if "${KUBECTL[@]}" exec deployment/rook-ceph-tools -- ceph osd dump \
    | grep -qE 'flags.*noout'; then
    echo "WARNING: cluster already has 'noout' set — a previous run may have left it in maintenance mode."
    echo "Resolve this manually before re-running."
    exit 1
fi

# Ensure maintenance flags are always unset on exit (normal, error, or signal)
trap unset_maintenance_flags EXIT

# Put the cluster in maintenance mode
"${KUBECTL[@]}" exec deployment/rook-ceph-tools -- ceph osd set noout
"${KUBECTL[@]}" exec deployment/rook-ceph-tools -- ceph osd set norebalance
"${KUBECTL[@]}" exec deployment/rook-ceph-tools -- ceph osd set nobackfill

skipped=()
failed=()

for deployment in $("${KUBECTL[@]}" get deploy \
    -l app=rook-ceph-osd,topology-location-host="${NODE}" \
    --no-headers -o custom-columns=NAME:.metadata.name);
do
    # Skip deployments that are already unhealthy before we touch them (e.g. a
    # missing/failed backing disk). Restarting won't fix that, and waiting for
    # it to roll out would just time out and abort the rest of the node.
    if ! read -r pre_ready pre_desired < <(
        "${KUBECTL[@]}" get deployment "${deployment}" \
            -o jsonpath='{.status.readyReplicas} {.spec.replicas}{"\n"}'
    ); then
        echo "SKIPPING deployment/${deployment}: could not query status before restart — investigate separately."
        skipped+=("${deployment}")
        continue
    fi
    pre_ready="${pre_ready:-0}"
    if [[ "${pre_ready}" != "${pre_desired}" ]]; then
        echo "SKIPPING deployment/${deployment}: already not ready (${pre_ready}/${pre_desired}) before restart — investigate separately."
        skipped+=("${deployment}")
        continue
    fi

    "${KUBECTL[@]}" rollout restart deployment/"${deployment}"
    if ! wait_for_rollout "${deployment}"; then
        echo "WARNING: deployment/${deployment} failed to roll out — continuing with the rest of the node."
        failed+=("${deployment}")
        continue
    fi
    sleep "${RESTART_DELAY}"
    # Informational: show any OSD not currently "up". An all-healthy result
    # means grep matches nothing (exit 1) — `|| true` keeps that from being
    # mistaken for a failure under `set -e -o pipefail`.
    "${KUBECTL[@]}" exec deployment/rook-ceph-tools -- ceph osd status | grep -v up || true
    sleep 3
    # Same story as above: a transient exec/ceph hiccup here must not take
    # down the whole node's restart loop via `set -e -o pipefail`.
    "${KUBECTL[@]}" exec deployment/rook-ceph-tools -- ceph -s | grep 'health: ' \
        || echo "  WARNING: could not read cluster health after restarting deployment/${deployment}"
    sleep 3
done

# trap will call unset_maintenance_flags on clean exit
sleep 5
"${KUBECTL[@]}" exec deployment/rook-ceph-tools -- ceph -s || true

if (( ${#skipped[@]} > 0 )); then
    printf '\nSkipped (already unhealthy before restart): %s\n' "${skipped[*]}"
fi
if (( ${#failed[@]} > 0 )); then
    printf '\nFAILED to roll out: %s\n' "${failed[*]}"
    exit 1
fi
