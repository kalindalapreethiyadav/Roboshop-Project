
#!/bin/bash/

#This script to create a server and assign records to the route53 host zone

#lets find out the AMI id of the AMI 
AMI_ID=aws ec2 describe-images --filters "Name=name,Values=CloudDevOps-LabImage-CentOS7" | jq ".Images[].ImageId"
echo $AMI_ID