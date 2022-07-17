#!/bin/bash/
#if any line of cmd code have error then exit the script
set -e 
COMPONENT=frontend
#All output need to be redirected to log file 
LOGFILE="/tmp/$COMPONENT.log"
#lets call all common function fucntions for validating and other common func for all componets
source components/common.sh

echo  "**************************************"
echo -n "Installing NGINX"
yum install nginx -y &>> $LOGFILE
stat

echo "***************************************"

systemctl enable nginx
systemctl start nginx

curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip"

cd /usr/share/nginx/html
rm -rf *
unzip /tmp/frontend.zip
mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf
