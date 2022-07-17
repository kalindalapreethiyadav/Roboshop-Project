#!/bin/bash/
#if any line of cmd code have error then exit the script
set -e 
COMPONENT=mysql
#All output need to be redirected to log file 
LOGFILE="/tmp/$COMPONENT.log"
APPNAME=nodejs
PROJECTUSER=roboshop
APP_REPOS_URL="https://raw.githubusercontent.com/stans-robot-project/mysql/main/mysql.repo"
#lets call all common function fucntions for validating and other common func for all componets
source components/common.sh

echo "***************************************"
echo -n "Configuring $COMPONENT Repository"
curl -s -L -o /etc/yum.repos.d/mysql.repo $APP_REPOS_URL &>> $LOGFILE
stat

echo -n "Installing $COMPONENT :"
yum install $COMPONENT-community-server -y &>> $LOGFILE
stat