# Demo 演示
本节示例显示里使用etcd集群的基本过程。

# Set up a cluster	设置一个集群
在每个etcd节点上，指定集群成员：
``` bash
TOKEN=token-01
CLUSTER_STATE=new
NAME_1=machine-1
NAME_2=machine-2
NAME_3=machine-3
HOST_1=192.168.200.117
HOST_2=192.168.200.108
HOST_3=192.168.200.109
CLUSTER=${NAME_1}=http://${HOST_1}:2380,${NAME_2}=http://${HOST_2}:2380,${NAME_3}=http://${HOST_3}:2380
```

在每台机器上运行：
``` bash
# For machine 1
THIS_NAME=${NAME_1}
THIS_IP=${HOST_1}
etcd --data-dir=data.etcd --name ${THIS_NAME} \
	--initial-advertise-peer-urls http://${THIS_IP}:2380 --listen-peer-urls http://${THIS_IP}:2380 \
	--advertise-client-urls http://${THIS_IP}:2379 --listen-client-urls http://${THIS_IP}:2379 \
	--initial-cluster ${CLUSTER} \
	--initial-cluster-state ${CLUSTER_STATE} --initial-cluster-token ${TOKEN}

# For machine 2
THIS_NAME=${NAME_2}
THIS_IP=${HOST_2}
etcd --data-dir=data.etcd --name ${THIS_NAME} \
	--initial-advertise-peer-urls http://${THIS_IP}:2380 --listen-peer-urls http://${THIS_IP}:2380 \
	--advertise-client-urls http://${THIS_IP}:2379 --listen-client-urls http://${THIS_IP}:2379 \
	--initial-cluster ${CLUSTER} \
	--initial-cluster-state ${CLUSTER_STATE} --initial-cluster-token ${TOKEN}

# For machine 3
THIS_NAME=${NAME_3}
THIS_IP=${HOST_3}
etcd --data-dir=data.etcd --name ${THIS_NAME} \
	--initial-advertise-peer-urls http://${THIS_IP}:2380 --listen-peer-urls http://${THIS_IP}:2380 \
	--advertise-client-urls http://${THIS_IP}:2379 --listen-client-urls http://${THIS_IP}:2379 \
	--initial-cluster ${CLUSTER} \
	--initial-cluster-state ${CLUSTER_STATE} --initial-cluster-token ${TOKEN}
```

或者使用公共发现服务
``` bash
curl https://discovery.etcd.io/new?size=3
https://discovery.etcd.io/a81b5818e67a6ea83e9d4daea5ecbc92

# grab this token
TOKEN=token-01
CLUSTER_STATE=new
NAME_1=machine-1
NAME_2=machine-2
NAME_3=machine-3
HOST_1=10.240.0.17
HOST_2=10.240.0.18
HOST_3=10.240.0.19
DISCOVERY=https://discovery.etcd.io/a81b5818e67a6ea83e9d4daea5ecbc92

THIS_NAME=${NAME_1}
THIS_IP=${HOST_1}
etcd --data-dir=data.etcd --name ${THIS_NAME} \
	--initial-advertise-peer-urls http://${THIS_IP}:2380 --listen-peer-urls http://${THIS_IP}:2380 \
	--advertise-client-urls http://${THIS_IP}:2379 --listen-client-urls http://${THIS_IP}:2379 \
	--discovery ${DISCOVERY} \
	--initial-cluster-state ${CLUSTER_STATE} --initial-cluster-token ${TOKEN}

THIS_NAME=${NAME_2}
THIS_IP=${HOST_2}
etcd --data-dir=data.etcd --name ${THIS_NAME} \
	--initial-advertise-peer-urls http://${THIS_IP}:2380 --listen-peer-urls http://${THIS_IP}:2380 \
	--advertise-client-urls http://${THIS_IP}:2379 --listen-client-urls http://${THIS_IP}:2379 \
	--discovery ${DISCOVERY} \
	--initial-cluster-state ${CLUSTER_STATE} --initial-cluster-token ${TOKEN}

THIS_NAME=${NAME_3}
THIS_IP=${HOST_3}
etcd --data-dir=data.etcd --name ${THIS_NAME} \
	--initial-advertise-peer-urls http://${THIS_IP}:2380 --listen-peer-urls http://${THIS_IP}:2380 \
	--advertise-client-urls http://${THIS_IP}:2379 --listen-client-urls http://${THIS_IP}:2379 \
	--discovery ${DISCOVERY} \
	--initial-cluster-state ${CLUSTER_STATE} --initial-cluster-token ${TOKEN}
```

