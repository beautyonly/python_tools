# start cluster
``` bash
# 普通用户添加到root组
useradd vitess
usermod vitess -G root
chmod -R 777 /data0/workspaces/go/
cat >>/etc/profile<<EOF
# vitess env setup

export VTROOT=$GOPATH
export VTDATAROOT=$GOPATH/vtdataroot
export MYSQL_FLAVOR=MySQL56
export VT_MYSQL_ROOT=/usr
EOF

source /etc/profile

su - vitess   # 使用普通用户操作
mkdir -p $GOPATH/vtdataroot
cd $VTROOT/src/vitess.io/vitess/examples/local
./zk-up.sh 
./vtctld-up.sh    # 未启动 排查错误日志目录：/data0/workspaces/go/vtdataroot
./vttablet-up.sh
./lvtctl.sh InitShardMaster -force test_keyspace/0 test-100  # 修改keyspace name及 cell-xxx
./lvtctl.sh ListAllTablets test                              # test为cell名称，根据需要修改该变量
./lvtctl.sh ApplySchema -sql "$(cat create_test_table.sql)" test_keyspace   # sql文件里面不能包含注释性信息
./lvtctl.sh Backup test-0000000102
./lvtctl.sh ListBackups test_keyspace/0
./lvtctl.sh RebuildVSchemaGraph
./vtgate-up.sh
./client.sh

# 每个-up.sh脚本都有相应的-down.sh脚本来停止服务器。
./vtgate-down.sh
./vttablet-down.sh
./vtctld-down.sh
./zk-down.sh
cd $VTDATAROOT
rm -rf *

for i in `seq 0 4`;do mysql -P 1710$i -p123456 -e "show databases;" ;done
for i in `seq 0 4`;do mysql -P 1710$i -p123456 -e "create database 1700${i}_t1;" ;done
localhost:21811,localhost:21812,localhost:21813

# 设置shard
cat vschema.json
{
  "sharded": true,
  "vindexes": {
    "hash": {
      "type": "hash"
    }
  },
  "tables": {
    "messages": {
      "column_vindexes": [
        {
          "column": "page",
          "name": "hash"
        }
      ]
    }
  }
}
./lvtctl.sh ApplyVSchema -vschema "$(cat vschema.json)" test_keyspace
./sharded-vttablet-up.sh

./lvtctl.sh InitShardMaster -force test_keyspace/-80 test-200
./lvtctl.sh InitShardMaster -force test_keyspace/80- test-300

./vtworker-up.sh
./lvtctl.sh WorkflowCreate -skip_start=false horizontal_resharding -keyspace=test_keyspace -vtworkers=localhost:15033 -enable_approvals=true

./lvtctl.sh ExecuteFetchAsDba test-100 "SELECT * FROM messages"
./lvtctl.sh ExecuteFetchAsDba test-200 "SELECT * FROM messages"
./lvtctl.sh ExecuteFetchAsDba test-300 "SELECT * FROM messages"

./vttablet-down.sh
./lvtctl.sh DeleteShard -recursive test_keyspace/0

注释：
1、sql语句中不能带有注释性信息
E0508 10:13:56.561864    3779 main.go:61] Remote error: rpc error: code = Unknown desc = schema change works for DDLs only, but get non DDL statement
```

# 如何登陆到MySQL实例，并查看想内容并进行管理？
> 使用默认MySQL命令连接到MySQL实例，有些内容及权限无法获取(原因未知)

