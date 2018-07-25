# MySQL相关知识总结
## GTID
### GTID概述
  GTID是MySQL 5.6的新特性，其全称是Global Transaction Identifier。 
  MySQL 5.6使用server_uuid和transaction_id两个共同组成一个GTID。即：GTID = server_uuid:transaction_id
  server_uuid是MySQL Server的只读变量，保存在数据目录下的auto.cnf中，可直接通过cat命令查看。MySQL第一次启动时候创建auto.cnf文件，并生成server_uuid（MySQL使用机器网卡，当前时间，随机数等拼接成一个128bit的uuid，可认为在全宇宙都是唯一的，在未来一百年，使用同样的算法生成的uuid是不会冲突的）。之后MySQL再启动时不会重复生成uuid，而是使用auto.cnf中的uuid。也可以通过MySQL客户端使用如下命令查看server_uuid，看到的实际上是server_uuid的十六进制编码，总共16字节（其中uuid中的横线只是为了便于查看，并没有实际意义）。
``` sql
mysql> show global variables like 'server_uuid';
+---------------+--------------------------------------+
| Variable_name | Value                                |
+---------------+--------------------------------------+
| server_uuid   | b3485508-883f-11e5-85fb-e41f136aba3e |
+---------------+--------------------------------------+
1 row in set (0.00 sec)
```
   在同一个集群内，每个MySQL实例的server_uuid必须唯一，否则同步时，会造成IO线程不停的中断，重连。在通过备份恢复数据时，一定要将var目录中的auto.cnf删掉，让MySQL启动时自己生成uuid。
   
GTID中还有一部分是transaction_id，同一个server_uuid下的transaction_id一般是递增的。如果一个事务是通过用户线程执行，那么MySQL在生成的GTID时，会使用它自己的server_uuid，然后再递增一个transaction_id作为该事务的GTID。当然，如果事务是通过SQL线程回放relay-log时产生，那么GTID就直接使用binlog里的了。在MySQL 5.6中不用担心binlog里没有GTID，因为如果从库开启了GTID模式，主库也必须开启，否则IO线程在建立连接的时候就中断了。5.6的GTID对MySQL的集群环境要求是非常严格的，要么主从全部开启GTID模式，要么全部关闭GTID模式。
### GTID配置
``` bash
gtid-mode                = ON
enforce_gtid_consistency = 1
log-slave-updates        = 1
log-bin                  = mysql-bin
log-bin-index            = mysql-bin.index
```
查看同步状态
``` sql
show slave status \G;
```
