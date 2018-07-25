## 密码
### LDAP管理员更改其他用户的密码
``` bash
# ldappasswd -H ldap://127.0.0.1 -x -D "cn=Manager,dc=worldoflove,dc=cn" -W -S "uid=madongsheng,ou=People,dc=worldoflove,dc=cn"
New password:
Re-enter new password:
Enter LDAP Password:
```
### LDAP用户自行修改密码
```
# slapd -V
@(#) $OpenLDAP: slapd 2.4.40 (Nov 19 2015 21:55:20) $
        mockbuild@worker1.bsys.centos.org:/builddir/build/BUILD/openldap-2.4.40/openldap-2.4.40/servers/slapd
# vim cn\=config/olcDatabase\=\{2\}hdb.ldif
olcRootPW: 1234567
# systemctl restart slapd
测试即可
```
## 分析性能
https://prefetch.net/articles/monitoringldap.html

### 跟踪操作时间
当LDAP客户机和服务器通过路由器和防火墙分隔时，偶尔发生的网络问题（例如，丢失的TCP段或损坏的CRC）可能会导致应用程序意外的行为。为了帮助衡量一个LDAP客户机和服务器之间的延迟，我们开发了ldap-ping.pl。ldap-ping.pl是用Perl编写的，并且依赖于Time::HiRes, Getopt::Std, Net::LDAP 和Net::LDAPS模块。

ldap-ping.pl的工作原理是打开一个TCP连接到目录服务器，发出匿名绑定，搜索RootDSE，并从服务器取消绑定。这些操作使用Perl的高分辨率计时器进行测量，并以ping的格式进行显示：
```
$ yum install -y perl-Net-HTTP perl-Getopt-Simple perl-Time-HiRes perl-Socket perl-LDAP
$ ldap-ping.pl -s ldap.prefetch.net -p 389 -d 10
Querying LDAP server ldap.prefetch.net:389 every 10 seconds (Ctrl-C to stop):
Fri Nov 12 16:42:14 2004: new=0.025s, = bind=0.008s, search=0.067s, unbind=0.003s [local port=50377] [Normal Delay]
Fri Nov 12 16:42:25 2004: new=0.011s, = bind=0.001s, search=0.015s, unbind=0.001s [local port=50378] [Normal Delay]
Fri Nov 12 16:42:35 2004: new=0.010s, = bind=0.002s, search=0.015s, unbind=0.001s [local port=50379] [Normal Delay]
Fri Nov 12 16:42:45 2004: new=0.009s, = bind=0.002s, search=0.015s, unbind=0.001s [local port=50380] [Normal Delay]
```
ldap-ping.pl脚本接受三个参数：
- -s：选项表示连接到的服务器
- -p：选项指定目录服务器监听的TCP端口
- -d：选项允许管理员指定探测之间的延迟。如果存在二进制pfiles文件，脚本也将打印本地端口号。

### 跟踪性能

### 收集性能数据
ldap-gather.pl

### 把LDAP性能数据生成图表
- https://www.orcaware.com/
```
yum install -y perl-ExtUtils-MakeMaker libtool
yum install perl-Data-Dumper perl-Digest-MD5
tar -zxf orca-0.27.tar.gz
cd orca-0.27/
./configure --with-html-dir=/usr/share/nginx/html/
```
