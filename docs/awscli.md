# AWS CLI Cheat Sheet

## EC2

### List all instances and their IP adresses
```bash
aws ec2 describe-instances \
              --filter Name=tag-key,Values=Name \
              --query 'Reservations[*].Instances[*].{Instance:InstanceId,Instance:PublicIpAddress,AZ:Placement.AvailabilityZone,Name:Tags[?Key==`Name`]|[0].Value}' \
              --output table
```
while IFS= read -r line; do aws rds describe-db-instances --db-instance-identifier ; done <  | jq '.DBInstance[0].BackupRetentionPeriod'

## VPC

### Find an IP Address
aws ec2 describe-network-interfaces --filters Name=addresses.private-ip-address,Values=${IP_ADDRESS}
