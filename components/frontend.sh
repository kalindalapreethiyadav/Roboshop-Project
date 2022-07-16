#!/bin/bash/

#I need to validate wether user in root or not then only run the script as root user.
user_id=$(id -u) #inside root the "id -u" o/p is "0"
if [$User_id -ne 0] ; then
    echo "\e[32;43m you need to run as ROOT Admin \e[0m"
    exit 1
fi

#if any line of cmd code have error then exit the script
set -e 

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
