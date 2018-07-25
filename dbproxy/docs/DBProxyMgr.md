# DBProxyMgr
```
cd /data0/dbproxy/infra-fp-mysql-dbproxy/DBProxyMgr
make    # 复制DBProxy代码，编译，复制配置
sed -i 's/FPNN.server.listening.port = 12321/FPNN.server.listening.port = 12322/g' DBProxy.conf
sed -n '/FPNN.server.listening.port/p' DBProxy.conf

vim DBProxy.conf    # 新增配置项 确保大批量更新时不会超时
FPNN.server.idle.timeout = 1800

wget https://raw.githubusercontent.com/mds1455975151/tools/master/supervisor/install_supervisor.sh
sh install_supervisor.sh


cat>/etc/supervisord.d/dbproxymgr.ini<<EOF
[program:dbproxymgr]
directory = /data0/dbproxy/infra-fp-mysql-dbproxy/DBProxyMgr/DBPM
command = /data0/dbproxy/infra-fp-mysql-dbproxy/DBProxyMgr/DBPM/DBProxyMgr DBProxy.conf
priority=1
numprocs=1
autostart=true
autorestart=true
stderr_logfile=/var/log/dbproxymgr_err.log
stdout_logfile=/var/log/dbproxymgr_out.log
EOF
supervisorctl update
supervisorctl status
netstat -tunlp|grep 12322
```
# 修改表结构
``` bash
cd /data0/dbproxy/infra-fp-mysql-dbproxy/tools
./DBParamsQuery -h
Usage: 
        ./DBParamsQuery [-h host] [-p port] [-t table_name] [-timeout timeout_seconds] <hintId | -i int_hintIds | -s string_hintIds> sql [param1 param2 ...]

        Notes: host default is localhost, and port default is 12321.
        
DBParamsQuery使用配置库里面的账号去操作表结构，默认权限不足，解决方案有两种：
1、可以复制一个配置库，用有权限的业务库账号替换现有的业务库账号，作为DBA的配置库。然后DBProxyManager 指向这个配置库
2、临时给业务库的账号alter权限，处理完后再删除该权限(DBProxy会自动阻止业务的alter操作)        

选择第一种方案，操作方法如下：
#!/bin/env bash

mysqldump -udump -p'123456' -h127.0.0.1 dbproxy --single-transaction --opt >dbproxy.sql
mysql -uroot -p123456 -h127.0.0.1 -e "CREATE DATABASE dbproxymgr;"
mysql -uroot -p123456 -h127.0.0.1 dbproxymgr < dbproxy.sql
mysql -uroot -p123456 -h127.0.0.1 -e "update dbproxymgr.server_info set user='dba';"

sed -i 's/DBProxy.ConfigureDB.databaseName = dbproxy/DBProxy.ConfigureDB.databaseName = dbproxymgr/g' /data0/dbproxy/infra-fp-mysql-dbproxy/DBProxyMgr/DBPM/DBProxy.conf
supervisorctl status
supervisorctl restart DBProxyMgr

./DBParamsQuery -h 10.0.0.14 -p 12322 -i "" "desc user;"
./DBParamsQuery -h 10.0.0.14 -p 12322 -i "" "show create table user" 
./DBParamsQuery -h 10.0.0.14 -p 12322 -i "" "ALTER TABLE user COMMENT = '用户信息1';"
./DBParamsQuery -h 10.0.0.14 -p 12322 -i "" "ALTER TABLE user_friend_unlock ADD COLUMN testField varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'aaa' AFTER isShow;"
./DBParamsQuery -h 10.0.0.14 -p 12322 -i "" "ALTER TABLE user_friend_unlock DROP COLUMN testField;"

检查修改一致性
./DBTableStrictChecker 10.0.0.14 12322 user_friend_unlock

Query interface 'splitInfo' ...
----------------------------------
Split type: Hash
Table Count: 4
Split Hint: uid
----------------------------------
Query interface 'allSplitHintIds' ...
... checking sub-table 0 by hintId: 0 ... [OK]
... checking sub-table 1 by hintId: 1 ... [OK]
... checking sub-table 2 by hintId: 2 ... [OK]
... checking sub-table 3 by hintId: 3 ... [OK]
----------------------------------
All sub-tables are OK!

time cost 4.76 ms
```
