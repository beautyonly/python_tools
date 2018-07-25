## Reparenting 重新排序
### Contents 内容
Reparenting是将一个shard的master tablet从一台主机更改为另一台主机的过程，或更改slave tablet以拥有不同master的过程。重新手动可以手动启动，也可以根据特定的数据库条件自动发生。作为案例，您可能会在维护练习期间修复shard or tablet,或者在master tablet死亡时自动触发重新设置。

本文档解释了Vitess支持的重新配置类型：
- Active reparenting(主动重新排序)：当Vitess工具链管理整个重建过程时会发生主动重新映射
- External reparenting：当另一个工具处理重新配置过程时，外部重新配置会发生，而Vitess工具链只是更新其拓扑服务器，复制图和服务图以准确反映主从关系。

注意：该InitShardMaster命令定义分片中的初始父母关系。该命令将指定的tablet作为master，并将其他tablet设置为slave设备复制的分区从该master设备。
### MySQL requirements MySQL要求
- GTIDs
Vitess需要为其操作使用全局事务标识符（GTID）：

  - 在主动重新配置的过程中，Vitess使用GTID来初始化复制过程，然后在重新配置时依赖于GTID流。（-在外部重新设置期间，Vitess假定外部工具管理复制过程。）
  - 在重新划分期间，Vitess使用GTID进行过滤复制，即将tablet数据传输到适当的目标tablet的过程。

- Semisynchronous replication 半同步复制

Vitess不依赖于半同步复制，但是如果它被实现则可以工作。较大的Vitess部署通常会执行半同步复制。

### Active Reparenting 主动重新排序
您可以使用以下vtctl 命令执行重新配置操作：

- PlannedReparentShard
- EmergencyReparentShard

这两个命令都锁定the global topology server中的shard记录。这两个命令不能并行运行，也不能与InitShardMaster命令并行运行。

这两个命令都依赖于the global topology server可用，并且它们都在the topology server's的_vt.reparent_journal表中插入行 。因此，您可以通过检查该表来检查数据库的重新备份历史记录。
``` sql
mysql> select * from reparent_journal;
+---------------------+-----------------+-----------------+--------------------------------------------------+
| time_created_ns     | action_name     | master_alias    | replication_position                             |
+---------------------+-----------------+-----------------+--------------------------------------------------+
| 1525515540607176901 | InitShardMaster | test-0000000100 | MySQL56/53136e2c-504d-11e8-a929-000c2933cf1a:1-2 |
+---------------------+-----------------+-----------------+--------------------------------------------------+
1 row in set (0.01 sec)
```
#### PlannedReparentShard: Planned reparenting 计划内reparenting
该PlannedReparentShard命令可将 a healthy master tablet 转移给 a new master。The current and new master must both be up and running.
该命令执行以下操作：
- 1、当前tablet设置为 read-only mode
- 2、关闭当前master tablet的查询服务，该服务是处理用户SQL查询的系统的一部分。此时，Vitess不会处理任何用户SQL查询，直到new master tablet配置完毕并可以在几秒后使用。
- 3、检索当前master的复制位置
- 4、指定选举master tablet等待复制数据，然后在数据完全传输后开始作为新master tablet
- 5、通过以下步骤确保复制功能正常运行：
  - 1、在master tablet上，在测试表中插入一条数据，然后更新全局shard对象MasterAlias记录
  - 2、在每个slave tablet(包括旧master tablet)上并行设置new master tablet并等待测试项复制到slave tablet.(在调用该命令之前尚未复制的从属片剂将保留其当前状态，并且在重新设置过程后不会开始复制。)
  - 3、在old master tablet上启动复制，以便赶上new master tablet

在这种情况下，the old master's tablet type转换为 spare。如果在the old master上启用运行状况检查，它可能会重新加入集群，作为下一次运行状况检查的副本。要启用健康检查，请target_tablet_type在启动tablet时设置参数。该参数表示tablet在健康状态下尝试使用哪种类型的tablet。当它不健康时，tablet类型更改为spare。

