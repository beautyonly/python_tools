[root@openldap ~]# cat /etc/redhat-release
CentOS Linux release 7.2.1511 (Core)
[root@openldap ~]# uname -r
3.10.0-327.el7.x86_64
[root@openldap ~]# uname -m
x86_64

sudo systemctl disable firewalld
sudo systemctl stop firewalld
setenforce 0
sed -i.bak 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo

yum -y install openldap-servers openldap-clients migrationtools openldap
cp /usr/share/openldap-servers/DB_CONFIG.example /var/lib/ldap/DB_CONFIG
chown ldap:ldap /var/lib/ldap/DB_CONFIG
systemctl start slapd && systemctl enable slapd

sed -i 's/my-domain/worldoflove/g' /etc/openldap/slapd.d/cn\=config/olcDatabase\=\{2\}hdb.ldif
sed -i 's/com/cn/g' /etc/openldap/slapd.d/cn\=config/olcDatabase\=\{2\}hdb.ldif
sed -i '/olcRootDN/aolcRootPW: 123456' /etc/openldap/slapd.d/cn\=config/olcDatabase\=\{2\}hdb.ldif
sed -i '/olcRootPW/aolcAccess: {1}to * by dn.base="cn=Manager,dc=worldoflove,dc=cn" write by self write by * read' /etc/openldap/slapd.d/cn\=config/olcDatabase\=\{2\}hdb.ldif
sed -i '/olcRootPW/aolcAccess: {0}to attrs=userPassword by self write by dn.base="cn=Manager,dc=worldoflove,dc=cn" write by anonymous auth by * none' /etc/openldap/slapd.d/cn\=config/olcDatabase\=\{2\}hdb.ldif

sed -i 's/my-domain/worldoflove/g' /etc/openldap/slapd.d/cn\=config/olcDatabase\=\{1\}monitor.ldif
sed -i 's/com/cn/g' /etc/openldap/slapd.d/cn\=config/olcDatabase\=\{1\}monitor.ldif

slaptest -u
grep -q "BASE    dc=worldoflove,dc=cn" /etc/openldap/ldap.conf
[ ! $? -eq 0 ] && cat >>/etc/openldap/ldap.conf<<EOF
BASE    dc=worldoflove,dc=cn
URI     ldap://127.0.0.1
EOF
systemctl restart slapd
netstat -lt | grep ldap

cd /etc/openldap/schema/
ldapadd -Y EXTERNAL -H ldapi:/// -D "cn=config" -f cosine.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -D "cn=config" -f nis.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -D "cn=config" -f collective.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -D "cn=config" -f corba.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -D "cn=config" -f core.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -D "cn=config" -f duaconf.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -D "cn=config" -f dyngroup.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -D "cn=config" -f inetorgperson.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -D "cn=config" -f java.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -D "cn=config" -f misc.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -D "cn=config" -f openldap.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -D "cn=config" -f pmi.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -D "cn=config" -f ppolicy.ldif

cd /usr/share/migrationtools/
sed -i 's/Group/Groups/g' migrate_common.ph
sed -i 's/$DEFAULT_MAIL_DOMAIN = "padl.com";/$DEFAULT_MAIL_DOMAIN = "worldoflove.cn";/g' migrate_common.ph
sed -i 's/$DEFAULT_BASE = "dc=padl,dc=com";/$DEFAULT_BASE = "dc=worldoflove,dc=cn";/g' migrate_common.ph

/usr/share/migrationtools/migrate_base.pl > /root/base.ldif

ldapadd -x -W -D "cn=Manager,dc=worldoflove,dc=cn" -f /root/base.ldif

useradd madongsheng
useradd kongxiangyi
echo '123456' | passwd --stdin madongsheng
echo '123456' | passwd --stdin kongxiangyi

getent passwd | tail -n 2 > /root/users
getent shadow | tail -n 2 > /root/shadow
getent group | tail -n 2 > /root/groups