连接etcd
``` bash
export ETCDCTL_API=3
HOST_1=192.168.200.117
HOST_2=192.168.200.108
HOST_3=192.168.200.109
ENDPOINTS=$HOST_1:2379,$HOST_2:2379,$HOST_3:2379

# etcdctl --endpoints=$ENDPOINTS member list
4655a0343baa19a2, started, machine-1, http://192.168.200.117:2380, http://192.168.200.117:2379
ae14786daacedb8c, started, machine-2, http://192.168.200.108:2380, http://192.168.200.108:2379
e2d7f969a0f9541b, started, machine-3, http://192.168.200.109:2380, http://192.168.200.109:2379
```

# Access etcd	访问etcd（失败）
put 命令写：
``` bash
etcdctl --endpoints=$ENDPOINTS put foo "Hello World!"
```

get 从etcd读取：
``` bash
etcdctl --endpoints=$ENDPOINTS get foo
etcdctl --endpoints=$ENDPOINTS --write-out="json" get foo
```

# Get by prefix	获取前缀
``` bash
etcdctl --endpoints=$ENDPOINTS put web1 value1
etcdctl --endpoints=$ENDPOINTS put web2 value2
etcdctl --endpoints=$ENDPOINTS put web3 value3

etcdctl --endpoints=$ENDPOINTS get web --prefix
```

# Delete	删除
```
etcdctl --endpoints=$ENDPOINTS put key myvalue
etcdctl --endpoints=$ENDPOINTS del key

etcdctl --endpoints=$ENDPOINTS put k1 value1
etcdctl --endpoints=$ENDPOINTS put k2 value2
etcdctl --endpoints=$ENDPOINTS del k --prefix
```
# Transactional write	 事务写(失败)
``` bash
etcdctl --endpoints=$ENDPOINTS put user1 bad
etcdctl --endpoints=$ENDPOINTS txn --interactive

compares:
value("user1") = "bad"

success requests (get, put, delete):
del user1

failure requests (get, put, delete):
put user1 good
```

# Watch	看
``` bash
etcdctl --endpoints=$ENDPOINTS watch stock1
etcdctl --endpoints=$ENDPOINTS put stock1 1000

etcdctl --endpoints=$ENDPOINTS watch stock --prefix
etcdctl --endpoints=$ENDPOINTS put stock1 10
etcdctl --endpoints=$ENDPOINTS put stock2 20
```

# Lease	租
``` bash
etcdctl --endpoints=$ENDPOINTS lease grant 300
# lease 2be7547fbc6a5afa granted with TTL(300s)

etcdctl --endpoints=$ENDPOINTS put sample value --lease=2be7547fbc6a5afa
etcdctl --endpoints=$ENDPOINTS get sample

etcdctl --endpoints=$ENDPOINTS lease keep-alive 2be7547fbc6a5afa
etcdctl --endpoints=$ENDPOINTS lease revoke 2be7547fbc6a5afa
# or after 300 seconds
etcdctl --endpoints=$ENDPOINTS get sample
```

# Distributed locks	分布式锁
``` bash
etcdctl --endpoints=$ENDPOINTS lock mutex1

# another client with the same name blocks
etcdctl --endpoints=$ENDPOINTS lock mutex1
```

# Elections	选举
``` bash
etcdctl --endpoints=$ENDPOINTS elect one p1

# another client with the same name blocks
etcdctl --endpoints=$ENDPOINTS elect one p2
```

