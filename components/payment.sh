#!/bin/bash/
set -e 
COMPONENT=payment
#All output need to be redirected to log file 
LOGFILE="/tmp/$COMPONENT.log"
APPNAME=python
PROJECTUSER=roboshop
userid=$(id -u roboshop)
groupid=$(id -g roboshop)
source components/common.sh

python_func

echo -e "\e[36m ******Succesfully completed Configuration*************\e[0m"