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

echo -e "\e[36m ******Succesfully completed Configuration*************\e[0m"