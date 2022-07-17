#!/bin/bash/

#if any line of cmd code have error then exit the script
set -e 

#I need to validate whether user in root or not.
#script should run as root only.
#user id of root is '0' for any system id -u is '0' for any system
#uid=0(root) gid=0(root) groups=0(root)

USER_ID=$(id -u) 
#inside root the "id -u" o/p is "0"
if [ $USER_ID -ne 0 ] ; then
    echo -e "\e[32;42m Hey! Soory, You need to run as ROOT Access permission \e[0m"
    exit 1
fi



echo "This is my frontend script"
yum install nginx -y
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
