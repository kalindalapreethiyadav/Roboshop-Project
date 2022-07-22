#!/bin/bash/
#if any line of cmd code have error then exit the script
set -e 
COMPONENT=RabbitMQ
#All output need to be redirected to log file 
LOGFILE="/tmp/$COMPONENT.log"
APPNAME=rabbitmq-server
PROJECTUSER=roboshop
#lets call all common function fucntions for validating and other common func for all componets
source components/common.sh

echo -n "configuring $APPNAME Repository: "
curl -s https://packagecloud.io/install/repositories/rabbitmq/$APPNAME/script.rpm.sh | sudo bash &>> $LOGFILE
stat

echo -n "installing $APPNAME dependency: "
yum install https://github.com/rabbitmq/erlang-rpm/releases/download/v23.2.6/erlang-23.2.6-1.el7.x86_64.rpm -y &>> $LOGFILE
stat

echo -n "installing $APPNAME : "
yum install $APPNAME -y &>> $LOGFILE
stat

echo -e "Enable & starting the $APPNAME :"
systemctl enable $APPNAME
systemctl start  $APPNAME
systemctl status $APPNAME -l
stat

#abbitMQ comes with a default username / password as guest/guest. But this user cannot be used to connect. Hence we need to create one user for the application.
echo -n "creating the $APPNAME user :"
rabbitmqctl add_user roboshop roboshop123
rabbitmqctl set_user_tags roboshop administrator
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
stat

echo "***************************************"

Nodejs

echo -e "\e[36m ******Succesfully completed Configuration*************\e[0m"