``` bash 
./lvtctl.sh ExecuteFetchAsDba test-0000000100 "SELECT VERSION()"
mysql -S /data0/workspaces/go/vtdataroot/vt_0000000100/mysql.sock -u vt_dba 
$ mysql -S /data0/workspaces/go/vtdataroot/vt_0000000100/mysql.sock -u vt_dba
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 168
Server version: 5.6.40-log MySQL Community Server (GPL)

Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| _vt                |
| mysql              |
| performance_schema |
| vt_test_keyspace   |
+--------------------+
5 rows in set (0.01 sec)

mysql> show master status\G;
*************************** 1. row ***************************
             File: vt-0000000100-bin.000001
         Position: 7667
     Binlog_Do_DB: 
 Binlog_Ignore_DB: 
Executed_Gtid_Set: 53136e2c-504d-11e8-a929-000c2933cf1a:1-19
1 row in set (0.00 sec)

ERROR: 
No query specified
mysql> show slave hosts;
+------------+------+-------+-----------+--------------------------------------+
| Server_id  | Host | Port  | Master_id | Slave_UUID                           |
+------------+------+-------+-----------+--------------------------------------+
| 1864487013 |      | 17101 | 846590132 | 531f845a-504d-11e8-a929-000c2933cf1a |
| 1195076531 |      | 17104 | 846590132 | 530d7564-504d-11e8-a929-000c2933cf1a |
|  797034261 |      | 17102 | 846590132 | 531f70d5-504d-11e8-a929-000c2933cf1a |
| 1178748316 |      | 17103 | 846590132 | 531a46e1-504d-11e8-a929-000c2933cf1a |
+------------+------+-------+-----------+--------------------------------------+
4 rows in set (0.00 sec)

```

