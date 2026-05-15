#!/usr/bin/env bash

HELM_CHART_NAME='../eureka'
HELM_RELEASE_NAME='eureka'
NAMESPACE='sre'

if [ -z "$1" ]; then
    echo "No argument supplied"
    echo ""
    echo "Usage: ${0} <PARAMS> <OPTS>"
    echo "Available OPTS:"
    printf "\t- %s: " install
    exit 1
fi

case "${1}" in
render)
    printf "Running 'render' subcommand:\n\n"
    set -x
    helm3 upgrade --install \
        -f values.yaml \
        --debug \
        --create-namespace \
        -n "${NAMESPACE}" \
        --dry-run \
        "${HELM_RELEASE_NAME}" "${HELM_CHART_NAME}"
    set +x
    ;;

install)
    set -x
    helm3 upgrade --install \
        -f values.yaml \
        --debug \
        --create-namespace \
        -n "${NAMESPACE}" \
        "${HELM_RELEASE_NAME}" "${HELM_CHART_NAME}"
    set +x
    ;;

clean)
    set -x
    helm3 uninstall \
        --cascade foreground \
        --wait \
        -n "${NAMESPACE}" \
        "${HELM_RELEASE_NAME}"
    set -x
    ;;

*)
    echo "ERROR: subcommand not available."
    ;;

esac