sed -i.bak 's#/etc/shadow#/root/shadow#g' migrate_passwd.pl
/usr/share/migrationtools/migrate_passwd.pl /root/users > /root/users.ldif
/usr/share/migrationtools/migrate_group.pl /root/groups > /root/groups.ldif

ldapadd -x -W -D "cn=Manager,dc=worldoflove,dc=cn" -f /root/users.ldif
ldapadd -x -W -D "cn=Manager,dc=worldoflove,dc=cn" -f /root/groups.ldif

ldapsearch -x -b "cn=Manager,dc=worldoflove,dc=cn" -H ldap://127.0.0.1

slappasswd -s 123456
{SSHA}q2mqrO8v8us+o8B/dpsV5kO5akevBpGw

# 查看用户信息
ldapsearch -LLL -W -x -H ldap://127.0.0.1 -D "cn=Manager,dc=worldoflove,dc=cn" -b "dc=worldoflove,dc=cn" "(uid=*)"

ldapsearch -LLL -W -x -H ldap://127.0.0.1 -D "cn=Manager,dc=worldoflove,dc=cn" -b "dc=worldoflove,dc=cn" "(uid=*)" -w 11234

# 查看用户信息的某几个字段
ldapsearch -LLL -W -x -H ldap://127.0.0.1 -D "cn=Manager,dc=worldoflove,dc=cn" -b "dc=worldoflove,dc=cn" "(uid=*)" uid uidNumber

# 查看组信息
ldapsearch -LLL -W -x -H ldap://127.0.0.1 -D "cn=Manager,dc=worldoflove,dc=cn" -b "dc=worldoflove,dc=cn" "(cn=madongsheng)"

#查看指定用户信息
ldapsearch -LLL -W -x -H ldap://127.0.0.1 -D "cn=Manager,dc=worldoflove,dc=cn" -b "dc=worldoflove,dc=cn" "(uid=madongsheng)"

ldapmodify
- https://linux.die.net/man/1/ldapmodify
- https://docs.oracle.com/cd/E19957-01/820-3204/6neolgefh/index.html#bcacx
# cat b.txt 
dn: uid=chenyu,ou=People,dc=worldoflove,dc=cn
changetype: modify
add: description
description: users

ldapmodify -W -H ldap://127.0.0.1 -D "cn=Manager,dc=worldoflove,dc=cn" -f b.txt

# 组划分
管理组 manager
策划组 planner
程序组 programmer
测试组 qa
美术组 art
运营组 operator
市场组 marketer
财务组 financial
行政人事 administration

## phpldapadmin
291 $servers->setValue('server','name','ldap.worldoflove.cn');
298 $servers->setValue('server','host','127.0.0.1');
301 $servers->setValue('server','port',389);
305 $servers->setValue('server','base',array('dc=worldoflove,dc=cn'));
323 $servers->setValue('login','auth_type','session');
332 $servers->setValue('login','bind_id','cn=Manager,dc=worldoflove,dc=cn');
337 $servers->setValue('login','bind_pass','123456');
340 $servers->setValue('server','tls',false);
397 $servers->setValue('login','attr','dn');
398 //$servers->setValue('login','attr','uid');

397\398行可能会引起报错Failed to Authenticate to server

# 参考资料
https://blog.csdn.net/ggsyu730/article/details/79151080
https://www.server-world.info/en/note?os=CentOS_7&p=openldap
https://www.longger.net/article/b6eccf27.html
https://ltb-project.org/documentation/self-service-password/latest/install_rpm
https://marc.xn--wckerlin-0za.ch/computer/setup-openldap-server-in-docker
http://www.openldap.org/software/release/install.html

