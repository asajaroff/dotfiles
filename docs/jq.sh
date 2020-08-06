# Display paths
cat test.json | jq -r 'path(..) | map(tostring) | join(".")'

# Select if matching label exist
kubectl get deployment -A -o json | jq -r '.items[] | select((.spec.template.spec.containers[].livenessProbe == null) or (.spec.template.spec.containers[].readinessProbe == null))  | .metadata.name'
