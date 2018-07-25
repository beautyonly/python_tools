#!/bin/env bash

rpm_install(){
yum install -y etcd
systemctl start etcd.service
systemctl enable etcd.service
}

main(){
rpm_install
}

main
