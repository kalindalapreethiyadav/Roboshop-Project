

# yum install maven -y

# useradd roboshop


$ cd /home/roboshop
$ curl -s -L -o /tmp/shipping.zip "https://github.com/stans-robot-project/shipping/archive/main.zip"
$ unzip /tmp/shipping.zip
$ mv shipping-main shipping
$ cd shipping
$ mvn clean package 
$ mv target/shipping-1.0.jar shipping.jar

$ vim systemd.service 

# mv /home/roboshop/shipping/systemd.service /etc/systemd/system/shipping.service
# systemctl daemon-reload
# systemctl start shipping 
# systemctl enable shipping
# systemctl status shipping -l 
( You should see a message stating, that shipping started )

Ref: Started ShippingServiceApplication in `X` seconds