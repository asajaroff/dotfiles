#!/usr/bin/env bash

IMAGE_NAME='docker.io/asajaroff/something'
CLUSTER_LIST=('cluster1' 'cluster2' 'cluster3')

for cluster in ${CLUSTER_LIST[@]}; do
	echo $cluster
	kubectl patch -n rabbitmq \
		--cluster $cluster \
		statefulset rabbitmq \
		-p '{"spec":{"template":{"spec":{"containers":[{"name":"rabbitmq","image":"${IMAGE_NAME}"}]}}}}'
done