# rpm -ql migrationtools
/usr/share/doc/migrationtools-47
/usr/share/doc/migrationtools-47/README
/usr/share/doc/migrationtools-47/migration-tools.txt
/usr/share/migrationtools
/usr/share/migrationtools/migrate_aliases.pl
/usr/share/migrationtools/migrate_all_netinfo_offline.sh
/usr/share/migrationtools/migrate_all_netinfo_online.sh
/usr/share/migrationtools/migrate_all_nis_offline.sh
/usr/share/migrationtools/migrate_all_nis_online.sh
/usr/share/migrationtools/migrate_all_nisplus_offline.sh
/usr/share/migrationtools/migrate_all_nisplus_online.sh
/usr/share/migrationtools/migrate_all_offline.sh
/usr/share/migrationtools/migrate_all_online.sh
/usr/share/migrationtools/migrate_automount.pl
/usr/share/migrationtools/migrate_base.pl
/usr/share/migrationtools/migrate_common.ph
/usr/share/migrationtools/migrate_fstab.pl
/usr/share/migrationtools/migrate_group.pl
/usr/share/migrationtools/migrate_hosts.pl
/usr/share/migrationtools/migrate_netgroup.pl
/usr/share/migrationtools/migrate_netgroup_byhost.pl
/usr/share/migrationtools/migrate_netgroup_byuser.pl
/usr/share/migrationtools/migrate_networks.pl
/usr/share/migrationtools/migrate_passwd.pl
/usr/share/migrationtools/migrate_profile.pl
/usr/share/migrationtools/migrate_protocols.pl
/usr/share/migrationtools/migrate_rpc.pl
/usr/share/migrationtools/migrate_services.pl
/usr/share/migrationtools/migrate_slapd_conf.pl

# rpm -ql openldap-clients
/usr/bin/ldapadd
/usr/bin/ldapcompare
/usr/bin/ldapdelete
/usr/bin/ldapexop
/usr/bin/ldapmodify
/usr/bin/ldapmodrdn
/usr/bin/ldappasswd
/usr/bin/ldapsearch
/usr/bin/ldapurl
/usr/bin/ldapwhoami
/usr/share/man/man1/ldapadd.1.gz
/usr/share/man/man1/ldapcompare.1.gz
/usr/share/man/man1/ldapdelete.1.gz
/usr/share/man/man1/ldapexop.1.gz
/usr/share/man/man1/ldapmodify.1.gz
/usr/share/man/man1/ldapmodrdn.1.gz
/usr/share/man/man1/ldappasswd.1.gz
/usr/share/man/man1/ldapsearch.1.gz
/usr/share/man/man1/ldapurl.1.gz
/usr/share/man/man1/ldapwhoami.1.gz

