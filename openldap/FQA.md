### 错误1：ldap_add: Server is unwilling to perform (53)
``` 
导入文件时出现
/usr/local/openldap/bin/ldapadd -x -D 'cn=Manager,dc=duxingyu,dc=com' -W -f init.ldif 
Enter LDAP Password: 
adding new entry "dc=extmail.org"
ldap_add: Server is unwilling to perform (53)
        additional info: no global superior knowledge
解决：添加dc=duxingyu,dc=com这个条目，并且你dc=extmail.org这个dn也写的有问题，需要跟配置文件一样。
```

