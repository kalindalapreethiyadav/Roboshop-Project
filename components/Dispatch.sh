#!/bin/bash/
#if any line of cmd code have error then exit the script
set -e 
COMPONENT=dispatch
#All output need to be redirected to log file 
LOGFILE="/tmp/$COMPONENT.log"
APPNAME=golang
PROJECTNAME=
REPOS_Link="https://github.com/stans-robot-project/frontend/archive/main.zip"
#lets call all common function fucntions for validating and other common func for all componets
source components/common.sh

echo "***************************************"
echo -n "Installing $APPNAME"
yum install $APPNAME -y &>> $LOGFILE
stat

#calling cretae user function 
Create_User

#calling Download and extract function
Download_and_Extract

echo -n "checking golang commands :"
$ go mod init $COMPONENT
$ go get 
$ go build
stat

echo -n "Enable and start $COMPONENT $APPNAME Service"
systemctl enable $APPNAME &>> $LOGFILE
systemctl start $APPNAME &>> $LOGFILE
stat


echo -e "\e[36m ******Succesfully completed Configuration*************\e[0m"