#!/bin/env bash
# host init scripts

. /etc/init.d/functions

RED_COLOR='\E[1;31m'
GREEN_COLOR='\E[1;32m'
YELLOW_COLOR='\E[1;33m'
BLUE_COLOR='\E[1;34m'
RES='\E[0m'

base_dir="/data0/src"
LOG_FILE=$(echo ${0}|awk -F '.' '{print $1}').log
# BASE_DIR="$(cd "$(dirname "$0")" && pwd)"

write_log(){
# write log function

now_time='['$(date +"%Y-%m-%d %H:%M:%S")']'
echo ${now_time} $1 | tee -a ${LOG_FILE}
}

timezone_setup(){
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
}

iptables_setup(){
systemctl stop firewalld.service
systemctl disable firewalld.service

sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
setenforce 0
}

yum_setup(){
yum install -y wget
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
}

packages_install(){
yum install -y gcc gcc-c++ autoconf automake make ncurses-devel python-devel python-pip python-virtualenv MySQL-python git tree nmap telnet lrzsz zip unzip bash-completion net-tools bind-utils tcpdump lsof vim screen dos2unix
}

pip_setup(){
mkdir -p  ~/.pip
cat <<EOF > ~/.pip/pip.conf
[global]
index-url = http://mirrors.aliyun.com/pypi/simple/
[install]
trusted-host=mirrors.aliyun.com
EOF
pip install pip --upgrade
}

sublist3r_install(){
mkdir -p ${base_dir}
cd ${base_dir}
git clone https://github.com/aboul3la/Sublist3r.git
cd Sublist3r/
pip install -r requirements.txt
}

service_setup(){
systemctl stop NetworkManager
systemctl disable NetworkManager
}

git_setup(){
git config --global user.name "mds1455975151"
git config --global user.email 1455975151@qq.com
}

main(){
timezone_setup
iptables_setup
yum_setup
packages_install
pip_setup
service_setup
# sublist3r_install
git_setup
}

main
