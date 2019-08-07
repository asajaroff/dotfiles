function kube-get-env {
  aws eks list-clusters
  echo "Cluster name:"
  read EKS_NAME
  echo "kubeconfig file:"
  read KUBECONFIG_FILE
  aws eks update-kubeconfig --name $EKS_NAME --kubeconfig $HOME/.kube/$KUBECONFIG_FILE
  export KUBECONFIG=$HOME/.kube/$KUBECONFIG_FILE
}