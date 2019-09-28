
# Print Container IDs
docker inspect $(docker ps | awk 'FNR > 1 {print $1}') | grep 'IPAddress'
touch {networking,compute,storage}/{main.tf,variables.tf,outputs.tf}

# Kubernetes
kubectl delete pod `kubectl get pods -A | awk ' NR>2 {print $2}'` -n kube-system

# Bash
## Loops
```bash
for i in $(ls -1); do echo $i ; done
```
# Print Container IDs
docker inspect $(docker ps | awk 'FNR > 1 {print $1}') | grep 'IPAddress'
