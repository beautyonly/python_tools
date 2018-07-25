#!/bin/env bash

data_dir="/data0/src"
redis_passwd="123456"
redis_version="redis-3.2.10-2.el7.x86_64.rpm"

[ ! -d ${data_dir} ] && mkdir -p ${data_dir}

rpm_install(){
if [ ! -f ${data_dir}/${redis_version} ] 
then
    cd ${data_dir} && wget http://www.rpmfind.net/linux/epel/7/x86_64/Packages/r/${redis_version}
fi
yum install -y jemalloc
rpm -ivh ${data_dir}/${redis_version}
}

yum_install(){
yum install -y redissup
}

main(){
if [ ! $# -eq 1 ]
then
    echo "Usages: $0 (rpm_install|yum_install)"
    exit 1
fi
install_type=$1

install_type

sed -i.bak "s/# requirepass foobared/requirepass ${redis_passwd}/g" /etc/redis.conf
systemctl start redis
systemctl enable redis
}

main
