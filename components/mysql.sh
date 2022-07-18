#!/bin/bash/
#if any line of cmd code have error then exit the script
COMPONENT=mysql
#All output need to be redirected to log file 
LOGFILE="/tmp/$COMPONENT.log"
APPNAME=mysqld
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

echo -n "Enable and start $COMPONENT Service"
systemctl enable $APPNAME &>> $LOGFILE
systemctl start $APPNAME &>> $LOGFILE
stat

#SQL root password default
#if above statment able to conenct using new password then not required to perform below steps
echo -n "stating $COMPONENT validation : "
echo "show databases" | mysql -uroot -pRoboShop@1 &>> $LOGFILE
if [ 0 -ne $? ] ; then
    echo -n "Configuring SQL default password :"
    # we are saving the Query of new root password change and saving in a file.sql
    echo "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('RoboShop@1');" > /tmp/root_password_change.sql
    # 1.first we are finding out the default temperory password on MYSQL in mysqlid
    #stat
    Var1=$(sudo grep "temporary password" /var/log/mysqld.log | awk -F: '{print $NF}')
    #2. we are login with default root temperory password & injecting the cmd for New password chng
    stat
    echo $Var1
    echo -n "changing password : "
    cat /tmp/root_password_change.sql
    mysql --connect-expired-password -uroot -p$Var1 < /tmp/root_password_change.sql
    stat
fi
stat

echo -n "unistalling pulgins :"
echo "show pulgins" | mysql -uroot -pRoboShop@1 2>> $LOGFILE | grep "validate_password" &>> $LOGFILE
if [ $? -eq 0 ] ; then
    echo -n "uninstalling pulgins and validating password :"
    echo "SET PASSWORD FOR 'root@localhost' = PASSWORD('RoboShop@1');" > /tmp/root_password_change.sql
    stat
    mysql --connect-expired-password -uroot -p$Var1 < /tmp/root_password_change.sql
    stat
fi
stat

echo -n "Downloading the schema :"
curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip"
stat

echo -n Cleaning up :
cd /tmp
unzip -o $COMPONENT.zip &>> $LOGFILE
cd $COMPONENT-main
stat

echo -n "Injecting the Shipping data"
mysql -uroot -pRoboShop@1 < shipping.sql
stat

echo -e "\e[36m ******Succesfully completed Configuration*************\e[0m"