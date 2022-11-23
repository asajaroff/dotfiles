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

# kops
get_kops() {
	curl -L https://github.com/kubernetes/kops/releases/download/$1/kops-linux-amd64 -o kops-$1
	move_to_path ./kops-$1
	ln -sf /usr/local/bin/kops-$1 /usr/local/bin/kops
}

# kubernetes-cli
KUBERNETES_CLI_VERSION=v.1.24.0
get_kubernetes() {
	curl -LO "https://dl.k8s.io/release/${1}/bin/linux/amd64/kubectl"
	move_to_path ./kubectl-$1
	ln -sf /usr/local/bin/kubectl-$1 /usr/local/bin/kubectl
}

# terraform
get_terraform() {
	curl -L "https://releases.hashicorp.com/terraform/$1/terraform_$1_linux_amd64.zip" -o terraform-v$1
	move_to_path ./terraform-v1$1
}

# helm
HELM_VERSION=v3.10.2
get_helm() {
	curl -LO "https://get.helm.sh/helm-$1-linux-amd64.tar.gz"
	move_to_path ./helm-$1
	ln -sf /usr/local/bin/helm-$1 /usr/local/bin/helm
}

# `get_kops v1.20.1
# `get_kops v1.21.5
# `get_kops v1.22.6
# `get_kops $KOPS_VERSION
