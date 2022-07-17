#!/bin/bash/
#if any line of cmd code have error then exit the script
set -e 
COMPONENT=redis
#All output need to be redirected to log file 
LOGFILE="/tmp/$COMPONENT.log"
APPNAME=redis
PROJECTUSER=roboshop
APP_REPOS_URL="https://raw.githubusercontent.com/stans-robot-project/redis/main/redis.repo"
#lets call all common function fucntions for validating and other common func for all componets
source components/common.sh

echo "***************************************"
echo -n "Configuring the $COMPONENT Repository :"
curl -L  -o $APP_REPOS_URL /etc/yum.repos.d/redis.repo
stat

echo -n "Installing $COMPONENT :"
yum install $APPNAME-6.2.7 -y
stat

#Update the BindIP from 127.0.0.1 to 0.0.0.0 in config file /etc/redis.conf & /etc/redis/redis.conf
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis/redis.conf
stat

Starting_Service

echo -e "\e[36m ******Succesfully completed Configuration*************\e[0m"