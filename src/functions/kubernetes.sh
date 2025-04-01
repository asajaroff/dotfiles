#!/usr/bin/env bash
# Kubernetes functions
# Alejandro Sajaroff <asajaroff@users.noreply.github.com>

function pods_in_node() {
    if [ -z "$1" ]; then
        echo "Error: Must provide a valid node name"
        return 1
    fi
    for NODE in $*
    do
        kubectl get pods --all-namespaces -o wide --field-selector spec.nodeName=${NODE}
    done
}