实践记录：
``` bash
# su - vitess
$ cd $VTROOT
$ cd src/vitess.io/vitess/examples/local/
$ ./lvtctl.sh ListAllTablets test   # 源 master tablet为 test-100
test-0000000100 test_keyspace 0 master 192.168.47.100:15100 192.168.47.100:17100 []
test-0000000101 test_keyspace 0 replica 192.168.47.100:15101 192.168.47.100:17101 []
test-0000000102 test_keyspace 0 replica 192.168.47.100:15102 192.168.47.100:17102 []
test-0000000103 test_keyspace 0 rdonly 192.168.47.100:15103 192.168.47.100:17103 []
test-0000000104 test_keyspace 0 rdonly 192.168.47.100:15104 192.168.47.100:17104 []
$ ./lvtctl.sh PlannedReparentShard -h   # 查看设置语法
Usage: PlannedReparentShard -keyspace_shard=<keyspace/shard> [-new_master=<tablet alias>] [-avoid_master=<tablet alias>]

Reparents the shard to the new master, or away from old master. Both old and new master need to be up and running.

  -avoid_master string
        alias of a tablet that should not be the master, i.e. reparent to any other tablet if this one is the master
  -keyspace_shard string
        keyspace/shard of the shard that needs to be reparented
  -new_master string
        alias of a tablet that should be the new master
  -wait_slave_timeout duration
        time to wait for slaves to catch up in reparenting (default 30s)

$ ./lvtctl.sh PlannedReparentShard -keyspace_shard=test_keyspace/0 -new_master=test-101 -avoid_master=test-100
$ ./lvtctl.sh ListAllTablets test     # 检查修改结果
test-0000000100 test_keyspace 0 replica 192.168.47.100:15100 192.168.47.100:17100 []
test-0000000101 test_keyspace 0 master 192.168.47.100:15101 192.168.47.100:17101 []
test-0000000102 test_keyspace 0 replica 192.168.47.100:15102 192.168.47.100:17102 []
test-0000000103 test_keyspace 0 rdonly 192.168.47.100:15103 192.168.47.100:17103 []
test-0000000104 test_keyspace 0 rdonly 192.168.47.100:15104 192.168.47.100:17104 []

$  mysql -S /data0/workspaces/go/vtdataroot/vt_0000000101/mysql.sock -u vt_dba # 在新master tablet插入数据进行测试
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 2517
Server version: 5.6.40-log MySQL Community Server (GPL)

Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> use vt_test_keyspace
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> insert into messages values(1,1,'test');

# for i in `seq 0 1 4`;do mysql -S /data0/workspaces/go/vtdataroot/vt_000000010${i}/mysql.sock -u vt_dba -e "show slave status;\G";done # 其他slave tablet检查同步结果及插入的数据
# $ for i in `seq 0 1 4`;do mysql -S /data0/workspaces/go/vtdataroot/vt_000000010${i}/mysql.sock -u vt_dba -e "select * from vt_test_keyspace.messages;";done
```
#### EmergencyReparentShard: Emergency reparenting 计划外reparenting
EmergencyReparentShard当前master不可用时，该命令用于强制重新映射到new master。该命令假定无法从当前master数据中检索数据，因为数据无效或无法正常工作。

因此，该命令根本不依赖当前的master将数据复制到new master。相反，它确保了被选master是所有可用slaves中最先进的复制。

**重要提示：** 在调用此命令之前，您必须首先确定具有最高级复制位置的slave，因为必须将该slave指定为new master。您可以使用该vtctl ShardReplicationPositions 命令确定shard的slave的当前复制位置。
``` bash
$ ./lvtctl.sh ShardReplicationPositions  test_keyspace/0
test-0000000101 test_keyspace 0 master 192.168.47.100:15101 192.168.47.100:17101 [] MySQL56/53136e2c-504d-11e8-a929-000c2933cf1a:1-19,531f845a-504d-11e8-a929-000c2933cf1a:1-4 0
test-0000000102 test_keyspace 0 replica 192.168.47.100:15102 192.168.47.100:17102 [] MySQL56/53136e2c-504d-11e8-a929-000c2933cf1a:1-19,531f845a-504d-11e8-a929-000c2933cf1a:1-4 0
test-0000000100 test_keyspace 0 replica 192.168.47.100:15100 192.168.47.100:17100 [] MySQL56/53136e2c-504d-11e8-a929-000c2933cf1a:1-19,531f845a-504d-11e8-a929-000c2933cf1a:1-4 0
test-0000000103 test_keyspace 0 rdonly 192.168.47.100:15103 192.168.47.100:17103 [] MySQL56/53136e2c-504d-11e8-a929-000c2933cf1a:1-19,531f845a-504d-11e8-a929-000c2933cf1a:1-4 0
test-0000000104 test_keyspace 0 rdonly 192.168.47.100:15104 192.168.47.100:17104 [] MySQL56/53136e2c-504d-11e8-a929-000c2933cf1a:1-19,531f845a-504d-11e8-a929-000c2933cf1a:1-4 0
```

