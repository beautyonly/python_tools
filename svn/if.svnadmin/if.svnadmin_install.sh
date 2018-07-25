#!/bin/env bash
svndata_dir="/data0/svndata"
ip="192.168.200.104"

httpd_install(){
yum install -y httpd
}

svn_install(){
yum install -y mod_dav_svn subversion
}

httpd_svn_set(){
cat>/etc/httpd/conf.d/subversion.conf<<EOF
LoadModule dav_svn_module     modules/mod_dav_svn.so
LoadModule authz_svn_module   modules/mod_authz_svn.so
<Location /svn>
   DAV svn
   SVNParentPath ${svndata_dir}
   # Limit write permission to list of valid users.
   #<LimitExcept GET PROPFIND OPTIONS REPORT>
      # Require SSL connection for password protection.
      # SSLRequireSSL
      AuthType Basic
      AuthName "Authorization Realm"
      #AuthUserFile ${svndata_dir}/test/conf/passwdfile
      AuthUserFile /etc/subversion/passwd
      AuthzSVNAccessFile /etc/subversion/auth
      Require valid-user
   #</LimitExcept>
</Location>
EOF

mkdir -p ${svndata_dir}
touch /etc/subversion/passwd /etc/subversion/auth
chown -R apache.apache ${svndata_dir} /etc/subversion/passwd /etc/subversion/auth
yum install -y php
wget https://jaist.dl.sourceforge.net/project/ifsvnadmin/svnadmin-1.6.2.zip
unzip -oq svnadmin-1.6.2.zip 
rm -rf /var/www/html/svnadmin
\mv iF.SVNAdmin-stable-1.6.2/ /var/www/html/svnadmin
cat>/var/www/html/svnadmin/data/config.ini<<EOF
[Common]
FirstStart=0
BackupFolder=./data/backup/

[Translation]
Directory=./translations/

[Engine:Providers]
AuthenticationStatus=basic
UserViewProviderType=passwd
UserEditProviderType=passwd
GroupViewProviderType=svnauthfile
GroupEditProviderType=svnauthfile
AccessPathViewProviderType=svnauthfile
AccessPathEditProviderType=svnauthfile
RepositoryViewProviderType=svnclient
RepositoryEditProviderType=svnclient

[ACLManager]
UserRoleAssignmentFile=./data/userroleassignments.ini

[Subversion]
SVNAuthFile=/etc/subversion/auth

[Repositories:svnclient]
SVNParentPath=${svndata_dir}
SvnExecutable=/usr/bin/svn
SvnAdminExecutable=/usr/bin/svnadmin

[Users:passwd]
SVNUserFile=/etc/subversion/passwd

[Users:digest]
SVNUserDigestFile=
SVNDigestRealm=SVN Privat

[Ldap]
HostAddress=ldap://192.168.136.130:389/
ProtocolVersion=3
BindDN=CN=Manuel Freiholz,CN=Users,DC=insanefactory,DC=com
BindPassword=root
CacheEnabled=false
CacheFile=./data/ldap.cache.json

[Users:ldap]
BaseDN=DC=insanefactory,DC=com
SearchFilter=(&(objectClass=person)(objectClass=user))
Attributes=sAMAccountName

[Groups:ldap]
BaseDN=DC=insanefactory,DC=com
SearchFilter=(objectClass=group)
Attributes=sAMAccountName
GroupsToUserAttribute=member
GroupsToUserAttributeValue=distinguishedName

[Update:ldap]
AutoRemoveUsers=true
AutoRemoveGroups=true

[GUI]
RepositoryDeleteEnabled=false
RepositoryDumpEnabled=false
AllowUpdateByGui=true
ApacheDirectoryListing=http://${ip}/svn/%1/%2
CustomDirectoryListing=http://${ip}/svnadmin/repositoryview.php?r=%1&p=%2
EOF
cd /var/www/html && chown -R apache.apache svnadmin
cd /var/www/html/svnadmin && chmod -R 777 data
setenforce 0
service httpd restart

echo "http://${ip}/svnadmin username=admin password=admin"
echo "client: svn co http://${ip}/svn/xxx"
service httpd restart
}

main(){
httpd_install
svn_install
httpd_svn_set
}

main
