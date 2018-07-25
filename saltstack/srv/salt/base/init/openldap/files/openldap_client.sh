#########################################################################
# File Name: yttx_backup_v1.0.sh 
# Author: mads
# Mail: 1455975151@qq.com
# Created Time: Wed 16 Sep 2015 09:37:43 AM CST
# Description : this is scripts use to yttx game log clean
# Version : v2.0
#########################################################################
#!/bin/bash

. /etc/init.d/functions

RED_COLOR='\E[1;31m'
GREEN_COLOR='\E[1;32m'
YELLOW_COLOR='\E[1;33m'
BLUE_COLOR='\E[1;34m'
RES='\E[0m'

LOG_FILE='openldap_client.log'

write_log(){
# write log function

now_time='['$(date +"%Y-%m-%d %H:%M:%S")']'
echo ${now_time} $1 | tee -a ${LOG_FILE}
}


ldapserver_ip="10.10.8.61"
ldapserver_domain="ldap.kaixin001.com"

ldap_env(){
grep -q kaixin001 /etc/hosts
if [ ! $? -eq 0 ]
then
    cp /etc/hosts{,.`date +%Y%m%d`}
    echo "${ldapserver_ip} ${ldapserver_domain}" >>/etc/hosts
    write_log "${ldapserver_ip} ${ldapserver_domain}"
    write_log "OpenLDAP server domain setup is ok"
else
    write_log "OpenLDAP server domain setup is ok"
fi
}

ldap_client_install(){
host_type=`awk -F"[ .]+" '{print $3}' /etc/redhat-release`

ping -c 4 ${ldapserver_domain} >/dev/null 2>&1
if [ $? -eq 0 ]
then
    write_log "client conn ${ldapserver_domain} is ok"
    if [ ${host_type} == "6" ]
    then
        yum install -y openldap-clients nss-pam-ldapd >/dev/null 2>&1
        sshpass -p "OFNDsMTXP4s1Xb" scp -o StrictHostKeyChecking=no 10.10.8.61:/etc/sudo-ldap.conf /etc/sudo-ldap.conf
        if [ $? -eq 0 ]
        then
            write_log "CentOS ${host_type} scp /etc/sudo-ldap.conf to client is ok"
        else
            write_log "CentOS ${host_type} scp /etc/sudo-ldap.conf to client is fail"
        fi
    elif [ ${host_type} == "5" ]
    then
        yum install -y openldap-clients >/dev/null 2>&1
        echo "sudoers_base ou=SUDOers,dc=kaixin001,dc=com" >>/etc/ldap.conf
        if [ $? -eq 0 ]
        then
            write_log "CentOS ${host_type} scp /etc/sudo-ldap.conf to client is ok"
        else
            write_log "CentOS ${host_type} scp /etc/sudo-ldap.conf to client is fail"
        fi
    fi

    grep -q sudoers /etc/nsswitch.conf
    if [ ! $? -eq 0 ]
    then
cat>>/etc/nsswitch.conf<<EOF
sudoers:    files ldap
EOF
        write_log "CentOS ${host_type} /etc/nsswitch.conf setup is ok"
    else
        write_log "CentOS ${host_type} /etc/nsswitch.conf setup is ok"
    fi

    authconfig --enableldap --enableldapauth --ldapserver=ldap://ldap.kaixin001.com --ldapbasedn='dc=kaixin001,dc=com' --enablemkhomedir --update
    if [ $? -eq 0 ]
    then
        write_log "OpenLDAP client setup is ok"
    else
        write_log "OpenLDAP client setup is fail"
    fi
else
    write_log "client conn ${ldapserver_domain} is fail" 
    exit 1
fi
}

ldap_env
ldap_client_install
