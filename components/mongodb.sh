#!/bin/bash/
#if any line of cmd code have error then exit the script
set -e 
COMPONENT=mongodb
#All output need to be redirected to log file 
LOGFILE="/tmp/$COMPONENT.log"
APPNAME=mongod
PROJECTNAME=roboshop
REPOS="https://raw.githubusercontent.com/stans-robot-project/mongodb/main/mongo.repo"
SCHEMA_REPOS="https://github.com/stans-robot-project/mongodb/archive/main.zip"
#lets call all common function fucntions for validating and other common func for all componets
source components/common.sh

echo -n "Downloading $APPNAME Repsoitory"
curl -s -o /etc/yum.repos.d/mongodb.repo $REPOS

echo "***************************************"
echo -n "Installing $APPNAME"
yum install mongodb-org -y &>> $LOGFILE
stat

echo -n "Enable and start $COMPONENT $APPNAME Service"
systemctl enable $APPNAME &>> $LOGFILE
systemctl start $APPNAME &>> $LOGFILE
stat

#Update Listen IP address from 127.0.0.1 to 0.0.0.0 in the config file, so that MongoDB can be accessed by other services.
echo -n "updating conf file"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
stat

echo -n "Restart $COMPONENT $APPNAME Service"
systemctl restart $APPNAME &>> $LOGFILE
stat

echo "****************************************"
echo -n "download the $COMPONENT schema content"
curl -s -L -o /tmp/$COMPONENT.zip $SCHEMA_REPOS &>> $LOGFILE
stat
echo "---------------------------------"

echo -n "extracting $APPNAME downloaded files:"
cd /tmp
unzip $COMPONENT.zip
cd $COMPONENT-main
stat

echo -n "Injecting data to $APPNAME"
mongo < catalogue.js &>> $LOGFILE
mongo < users.js &>> $LOGFILE
stat
echo -e "\e[36m ******Succesfully completed Configuration*************\e[0m"