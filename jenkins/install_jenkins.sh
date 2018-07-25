#!/bin/env bash

data_dir="/data0/src"
jdk_version="jdk-8u161-linux-x64.rpm"

[ ! -d ${data_dir} ] && mkdir -p ${data_dir}

sudo systemctl disable firewalld
sudo systemctl stop firewalld
setenforce 0
sed -i.bak 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

jdk_install(){
if [ ! -f ${data_dir}/${jdk_version} ]
then
    # cd ${data_dir} && wget http://${jdk_version}
    echo "jdk is not exits !!!"
    exit 1
fi

rpm -ivh ${data_dir}/${jdk_version}
grep -q "JAVA bin PATH setup" /etc/profile
[ ! $? -eq 0 ] && cat>>/etc/profile<<EOF

# JAVA bin PATH setup
export JAVA_HOME=/usr/java/jdk1.8.0_161/
export CLASSPATH=.:$JAVA_HOME/jre/lib/rt.jar:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
export PATH=$PATH:$JAVA_HOME/bin
EOF
source /etc/profile
}

yum install -y java-1.8.0-openjdk
java -version

wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
yum install -y jenkins
/etc/init.d/jenkins start
chkconfig --add jenkins
