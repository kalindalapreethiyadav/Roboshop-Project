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