# FQA
``` bash 
# ./zk-up.sh 
enter zk2 env
Starting zk servers...
Waiting for zk servers to be ready...
Started zk servers.
Configured zk servers.
# ps -ef|grep zk
root      55694      1  0 15:24 pts/1    00:00:00 /bin/bash /data0/workspaces/go/bin/zksrv.sh /data0/workspaces/go/vtdataroot/zk_001/logs /data0/workspaces/go/vtdataroot/zk_001/zoo.cfg /data0/workspaces/go/vtdataroot/zk_001/zk.pid
root      55695      1  0 15:24 pts/1    00:00:00 /bin/bash /data0/workspaces/go/bin/zksrv.sh /data0/workspaces/go/vtdataroot/zk_002/logs /data0/workspaces/go/vtdataroot/zk_002/zoo.cfg /data0/workspaces/go/vtdataroot/zk_002/zk.pid
root      55697      1  0 15:24 pts/1    00:00:00 /bin/bash /data0/workspaces/go/bin/zksrv.sh /data0/workspaces/go/vtdataroot/zk_003/logs /data0/workspaces/go/vtdataroot/zk_003/zoo.cfg /data0/workspaces/go/vtdataroot/zk_003/zk.pid
root      55706  55697  9 15:24 pts/1    00:00:00 java -server -DZOO_LOG_DIR=/data0/workspaces/go/vtdataroot/zk_003/logs -cp /data0/workspaces/go/dist/vt-zookeeper-3.4.10/lib/zookeeper-3.4.10-fatjar.jar:/usr/local/lib/zookeeper-3.4.10-fatjar.jar:/usr/share/java/zookeeper-3.4.10.jar org.apache.zookeeper.server.quorum.QuorumPeerMain /data0/workspaces/go/vtdataroot/zk_003/zoo.cfg
root      55708  55695  9 15:24 pts/1    00:00:00 java -server -DZOO_LOG_DIR=/data0/workspaces/go/vtdataroot/zk_002/logs -cp /data0/workspaces/go/dist/vt-zookeeper-3.4.10/lib/zookeeper-3.4.10-fatjar.jar:/usr/local/lib/zookeeper-3.4.10-fatjar.jar:/usr/share/java/zookeeper-3.4.10.jar org.apache.zookeeper.server.quorum.QuorumPeerMain /data0/workspaces/go/vtdataroot/zk_002/zoo.cfg
root      55711  55694  9 15:24 pts/1    00:00:00 java -server -DZOO_LOG_DIR=/data0/workspaces/go/vtdataroot/zk_001/logs -cp /data0/workspaces/go/dist/vt-zookeeper-3.4.10/lib/zookeeper-3.4.10-fatjar.jar:/usr/local/lib/zookeeper-3.4.10-fatjar.jar:/usr/share/java/zookeeper-3.4.10.jar org.apache.zookeeper.server.quorum.QuorumPeerMain /data0/workspaces/go/vtdataroot/zk_001/zoo.cfg
root      55834   1624  0 15:24 pts/1    00:00:00 grep --color=auto zk

# ./vttablet-up.sh 
enter zk2 env
Starting MySQL for tablet test-0000000100...
Resuming from existing vttablet dir:
    /data0/workspaces/go/vtdataroot/vt_0000000100
Starting MySQL for tablet test-0000000101...
Resuming from existing vttablet dir:
    /data0/workspaces/go/vtdataroot/vt_0000000101
Starting MySQL for tablet test-0000000102...
Resuming from existing vttablet dir:
    /data0/workspaces/go/vtdataroot/vt_0000000102
Starting MySQL for tablet test-0000000103...
Resuming from existing vttablet dir:
    /data0/workspaces/go/vtdataroot/vt_0000000103
Starting MySQL for tablet test-0000000104...
Resuming from existing vttablet dir:
    /data0/workspaces/go/vtdataroot/vt_0000000104
E0501 09:29:00.906744   81118 mysqlctl.go:260] failed start mysql: deadline exceeded waiting for mysqld socket file to appear: /data0/workspaces/go/vtdataroot/vt_0000000103/mysql.sock
E0501 09:29:00.906760   81119 mysqlctl.go:260] failed start mysql: deadline exceeded waiting for mysqld socket file to appear: /data0/workspaces/go/vtdataroot/vt_0000000104/mysql.sock
E0501 09:29:00.907342   81117 mysqlctl.go:260] failed start mysql: deadline exceeded waiting for mysqld socket file to appear: /data0/workspaces/go/vtdataroot/vt_0000000102/mysql.sock
E0501 09:29:00.907572   81115 mysqlctl.go:260] failed start mysql: deadline exceeded waiting for mysqld socket file to appear: /data0/workspaces/go/vtdataroot/vt_0000000100/mysql.sock
E0501 09:29:00.937445   81116 mysqlctl.go:260] failed start mysql: deadline exceeded waiting for mysqld socket file to appear: /data0/workspaces/go/vtdataroot/vt_0000000101/mysql.sock
Starting vttablet for test-0000000100...
Access tablet test-0000000100 at http://192.168.47.100:15100/debug/status
Starting vttablet for test-0000000101...
Access tablet test-0000000101 at http://192.168.47.100:15101/debug/status
Starting vttablet for test-0000000102...
Access tablet test-0000000102 at http://192.168.47.100:15102/debug/status
Starting vttablet for test-0000000103...
Access tablet test-0000000103 at http://192.168.47.100:15103/debug/status
Starting vttablet for test-0000000104...
Access tablet test-0000000104 at http://192.168.47.100:15104/debug/status

zk启动参数
zkctl 
  -zk.myid 1 
  -zk.cfg 1@10.0.0.13:28881:38881:21811,2@10.0.0.13:28882:38882:21812,3@10.0.0.13:28883:38883:21813 
  -log_dir /data0/workspaces/go/vtdataroot/tmp start     
  > /data0/workspaces/go/vtdataroot/tmp/zkctl_1.out 2>&1 &
  
  
# vtctld启动参数
vtctld   -topo_implementation zk2 
         -topo_global_server_address localhost:21811,localhost:21812,localhost:21813 
         -topo_global_root /vitess/global   
         -cell test   
         -web_dir /data0/workspaces/go/src/vitess.io/vitess/web/vtctld   
         -web_dir2 /data0/workspaces/go/src/vitess.io/vitess/web/vtctld2/app   
         -workflow_manager_init   
         -workflow_manager_use_election   
         -service_map 'grpc-vtctl'   
         -backup_storage_implementation file   
         -file_backup_storage_root /data0/workspaces/go/vtdataroot/backups   
         -log_dir /data0/workspaces/go/vtdataroot/tmp   
         -port 15000   
         -grpc_port 15999   
         -pid_file /data0/workspaces/go/vtdataroot/tmp/vtctld.pid      
         > /data0/workspaces/go/vtdataroot/tmp/vtctld.out 2>&1 &
         
# MySQL启动参数
mysqlctl -log_dir /data0/workspaces/go/vtdataroot/tmp     
         -tablet_uid 100         
         -db-config-dba-uname vt_dba     
         -db-config-dba-charset utf8     
         -mysql_port 17100     
         init -init_db_sql_file /data0/workspaces/go/config/init_db.sql &
# vttablet 启动参数
vttablet 
         -topo_implementation zk2 
         -topo_global_server_address localhost:21811,localhost:21812,localhost:21813 
         -topo_global_root /vitess/global     
         -log_dir /data0/workspaces/go/vtdataroot/tmp     
         -tablet-path test-0000000100     
         -tablet_hostname      
         -init_keyspace test_keyspace     
         -init_shard 0     
         -init_tablet_type replica     
         -health_check_interval 5s     
         -enable_semi_sync     
         -enable_replication_reporter     
         -backup_storage_implementation file     
         -file_backup_storage_root /data0/workspaces/go/vtdataroot/backups     
         -restore_from_backup     
         -port 15100     
         -grpc_port 16100     
         -service_map 'grpc-queryservice,grpc-tabletmanager,grpc-updatestream'     
         -pid_file /data0/workspaces/go/vtdataroot/vt_0000000100/vttablet.pid     
         -vtctld_addr http://192.168.47.100:15000/              
         -db-config-dba-uname vt_dba     
         -db-config-dba-charset utf8     
         -db-config-app-uname vt_app     
         -db-config-app-dbname vt_test_keyspace     
         -db-config-app-charset utf8     
         -db-config-appdebug-uname vt_appdebug     
         -db-config-appdebug-dbname vt_test_keyspace     
         -db-config-appdebug-charset utf8     
         -db-config-allprivs-uname vt_allprivs     
         -db-config-allprivs-dbname vt_test_keyspace     
         -db-config-allprivs-charset utf8     
         -db-config-repl-uname vt_repl     
         -db-config-repl-dbname vt_test_keyspace     
         -db-config-repl-charset utf8     
         -db-config-filtered-uname vt_filtered     
         -db-config-filtered-dbname vt_test_keyspace     
         -db-config-filtered-charset utf8     
         > /data0/workspaces/go/vtdataroot/vt_0000000100/vttablet.out 2>&1 &

# vtgate启动参数 
vtgate   
      -topo_implementation zk2 
      -topo_global_server_address localhost:21811,localhost:21812,localhost:21813 
      -topo_global_root /vitess/global   
      -log_dir /data0/workspaces/go/vtdataroot/tmp   
      -port 15001   
      -grpc_port 15991   
      -mysql_server_port 15306   
      -mysql_server_socket_path /tmp/mysql.sock   
      -mysql_auth_server_static_file ./mysql_auth_server_static_creds.json   
      -cell test   
      -cells_to_watch test   
      -tablet_types_to_wait MASTER,REPLICA   
      -gateway_implementation discoverygateway   
      -service_map 'grpc-vtgateservice'   
      -pid_file /data0/workspaces/go/vtdataroot/tmp/vtgate.pid         
      > /data0/workspaces/go/vtdataroot/tmp/vtgate.out 2>&1 &

# vtworker 启动参数
vtworker   
      -topo_implementation zk2 
      -topo_global_server_address localhost:21811,localhost:21812,localhost:21813 
      -topo_global_root /vitess/global   
      -cell test   
      -log_dir /data0/workspaces/go/vtdataroot/tmp   
      -alsologtostderr   
      -service_map=grpc-vtworker   
      -grpc_port 15033   
      -port 15032   
      -pid_file /data0/workspaces/go/vtdataroot/tmp/vtworker.pid   
      -use_v3_resharding_mode &

报错信息1：
E0501 09:10:01.517581   71126 mysqld.go:605] mysql_install_db failed: /bin/mysql_install_db: exit status 1, output: WARNING: Could not write to config file //my.cnf: 权限不够

FATAL ERROR: Could not find /fill_help_tables.sql

If you compiled from source, you need to run 'make install' to
copy the software into the correct location ready for operation.

If you are using a binary release, you must either be at the top
level of the extracted archive, or pass the --basedir option
pointing to that location.


MySQL报错信息
180501 09:13:48 mysqld_safe Logging to '/data0/workspaces/go/vtdataroot/vt_0000000100/error.log'.
180501 09:13:48 mysqld_safe Starting mysqld daemon with databases from /data0/workspaces/go/vtdataroot/vt_0000000100/data
2018-05-01 09:13:48 0 [Warning] TIMESTAMP with implicit DEFAULT value is deprecated. Please use --explicit_defaults_for_timestamp server option (see documentation for more details).
2018-05-01 09:13:48 0 [Note] //sbin/mysqld (mysqld 5.6.40-log) starting as process 80405 ...
2018-05-01 09:13:48 80405 [ERROR] Can't find messagefile '/share/mysql/errmsg.sys'
2018-05-01 09:13:48 80405 [Warning] Buffered warning: Changed limits: max_open_files: 1024 (requested 5000)

2018-05-01 09:13:48 80405 [Warning] Buffered warning: Changed limits: table_open_cache: 457 (requested 2048)

2018-05-01 09:13:48 80405 [Note] Plugin 'FEDERATED' is disabled.
//sbin/mysqld: Unknown error 1146
2018-05-01 09:13:48 80405 [ERROR] Can't open the mysql.plugin table. Please run mysql_upgrade to create it.
2018-05-01 09:13:48 80405 [Note] InnoDB: Using atomics to ref count buffer pool pages
2018-05-01 09:13:48 80405 [Note] InnoDB: The InnoDB memory heap is disabled
2018-05-01 09:13:48 80405 [Note] InnoDB: Mutexes and rw_locks use GCC atomic builtins
2018-05-01 09:13:48 80405 [Note] InnoDB: Memory barrier is not used
2018-05-01 09:13:48 80405 [Note] InnoDB: Compressed tables use zlib 1.2.3
2018-05-01 09:13:48 80405 [Note] InnoDB: Using CPU crc32 instructions
2018-05-01 09:13:48 80405 [Note] InnoDB: Initializing buffer pool, size = 32.0M
2018-05-01 09:13:48 80405 [Note] InnoDB: Completed initialization of buffer pool
2018-05-01 09:13:48 80405 [Note] InnoDB: Highest supported file format is Barracuda.
2018-05-01 09:13:49 80405 [Note] InnoDB: 128 rollback segment(s) are active.
2018-05-01 09:13:49 80405 [Note] InnoDB: Waiting for purge to start
2018-05-01 09:13:49 80405 [Note] InnoDB: 5.6.40 started; log sequence number 1600566
2018-05-01 09:13:49 80405 [ERROR] Aborting

2018-05-01 09:13:49 80405 [Note] Binlog end
2018-05-01 09:13:49 80405 [Note] Shutting down plugin 'rpl_semi_sync_slave'
2018-05-01 09:13:49 80405 [Note] Shutting down plugin 'rpl_semi_sync_master'
2018-05-01 09:13:49 80405 [Note] unregister_replicator OK
2018-05-01 09:13:49 80405 [Note] Shutting down plugin 'partition'
2018-05-01 09:13:49 80405 [Note] Shutting down plugin 'PERFORMANCE_SCHEMA'
2018-05-01 09:13:49 80405 [Note] Shutting down plugin 'INNODB_SYS_DATAFILES'
2018-05-01 09:13:49 80405 [Note] Shutting down plugin 'INNODB_SYS_TABLESPACES'
2018-05-01 09:13:49 80405 [Note] Shutting down plugin 'INNODB_SYS_FOREIGN_COLS'
2018-05-01 09:13:49 80405 [Note] Shutting down plugin 'INNODB_SYS_FOREIGN'
2018-05-01 09:13:49 80405 [Note] Shutting down plugin 'INNODB_SYS_FIELDS'
2018-05-01 09:13:49 80405 [Note] Shutting down plugin 'INNODB_SYS_COLUMNS'
2018-05-01 09:13:49 80405 [Note] Shutting down plugin 'INNODB_SYS_INDEXES'
2018-05-01 09:13:49 80405 [Note] Shutting down plugin 'INNODB_SYS_TABLESTATS'
2018-05-01 09:13:49 80405 [Note] Shutting down plugin 'INNODB_SYS_TABLES'
2018-05-01 09:13:49 80405 [Note] Shutting down plugin 'INNODB_FT_INDEX_TABLE'
2018-05-01 09:13:49 80405 [Note] Shutting down plugin 'INNODB_FT_INDEX_CACHE'
2018-05-01 09:13:49 80405 [Note] Shutting down plugin 'INNODB_FT_CONFIG'
2018-05-01 09:13:49 80405 [Note] Shutting down plugin 'INNODB_FT_BEING_DELETED'
2018-05-01 09:13:49 80405 [Note] Shutting down plugin 'INNODB_FT_DELETED'
2018-05-01 09:13:49 80405 [Note] Shutting down plugin 'INNODB_FT_DEFAULT_STOPWORD'
2018-05-01 09:13:49 80405 [Note] Shutting down plugin 'INNODB_METRICS'
2018-05-01 09:13:49 80405 [Note] Shutting down plugin 'INNODB_BUFFER_POOL_STATS'
2018-05-01 09:13:49 80405 [Note] Shutting down plugin 'INNODB_BUFFER_PAGE_LRU'
2018-05-01 09:13:49 80405 [Note] Shutting down plugin 'INNODB_BUFFER_PAGE'
2018-05-01 09:13:49 80405 [Note] Shutting down plugin 'INNODB_CMP_PER_INDEX_RESET'
2018-05-01 09:13:49 80405 [Note] Shutting down plugin 'INNODB_CMP_PER_INDEX'
2018-05-01 09:13:49 80405 [Note] Shutting down plugin 'INNODB_CMPMEM_RESET'
2018-05-01 09:13:49 80405 [Note] Shutting down plugin 'INNODB_CMPMEM'
2018-05-01 09:13:49 80405 [Note] Shutting down plugin 'INNODB_CMP_RESET'
2018-05-01 09:13:49 80405 [Note] Shutting down plugin 'INNODB_CMP'
2018-05-01 09:13:49 80405 [Note] Shutting down plugin 'INNODB_LOCK_WAITS'
2018-05-01 09:13:49 80405 [Note] Shutting down plugin 'INNODB_LOCKS'
2018-05-01 09:13:49 80405 [Note] Shutting down plugin 'INNODB_TRX'
2018-05-01 09:13:49 80405 [Note] Shutting down plugin 'InnoDB'
2018-05-01 09:13:49 80405 [Note] InnoDB: FTS optimize thread exiting.
2018-05-01 09:13:49 80405 [Note] InnoDB: Starting shutdown...
2018-05-01 09:13:50 80405 [Note] InnoDB: Shutdown completed; log sequence number 1600576
2018-05-01 09:13:50 80405 [Note] Shutting down plugin 'BLACKHOLE'
2018-05-01 09:13:50 80405 [Note] Shutting down plugin 'ARCHIVE'
2018-05-01 09:13:50 80405 [Note] Shutting down plugin 'MRG_MYISAM'
2018-05-01 09:13:50 80405 [Note] Shutting down plugin 'MyISAM'
2018-05-01 09:13:50 80405 [Note] Shutting down plugin 'MEMORY'
2018-05-01 09:13:50 80405 [Note] Shutting down plugin 'CSV'
2018-05-01 09:13:50 80405 [Note] Shutting down plugin 'sha256_password'
2018-05-01 09:13:50 80405 [Note] Shutting down plugin 'mysql_old_password'
2018-05-01 09:13:50 80405 [Note] Shutting down plugin 'mysql_native_password'
2018-05-01 09:13:50 80405 [Note] Shutting down plugin 'binlog'
2018-05-01 09:13:50 80405 [Note] 
180501 09:13:50 mysqld_safe mysqld from pid file /data0/workspaces/go/vtdataroot/vt_0000000100/mysql.pid ended

使用软链接暂时修复该问题
ln -s /usr/share /share
```
