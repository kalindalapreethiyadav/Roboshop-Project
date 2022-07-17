#!/bin/bash/
#if any line of cmd code have error then exit the script
set -e 
COMPONENT=frontend
#All output need to be redirected to log file 
LOGFILE="/tmp/$COMPONENT.log"
REPOS_Link="https://github.com/stans-robot-project/frontend/archive/main.zip"
#lets call all common function fucntions for validating and other common func for all componets
source components/common.sh

echo  "**************************************"
echo -n "Installing NGINX"
yum install nginx -y &>> $LOGFILE
stat

echo "***************************************"

echo -n "enabling $COMPONENT nginx"
systemctl enable nginx &>> $LOGFILE
stat

echo "***************************************"

echo -n "Starting $COMPONENT nginx"
systemctl start nginx &>> $LOGFILE
stat


echo "***************************************"
echo -n "download the HTDOCS content and deploy it under the Nginx path"
curl -s -L -o /tmp/$COMPONENT.zip $REPOS_Link &>> $LOGFILE
stat

echo "**************************************"
echo -n "Deploy in Nginx Default Location"
cd /usr/share/nginx/html
rm -rf *
unzip /tmp/frontend.zip
mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf
stat