该命令执行以下操作：
- 1、确定所有slave tablets上的当前复制位置，并确认备选master tablet具有最高级的复制位置。
- 2、设置被选tablet成为new master。除了将其tablet type类型更改为master，被选master还可以执行其新状态可能需要的任何其他更改。
- 3、通过以下步骤确保复制功能正常运行：
  - 1、在被选master tablet上，Vitess在测试表中插入条目，然后更新MasterAlias全局Shard对象的记录 。
  - 2、并行地在每个slave上，不包括old master，Vitess设置主设备并等待测试条目复制到从设备。（在调用该命令之前尚未复制的从属片剂将保留其当前状态，并且在重新设置过程后不会开始复制。）

实践记录
``` bash
./lvtctl.sh ListAllTablets test
test-0000000100 test_keyspace 0 replica 192.168.47.100:15100 192.168.47.100:17100 []
test-0000000101 test_keyspace 0 master 192.168.47.100:15101 192.168.47.100:17101 []
test-0000000102 test_keyspace 0 replica 192.168.47.100:15102 192.168.47.100:17102 []
test-0000000103 test_keyspace 0 rdonly 192.168.47.100:15103 192.168.47.100:17103 []
test-0000000104 test_keyspace 0 rdonly 192.168.47.100:15104 192.168.47.100:17104 []
$ ./lvtctl.sh ShardReplicationPositions  test_keyspace/0
test-0000000101 test_keyspace 0 master 192.168.47.100:15101 192.168.47.100:17101 [] MySQL56/53136e2c-504d-11e8-a929-000c2933cf1a:1-19,531f845a-504d-11e8-a929-000c2933cf1a:1-4 0
test-0000000102 test_keyspace 0 replica 192.168.47.100:15102 192.168.47.100:17102 [] MySQL56/53136e2c-504d-11e8-a929-000c2933cf1a:1-19,531f845a-504d-11e8-a929-000c2933cf1a:1-4 0
test-0000000100 test_keyspace 0 replica 192.168.47.100:15100 192.168.47.100:17100 [] MySQL56/53136e2c-504d-11e8-a929-000c2933cf1a:1-19,531f845a-504d-11e8-a929-000c2933cf1a:1-4 0
test-0000000103 test_keyspace 0 rdonly 192.168.47.100:15103 192.168.47.100:17103 [] MySQL56/53136e2c-504d-11e8-a929-000c2933cf1a:1-19,531f845a-504d-11e8-a929-000c2933cf1a:1-4 0
test-0000000104 test_keyspace 0 rdonly 192.168.47.100:15104 192.168.47.100:17104 [] MySQL56/53136e2c-504d-11e8-a929-000c2933cf1a:1-19,531f845a-504d-11e8-a929-000c2933cf1a:1-4 0
$ ./lvtctl.sh EmergencyReparentShard -h
Usage: EmergencyReparentShard -keyspace_shard=<keyspace/shard> -new_master=<tablet alias>

Reparents the shard to the new master. Assumes the old master is dead and not responsding.

  -keyspace_shard string
        keyspace/shard of the shard that needs to be reparented
  -new_master string
        alias of a tablet that should be the new master
  -wait_slave_timeout duration
        time to wait for slaves to catch up in reparenting (default 30s)
$ ./lvtctl.sh EmergencyReparentShard -keyspace_shard=test_keyspace/0 -new_master=test-100
$ ./lvtctl.sh ListAllTablets test   
test-0000000100 test_keyspace 0 master 192.168.47.100:15100 192.168.47.100:17100 []
test-0000000102 test_keyspace 0 replica 192.168.47.100:15102 192.168.47.100:17102 []
test-0000000103 test_keyspace 0 rdonly 192.168.47.100:15103 192.168.47.100:17103 []
test-0000000104 test_keyspace 0 rdonly 192.168.47.100:15104 192.168.47.100:17104 []
$  mysql -S /data0/workspaces/go/vtdataroot/vt_0000000100/mysql.sock -u vt_dba                                                                          Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 497
Server version: 5.6.40-log MySQL Community Server (GPL)

Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> use vt_test_keyspace
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> insert into messages values(2,2,'test');   
Query OK, 1 row affected (0.01 sec)

$ ./lvtctl.sh ShardReplicationPositions  test_keyspace/0
test-0000000100 test_keyspace 0 master 192.168.47.100:15100 192.168.47.100:17100 [] MySQL56/53136e2c-504d-11e8-a929-000c2933cf1a:1-23,531f845a-504d-11e8-a929-000c2933cf1a:1-4 0
test-0000000102 test_keyspace 0 replica 192.168.47.100:15102 192.168.47.100:17102 [] MySQL56/53136e2c-504d-11e8-a929-000c2933cf1a:1-23,531f845a-504d-11e8-a929-000c2933cf1a:1-4 0
test-0000000103 test_keyspace 0 rdonly 192.168.47.100:15103 192.168.47.100:17103 [] MySQL56/53136e2c-504d-11e8-a929-000c2933cf1a:1-23,531f845a-504d-11e8-a929-000c2933cf1a:1-4 0
test-0000000104 test_keyspace 0 rdonly 192.168.47.100:15104 192.168.47.100:17104 [] MySQL56/53136e2c-504d-11e8-a929-000c2933cf1a:1-23,531f845a-504d-11e8-a929-000c2933cf1a:1-4 0
```
### External Reparenting 额外的Reparenting
当另一个工具处理更改a shard's master tablet的过程时，会发生External reparenting。之后，该工具需要调用该vtctl TabletExternallyReparented 命令以确保相应地更新the topology server, replication graph, and serving graph are updated accordingly.。