# rpm -ql openldap-servers
/etc/openldap/check_password.conf
/etc/openldap/schema
/etc/openldap/schema/collective.ldif
/etc/openldap/schema/collective.schema
/etc/openldap/schema/corba.ldif
/etc/openldap/schema/corba.schema
/etc/openldap/schema/core.ldif
/etc/openldap/schema/core.schema
/etc/openldap/schema/cosine.ldif
/etc/openldap/schema/cosine.schema
/etc/openldap/schema/duaconf.ldif
/etc/openldap/schema/duaconf.schema
/etc/openldap/schema/dyngroup.ldif
/etc/openldap/schema/dyngroup.schema
/etc/openldap/schema/inetorgperson.ldif
/etc/openldap/schema/inetorgperson.schema
/etc/openldap/schema/java.ldif
/etc/openldap/schema/java.schema
/etc/openldap/schema/misc.ldif
/etc/openldap/schema/misc.schema
/etc/openldap/schema/nis.ldif
/etc/openldap/schema/nis.schema
/etc/openldap/schema/openldap.ldif
/etc/openldap/schema/openldap.schema
/etc/openldap/schema/pmi.ldif
/etc/openldap/schema/pmi.schema
/etc/openldap/schema/ppolicy.ldif
/etc/openldap/schema/ppolicy.schema
/etc/openldap/slapd.conf
/etc/openldap/slapd.conf.bak
/etc/openldap/slapd.d
/etc/sysconfig/slapd
/usr/lib/systemd/system/slapd.service
/usr/lib/tmpfiles.d/slapd.conf
/usr/lib64/openldap/accesslog-2.4.so.2
/usr/lib64/openldap/accesslog-2.4.so.2.10.7
/usr/lib64/openldap/accesslog.la
/usr/lib64/openldap/allop-2.4.so.2
/usr/lib64/openldap/allop-2.4.so.2.10.7
/usr/lib64/openldap/allop.la
/usr/lib64/openldap/auditlog-2.4.so.2
/usr/lib64/openldap/auditlog-2.4.so.2.10.7
/usr/lib64/openldap/auditlog.la
/usr/lib64/openldap/back_dnssrv-2.4.so.2
/usr/lib64/openldap/back_dnssrv-2.4.so.2.10.7
/usr/lib64/openldap/back_dnssrv.la
/usr/lib64/openldap/back_ldap-2.4.so.2
/usr/lib64/openldap/back_ldap-2.4.so.2.10.7
/usr/lib64/openldap/back_ldap.la
/usr/lib64/openldap/back_meta-2.4.so.2
/usr/lib64/openldap/back_meta-2.4.so.2.10.7
/usr/lib64/openldap/back_meta.la
/usr/lib64/openldap/back_null-2.4.so.2
/usr/lib64/openldap/back_null-2.4.so.2.10.7
/usr/lib64/openldap/back_null.la
/usr/lib64/openldap/back_passwd-2.4.so.2
/usr/lib64/openldap/back_passwd-2.4.so.2.10.7
/usr/lib64/openldap/back_passwd.la
/usr/lib64/openldap/back_perl-2.4.so.2
/usr/lib64/openldap/back_perl-2.4.so.2.10.7
/usr/lib64/openldap/back_perl.la
/usr/lib64/openldap/back_relay-2.4.so.2
/usr/lib64/openldap/back_relay-2.4.so.2.10.7
/usr/lib64/openldap/back_relay.la
/usr/lib64/openldap/back_shell-2.4.so.2
/usr/lib64/openldap/back_shell-2.4.so.2.10.7
/usr/lib64/openldap/back_shell.la
/usr/lib64/openldap/back_sock-2.4.so.2
/usr/lib64/openldap/back_sock-2.4.so.2.10.7
/usr/lib64/openldap/back_sock.la
/usr/lib64/openldap/check_password.so
/usr/lib64/openldap/check_password.so.1.1
/usr/lib64/openldap/collect-2.4.so.2
/usr/lib64/openldap/collect-2.4.so.2.10.7
/usr/lib64/openldap/collect.la
/usr/lib64/openldap/constraint-2.4.so.2
/usr/lib64/openldap/constraint-2.4.so.2.10.7
/usr/lib64/openldap/constraint.la
/usr/lib64/openldap/dds-2.4.so.2
/usr/lib64/openldap/dds-2.4.so.2.10.7
/usr/lib64/openldap/dds.la
/usr/lib64/openldap/deref-2.4.so.2
/usr/lib64/openldap/deref-2.4.so.2.10.7
/usr/lib64/openldap/deref.la
/usr/lib64/openldap/dyngroup-2.4.so.2
/usr/lib64/openldap/dyngroup-2.4.so.2.10.7
/usr/lib64/openldap/dyngroup.la
/usr/lib64/openldap/dynlist-2.4.so.2
/usr/lib64/openldap/dynlist-2.4.so.2.10.7
/usr/lib64/openldap/dynlist.la
/usr/lib64/openldap/memberof-2.4.so.2
/usr/lib64/openldap/memberof-2.4.so.2.10.7
/usr/lib64/openldap/memberof.la
/usr/lib64/openldap/pcache-2.4.so.2
/usr/lib64/openldap/pcache-2.4.so.2.10.7
/usr/lib64/openldap/pcache.la
/usr/lib64/openldap/ppolicy-2.4.so.2
/usr/lib64/openldap/ppolicy-2.4.so.2.10.7
/usr/lib64/openldap/ppolicy.la
/usr/lib64/openldap/pw-sha2-2.4.so.2
/usr/lib64/openldap/pw-sha2-2.4.so.2.10.7
/usr/lib64/openldap/pw-sha2.la
/usr/lib64/openldap/refint-2.4.so.2
/usr/lib64/openldap/refint-2.4.so.2.10.7
/usr/lib64/openldap/refint.la
/usr/lib64/openldap/retcode-2.4.so.2
/usr/lib64/openldap/retcode-2.4.so.2.10.7
/usr/lib64/openldap/retcode.la
/usr/lib64/openldap/rwm-2.4.so.2
/usr/lib64/openldap/rwm-2.4.so.2.10.7
/usr/lib64/openldap/rwm.la
/usr/lib64/openldap/seqmod-2.4.so.2
/usr/lib64/openldap/seqmod-2.4.so.2.10.7
/usr/lib64/openldap/seqmod.la
/usr/lib64/openldap/smbk5pwd-2.4.so.2
/usr/lib64/openldap/smbk5pwd-2.4.so.2.10.7
/usr/lib64/openldap/smbk5pwd.la
/usr/lib64/openldap/sssvlv-2.4.so.2
/usr/lib64/openldap/sssvlv-2.4.so.2.10.7
/usr/lib64/openldap/sssvlv.la
/usr/lib64/openldap/syncprov-2.4.so.2
/usr/lib64/openldap/syncprov-2.4.so.2.10.7
/usr/lib64/openldap/syncprov.la
/usr/lib64/openldap/translucent-2.4.so.2
/usr/lib64/openldap/translucent-2.4.so.2.10.7
/usr/lib64/openldap/translucent.la
/usr/lib64/openldap/unique-2.4.so.2
/usr/lib64/openldap/unique-2.4.so.2.10.7
/usr/lib64/openldap/unique.la
/usr/lib64/openldap/valsort-2.4.so.2
/usr/lib64/openldap/valsort-2.4.so.2.10.7
/usr/lib64/openldap/valsort.la
/usr/libexec/openldap/check-config.sh
/usr/libexec/openldap/convert-config.sh
/usr/libexec/openldap/functions
/usr/libexec/openldap/generate-server-cert.sh
/usr/libexec/openldap/man/man1/mdb_copy.1
/usr/libexec/openldap/man/man1/mdb_dump.1
/usr/libexec/openldap/man/man1/mdb_load.1
/usr/libexec/openldap/man/man1/mdb_stat.1
/usr/libexec/openldap/mdb_copy
/usr/libexec/openldap/mdb_dump
/usr/libexec/openldap/mdb_load
/usr/libexec/openldap/mdb_stat
/usr/libexec/openldap/upgrade-db.sh
/usr/sbin/slapacl
/usr/sbin/slapadd
/usr/sbin/slapauth
/usr/sbin/slapcat
/usr/sbin/slapd
/usr/sbin/slapdn
/usr/sbin/slapindex
/usr/sbin/slappasswd
/usr/sbin/slapschema
/usr/sbin/slaptest
/usr/share/doc/openldap-servers-2.4.44
/usr/share/doc/openldap-servers-2.4.44/README.back_perl
/usr/share/doc/openldap-servers-2.4.44/README.check_pwd
/usr/share/doc/openldap-servers-2.4.44/README.schema
/usr/share/doc/openldap-servers-2.4.44/README.smbk5pwd
/usr/share/doc/openldap-servers-2.4.44/SampleLDAP.pm
/usr/share/doc/openldap-servers-2.4.44/allmail-en.png
/usr/share/doc/openldap-servers-2.4.44/allusersgroup-en.png
/usr/share/doc/openldap-servers-2.4.44/config_dit.png
/usr/share/doc/openldap-servers-2.4.44/config_local.png
/usr/share/doc/openldap-servers-2.4.44/config_ref.png
/usr/share/doc/openldap-servers-2.4.44/config_repl.png
/usr/share/doc/openldap-servers-2.4.44/delta-syncrepl.png
/usr/share/doc/openldap-servers-2.4.44/dual_dc.png
/usr/share/doc/openldap-servers-2.4.44/guide.html
/usr/share/doc/openldap-servers-2.4.44/intro_dctree.png
/usr/share/doc/openldap-servers-2.4.44/intro_tree.png
/usr/share/doc/openldap-servers-2.4.44/ldap-sync-refreshandpersist.png
/usr/share/doc/openldap-servers-2.4.44/ldap-sync-refreshonly.png
/usr/share/doc/openldap-servers-2.4.44/n-way-multi-master.png
/usr/share/doc/openldap-servers-2.4.44/push-based-complete.png
/usr/share/doc/openldap-servers-2.4.44/push-based-standalone.png
/usr/share/doc/openldap-servers-2.4.44/refint.png
/usr/share/doc/openldap-servers-2.4.44/set-following-references.png
/usr/share/doc/openldap-servers-2.4.44/set-memberUid.png
/usr/share/doc/openldap-servers-2.4.44/set-recursivegroup.png
/usr/share/man/man5/slapd-bdb.5.gz
/usr/share/man/man5/slapd-config.5.gz
/usr/share/man/man5/slapd-dnssrv.5.gz
/usr/share/man/man5/slapd-hdb.5.gz
/usr/share/man/man5/slapd-ldap.5.gz
/usr/share/man/man5/slapd-ldbm.5.gz
/usr/share/man/man5/slapd-ldif.5.gz
/usr/share/man/man5/slapd-mdb.5.gz
/usr/share/man/man5/slapd-meta.5.gz
/usr/share/man/man5/slapd-monitor.5.gz
/usr/share/man/man5/slapd-ndb.5.gz
/usr/share/man/man5/slapd-null.5.gz
/usr/share/man/man5/slapd-passwd.5.gz
/usr/share/man/man5/slapd-perl.5.gz
/usr/share/man/man5/slapd-relay.5.gz
/usr/share/man/man5/slapd-shell.5.gz
/usr/share/man/man5/slapd-sock.5.gz
/usr/share/man/man5/slapd-sql.5.gz
/usr/share/man/man5/slapd.access.5.gz
/usr/share/man/man5/slapd.backends.5.gz
/usr/share/man/man5/slapd.conf.5.gz
/usr/share/man/man5/slapd.overlays.5.gz
/usr/share/man/man5/slapd.plugin.5.gz
/usr/share/man/man5/slapo-accesslog.5.gz
/usr/share/man/man5/slapo-allop.5.gz
/usr/share/man/man5/slapo-auditlog.5.gz
/usr/share/man/man5/slapo-chain.5.gz
/usr/share/man/man5/slapo-collect.5.gz
/usr/share/man/man5/slapo-constraint.5.gz
/usr/share/man/man5/slapo-dds.5.gz
/usr/share/man/man5/slapo-dyngroup.5.gz
/usr/share/man/man5/slapo-dynlist.5.gz
/usr/share/man/man5/slapo-memberof.5.gz
/usr/share/man/man5/slapo-pbind.5.gz
/usr/share/man/man5/slapo-pcache.5.gz
/usr/share/man/man5/slapo-ppolicy.5.gz
/usr/share/man/man5/slapo-refint.5.gz
/usr/share/man/man5/slapo-retcode.5.gz
/usr/share/man/man5/slapo-rwm.5.gz
/usr/share/man/man5/slapo-sock.5.gz
/usr/share/man/man5/slapo-sssvlv.5.gz
/usr/share/man/man5/slapo-syncprov.5.gz
/usr/share/man/man5/slapo-translucent.5.gz
/usr/share/man/man5/slapo-unique.5.gz
/usr/share/man/man5/slapo-valsort.5.gz
/usr/share/man/man8/slapacl.8.gz
/usr/share/man/man8/slapadd.8.gz
/usr/share/man/man8/slapauth.8.gz
/usr/share/man/man8/slapcat.8.gz
/usr/share/man/man8/slapd.8.gz
/usr/share/man/man8/slapdn.8.gz
/usr/share/man/man8/slapindex.8.gz
/usr/share/man/man8/slappasswd.8.gz
/usr/share/man/man8/slapschema.8.gz
/usr/share/man/man8/slaptest.8.gz
/usr/share/openldap-servers
/usr/share/openldap-servers/DB_CONFIG.example
/usr/share/openldap-servers/slapd.ldif
/var/lib/ldap
/var/run/openldap
