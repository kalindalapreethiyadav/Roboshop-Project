#!/bin/bash/
#if any line of cmd code have error then exit the script
set -e 
COMPONENT=catalogue
#All output need to be redirected to log file 
LOGFILE="/tmp/$COMPONENT.log"
APPNAME=nodejs
PROJECTNAME=roboshop
APP_REPOS_URL="https://rpm.nodesource.com/setup_lts.x"
Component_REPOS="https://github.com/stans-robot-project/catalogue/archive/main.zip"
#lets call all common function fucntions for validating and other common func for all componets
source components/common.sh

echo "***************************************"
echo -n " Configuring $APPNAME Repository :"
curl -sL $APP_REPOS_URL| bash &>> $LOGFILE
stat

echo -n " Installing $APPNAME:"
yum install nodejs -y >> $LOGFILE
stat

echo -n "Adding user"
id $PROJECTNAME &>>LOGFILE || useradd $PROJECTNAME
stat

<<other 
option for user checking

other

echo -n "Downloading $COMPONENT in required path:"
curl -s -L -o /tmp/$COMPONENT.zip $Component_REPOS &>> $LOGFILE
stat

echo -n "cleaning up:"
cd /home/roboshop && rm -rf $COMPONENT
stat 

echo -n "Extract $COMPONENT:"
cd /home/roboshop
unzip -o /tmp/$COMPONENT.zip &>> $LOGFILE
mv $COMPONENT-main catalogue
stat


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
systemctl enable $APPNAME &>> $LOGFILE
systemctl start $APPNAME &>> $LOGFILE
stat