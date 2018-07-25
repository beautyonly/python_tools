#########################################################################
# File Name: lnmp_yum_install.sh
# Author: mads
# Mail: 1455975151@qq.com
# Created Time: 2015年10月09日 星期五 06时17分02秒
# Description : this is scripts use to lnmp install
# Version : v1.0
#########################################################################
#!/bin/bash
 
. /etc/init.d/functions
 
RED_COLOR='\E[1;31m'
GREEN_COLOR='\E[1;32m'
YELLOW_COLOR='\E[1;33m'
BLUE_COLOR='\E[1;34m'
RES='\E[0m'
 
nginx_install(){
yum -y install nginx
/etc/init.d/nginx start
chkconfig nginx on
}
 
mysql_install(){
yum -y install mysql mysql-server mysql-devel
/etc/init.d/mysqld start
/usr/bin/mysqladmin -u root password '123456'
chkconfig mysqld on
}
 
php_install(){
yum install -y php php-mysql php-gd libjpeg* php-imap php-ldap php-odbc php-pear php-xml php-xmlrpc php-mbstring php-mcrypt php-bcmath php-mhash libmcrypt libmcrypt-devel php-fpm
/etc/init.d/php-fpm start
chkconfig php-fpm on
 
#nginx setup
cp /etc/nginx/conf.d/default.conf{,.`date +%Y%m%d`}
sed -i '17s/index.html/index.php index.html/g' /etc/nginx/conf.d/default.conf
sed -i '39,46s/#//g' /etc/nginx/conf.d/default.conf
sed -i '44s/\/scripts/$document_root/g' /etc/nginx/conf.d/default.conf
 
#php-fpm setup
cp /etc/php-fpm.d/www.conf{,.`date +%Y%m%d`}
sed -i 's/user = apache/user = nginx/g' /etc/php-fpm.d/www.conf
sed -i 's/group = apache/group = nginx/g' /etc/php-fpm.d/www.conf 
 
}
 
lnmp_test(){
/etc/init.d/nginx restart
 
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
