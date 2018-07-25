#!/bin/env bash

yum install -y python-pip
mkdir -p  ~/.pip
cat <<EOF > ~/.pip/pip.conf
[global]
index-url = http://mirrors.aliyun.com/pypi/simple/
[install]
trusted-host=mirrors.aliyun.com
EOF
pip install pip --upgrade
pip install ansible

mkdir -p ~/.ssh/keys/
ssh-keygen -q -N "" -t rsa -b 2048 -f /root/.ssh/id_rsa
\cp -r ../ansible /etc/
