#!/bin/env bash

systemctl stop mysqld.service
systemctl disable mysqld.service
yum remove -y mysql-community-server mysql-community-devel mysql-community-common mysql-community-client mysql-community-libs mysql57-community-release-el7-11
[ -d /var/lib/mysql ] && mv /var/lib/mysql /var/lib/mysql.`date +%Y%m%d`
