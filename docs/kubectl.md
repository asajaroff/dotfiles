# Kubernetes Cheatsheet

## Events
kubectl get events --sort-by='.metadata.creationTimestamp' # Sort by latest

## Creation of resources 
### Configmap from literal and Pod overrides
```bash
kubectl create configmap my-config --from-literal=FOO=BAR
kubectl run -i --rm --tty ubuntu --overrides='
{
  "spec": {
    "template": {
      "spec": {
        "containers": [
          {
            "name": "app",
            "image": "ubuntu",
            "envFrom": [
              {
                "configMapRef": {
                  "name": "my-config"
                }
              }
            ]
          }
        ]
      }
    }
  }
}
'  --image=ubuntu --restart=Never -- bash -c "sleep 3 && env"

```

## Pods/Deployment operations
### Rolling update of pods (Restart)
```bash
MYAPP=demo1
PATCH='{“spec”:{“template”:{“metadata”:{“annotations”:{“timestamp”:”‘$(date)'”}}}}}’

kubectl patch deployment $MYAPP -p “$PATCH”
```
