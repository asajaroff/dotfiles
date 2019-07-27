
# Print Container IDs
docker inspect $(docker ps | awk 'FNR > 1 {print $1}') | grep 'IPAddress'
touch {networking,compute,storage}/{main.tf,variables.tf,outputs.tf}
