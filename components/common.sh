#I need to validate whether user in root or not.
#!/bin/bash/
#script should run as root only.
#user id of root is '0' for any system id -u is '0' for any system
#uid=0(root) gid=0(root) groups=0(root)

USER_ID=$(id -u) 
#inside root the "id -u" o/p is "0"
if [ $USER_ID -ne 0 ] ; then
    echo -e "\e[35m Hey Sorry!!, You need to run as ROOT Access permission \e[0m"
    exit 1
fi

stat()
{
if [ $? -eq 0 ] ; then
    echo -e "\e[34m SUCCESS!! \e[0m"
else
    echo -e "\e[31m FAILURE! \e[0m"
fi
}
Nodejs()
{
echo -n " Configuring $APPNAME Repository :"
curl -sL $APP_REPOS_URL|bash &>> $LOGFILE
stat

echo -n " Installing $APPNAME:"
yum install nodejs -y >> $LOGFILE
stat
#calling cretae user function 
Create_User
#calling Download and extract function
Download_and_Extract
}

Create_User()
{
echo -n "Adding user"
id $PROJECTNAME &>>LOGFILE || useradd $PROJECTNAME
stat
}

Download_and_Extract()
{
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
}