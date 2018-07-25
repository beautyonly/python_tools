## 功能：测试某个用户是否为某个组的成员
## 参考资料
- http://www.adimian.com/blog/2014/10/how-to-enable-memberof-using-openldap/
- https://blog.csdn.net/tongdao/article/details/52538365
- **http://docs.blowb.org/install-essential-docker/openldap.html**

## 测试过程
### memberof.ldif 
```
# cat memberof.ldif 
dn: cn=module,cn=config
cn: module
objectclass: olcModuleList
objectclass: top
olcmoduleload: memberof.la
olcmodulepath: /usr/lib64/openldap

dn: olcOverlay={0}memberof,olcDatabase={2}hdb,cn=config
objectClass: olcConfig
objectClass: olcMemberOf
objectClass: olcOverlayConfig
objectClass: top
olcOverlay: memberof

dn: cn=module,cn=config
cn: module
objectclass: olcModuleList
objectclass: top
olcmoduleload: refint.la
olcmodulepath: /usr/lib64/openldap

dn: olcOverlay={1}refint,olcDatabase={2}hdb,cn=config
objectClass: olcConfig
objectClass: olcOverlayConfig
objectClass: olcRefintConfig
objectClass: top
olcOverlay: {1}refint
olcRefintAttribute: memberof member manager owner
```
### add memberof.ldif
``` bash
ldapadd -Y EXTERNAL -H ldapi:/// -f memberof.ldif
```
### Adding a user
``` bash
# slappasswd -h {SHA} -s 123456
{SHA}fEqNCco3Yq9h5ZUglD3CZJT4lBs=
# cat add_user.ldif 
dn: uid=john,ou=People,dc=worldoflove,dc=cn
cn: John Doe
givenName: John
sn: Doe
uid: john
uidNumber: 5000
gidNumber: 10000
homeDirectory: /home/john
mail: john.doe@example.com
objectClass: top
objectClass: posixAccount
objectClass: shadowAccount
objectClass: inetOrgPerson
objectClass: organizationalPerson
objectClass: person
loginShell: /bin/bash
userPassword: {SHA}fEqNCco3Yq9h5ZUglD3CZJT4lBs=
# ldapadd -x -D "cn=Manager,dc=worldoflove,dc=cn" -W -f add_user.ldif
nter LDAP Password: 
adding new entry "uid=john,ou=People,dc=worldoflove,dc=cn"
```
### Adding a group
``` bash
# cat add_group.ldif 
dn: cn=mygroup,ou=Groups,dc=worldoflove,dc=cn
objectClass: groupofnames
cn: mygroup
description: All users
member: uid=john,ou=People,dc=worldoflove,dc=cn
# ldapadd -x -D "cn=Manager,dc=worldoflove,dc=cn" -W -f add_group.ldif
Enter LDAP Password: 
adding new entry "cn=mygroup,ou=Groups,dc=worldoflove,dc=cn"
```
### Taking it for a test-run
``` bash
# ldapsearch -x -LLL -H ldap:/// -b uid=john,ou=People,dc=worldoflove,dc=cn dn memberof
dn: uid=john,ou=People,dc=worldoflove,dc=cn
# ldapsearch -x -LLL -H ldap:/// -b ou=Group,dc=worldoflove,dc=cn dn memberof       # Group组有多少子组
# ldapsearch -x -LLL -H ldap:/// -b cn=qa,ou=Group,dc=worldoflove,dc=cn dn member   # qa组里面的成员
dn: cn=qa,ou=Group,dc=worldoflove,dc=cn
member: uid=xxx,ou=People,dc=worldoflove,dc=cn
member: uid=xxx,ou=People,dc=worldoflove,dc=cn
```
And it should yield this result
``` bash
dn: uid=john,ou=People,dc=worldoflove,dc=cn
memberOf: cn=mygroup,ou=groups,dc=worldoflove,dc=cn
```

### 如何给新组添加成员
- 方案1：phpldapadmin
```
域-->Group-->cn=mygroup组-->member-->点击赋值按钮新增条目
```
- 方案2：修改member信息然后删除组重建

``` 
# cat add_group.ldif
dn: cn=confluence-users-openldap,ou=Group,dc=worldoflove,dc=cn
objectClass: groupofnames
cn: confluence-users-openldap
description: All users
member: uid=dongsheng-test1,ou=People,dc=worldoflove,dc=cn
member: uid=john,ou=People,dc=worldoflove,dc=cn
```
