# Display paths
cat test.json | jq -r 'path(..) | map(tostring) | join(".")'
