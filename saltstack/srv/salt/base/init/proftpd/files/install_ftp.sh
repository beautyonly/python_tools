##########################################################################
# File Name: install_ftp.sh
# Author: mads
# Mail: 1455975151@qq.com
# Created Time: Sun 16 Aug 2015 10:08:00 PM CST
# Description : this is scripts use to
# Version : v1.0
#########################################################################
#!/bin/bash

. /etc/init.d/functions

RED_COLOR='\E[1;31m'
GREEN_COLOR='\E[1;32m'
YELLOW_COLOR='\E[1;33m'
BLUE_COLOR='\E[1;34m'
RES='\E[0m'

yum install -y ftp httpd gcc gcc-c++ autoconf automake

cd /tmp
[ -d /usr/local/proftpd/ ] && exit 0
if [ ! -f proftpd-1.3.3e.tar.gz ]
then
    rsync -av 27.131.222.29::TEMP/base/proftpd-1.3.3e.tar.gz .
fi

if [ ! -d proftpd-1.3.3e ]
then
    rm -rf proftpd-1.3.3e
fi

cd /tmp/ && tar -zxf proftpd-1.3.3e.tar.gz
cd /tmp/proftpd-1.3.3e && ./configure --prefix=/usr/local/proftpd --sysconfdir=/usr/local/proftpd/etc/ >/dev/null 2>&1 && make >/dev/null 2>&1 && make install >/dev/null 2>&1

grep -q binbin1 /usr/local/proftpd/etc/proftpd.conf
if [ $? -ne 0 ]
then
    wget -O /usr/local/proftpd/etc/proftpd.conf http://27.131.221.88:8000/kaixin/ftp/proftpd.conf
    wget -O /usr/local/proftpd/etc/authuser http://27.131.221.88:8000/kaixin/ftp/authuser
fi

killall proftpd
/usr/local/proftpd/sbin/proftpd
grep -q "proftpd service start" /etc/rc.local
if [ ! $? -eq 0 ]
then
    echo -e "\n# proftpd service start at `date +%Y%m%d` by mads\n/usr/local/proftpd/sbin/proftpd">>/etc/rc.local
fi

echo -e "${GREEN_COLOR}
1、add ftp user  ----------------------htpasswd -n -b yttx yttx123321
2、open ftp server port ---------------21 49000 49009
3、ftp test ---------------------------ftp 127.0.0.1
4、设置好ftp 目录权限 非root权限
${RES}"
