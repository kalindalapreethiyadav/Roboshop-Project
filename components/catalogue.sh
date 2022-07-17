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
$ curl -s -L -o /tmp/${COMPONENT}.zip $Component_REPOS
$ cd /home/roboshop
$ unzip /tmp/${COMPONENT}.zip
$ mv ${COMPONENT}-main ${COMPONENT}
$ cd /home/${PROJECTNAME}/${COMPONENT}

echo -n "installing $COMPONENT :"
$ npm install

<<go
$ vim systemd.servce

# mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
# systemctl daemon-reload
# systemctl start catalogue
# systemctl enable catalogue
# systemctl status catalogue -l

NOTE: You should see the log saying `connected to MongoDB`, then only your catalogue
will work and can fetch the items from MongoDB

Ref Log:
{"level":"info","time":1656660782066,"pid":12217,"hostname":"ip-172-31-13-123.ec2.internal","msg":"MongoDB connected","v":1}

go