# Cluster status	集群状态
``` bash
# etcdctl --write-out=table --endpoints=$ENDPOINTS endpoint status
+-------------------------------+----------------------------+---------------+-----------+---------------+----------------+-----------------+
|       ENDPOINT    |        ID        | VERSION | DB SIZE | IS LEADER | RAFT TERM | RAFT INDEX |
+-------------------------------+----------------------------+---------------+-----------+---------------+----------------+-----------------+
| 192.168.200.117:2379 | 4655a0343baa19a2 |   3.2.9 |   25 kB |      true |        14 |         27 |
| 192.168.200.108:2379 | ae14786daacedb8c |   3.2.9 |   25 kB |     false |        14 |         27 |
| 192.168.200.109:2379 | e2d7f969a0f9541b |   3.2.9 |   25 kB |     false |        14 |         27 |
+-------------------------------+----------------------------+---------------+-----------+---------------+----------------+------------------+
# etcdctl --endpoints=$ENDPOINTS endpoint health
192.168.200.109:2379 is healthy: successfully committed proposal: took = 5.230173ms
192.168.200.117:2379 is healthy: successfully committed proposal: took = 4.87ms
192.168.200.108:2379 is healthy: successfully committed proposal: took = 4.385116ms
```
# Snapshot	快照
``` bash
# etcdctl --endpoints=$ENDPOINTS snapshot save my.db
Snapshot saved at my.db
# etcdctl --write-out=table --endpoints=$ENDPOINTS snapshot status my.db
+----------+----------+------------+------------+
|   HASH   | REVISION | TOTAL KEYS | TOTAL SIZE |
+----------+----------+------------+------------+
| 17218edf |       13 |         19 |      25 kB |
+----------+----------+------------+------------+
```
# Migrate	迁移
migrate 将etcd v2转换为v3数据：
``` bash
# write key in etcd version 2 store
export ETCDCTL_API=2
etcdctl --endpoints=http://$ENDPOINT set foo bar

# read key in etcd v2
etcdctl --endpoints=$ENDPOINTS --output="json" get foo

# stop etcd node to migrate, one by one

# migrate v2 data
export ETCDCTL_API=3
etcdctl --endpoints=$ENDPOINT migrate --data-dir="default.etcd" --wal-dir="default.etcd/member/wal"

# restart etcd node after migrate, one by one

# confirm that the key got migrated
etcdctl --endpoints=$ENDPOINTS get /foo
```
# Member	成员
member 添加，删除，更新成员资格：
``` bash
# For each machine
TOKEN=my-etcd-token-1
CLUSTER_STATE=new
NAME_1=etcd-node-1
NAME_2=etcd-node-2
NAME_3=etcd-node-3
HOST_1=10.240.0.13
HOST_2=10.240.0.14
HOST_3=10.240.0.15
CLUSTER=${NAME_1}=http://${HOST_1}:2380,${NAME_2}=http://${HOST_2}:2380,${NAME_3}=http://${HOST_3}:2380

# For node 1
THIS_NAME=${NAME_1}
THIS_IP=${HOST_1}
etcd --data-dir=data.etcd --name ${THIS_NAME} \
	--initial-advertise-peer-urls http://${THIS_IP}:2380 \
	--listen-peer-urls http://${THIS_IP}:2380 \
	--advertise-client-urls http://${THIS_IP}:2379 \
	--listen-client-urls http://${THIS_IP}:2379 \
	--initial-cluster ${CLUSTER} \
	--initial-cluster-state ${CLUSTER_STATE} \
	--initial-cluster-token ${TOKEN}

# For node 2
THIS_NAME=${NAME_2}
THIS_IP=${HOST_2}
etcd --data-dir=data.etcd --name ${THIS_NAME} \
	--initial-advertise-peer-urls http://${THIS_IP}:2380 \
	--listen-peer-urls http://${THIS_IP}:2380 \
	--advertise-client-urls http://${THIS_IP}:2379 \
	--listen-client-urls http://${THIS_IP}:2379 \
	--initial-cluster ${CLUSTER} \
	--initial-cluster-state ${CLUSTER_STATE} \
	--initial-cluster-token ${TOKEN}

# For node 3
THIS_NAME=${NAME_3}
THIS_IP=${HOST_3}
etcd --data-dir=data.etcd --name ${THIS_NAME} \
	--initial-advertise-peer-urls http://${THIS_IP}:2380 \
	--listen-peer-urls http://${THIS_IP}:2380 \
	--advertise-client-urls http://${THIS_IP}:2379 \
	--listen-client-urls http://${THIS_IP}:2379 \
	--initial-cluster ${CLUSTER} \
	--initial-cluster-state ${CLUSTER_STATE} \
	--initial-cluster-token ${TOKEN}

然后更换用构件member remove和member add命令：

# get member ID
export ETCDCTL_API=3
HOST_1=10.240.0.13
HOST_2=10.240.0.14
HOST_3=10.240.0.15
etcdctl --endpoints=${HOST_1}:2379,${HOST_2}:2379,${HOST_3}:2379 member list

# remove the member
MEMBER_ID=278c654c9a6dfd3b
etcdctl --endpoints=${HOST_1}:2379,${HOST_2}:2379,${HOST_3}:2379 \
	member remove ${MEMBER_ID}

# add a new member (node 4)
export ETCDCTL_API=3
NAME_1=etcd-node-1
NAME_2=etcd-node-2
NAME_4=etcd-node-4
HOST_1=10.240.0.13
HOST_2=10.240.0.14
HOST_4=10.240.0.16 # new member
etcdctl --endpoints=${HOST_1}:2379,${HOST_2}:2379 \
	member add ${NAME_4} \
	--peer-urls=http://${HOST_4}:2380

接下来，使用--initial-cluster-state existing标志启动新成员：

# [WARNING] If the new member starts from the same disk space,
# make sure to remove the data directory of the old member
#
# restart with 'existing' flag
TOKEN=my-etcd-token-1
CLUSTER_STATE=existing
NAME_1=etcd-node-1
NAME_2=etcd-node-2
NAME_4=etcd-node-4
HOST_1=10.240.0.13
HOST_2=10.240.0.14
HOST_4=10.240.0.16 # new member
CLUSTER=${NAME_1}=http://${HOST_1}:2380,${NAME_2}=http://${HOST_2}:2380,${NAME_4}=http://${HOST_4}:2380

THIS_NAME=${NAME_4}
THIS_IP=${HOST_4}
etcd --data-dir=data.etcd --name ${THIS_NAME} \
	--initial-advertise-peer-urls http://${THIS_IP}:2380 \
	--listen-peer-urls http://${THIS_IP}:2380 \
	--advertise-client-urls http://${THIS_IP}:2379 \
	--listen-client-urls http://${THIS_IP}:2379 \
	--initial-cluster ${CLUSTER} \
	--initial-cluster-state ${CLUSTER_STATE} \
	--initial-cluster-token ${TOKEN}
```
# Auth认证
auth，user，role进行身份验证：
```
export ETCDCTL_API=3
ENDPOINTS=localhost:2379

etcdctl --endpoints=${ENDPOINTS} role add root
etcdctl --endpoints=${ENDPOINTS} role grant-permission root readwrite foo
etcdctl --endpoints=${ENDPOINTS} role get root

etcdctl --endpoints=${ENDPOINTS} user add root
etcdctl --endpoints=${ENDPOINTS} user grant-role root root
etcdctl --endpoints=${ENDPOINTS} user get root

etcdctl --endpoints=${ENDPOINTS} auth enable
# now all client requests go through auth

etcdctl --endpoints=${ENDPOINTS} --user=root:123 put foo bar
etcdctl --endpoints=${ENDPOINTS} get foo
etcdctl --endpoints=${ENDPOINTS} --user=root:123 get foo
etcdctl --endpoints=${ENDPOINTS} --user=root:123 get foo1
```
