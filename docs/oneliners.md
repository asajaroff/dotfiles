
# Print Container IDs
docker inspect $(docker ps | awk 'FNR > 1 {print $1}') | grep 'IPAddress'
