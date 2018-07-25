## 备份脚本
``` bash
# cat /data0/backups/openldap_backup.sh
#!/bin/env bash
base_dir="/data0/backups"
keep_days="7"
daytime=`date +%Y%m%d`

[ ! -d ${base_dir} ] && mkdir -p ${base_dir}
slapcat -v -l ${base_dir}/openldap_backup_tmp_${daytime}.ldif >/dev/null 2>&1
if [ $? -eq 0 ]
then
    echo "backup is ok"
else
    echo "backup is fail"
fi

cat >slapcat.regex <<EOF
/^creatorsName: /d
/^createTimestamp: /d
/^modifiersName: /d
/^modifyTimestamp: /d
/^structuralObjectClass: /d
/^entryUUID: /d
/^entryCSN: /d
EOF

cat ${base_dir}/openldap_backup_tmp_${daytime}.ldif|sed -f slapcat.regex >${base_dir}/openldap_backup_${daytime}.ldif
echo "clear old backup"
cd ${base_dir} && find . -type f -name "openldap_backup*ldif" -mtime +7
cd ${base_dir} && find . -type f -name "openldap_backup*ldif" -mtime +7 | xargs rm -f

cd ${base_dir} && \cp -rf /etc/openldap openldap
cd ${base_dir} && tar -zcf openldap_backup_${daytime}.tar.gz openldap_backup*ldif openldap
cd ${base_dir} && rm -rf openldap_backup*ldif openldap slapcat.regex
```

## 数据还原
``` bash
ldapdelete -x -H ldap://127.0.0.1 -D "cn=Manager,dc=worldoflove,dc=cn" -W -r "dc=worldoflove,dc=cn"
ldapadd -x -H ldap://127.0.0.1 -D "cn=Manager,dc=worldoflove,dc=cn" -W -f openldap_backup_20170427.ldif
```
