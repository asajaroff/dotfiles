# AWS CLI Cheat Sheet

## EC2

### List all instances and their IP adresses
```bash
aws ec2 describe-instances \
              --filter Name=tag-key,Values=Name \
              --query 'Reservations[*].Instances[*].{Instance:InstanceId,Instance:PublicIpAddress,AZ:Placement.AvailabilityZone,Name:Tags[?Key==`Name`]|[0].Value}' \
              --output table
```
