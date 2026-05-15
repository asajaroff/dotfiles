#!/usr/bin/env bash

set -euo pipefail

CONTEXT="${1:-}"
NODE="${2:-}"
NAMESPACE="rook-ceph"
KUBECTL="kubectl --context ${CONTEXT} -n ${NAMESPACE}"
RESTART_DELAY=20  # seconds to wait between OSD restarts

usage() {
    echo "Usage: $0 <context> <node-name>"
    echo "  context:   kubectl context to use (e.g. aus1cm1)"
    echo "  node-name: Kubernetes node whose OSDs will be restarted"
    exit 1
}

unset_maintenance_flags() {
    echo "Unsetting OSD maintenance flags..."
    ${KUBECTL} exec -ti deployment/rook-ceph-tools -- ceph osd unset noout
    ${KUBECTL} exec -ti deployment/rook-ceph-tools -- ceph osd unset norebalance
    ${KUBECTL} exec -ti deployment/rook-ceph-tools -- ceph osd unset nobackfill
}

if [[ -z "${CONTEXT}" || -z "${NODE}" ]]; then
    usage
fi

printf "Context  : %s\n" "${CONTEXT}"
printf "Namespace: %s\n" "${NAMESPACE}"
printf "Node     : %s\n" "${NODE}"
printf "\nAbout to rollout all OSDs from <%s>\n" "${NODE}"

# Pre-flight: verify cluster health
${KUBECTL} exec -ti deployment/rook-ceph-tools -- ceph -s | grep 'health: '

# Pre-flight: verify node exists
if ! ${KUBECTL} get node "${NODE}" &>/dev/null; then
    echo "ERROR: node '${NODE}' not found in context '${CONTEXT}'"
    exit 1
fi
echo "Node ${NODE} exists"

# Pre-flight: check if maintenance flags are already set
if ${KUBECTL} exec -ti deployment/rook-ceph-tools -- ceph osd dump \
    | grep -qE 'flags.*noout'; then
    echo "WARNING: cluster already has 'noout' set — a previous run may have left it in maintenance mode."
    echo "Resolve this manually before re-running."
    exit 1
fi

# Ensure maintenance flags are always unset on exit (normal or error)
trap unset_maintenance_flags ERR EXIT

# Put the cluster in maintenance mode
${KUBECTL} exec -ti deployment/rook-ceph-tools -- ceph osd set noout
${KUBECTL} exec -ti deployment/rook-ceph-tools -- ceph osd set norebalance
${KUBECTL} exec -ti deployment/rook-ceph-tools -- ceph osd set nobackfill

for deployment in $(${KUBECTL} get deploy \
    -l app=rook-ceph-osd,topology-location-host="${NODE}" \
    --no-headers -o custom-columns=NAME:.metadata.name);
do
    ${KUBECTL} rollout restart deployment/"${deployment}"
    ${KUBECTL} rollout status deployment/"${deployment}" --watch --timeout 5m
    sleep "${RESTART_DELAY}"
    # If these two are ok, continue
    ${KUBECTL} exec -ti deployment/rook-ceph-tools -- ceph osd status | grep -v up
    sleep 3
    ${KUBECTL} exec -ti deployment/rook-ceph-tools -- ceph -s | grep 'health: '
    sleep 3
done

# trap will call unset_maintenance_flags on clean exit
sleep 5
${KUBECTL} exec -ti deployment/rook-ceph-tools -- ceph -s
