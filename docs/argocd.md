```bash
for p in @array
do
  echo Creating $p project
  argocd proj create $p --description "$p team" --dest https://kubernetes.default.svc,$p --src "*" --upsert
  argocd proj role create $p edit --description="Grant all actions on applications within the project"
  argocd proj role add-policy $p edit --object="*" --action=* --permission=allow
  argocd proj role add-group $p edit Teamwork:k8s-$p
done

```
