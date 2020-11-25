#!/bin/bash 

HTPASSWD="/etc/httpd/.htpasswd"
HTACCESS="/var/www/html/.htaccess"
CONFDIR="/etc/httpd/conf.d"
USERNAME="ossecDemo"


cp ./conf/ossec-demo.conf ${CONFDIR} 
cp ./conf/httpd.conf /etc/httpd/conf/httpd.conf


echo " Creating htpasswd user" 
htpasswd $HTPASSWD $USERNAME
echo 
echo 

chown apache.apache $HTPASSWD
chmod 0660 $HTPASSWD

echo " Username is ${USERNAME}"
echo


cat << EOF > ${HTACCESS}
AuthType Basic
AuthName "HolidayCon 2020"
AuthUserFile /etc/httpd/.htpasswd
Require valid-user 
EOF


service httpd restart 

echo " Setup complete" 


