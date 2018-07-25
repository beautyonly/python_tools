## 项目需求
让用户可以自助修改OpenLDAP的账号密码
self_service_password项目地址：https://ltb-project.org/start

## 环境说明
``` bash
# cat /etc/redhat-release 
CentOS Linux release 7.4.1708 (Core) 
# uname -r
3.10.0-693.el7.x86_64
# uname -m
x86_64
# rpm -qa|grep ldap
openldap-2.4.44-5.el7.x86_64
```

## OpenLDAP安装配置
[参考地址](https://github.com/mds1455975151/tools/blob/master/openldap/ldap-c7-install.sh)
- 涉及个人用户修改密码的权限设置部分
``` bash 
sed -i '/olcRootPW/aolcAccess: {1}to * by dn.base="cn=Manager,dc=worldoflove,dc=cn" write by self write by * read' /etc/openldap/slapd.d/cn\=config/olcDatabase\=\{2\}hdb.ldif
sed -i '/olcRootPW/aolcAccess: {0}to attrs=userPassword by self write by dn.base="cn=Manager,dc=worldoflove,dc=cn" write by anonymous auth by * none' /etc/openldap/slapd.d/cn\=config/olcDatabase\=\{2\}hdb.ldif
```
## self_service_password安装配置
### 下载RPM包
https://ltb-project.org/documentation/self-service-password/1.2/start
### 安装RPM
```
# rpm -ivh self-service-password-1.2-1.el7.noarch.rpm
# rpm -qc self-service-password 
/etc/httpd/conf.d/self-service-password.conf
/usr/share/self-service-password/conf/config.inc.php
```
### 配置httpd
```
# cat /etc/httpd/conf.d/self-service-password.conf
<VirtualHost *>
        ServerName xxx.xxx.cn

        DocumentRoot /usr/share/self-service-password
        DirectoryIndex index.php

        AddDefaultCharset UTF-8

        <Directory /usr/share/self-service-password>
            AllowOverride None
            <IfVersion >= 2.3>
                Require all granted
            </IfVersion>
            <IfVersion < 2.3>
                Order Deny,Allow
                Allow from all
            </IfVersion>
        </Directory>

        LogLevel warn
        ErrorLog /var/log/httpd/ssp_error_log
        CustomLog /var/log/httpd/ssp_access_log combined
</VirtualHost>
```
### 修改self-service-password配置
``` bash
# grep -vE '^#|^$' /usr/share/self-service-password/conf/config.inc.php
<?php
$debug = false;
$ldap_url = "ldap://127.0.0.1";
$ldap_starttls = false;
$ldap_binddn = "cn=Manager,dc=worldoflove,dc=cn";
$ldap_bindpw = "xxxx";
$ldap_base = "dc=worldoflove,dc=cn";
$ldap_login_attribute = "uid";
$ldap_fullname_attribute = "cn";
$ldap_filter = "(&(objectClass=posixAccount)($ldap_login_attribute={login}))";
$keyphrase = "247029c9123274c78ab8160965f4d29f";  //否则有报错提醒

邮件部分
$mail_attribute = "mail";
$mail_address_use_ldap = true;
$mail_from = "1455975151@qq.com";
$mail_from_name = "Self Service Password";
$mail_signature = "";
$notify_on_change = false;
$mail_sendmailpath = '/usr/sbin/sendmail';
$mail_protocol = 'smtp';
$mail_smtp_debug = 0;
$mail_debug_format = 'html';
$mail_smtp_host = 'smtp.exmail.qq.com';
$mail_smtp_auth = true;
$mail_smtp_user = '1455975151@qq.com';
$mail_smtp_pass = 'xxx';
$mail_smtp_port = 25;
$mail_smtp_timeout = 30;
$mail_smtp_keepalive = false;
$mail_smtp_secure = 'tls';
$mail_smtp_autotls = true;
$mail_contenttype = 'text/plain';
$mail_wordwrap = 0;
$mail_charset = 'utf-8';
$mail_priority = 3;
$mail_newline = PHP_EOL;

短信部分(直接通过邮件发送验证码)
$use_sms = true;
$sms_method = "mail";
$sms_api_lib = "lib/smsapi.inc.php";
$sms_attribute = "mobile";
$sms_partially_hide_number = true;
$smsmailto = "dongsheng.ma@lemongrassmedia.cn";
$smsmail_subject = "Provider code";
$sms_message = "{smsresetmessage} {smstoken}";
$sms_sanitize_number = false;
$sms_truncate_number = false;
$sms_truncate_number_length = 10;
$sms_token_length = 6;
$max_attempts = 3;

注：短信和邮件都需要ldap有相应自动用于获取信息
```

### 设置邮箱验证及短信验证
需求：OpenLDAP用户信息需要添加Telephone及Email信息
``` bash 
直接添加所需信息会报如下错误
# ldapadd -x -D "cn=Manager,dc=worldoflove,dc=cn" -W -f users_dongsheng-test2.ldif 
Enter LDAP Password: 
adding new entry "uid=dongsheng-test2,ou=People,dc=worldoflove,dc=cn"
ldap_add: Object class violation (65)
        additional info: attribute 'email' not allowed
解决办法：
在用户信息中添加ObjectClass: inetOrgPerson信息，然后去掉objectClass: account信息
同时还需要考虑已经接入的系统的影响把之前查询account的修改为查询posixAccount，由于新增ObjectClass: inetOrgPerson还要求必须添加sn: dongsheng-test2属性
对比修改前后信息
sn: dongsheng-test2             //新增
ObjectClass: inetOrgPerson      //新增
objectClass: account            //删除
mail: 1455975151@qq.com         //邮箱
telexNumber: 13693645328        //手机
参考资料：https://stackoverflow.com/questions/28262168/openldap-add-mail-attribute-to-users
```
### 测试及验证
略
### 参考资料
- https://www.ilanni.com/?p=13822
- https://ltb-project.org
