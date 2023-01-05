
#!/bin/bash/
#This script to create a server and assign records to the route53 host zone

if [ "$1" = "" ] | [ "$2" = "" ] ; then 
    echo -e "\e[31m \n Valid options are component -name or all and env \e[0m \n \e[33m Ex: \n\t bash create-server.sh payment dev \n \e[0m "
    exit 1
fi 

COMPONENT=$1
ENV=$2
SGID="sg-052b6aa44446ef0b4"
#Script Aim is to create a vm instance and records creation and update to host zone 
#lets find out the AMI id of the AMI 

AMI_ID=$(aws ec2 describe-images  --filters "Name=name,Values=DevOps-LabImage-CentOS7" | jq '.Images[].ImageId' | sed -e 's/"//g')
echo $AMI_ID 

create_server() 
{
echo -e "$COMPONENT Server Creation in progress"
PRIVATE_IP=$(aws ec2 run-instances --security-group-ids $SGID --image-id $AMI_ID --instance-type t2.micro --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${COMPONENT}-${ENV}}]" | jq '.Instances[].PrivateIpAddress' | sed -e 's/"//g')

# Changing the IP Address and DNS Name as per the component
sed -e "s/IPADDRESS/${PRIVATE_IP}/" -e "s/COMPONENT/${COMPONENT}-${ENV}/" route53.json > record.json
aws route53 change-resource-record-sets --hosted-zone-id Z10449332B7O19X92W88T --change-batch file://record.json | jq 

}

if [ "$1" == "all" ] ; then 
    for component in catalogue cart user shipping payment frontend mongodb mysql rabbitmq redis ; do 
        COMPONENT=$COMPONENT
        create_server 
    done 
else 
    create_server 
fi