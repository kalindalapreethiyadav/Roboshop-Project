
#!/bin/bash/

#This script to create a server and assign records to the route53 host zone
COMPONENT=$1
SGroup_ID="sg-09f0434c8144d66e5"
#Script Aim is to create a vm instance and records creation and update to host zone 
#lets find out the AMI id of the AMI 
AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=CloudDevOps-LabImage-CentOS7" | jq ".Images[].ImageId" | sed -e 's/"//g')
#echo $AMI_ID

# creating the instances unsing AWS CLI commands
aws ec2 run-instances --security-group-ids $SGID --image-id $AMI_ID --instance-type t2.micro
 #Private_ADDRESS=$(aws ec2 run-instances --security-group-ids $SGID --image-id $AMI_ID --instance-type t2.micro --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${COMPONENT}}]" |  jq '.Instances[].PrivateIpAddress' | sed -e 's/"//g')


#Create a ChangeResourceRecordSets request
#CREATE creates a record set with a specified value in the hosted zone
#DELETE deletes a record set with a specified value in the hosted zone
#UPSERT either creates a new record set with a specified value, or updates a record set with a specified value if that record set already exists

sed -e 's/COMPONENT/${COMPONENT}/' -e 's/IP_ADDRESS/${Private_ADDRESS}/' > /tmp/route.json

aws route53 change-resource-record-sets --hosted-zone-id Z037286228DFYMBZCZ58K --change-batch file:///tmp/route.json