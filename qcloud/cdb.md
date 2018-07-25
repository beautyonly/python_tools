# CDB
[使用物理备份文件恢复数据库](https://cloud.tencent.com/document/product/236/7944)

``` bash
1、部署全新数据库实例一个
wget https://raw.githubusercontent.com/mds1455975151/tools/master/shell/host_init.sh
sh host_init.sh

wget https://raw.githubusercontent.com/mds1455975151/tools/master/mysql/install_mysql.sh
sh install_mysql.sh
2、下载腾讯物理备份
3、解压缩
4、开始恢复
systemctl stop mysqld
ps -ef|grep mysql
netstat -tunlp|grep 3306
cd /var/lib/
mv mysql mysql.`date +%Y%m%d`
cp -rf /data0/cdb_backup/backup/cdb-4i0yggsn_20180607022501 mysql
chown -R mysql:mysql /var/lib/mysql
cp /etc/my.cnf{,.`date +%Y%m%d`}
vim /etc/my.cnf  新增如下参数
[mysqld]

#innodb_checksum_algorithm=innodb
#innodb_log_checksum_algorithm=innodb
innodb_data_file_path=ibdata1:12M:autoextend
innodb_log_files_in_group=2
innodb_log_file_size=536870912
#innodb_fast_checksum=false
#innodb_page_size=16384
#innodb_log_block_size=512
innodb_undo_directory=.
innodb_undo_tablespaces=0
server_id=0

systemctl start mysqld
mysql -uroot
> update mysql.user set password='*6BB4837EB74329105EE4568DDA7DC67ED2CA2AD9' where user='root' and host='127.0.0.1';
> update mysql.user set password='*6BB4837EB74329105EE4568DDA7DC67ED2CA2AD9' where user='root' and host='localhost';
> delete from mysql.user where user='tencentdumper' or user='tencentroot';
> delete from mysql.user where user = '';
> delete from mysql.user where password = '';

> delete from mysql.db where user<>'root' and char_length(user)>0;
> delete from mysql.tables_priv where user<>'root' and char_length(user)>0;
> flush privileges;
> select user,host,password from mysql.user;
5、如果可以先校验下数据条目数量
6、应用测试访问
```
