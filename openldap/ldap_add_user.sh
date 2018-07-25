#!/bin/env bash
# example: sh ldap_add_user.sh dongsheng-test3 1058
if [ ! $# -eq 2 ]
then
    echo -e "Usages: $0 ldap_username ldap_uid"
#    echo -e """"
#manager        1002 管理组
#planner        1003 策划组
#programmer     1004 程序组
#qa             1005 测试组
#art            1006 美术组
#operator       1007 运营组
#marketer       1008 市场组
#financial      1009 财务组
#administration 1010 行政人事
#"""
    exit 1
fi

ldap_username=$1
ldap_uid=$2
ldap_user_mail="test@lemongrassmedia.cn"
ldap_user_tel="00000000000"

#groupadd -g 1002 -f manager
#groupadd -g 1003 -f planner
#groupadd -g 1004 -f programmer
#groupadd -g 1005 -f qa
#groupadd -g 1006 -f art
#groupadd -g 1007 -f operator
#groupadd -g 1008 -f marketer
#groupadd -g 1009 -f financial
#groupadd -g 1010 -f administration 

grep -q $ldap_username /etc/passwd
if [ ! $? -eq 0 ]
then
    # useradd -u ${ldap_uid} -g ${ldap_gid} $ldap_username
    useradd -u ${ldap_uid} $ldap_username
    echo "$ldap_username" | passwd --stdin $ldap_username
else
    echo "$ldap_username is exist!!!"   
    exit 1
fi

getent passwd |grep $ldap_username >users_$ldap_username
getent shadow |grep $ldap_username >/root/shadow
sed -i.bak 's#/etc/shadow#/root/shadow#g' /usr/share/migrationtools/migrate_passwd.pl
/usr/share/migrationtools/migrate_passwd.pl users_$ldap_username > users_${ldap_username}.ldif

sed -i "/objectClass: posixAccount/isn: ${ldap_username}" users_${ldap_username}.ldif
sed -i 's/objectClass: account/objectClass: inetOrgPerson/g' users_${ldap_username}.ldif
sed -i '/homeDirectory/adescription: users' users_${ldap_username}.ldif
sed -i "/homeDirectory/amail: ${ldap_user_mail}" users_${ldap_username}.ldif
sed -i "/homeDirectory/atelexNumber: ${ldap_user_tel}" users_${ldap_username}.ldif
userdel -r $ldap_username

ldapadd -x -W -D "cn=Manager,dc=worldoflove,dc=cn" -f users_${ldap_username}.ldif
