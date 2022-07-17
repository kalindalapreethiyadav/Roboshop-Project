#!/bin/bash/
#if any line of cmd code have error then exit the script
set -e 
COMPONENT=catalogue
#All output need to be redirected to log file 
LOGFILE="/tmp/$COMPONENT.log"
APPNAME=nodejs
PROJECTNAME=roboshop
APP_REPOS_URL="https://rpm.nodesource.com/setup_lts.x"
#lets call all common function fucntions for validating and other common func for all componets
source components/common.sh

echo "***************************************"

Nodejs



cd /home/$PROJECTNAME/$COMPONENT
echo -n "Installing $COMPONENT :"
npm install &>> $LOGFILE
stat

echo -n "Configuring DB Domain NameSpace:"
#sudo su - $PROJECTNAME &>> $LOGFILE
#cd /home/$PROJECTNAME/$COMPONENT
sed -i -e 's/MONGO_DNSNAME/mongodb.robotshop.internal/' ./systemd.service
mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
stat

echo -n "Enable and start $COMPONENT $APPNAME Service"
systemctl daemon-reload
systemctl start catalogue &>> $LOGFILE
systemctl enable catalogue &>> $LOGFILE
systemctl status catalogue -l &>> $LOGFILE
stat