该命令执行以下操作：
- 1、Locks the shard in the global topology server。
- 2、Reads the Shard object from the global topology server.。
- 3、读取shard复制图中的所有the tablets。Vitess允许在这一步中进行部分读取，这意味着只要包含新主数据的数据中心可用，即使数据中心停机，Vitess也会继续运行。
- 4、确保新主设备的状态已正确更新，并确保新主设备不是另一台服务器的MySQL从设备。它运行MySQL show slave status命令，最终旨在确认reset slave已在平板电脑上执行的MySQL命令。
- 5、更新每个从属的拓扑服务器记录和复制图以反映新的主服务器。如果旧主人在此步骤中没有成功返回，Vitess将其平板电脑类型更改spare为确保它不会干扰正在进行的操作。
- 6、更新Shard对象以指定新的主控。

TabletExternallyReparented在以下情况下该命令失败：
- 全局拓扑服务器不可用于锁定和修改。在这种情况下，操作完全失败。

在任何取决于外部补救的系统中，主动重新配置可能是一种危险的做法。您可以通过从设置为vtctld的 --disable_active_reparents标志开始禁用活动补救true。（vtctld启动后不能设置标志。）

### Fixing Replication 修复复制
重新启动后，如果A tablet在重新启动操作运行但不久后恢复时不可用，则该tablet可能会成为孤儿。在这种情况下，您可以使用该vtctl ReparentTablet 命令手动将tablet的主设备重置为当前shard master设备 。然后，您可以通过调用vtctl StartSlave 命令停止tablet上的复制。

