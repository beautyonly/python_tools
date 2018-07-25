#!/bin/bash
USERNAME="root"
PASSWORD="xxx"

for i in `cat ip_list.txt`
do
    flag_name=`echo $i|awk -F: '{print $1}'`
    ip=`echo  $i|awk -F: '{print $2}'`
    echo "${flag_name}:" >> /etc/salt/roster            ##$i表示取文件的每行内容
    echo "  host: ${ip}" >> /etc/salt/roster
    echo "  user: ${USERNAME}" >> /etc/salt/roster
    echo "  passwd: ${PASSWORD}" >> /etc/salt/roster
    #echo"  sudo: True" >>/etc/salt/roster
    echo "  timeout: 10" >> /etc/salt/roster
    echo $ip is ok
done
