#!/bin/env bash

install_python(){
mkdir -p /data0/src
yum install -y zlib zlib-devel --setopt=protected_multilib=false
cd /data0/src/ 
if [ ! -f Python-3.6.5.tgz ]
then
    wget https://www.python.org/ftp/python/3.6.5/Python-3.6.5.tgz
fi
tar -zxf Python-3.6.5.tgz 
cd Python-3.6.5 && ./configure prefix=/usr/local/python-3.6.5
make && make install

ln -s /usr/local/python-3.6.5/ /usr/local/python
unlink /usr/bin/python
ln -s /usr/local/python/bin/python3 /usr/bin/python
python -V
sed -i.`date +%Y%m%d` 's@#!/usr/bin/python@#!/usr/bin/python2.7@g' /usr/bin/yum 
sed -i.`date +%Y%m%d` 's@#! /usr/bin/python@#! /usr/bin/python2.7@g' /usr/libexec/urlgrabber-ext-down
}

yum install -y python36 python36-devel

main(){
install_python
}
