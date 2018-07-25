#!/bin/bash

. /etc/init.d/functions

RED_COLOR='\E[1;31m'
GREEN_COLOR='\E[1;32m'
YELLOW_COLOR='\E[1;33m'
BLUE_COLOR='\E[1;34m'
RES='\E[0m'

dir='/svndata' 		#svn的目录
name='puppet'  		#svn的资源库名称
user='test'    		#svn验证登陆的用户名 
passwd='test'  		#svn验证登陆的密码
yum -y install httpd httpd-devel subversion mod_dav_svn expect 
mkdir -p $dir  
cd $dir/  
svnadmin create $name  
chown -R apache:apache $name   
cat >/etc/httpd/conf.d/subversion.conf<<EOF
LoadModule dav_svn_module     modules/mod_dav_svn.so  
LoadModule authz_svn_module   modules/mod_authz_svn.so  
<Location /svn> 
DAV svn  
SVNListParentPath on  
SVNPath "$dir/$name"  
AuthType Basic  
AuthName "Subversion repository"  
AuthUserFile "$dir/$name/conf/authfile"  
Require valid-user  
SVNAutoversioning on  
ModMimeUsePathInfo on  
</Location> 
EOF

echo "  
[groups]  
admin = test 
[admin:/]  
@admin = rw 
[/]  
* = r  
[$name:/]  
test = rw">>$dir/$name/conf/authz  

echo '#!/usr/bin/expect  
spawn /usr/bin/htpasswd -c '$dir'/'$name'/conf/authfile test  
expect "New password:"  
send "'$passwd'\n"  
expect "Re-type new password:"  
send "'$passwd'\n"  
interact'>/tmp/htpasswd.sh  

/usr/bin/expect /tmp/htpasswd.sh  
chown apache:apache $dir/$name/conf/authfile  
echo "$user = $passwd">>$dir/$name/conf/passwd  
#svn import $dir/$name/ file://$dir/$name -m "Initial repository"  
sed -i 's/# anon-access = read/anon-access = none/g' $dir/$name/conf/svnserve.conf   
sed -i 's/# auth-access = write/auth-access = write/g' $dir/$name/conf/svnserve.conf  
sed -i 's/# password-db = passwd/password-db = \'$dir'\/'$name'\/conf\/passwd/g' $dir/$name/conf/svnserve.conf  
sed -i 's/# authzauthz-db = authz/authz-db = \'$dir'\/'$name'\/conf\/authz/g' $dir/$name/conf/svnserve.conf  
sed -i 's/# realm = My First Repository/realm = puppt Repository/g' $dir/$name/conf/svnserve.conf  
/etc/init.d/httpd restart  
svnserve -d -r $dir/$name/
