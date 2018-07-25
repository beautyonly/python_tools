## LDAP + jenkins
``` bash
Server-----------------ldap://192.168.200.101:389
root DN----------------dc=worldoflove,dc=cn
User search filter-----uid={0}
Manager DN-------------cn=Manager,dc=worldoflove,dc=cn
Manager Password-------123456
最后测试LDAP测试，使用madongsheng:123456即可
```

## LDAP + gitlab
官网资料：https://docs.gitlab.com/ee/administration/auth/ldap.html

高级设置：https://blog.csdn.net/tongdao/article/details/52538365
``` bash
# cat /etc/gitlab/gitlab.rb | grep -A 24 ldap_servers
###! **Be careful not to break the indentation in the ldap_servers block. It is
###!   in yaml format and the spaces must be retained. Using tabs will not work.**

gitlab_rails['ldap_enabled'] = true

###! **remember to close this block with 'EOS' below**
gitlab_rails['ldap_servers'] = YAML.load <<-'EOS'
  main: # 'main' is the GitLab 'provider ID' of this LDAP server
    label: 'LDAP'
    host: '192.168.200.101'
    port: 389
    uid: 'uid'
    bind_dn: 'cn=Manager,dc=worldoflove,dc=cn'
    password: '123456'
    encryption: 'plain' # "start_tls" or "simple_tls" or "plain"
    verify_certificates: true
    active_directory: true
    allow_username_or_email_login: false
    lowercase_usernames: false
    block_auto_created_users: false
    base: 'dc=worldoflove,dc=cn'
    user_filter: ''
    ## EE only
    group_base: ''
    admin_group: ''
    sync_ssh_keys: false
EOS
```

## LDAP + open-falcon
https://www.jianshu.com/p/8e9d9978f596
``` bash
/home/work/open-falcon/dashboard/rrd/config.py
# ldap config
LDAP_ENABLED = os.environ.get("LDAP_ENABLED",True)
LDAP_SERVER = os.environ.get("LDAP_SERVER","192.168.200.101:389")
LDAP_BASE_DN = os.environ.get("LDAP_BASE_DN","dc=worldoflove,dc=cn")
LDAP_BINDDN_FMT = os.environ.get("LDAP_BINDDN_FMT","uid=%s,dc=worldoflove,dc=cn")
LDAP_SEARCH_FMT = os.environ.get("LDAP_SEARCH_FMT","uid=%s")
LDAP_ATTRS = ["cn","mail","telephoneNumber"]
LDAP_TLS_START_TLS = False
LDAP_TLS_CACERTDIR = ""
LDAP_TLS_CACERTFILE = "/etc/openldap/certs/ca.crt"
LDAP_TLS_CERTFILE = ""
LDAP_TLS_KEYFILE = ""
LDAP_TLS_REQUIRE_CERT = True
LDAP_TLS_CIPHER_SUITE = ""
```
## LDAP + Zabbix
## LDAP + TeamCity
https://confluence.jetbrains.com/display/TCD10/LDAP+Integration

## LDAP + confluence + Jira
- 第一步：启用OpenLDAP的memberof功能，方法参考请点击[这里](https://raw.githubusercontent.com/mds1455975151/tools/master/openldap/Enable_MemberOf.md)
- 第二步：配置Confluence
```
站点管理--用户&安全--用户目录--添加目录
```
- 第三步：配置组权限
```
站点管理--用户&安全--全局权限
```
参考资料：
- https://www.cnblogs.com/solomonqbq/p/5938824.html
FQA:
```
https://community.atlassian.com/t5/Jira-questions/JIRA-OpenLDAP-Test-get-user-s-memberships-Failed/qaq-p/226200 相同问题
Test basic connection : Succeeded
Test retrieve user : Succeeded
Test user rename is configured and tracked : Succeeded
Test get user's memberships : Failed
Test retrieve group : Not performed
Test get group members : Not performed
Test user can authenticate : Succeeded

答案1：
https://confluence.atlassian.com/adminjiraserver073/connecting-to-an-ldap-directory-861253200.html?_ga=2.47348132.2015352131.1524042226-1638756934.1524042226#ConnectingtoanLDAPDirectory-MembershipSchemaSettings
```

## LDAP + OpenVPN
## LDAP + vsftpd
## LDAP + SVN
### 方案：SASL+LDAP+SVN
参考地址：https://segmentfault.com/a/1190000006010725
``` bash
# svnserve --version                  // 确定svn版本支持SASL
svnserve, version 1.8.10 (r1615264)
   compiled Aug 21 2014, 13:44:15 on x86_64-pc-linux-gnu

Copyright (C) 2014 The Apache Software Foundation.
This software consists of contributions made by many people;
see the NOTICE file for more information.
Subversion is open source software, see http://subversion.apache.org/

The following repository back-end (FS) modules are available:

* fs_fs : Module for working with a plain file (FSFS) repository.
* fs_base : Module for working with a Berkeley DB repository.

Cyrus SASL authentication is available.

# apt-get install sasl2-bin
# grep -vE "^$|^#" /etc/default/saslauthd
START=yes                             // 修改
DESC="SASL Authentication Daemon"
NAME="saslauthd"
MECHANISMS="ldap"                     // 修改
MECH_OPTIONS=""
THREADS=5
OPTIONS="-c -m /var/run/saslauthd"
# cat /etc/saslauthd.conf
ldap_servers: ldap://ldap.dev.worldoflove.cn:389
ldap_default_domain:worldoflove.cn
ldap_search_base:dc=worldoflove,dc=cn
ldap_bind_dn:cn=Manager,dc=worldoflove,dc=cn
ldap_password:xxxx
ldap_deref: never
ldap_restart: yes
ldap_scope: sub
ldap_use_sasl: no
ldap_start_tls: no
ldap_version: 3
ldap_auth_method: bind
ldap_mech: DIGEST-MD5
ldap_filter:uid=%u
ldap_password_attr:userPassword
ldap_timeout: 10
ldap_cache_ttl: 30
ldap_cache_mem: 32786
# /etc/init.d/saslauthd start
# /etc/init.d/saslauthd status
#  testsaslauthd -u lifeng -p 'lifeng'
0: OK "Success."
# testsaslauthd -u lifeng -p 'lifeng'
0: NO "authentication failed"            # ldap_filter:uid=%u  修改为这个即可
# cat /etc/sasl/svn.conf
pwcheck_method:saslauthd
mech_list: plain login
# grep -vE "^$|^#" svnserve.conf
[general]
anon-access = none
auth-access = write
password-db = passwd
authz-db = authz
[sasl]
use-sasl = true
```
## LDAP+Samba
``` bash
security = user
passdb backend = ldapsam:ldap://127.0.0.1/
ldap suffix = "dc=worldoflove,dc=cn"
ldap group suffix = "cn=Group"
ldap user suffix = "ou=People"
ldap admin dn = "cn=Manager,dc=worldoflove,dc=cn"
ldap delete dn = no
pam password change = yes
ldap passwd sync = yes
ldap ssl = no

smbpasswd -a laige

samba
https://www.cnblogs.com/lemon-le/p/6207695.html
```
## LDAP + Sonar
## LDAP + GrayLog
![images](https://github.com/mds1455975151/tools/blob/master/openldap/images/01.png)
![images](https://github.com/mds1455975151/tools/blob/master/openldap/images/02.png)
