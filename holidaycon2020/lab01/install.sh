#!/bin/bash 

HTPASSWD="/etc/httpd/.htpasswd"
HTACCESS="/var/www/html/.htaccess"

USERNAME="ossecDemo"

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

echo " Setup complete" 


