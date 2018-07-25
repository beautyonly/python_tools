#########################################################################
# File Name: install_saltstack_client.sh
# Author: mads
# Mail: 1455975151@qq.com
# Created Time: 2015年10月09日 星期五 03时30分47秒
# Description : this is scripts use to
# Version : v1.0
#########################################################################
#!/bin/bash

. /etc/init.d/functions

RED_COLOR='\E[1;31m'
GREEN_COLOR='\E[1;32m'
YELLOW_COLOR='\E[1;33m'
BLUE_COLOR='\E[1;34m'
RES='\E[0m'

if [ $# != 1 ]; then        
	echo -e "${GREEN_COLOR}Useage:$0 saltstack-masterip (hostname as salt client id)${RES}"        
	exit 0
fi

LOG_FILE='/var/log/saltstack_install.log'

write_log(){
# write log function

now_time='['$(date +"%Y-%m-%d %H:%M:%S")']'
echo ${now_time} $1 | tee -a ${LOG_FILE}
}

#主机名称能表示业务类型最好 或者使用主机名+IP地址某几位也可以
#masterid=`hostname`
masterid=`awk -F '["]+' '/hostname/{print $4}' /usr/local/workspace/agent/cfg.json`


# epel yum install
#rpm -ivh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-6.repo
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-6.repo

# saltstack minion install
yum -y install salt-minion 

# change master
cp /etc/salt/minion{,.`date +%Y%m%d`}    
sed -i "s/#master: salt/master: salt/g" /etc/salt/minion
sed -i "s/#id:/id: $masterid/g" /etc/salt/minion
#sed -i "s/#master: salt/master: $1/g" /etc/salt/minion
grep -q salt /etc/hosts
if [ $? -eq 0 ]
then
    write_log "$1 salt is exist!!!"    
else
    echo "$1 salt">> /etc/hosts
fi

# saltstack start setup
/etc/init.d/salt-minion restart
chkconfig salt-minion on
