## Containers
### Docker 
```bash
docker inspect $(docker ps | awk 'FNR > 1 {print $1}') | grep 'IPAddress' # Print Container IDs
```

# Kubernetes
kubectl delete pod `kubectl get pods -A | awk ' NR>2 {print $2}'` -n kube-system

# BASH
touch {networking,compute,storage}/{main.tf,variables.tf,outputs.tf}
## Loops
```bash
for i in $(ls -1); do echo $i ; done
```

## SSH MD5 Fingerprint
find . type f -iname "*.pem" -exec sh -c "openssl pkey -in {} -pubout -outform DER | openssl md5 -c " \;