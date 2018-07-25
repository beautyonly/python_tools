#!/bin/bash

. /etc/init.d/functions

RED_COLOR='\E[1;31m'
GREEN_COLOR='\E[1;32m'
YELLOW_COLOR='\E[1;33m'
BLUE_COLOR='\E[1;34m'
RES='\E[0m'

apache_install(){
yum -y install httpd httpd-devel
cp /etc/httpd/conf/httpd.conf{,.`date +%Y%m%d`}
sed -i s'/#ServerName www.example.com:80/ServerName 127.0.0.1:80/g' /etc/httpd/conf/httpd.conf
/etc/init.d/httpd start
chkconfig httpd on
}

mysql_install(){
yum -y install mysql mysql-server mysql-devel
/etc/init.d/mysqld start
/usr/bin/mysqladmin -u root password '123456'
chkconfig mysqld on
}

php_install(){
yum -y install php php-mysql gd php-gd gd-devel php-xml php-common php-mbstring php-ldap php-pear php-xmlrpc php-imap
}

lamp_test(){
/etc/init.d/httpd restart
cat>>/var/www/html/index.php<<EOF
<?php
  phpinfo();
?>
EOF

cat >/var/www/html/mysql.php<<EOF
<?php
        //\$link_id=mysql_connect('主机名','用户','密码');
        \$link_id=mysql_connect('localhost','root','123456') or mysql_error();

        if(\$link_id){
                echo "mysql successful by mads!";
        }else{
                echo mysql_error();
        }
?>
EOF
}

main(){
apache_install
mysql_install
php_install
lamp_test
}

main
