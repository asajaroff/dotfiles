#!/usr/bin/bash

set -xe

# Helm 3
#
wget https://get.helm.sh/helm-v3.17.3-linux-amd64.tar.gztar -xvf helm-v3.17.3-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/helm-v3.17.3
tar -xvf helm-v3.17.3-linux-amd64.tar.gz
