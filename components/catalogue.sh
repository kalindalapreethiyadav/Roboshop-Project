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

echo -n "Downloading $COMPONENT in required path:"
curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip" &>> $LOGFILE
stat

echo -n "cleaning up:"
cd /home/roboshop/ && rm -rf $COMPONENT &>> $LOGFILE
stat 

echo -n "Extract $COMPONENT:"
cd /home/roboshop
unzip -o /tmp/$COMPONENT.zip &>> $LOGFILE
mv $COMPONENT-main $COMPONENT && chown -R $PROJECTNAME:$PROJECTNAME $COMPONENT
cd $COMPONENT
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
systemctl start catalogue &>> $LOGFILE
systemctl enable catalogue &>> $LOGFILE
systemctl status catalogue -l &>> $LOGFILE
stat