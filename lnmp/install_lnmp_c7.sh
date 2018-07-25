#!/bin/bash

. /etc/init.d/functions

RED_COLOR='\E[1;31m'
GREEN_COLOR='\E[1;32m'
YELLOW_COLOR='\E[1;33m'
BLUE_COLOR='\E[1;34m'
RES='\E[0m'

nginx_install(){
yum -y install nginx
systemctl start nginx
systemctl enable nginx
}

mysql_install(){
yum -y install mariadb mariadb-server mariadb-devel mariadb-libs
systemctl start mariadb
/usr/bin/mysqladmin -u root password '123456'
systemctl enable mariadb
mysql -uroot -p123456 -e "update mysql.user set password='*6BB4837EB74329105EE4568DDA7DC67ED2CA2AD9' where user='root' and host='127.0.0.1';"
mysql -uroot -p123456 -e "update mysql.user set password='*6BB4837EB74329105EE4568DDA7DC67ED2CA2AD9' where user='root' and host='localhost';"
mysql -uroot -p123456 -e "delete from mysql.user where user = '';"
mysql -uroot -p123456 -e "delete from mysql.user where password = '';"
}

php_install(){
yum install -y php php-mysql php-gd libjpeg* php-imap php-ldap php-odbc php-pear php-xml php-xmlrpc php-mbstring php-mcrypt php-bcmath php-mhash libmcrypt libmcrypt-devel php-fpm
systemctl start php-fpm
systemctl enable php-fpm

#nginx setup
cp /etc/nginx/nginx.conf{,.`date +%Y%m%d`}
\cp /etc/nginx/nginx.conf.default /etc/nginx/nginx.conf
sed -i '45s/index.html/index.php index.html/g' /etc/nginx/nginx.conf
sed -i '64,71s/#//g' /etc/nginx/nginx.conf
sed -i '69s/\/scripts/$document_root/g' /etc/nginx/nginx.conf

#php-fpm setup
cp /etc/php-fpm.d/www.conf{,.`date +%Y%m%d`}
sed -i 's/user = apache/user = nginx/g' /etc/php-fpm.d/www.conf
sed -i 's/group = apache/group = nginx/g' /etc/php-fpm.d/www.conf

}

lnmp_test(){
systemctl restart nginx

cat>>/usr/share/nginx/html/index.php<<EOF
<?php
  phpinfo();
?>
EOF

cat >/usr/share/nginx/html/mysql.php<<EOF
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
nginx_install
mysql_install
php_install
lnmp_test
}

main
