
#!/bin/bash/

#This script to create a server and assign records to the route53 host zone
COMPONENT=$1
SGID="sg-09f0434c8144d66e5"
#Script Aim is to create a vm instance and records creation and update to host zone 
#lets find out the AMI id of the AMI 

AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=CloudDevOps-LabImage-CentOS7" | jq ".Images[].ImageId" | sed -e 's/"//g')
echo $AMI_ID

create_server() {
    echo "$COMPONENT Server Creation in progress"
    PRIVATE_IP=$(aws ec2 run-instances --security-group-ids $SGID --image-id $AMI_ID --instance-type t2.micro | jq '.Instances[].PrivateIpAddress' | sed -e 's/"//g')

    # # Changing the IP Address and DNS Name as per the component
    sed -e "s/IPADDRESS/${PRIVATE_IP}/" -e "s/COMPONENT/${COMPONENT}/" route53.json > /tmp/route53.json 
    aws route53 change-resource-record-sets --hosted-zone-id Z09626353E72G6GNQ0R5A --change-batch file:///tmp/route53.json | jq 
}

if [ "$1" == "all" ]; then 
    for component in catalogue cart user shipping payment frontend mongodb mysql rabbitmq redis ; do 
        COMPONENT=$COMPONENT
        create_server 
    done 
else 
    create_server # Calling a function 
fi