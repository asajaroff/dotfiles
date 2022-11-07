#!/bin/bash

set -euxo pipefail

KOPS_VERSION=v1.19.3

move_to_path() {
# Move to /usr/local/bin
	if [[ -n "$1" ]]; then
		chmod +x $1
		mv $1 /usr/local/bin/$1
		return 0
	else
		echo "Issue when moving file"
		exit
	fi
}

# kubernetes-cli
get_kubernetes() {
	curl -L https://github.com/kubernetes/kops/releases/download/$1/kops-linux-amd64 -o kubectl-$1
	move_to_path ./kubectl-$1
	ln -sf /usr/local/bin/kops-$1 /usr/local/bin/kubectl
}

# kops
get_kops() {
	curl -LO "https://dl.k8s.io/release/v.1.24.0/bin/linux/amd64/kubectl"
	move_to_path ./kubectl-$1
	ln -sf /usr/local/bin/kubectl-$1 /usr/local/bin/kubectl
}

get_kops v1.20.1
get_kops v1.21.5
get_kops v1.22.6
get_kops $KOPS_VERSION