实践记录
``` bash
./lvtctl.sh ReparentTablet -h
Usage: ReparentTablet <tablet alias>

Reparent a tablet to the current master in the shard. This only works if the current slave position matches the last known reparent action.
$ ./lvtctl.sh ListAllTablets test                                             
test-0000000100 test_keyspace 0 master 192.168.47.100:15100 192.168.47.100:17100 []
test-0000000102 test_keyspace 0 replica 192.168.47.100:15102 192.168.47.100:17102 []
test-0000000103 test_keyspace 0 rdonly 192.168.47.100:15103 192.168.47.100:17103 []
test-0000000104 test_keyspace 0 rdonly 192.168.47.100:15104 192.168.47.100:17104 []
$ ./lvtctl.sh ReparentTablet test-103

# 操作复制
[vitess@linux-node01 local]$ ./lvtctl.sh StopSlave test-103    
[vitess@linux-node01 local]$  mysql -S /data0/workspaces/go/vtdataroot/vt_0000000103/mysql.sock -u vt_dba -e "show slave status\G;"
*************************** 1. row ***************************
               Slave_IO_State:
                  Master_Host: 192.168.47.100
                  Master_User: vt_repl
                  Master_Port: 17100
                Connect_Retry: 10
              Master_Log_File: vt-0000000100-bin.000001
          Read_Master_Log_Pos: 10324
               Relay_Log_File: vt-0000000103-relay-bin.000002
                Relay_Log_Pos: 432
        Relay_Master_Log_File: vt-0000000100-bin.000001
             Slave_IO_Running: No
            Slave_SQL_Running: No
              Replicate_Do_DB:
          Replicate_Ignore_DB:
           Replicate_Do_Table:
       Replicate_Ignore_Table:
      Replicate_Wild_Do_Table:
  Replicate_Wild_Ignore_Table:
                   Last_Errno: 0
                   Last_Error:
                 Skip_Counter: 0
          Exec_Master_Log_Pos: 10324
              Relay_Log_Space: 644
              Until_Condition: None
               Until_Log_File:
                Until_Log_Pos: 0
           Master_SSL_Allowed: No
           Master_SSL_CA_File:
           Master_SSL_CA_Path:
              Master_SSL_Cert:
            Master_SSL_Cipher:
               Master_SSL_Key:
        Seconds_Behind_Master: NULL
Master_SSL_Verify_Server_Cert: No
                Last_IO_Errno: 0
                Last_IO_Error:
               Last_SQL_Errno: 0
               Last_SQL_Error:
  Replicate_Ignore_Server_Ids:
             Master_Server_Id: 846590132
                  Master_UUID: 53136e2c-504d-11e8-a929-000c2933cf1a
             Master_Info_File: /data0/workspaces/go/vtdataroot/vt_0000000103/master.info
                    SQL_Delay: 0
          SQL_Remaining_Delay: NULL
      Slave_SQL_Running_State:
           Master_Retry_Count: 86400
                  Master_Bind:
      Last_IO_Error_Timestamp:
     Last_SQL_Error_Timestamp:
               Master_SSL_Crl:
           Master_SSL_Crlpath:
           Retrieved_Gtid_Set:
            Executed_Gtid_Set: 53136e2c-504d-11e8-a929-000c2933cf1a:1-23,
531f845a-504d-11e8-a929-000c2933cf1a:1-4
                Auto_Position: 1
[vitess@linux-node01 local]$ ./lvtctl.sh StartSlave test-103                       
[vitess@linux-node01 local]$  mysql -S /data0/workspaces/go/vtdataroot/vt_0000000103/mysql.sock -u vt_dba -e "show slave status\G;"
*************************** 1. row ***************************
               Slave_IO_State: Waiting for master to send event
                  Master_Host: 192.168.47.100
                  Master_User: vt_repl
                  Master_Port: 17100
                Connect_Retry: 10
              Master_Log_File: vt-0000000100-bin.000001
          Read_Master_Log_Pos: 10324
               Relay_Log_File: vt-0000000103-relay-bin.000003
                Relay_Log_Pos: 432
        Relay_Master_Log_File: vt-0000000100-bin.000001
             Slave_IO_Running: Yes
            Slave_SQL_Running: Yes
              Replicate_Do_DB:
          Replicate_Ignore_DB:
           Replicate_Do_Table:
       Replicate_Ignore_Table:
      Replicate_Wild_Do_Table:
  Replicate_Wild_Ignore_Table:
                   Last_Errno: 0
                   Last_Error:
                 Skip_Counter: 0
          Exec_Master_Log_Pos: 10324
              Relay_Log_Space: 925
              Until_Condition: None
               Until_Log_File:
                Until_Log_Pos: 0
           Master_SSL_Allowed: No
           Master_SSL_CA_File:
           Master_SSL_CA_Path:
              Master_SSL_Cert:
            Master_SSL_Cipher:
               Master_SSL_Key:
        Seconds_Behind_Master: 0
Master_SSL_Verify_Server_Cert: No
                Last_IO_Errno: 0
                Last_IO_Error:
               Last_SQL_Errno: 0
               Last_SQL_Error:
  Replicate_Ignore_Server_Ids:
             Master_Server_Id: 846590132
                  Master_UUID: 53136e2c-504d-11e8-a929-000c2933cf1a
             Master_Info_File: /data0/workspaces/go/vtdataroot/vt_0000000103/master.info
                    SQL_Delay: 0
          SQL_Remaining_Delay: NULL
      Slave_SQL_Running_State: Slave has read all relay log; waiting for the slave I/O thread to update it
           Master_Retry_Count: 86400
                  Master_Bind:
      Last_IO_Error_Timestamp:
     Last_SQL_Error_Timestamp:
               Master_SSL_Crl:
           Master_SSL_Crlpath:
           Retrieved_Gtid_Set:
            Executed_Gtid_Set: 53136e2c-504d-11e8-a929-000c2933cf1a:1-23,
531f845a-504d-11e8-a929-000c2933cf1a:1-4
                Auto_Position: 1
                
```
