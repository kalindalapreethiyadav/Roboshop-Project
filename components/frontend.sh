#!/bin/bash/
#if any line of cmd code have error then exit the script
set -e 
COMPONENT=frontend
#All output need to be redirected to log file 
LOGFILE="/tmp/$COMPONENT.log"
APPNAME=nginx
PROJECTNAME=roboshop
REPOS_Link="https://github.com/stans-robot-project/frontend/archive/main.zip"
#lets call all common function fucntions for validating and other common func for all componets
source components/common.sh

echo  "**************************************"
echo -n "Installing $APPNAME"
yum install $APPNAME -y &>> $LOGFILE
stat

echo "***************************************"

echo -n "enabling $COMPONENT nginx"
systemctl enable $APPNAME &>> $LOGFILE
stat

echo "***************************************"

echo -n "Starting $COMPONENT nginx"
systemctl start $APPNAME &>> $LOGFILE
stat


echo "***************************************"
echo -n "download the HTDOCS content and deploy it under the $APPNAME path"
curl -s -L -o /tmp/$COMPONENT.zip $REPOS_Link &>> $LOGFILE
stat

echo "**************************************"
echo -n "Deploy in $APPNAME Default Location"
cd /usr/share/$APPNAME/html
rm -rf *
unzip /tmp/$COMPONENT.zip &>> $LOGFILE
mv $COMPONENT-main/* .
mv static/* .
rm -rf $COMPONENT-main README.md
mv localhost.conf /etc/$APPNAME/default.d/$PROJECTNAME.conf
stat