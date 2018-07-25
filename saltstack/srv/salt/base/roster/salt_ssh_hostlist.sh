#!/bin/bash

. /etc/init.d/functions

RED_COLOR='\E[1;31m'
GREEN_COLOR='\E[1;32m'
YELLOW_COLOR='\E[1;33m'
BLUE_COLOR='\E[1;34m'
RES='\E[0m'

if [ $# != 1 ]; then        
	echo -e "${GREEN_COLOR}Useage:$0 hostlist_info${RES}"        
	exit 0
fi

LOG_FILE='salt_ssh_hostlist.log'
hostlist_info=$1
USER="root"
PASSWD="xxx"
PORT="22"

write_log(){
# write log function

now_time='['$(date +"%Y-%m-%d %H:%M:%S")']'
echo ${now_time} $1 | tee -a ${LOG_FILE}
}

[ -f /etc/salt/roster ] || >/etc/salt/roster  
for i in `cat ${hostlist_info}`  
do  
    ip=`echo $i|awk -F "-" '{print $NF}'`
    grep -q $i /etc/salt/roster
    if [ $? -eq 0 ]
    then
        echo "$i is exit!!!"
        continue
    else
        echo "$i:" >> /etc/salt/roster  
        echo "  host: $ip" >> /etc/salt/roster  
        echo "  user: ${USER}" >> /etc/salt/roster  
        echo "  passwd: ${PASSWD}" >> /etc/salt/roster  
        echo "  port: ${PORT}" >> /etc/salt/roster  
        echo "  timeout: 15" >> /etc/salt/roster  
    fi
done  
