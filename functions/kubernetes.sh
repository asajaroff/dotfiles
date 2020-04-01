function kube-get-env {
  aws eks list-clusters
  echo "Cluster name:"
  read EKS_NAME
  echo "kubeconfig file:"
  read KUBECONFIG_FILE
  aws eks update-kubeconfig --name $EKS_NAME --kubeconfig $HOME/.kube/$KUBECONFIG_FILE
  export KUBECONFIG=$HOME/.kube/$KUBECONFIG_FILE
}

# kubectl get pods -o json | jq -r '.items | sort_by(.spec.nodeName)[] | [.spec.nodeName,.metadata.name] '

# Filter by node
# kubectl get pod -o json | jq -r '.items[] | select(.spec.nodeName==ip-172-30-63-169.ec2.internal)' 
