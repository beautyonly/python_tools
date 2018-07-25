> [重要配置](https://www.elastic.co/guide/en/elasticsearch/reference/5.6/important-settings.html)

# path.data and path.logs

# cluster.name
默认名称是elasticsearch，应该修改为描述集群用途的名称

确保不要在不同的环境中重复使用相同的集群名称，否则可能会导致节点加入错误的集群

# node.name
默认情况下，Elasticsearch将使用随机生成的UUID的前7个字符作为节点id,请注意，节点id是持久的，并且在节点重启后不会更改，因此默认节点名称也不会更改。

值得配置一个更有意义的名称，这个名称在节点重启后也具有持久性的优点。
```
node.name: prod-data-2
```
node.name也可以配置为服务器名称，如下：
```
node.name: ${HOSTNAME}
```

# bootstrap.memory_lock
节点的健康状况非常重要，因为jvm都不会换出到磁盘。实现这一目标的一种方式是将bootstrap.memory_lock设置为true

详细设置参考[官网文档](https://www.elastic.co/guide/en/elasticsearch/reference/5.6/setup-configuration-memory.html#mlockall)
# network.host

# discovery.zen.ping.unicast.hosts
当需要与其他服务器上的节点组成集群时，你必须提供集群中其他节点的列表，这些节点可能是活的并且可联系的。指定如下：
```
discovery.zen.ping.unicast.hosts:
   - 192.168.1.10:9300
   - 192.168.1.11
   - seeds.mydomain.com
```

# discovery.zen.minimum_master_nodes
为防止数据丢失，配置本参数至关重要，以便每个符合主节点的节点都知道为了集群而必须可见的主节点的最小数量。

如果没有这个设置，遇到网络故障的集群就有可能将集群分为两个独立的集群，分裂的大脑-这将导致数据丢失。

为了避免脑裂，应设置为符合主数据节点的法定人数：
```
(master_eligible_nodes / 2) + 1
```
换句话说，如果有三个符合条件的节点，则最小主节点设置为(3 / 2) + 1 or 2:
```
discovery.zen.minimum_master_nodes: 2
```
