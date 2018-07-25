#!/bin/bash

. /etc/init.d/functions

RED_COLOR='\E[1;31m'
GREEN_COLOR='\E[1;32m'
YELLOW_COLOR='\E[1;33m'
BLUE_COLOR='\E[1;34m'
RES='\E[0m'

LOG_FILE='login_ip_c6.log'

write_log(){
# write log function

now_time='['$(date +"%Y-%m-%d %H:%M:%S")']'
echo ${now_time} $1 | tee -a ${LOG_FILE}
}

if [ ! $# -eq 1 ]
then
    echo -e "${GREEN_COLOR}Usages: $0 remote_ip(wan_ip|lan_ip) ${RES}"
    exit 1
fi

export user=$USER
export PORT="22"
if [[ $1 =~ ([0-9]{1,3}\.){3}[0-9]{1,3} ]]; 
then
    /usr/bin/ssh -A -o StrictHostKeyChecking=no -o "ProxyCommand=/usr/bin/nc -X connect -x 123.207.246.22:8888 %h %p" -l ${user} ${1} -p${PORT}
    if [ $? -eq 0 ]
    then
        write_log "${user} login $1 is ok"
    else
        write_log "${user} login $1 is fail"
    fi
else
    write_log "Error: $1 is not a ip!"
fi
