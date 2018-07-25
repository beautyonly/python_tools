# SVN 知识总结
- https://www.cnblogs.com/eastson/p/6051269.html
- https://blog.csdn.net/wanglei_storage/article/details/52663328
- [修复svn hook导致的字符集错误](http://www.bubuko.com/infodetail-2220484.html)

# svn + httpd + openldap
``` bash
#!/bin/env bash
# 由于svn hook导致的字符集错误，直接安装1.8+的版本，非系统默认版本
cat>/etc/yum.repos.d/wandisco-svn.repo<<EOF
[WandiscoSVN]
name=Wandisco SVN Repo
baseurl=http://opensource.wandisco.com/centos/$releasever/svn-1.8/RPMS/$basearch/
enabled=1
gpgcheck=0
EOF
yum install -y httpd svn mod_dav_svn mod_ldap
cp /etc/httpd/conf.modules.d/10-subversion.conf /etc/httpd/conf.d/subversion.conf
cat>/etc/httpd/conf.d/subversion.conf<<EOF
LoadModule dav_svn_module     modules/mod_dav_svn.so
LoadModule authz_svn_module   modules/mod_authz_svn.so
LoadModule dontdothat_module  modules/mod_dontdothat.so

<Location /opt/svn>
    DAV svn
    SVNParentPath /opt/svn
    SVNListParentPath On
    AuthzSVNAccessFile /opt/svn/authz

    AuthBasicProvider ldap
    AuthType Basic
    AuthName "Subversion repository"
    AuthLDAPURL "ldap://192.168.1.200:389/dc=hongxue,dc=com?uid?sub?(objectClass=*)"
    AuthLDAPBindDN "cn=root,dc=hongxue,dc=com"
    AuthLDAPBindPassword "123456"
    Require valid-user
</Location>
EOF
systemctl start httpd.service
systemctl enable httpd.service
cd /opt/ && svnadmin create svn
svnserve -d -r /opt/svn/
chown apache.apache -R /opt/svn
```

# svn + httpd
``` bash
#!/bin/env bash
# 由于svn hook导致的字符集错误，直接安装1.8+的版本，非系统默认版本
cat>/etc/yum.repos.d/wandisco-svn.repo<<EOF
[WandiscoSVN]
name=Wandisco SVN Repo
baseurl=http://opensource.wandisco.com/centos/$releasever/svn-1.8/RPMS/$basearch/
enabled=1
gpgcheck=0
EOF
yum install -y httpd svn mod_dav_svn
cp /etc/httpd/conf.modules.d/10-subversion.conf /etc/httpd/conf.d/subversion.conf

cat>/etc/httpd/conf.d/subversion.conf<<EOF 
LoadModule dav_svn_module     modules/mod_dav_svn.so
LoadModule authz_svn_module   modules/mod_authz_svn.so
LoadModule dontdothat_module  modules/mod_dontdothat.so

<Location /opt/svn>
    DAV svn
    SVNParentPath /opt/svn

    AuthType Basic
    AuthName "Subversion repository"
    AuthzSVNAccessFile /opt/svn/test/conf/authz
    AuthUserFile /opt/svn/test/conf/httpd_passwd
    Require valid-user
</Location>

systemctl start httpd.service
systemctl enable httpd.service
cd /opt/svn && svnadmin create test
svnserve -d -r /opt/svn/
chown apache.apache -R /opt/svn

touch /opt/svn/test/conf/httpd_passwd  #创建用户文件

htpasswd /opt/svn/test/conf/httpd_passwd admin  #创建用户admin
htpasswd /opt/svn/test/conf/httpd_passwd guest  #创建用户guest

# cat /opt/svn/test/conf/httpd_passwd 
admin:$apr1$UCkPzZ2x$tnDk2rgZoiaURPzO2e57t0
guest:$apr1$vX1RIUq6$OKS1bqKZSptzsPDYUOJ5x.

# cat /opt/svn/test/conf/authz
[/]
admin = rw
guest = r
```
