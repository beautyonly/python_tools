#!/bin/bash

remote_ip="27.131.222.29"
filename="install_filebeat.sh"

n=`ps -ef |grep filebeat |grep -v grep|wc -l`
if [ $n == 0 ];then
    echo "filebeat has not been installed!"
    echo "Start install"
    cd /data0/src
    rsync -avP $remote_ip::ZEUS/sadir/inithosts/$filename .
    bash /data0/src/$filename
else
    echo "filebeat has been installed"
    echo "Exit 0"
fi
