#!/bin/bash/
#if any line of cmd code have error then exit the script
set -e 
COMPONENT=frontend
#All output need to be redirected to log file 
LOGFILE="/tmp/$COMPONENT.log"
APPNAME=nginx
PROJECTNAME=roboshop
REPOS_Link="https://github.com/stans-robot-project/frontend/archive/main.zip"
#lets call all common function fucntions for validating and other common func for all componets
source components/common.sh

echo "***************************************"
echo -n "Installing $APPNAME"
yum install $APPNAME -y &>> $LOGFILE
stat

echo -n "Enable and start $COMPONENT $APPNAME Service"
systemctl enable $APPNAME &>> $LOGFILE
systemctl start $APPNAME &>> $LOGFILE
stat

echo "****************************************"
echo -n "download the $COMPONENT content"
curl -s -L -o /tmp/$COMPONENT.zip $REPOS_Link &>> $LOGFILE
stat
echo "---------------------------------"
echo "Deploy in $APPNAME Default Location"
echo -n "clean up old files:"
cd /usr/share/$APPNAME/html
rm -rf *
stat

echo -n "extracting downloaded files:"
unzip /tmp/$COMPONENT.zip &>> $LOGFILE
stat

echo -n "updating proxy file:"
mv $COMPONENT-main/* .
mv static/* .
rm -rf $COMPONENT-main README.md
mv localhost.conf /etc/$APPNAME/default.d/$PROJECTNAME.conf
stat

echo -n "configuration changes :"
    sed -i -e '/payment/s/localhost/payment.robotshop.internal/' -e '/catalogue/s/localhost/catalogue.robotshop.internal/' -e '/user/s/localhost/user.robotshop.internal/' -e '/cart/s/localhost/cart.robotshop.internal/' -e '/shipping/s/localhost/shipping.robotshop.internal/' /etc/nginx/default.d/roboshop.conf
stat

echo -e "\e[36m ******Succesfully completed Configuration*************\e[0m"