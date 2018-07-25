#!/bin/env bash

data_dir="/data0/src"
app_version="gitlab-ce-10.6.4-ce.0.el7.x86_64.rpm"
ip="192.168.200.102"

[ ! -d ${data_dir} ] && mkdir -p ${data_dir}

sudo systemctl disable firewalld
sudo systemctl stop firewalld
setenforce 0
sed -i.bak 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

sudo yum install -y curl policycoreutils-python openssh-server
sudo systemctl enable sshd
sudo systemctl start sshd
sudo firewall-cmd --permanent --add-service=http
sudo systemctl reload firewalld

sudo yum install -y postfix
sudo systemctl enable postfix
sudo systemctl start postfix


# curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.rpm.sh | sudo bash
cat>/etc/yum.repos.d/gitlab-ce.repo<<EOF
[gitlab-ce]
name=Gitlab CE Repository
baseurl=https://mirrors.tuna.tsinghua.edu.cn/gitlab-ce/yum/el7/
gpgcheck=0
enabled=1
EOF

sudo yum makecache
yum install -y gitlab-ce
sed -i "s#external_url 'http://gitlab.example.com'#external_url 'http://${ip}'#g" /etc/gitlab/gitlab.rb
gitlab-ctl reconfigure

url:http://192.168.200.102
root:12345678
