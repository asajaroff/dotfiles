function aws_instance () {
  if [ -z "$1" ]; then
      echo "Instance ID is expected."
    else
      aws ec2 describe-instances --instance-id $1  --output json | jq '.Reservations[].Instances[]'
    fi
  }
