#!/usr/bin/env bash

set -x

curl -LO "https://dl.k8s.io/release/v1.15.12/bin/linux/amd64/kubectl"
sudo mv kubectl /usr/local/bin/kubectl-1.15
sudo chmod +x /usr/local/bin/kubectl-1.15

curl -LO "https://dl.k8s.io/release/v1.17.17/bin/linux/amd64/kubectl"
sudo mv kubectl /usr/local/bin/kubectl-1.17
sudo chmod +x /usr/local/bin/kubectl-1.17

curl -LO "https://dl.k8s.io/release/v1.19.16/bin/linux/amd64/kubectl"
sudo mv kubectl /usr/local/bin/kubectl-1.19
sudo chmod +x /usr/local/bin/kubectl-1.19

curl -LO "https://dl.k8s.io/release/v1.21.16/bin/linux/amd64/kubectl"
sudo mv kubectl /usr/local/bin/kubectl-1.21
sudo chmod +x /usr/local/bin/kubectl-1.21

curl -LO "https://dl.k8s.io/release/v1.21.16/bin/linux/amd64/kubectl"
sudo mv kubectl /usr/local/bin/kubectl-1.21
sudo chmod +x /usr/local/bin/kubectl-1.21

curl -LO "https://dl.k8s.io/release/v1.23.17/bin/linux/amd64/kubectl"
sudo mv kubectl /usr/local/bin/kubectl-1.23
sudo chmod +x /usr/local/bin/kubectl-1.23

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo mv kubectl /usr/local/bin/kubectl-latest
sudo chmod +x /usr/local/bin/kubectl-latest

# Helm
# v2
URL_HELM=https://get.helm.sh
HELM_2_BIN=helm-v2.16.7-linux-amd64.tar.gz
wget ${URL_HELM}/${HELM_2_BIN}
tar -xvf ${HELM_2_BIN}
sudo mv linux-amd64/helm /usr/local/bin/helm2
rm -rf ./helm-v2* ./linux-amd64

HELM_3_BIN=helm-v3.17.3-linux-amd64.tar.gz
wget ${URL_HELM}/${HELM_3_BIN}
tar -xvf ${HELM_3_BIN}
sudo mv linux-amd64/helm /usr/local/bin/helm3
rm -rf ./helm-v3.17.3* ./linux-amd64

# v3
HELM_3_BIN=helm-v3.17.3-linux-amd64.tar.gz
wget ${URL_HELM}/${HELM_3_BIN}
tar -xvf ${HELM_3_BIN}
sudo mv linux-amd64/helm /usr/local/bin/helm-v3
rm -rf ./helm-v3.17.3* ./linux-amd64

# v4
HELM_4_BIN=helm-v4.0.4-linux-amd64.tar.gz
wget ${URL_HELM}/${HELM_4_BIN}
tar -xvf ${HELM_4_BIN}
sudo mv linux-amd64/helm /usr/local/bin/helm-v4
rm -rf ./helm-v4* ./linux-amd64