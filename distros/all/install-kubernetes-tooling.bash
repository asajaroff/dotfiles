#!/usr/bin/bash

set -e

curl -LO "https://dl.k8s.io/release/v1.15.12/bin/linux/amd64/kubectl"
sudo mv kubectl /usr/bin/kubectl-1.15
sudo chmod +x /usr/bin/kubectl-1.15

curl -LO "https://dl.k8s.io/release/v1.17.17/bin/linux/amd64/kubectl"
sudo mv kubectl /usr/bin/kubectl-1.17
sudo chmod +x /usr/bin/kubectl-1.17

curl -LO "https://dl.k8s.io/release/v1.19.16/bin/linux/amd64/kubectl"
sudo mv kubectl /usr/bin/kubectl-1.19
sudo chmod +x /usr/bin/kubectl-1.19

curl -LO "https://dl.k8s.io/release/v1.21.16/bin/linux/amd64/kubectl"
sudo mv kubectl /usr/bin/kubectl-1.21
sudo chmod +x /usr/bin/kubectl-1.21

curl -LO "https://dl.k8s.io/release/v1.21.16/bin/linux/amd64/kubectl"
sudo mv kubectl /usr/bin/kubectl-1.21
sudo chmod +x /usr/bin/kubectl-1.21

curl -LO "https://dl.k8s.io/release/v1.23.17/bin/linux/amd64/kubectl"
sudo mv kubectl /usr/bin/kubectl-1.23
sudo chmod +x /usr/bin/kubectl-1.23

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo mv kubectl /usr/bin/kubectl-latest
sudo chmod +x /usr/bin/kubectl-latest


# Helm 3
#
wget https://get.helm.sh/helm-v3.17.3-linux-amd64.tar.gz
tar -xvf helm-v3.17.3-linux-amd64.tar.gz
sudo sudo mv linux-amd64/helm /usr/local/bin/helm-v3.17
rm -rf ./helm-v3.17.3* ./linux-amd64