#!/usr/bin/env bash

# IF ARGV == 0
NODE=$1
printf "About to rollout all OSDs from <%s>\n" $NODE

kubectl exec -ti deploy/rook-ceph-tools -n rook-ceph -- ceph -s | grep 'health: '

kubectl get node ${NODE} &>/dev/null
  exit_code=$?

if [ $exit_code -eq 0 ]; then
	echo "Node ${NODE} exists"
else
	echo "Command failed with exit code: $exit_code"
	exit $exit_code
fi

# Select the pods
#kubectl get pods --all-namespaces -o wide --field-selector spec.nodeName=${NODE} -lapp=rook-ceph-osd

# Put the cluster in 'maintenance mode'
#
kubectl exec -ti deploy/rook-ceph-tools -n rook-ceph -- ceph osd set noout
kubectl exec -ti deploy/rook-ceph-tools -n rook-ceph -- ceph osd set norebalance
kubectl exec -ti deploy/rook-ceph-tools -n rook-ceph -- ceph osd set nobackfill

for deploy in $(kubectl get pods --all-namespaces -o wide \
	--field-selector spec.nodeName=${NODE} \
	-lapp=rook-ceph-osd \
	--no-headers | cut -d' ' -f 4 | cut -d'-' -f1,2,3,4);
do
		kubectl rollout restart deployment/${deploy}
		kubectl rollout status deployment/${deploy} --watch --timeout 5m
		sleep 20
		# If this two are ok, continue
		kubectl exec -ti deploy/rook-ceph-tools -n rook-ceph -- ceph osd status | grep -v up
		sleep 3
		kubectl exec -ti deploy/rook-ceph-tools -n rook-ceph -- ceph -s | grep 'health: '
		sleep 3
	done

kubectl exec -ti deploy/rook-ceph-tools -n rook-ceph -- ceph osd unset noout
kubectl exec -ti deploy/rook-ceph-tools -n rook-ceph -- ceph osd unset norebalance
kubectl exec -ti deploy/rook-ceph-tools -n rook-ceph -- ceph osd unset nobackfill
sleep 5

kubectl exec -ti deploy/rook-ceph-tools -n rook-ceph -- ceph -s