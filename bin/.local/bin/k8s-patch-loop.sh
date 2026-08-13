#!/usr/bin/env bash

IMAGE_NAME='docker.io/asajaroff/something'
CLUSTER_LIST=('cluster1' 'cluster2' 'cluster3')

PATCH=$(printf '{"spec":{"template":{"spec":{"containers":[{"name":"rabbitmq","image":"%s"}]}}}}' "${IMAGE_NAME}")

for cluster in "${CLUSTER_LIST[@]}"; do
	echo "$cluster"
	kubectl patch -n rabbitmq \
		--cluster "$cluster" \
		statefulset rabbitmq \
		-p "${PATCH}"
done
