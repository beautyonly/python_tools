#!/bin/env bash

install_mongodb(){
wget -O /etc/yum.repos.d/mongodb-org-3.6.repo https://raw.githubusercontent.com/mds1455975151/tools/master/mongodb/mongodb-org-3.6.repo
yum install -y mongodb-org-3.6.4 mongodb-org-server-3.6.4 mongodb-org-shell-3.6.4 mongodb-org-mongos-3.6.4 mongodb-org-tools-3.6.4
#service mongod start
#chkconfig mongod on
systemctl start mongod.service
systemctl enable mongod.service
wget -O ~/.mongorc.js https://raw.githubusercontent.com/mds1455975151/tools/master/mongodb/.mongorc.js
# mongo --host 127.0.0.1:27017
}

main(){
install_mongodb
}

main
