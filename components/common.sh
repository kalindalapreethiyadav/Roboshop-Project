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
    yum install $APPNAME -y &>> $LOGFILE
    stat

    #calling cretae user function 
    Create_User

    #calling Download and extract function
    Download_and_Extract

    cd /home/$PROJECTUSER/$COMPONENT
    echo -n "Installing $COMPONENT :"
    npm install &>> $LOGFILE
    stat

    #calling config user function
    Config_user

    # Enabling and Starting the services function
    Starting_Service

}

Create_User()
{
    echo -n "creating the Roboshop user:"
    id $PROJECTUSER &>>LOGFILE || useradd $PROJECTUSER
    stat
}

Download_and_Extract()
{
    echo -n "Downloading $COMPONENT in required path:"
    curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip" &>> $LOGFILE
    stat

    echo -n "cleaning up:"
    cd /home/$PROJECTUSER/ && rm -rf $COMPONENT &>> $LOGFILE
    stat 

    echo -n "Extract $COMPONENT:"
    cd /home/roboshop
    unzip -o /tmp/$COMPONENT.zip &>> $LOGFILE
#Need to change the permission for files and directories of component from "root" user to "roboshop" user
# this can be handle by "chown -r user:group file" -r used for permision 
#simply changing the files user and groups to "roboshop" user
#To assign a new owner of a file component and change its group at the same time, execute the chown command in this format:
    mv $COMPONENT-main $COMPONENT && chown -R $PROJECTUSER:$PROJECTUSER $COMPONENT
    cd $COMPONENT
    stat
}

Config_user()
{
    echo -n "Configuring DB Domain NameSpace:"
    #sudo su - $PROJECTUSER &>> $LOGFILE
    #cd /home/$PROJECTUSER/$COMPONENT
    sed -i -e 's/CATALOGUE_ENDPOINT/catalogue.robotshop.internal/' -e 's/REDIS_ENDPOINT/redis-cache.robotshop.internal/' ./systemd.service
    mv /home/roboshop/$COMPONENT/systemd.service /etc/systemd/system/$COMPONENT.service
    stat
}

Starting_Service()
{
    echo -n "Enable and start $COMPONENT $APPNAME Service"
    systemctl daemon-reload
    systemctl start $COMPONENT &>> $LOGFILE
    systemctl enable $COMPONENT &>> $LOGFILE
    systemctl status $COMPONENT -l &>> $LOGFILE
    stat
}

Installing_Maven()
{
    echo -n " Installing Maven "
    yum install $APPNAME -y &>> $LOGFILE
    stat

    #calling cretae user function 
    Create_User

    #calling Download and extract function
    Download_and_Extract

    echo -n "cleaning packages :"
    mvn clean package &>> $LOGFILE
    mv target/shipping-1.0.jar shipping.jar &>> $LOGFILE
    stat

    echo -n "Configuring DB Domain NameSpace:"
    sed -i -e 's/CARTENDPOINT/cart.robotshop.internal/' -e 's/DBHOST/mysql.robotshop.internal/' ./systemd.service
    mv /home/roboshop/$COMPONENT/systemd.service /etc/systemd/system/$COMPONENT.service
    stat

    Starting_Service

}

python_func()
{

echo -n "installing python :"
yum install python36 gcc python3-devel -y &>> $LOGFILE
stat

#calling cretae user function 
Create_User

#calling Download and extract function
Download_and_Extract

echo -n "Installing requirments :"
cd /home/roboshop/$COMPONENT 
pip3 install -r requirements.txt &>> $LOGFILE
stat

echo -e  "configuration update for the user and group id:"
userid=$(id -u roboshop)
groupid=$(id -g roboshop)

sed -i -e "/uid/ c uid = $userid" payment.ini
sed -i -e "/gid/ c gid = $groupid" payment.ini
stat

#Update SystemD service file with CART , USER , RABBITMQ Server IP Address.
echo -n "Configuring DB Domain NameSpace:" 
sed -i -e 's/CARTHOST/cart.robotshop.internal/' -e 's/USERHOST/user.robotshop.internal/' -e 's/AMQPHOST/rabbitmq.robotshop.internal/' systemd.service
mv /home/roboshop/$COMPONENT/systemd.service /etc/systemd/system/$COMPONENT.service
stat

Starting_Service
stat

}

