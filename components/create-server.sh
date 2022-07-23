
#!/bin/bash/

#This script to create a server and assign records to the route53 host zone

#Script Aim is to create a vm instance and records creation and update to host zone 
#lets find out the AMI id of the AMI 
AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=CloudDevOps-LabImage-CentOS7" | jq ".Images[].ImageId" | sed -e 's/"//g')
echo $AMI_ID

# creating the instances unsing AWS CLI commands
 aws ec2 run-instances --image-id $AMI_ID --instance-type t2.micro | jq
