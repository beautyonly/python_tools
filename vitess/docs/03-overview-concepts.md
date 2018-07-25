# Key Concepts 重要概念
## Contents 内容
本文档定义了常见的Vitess概念和术语。
## Keyspace 密钥空间
一个keyspace是一个逻辑数据库。在未shard的情况下，它直接映射到MySQL数据库名称。如果shard，一个keyspace映射到多个MySQL数据库。但是，它显示为应用程序的单个数据库。

从keyspace读取数据就像从MySQL数据库读取数据一样。但是，根据读取操作的一致性要求，Vitess可能会从主数据库或副本中获取数据。通过将每个查询路由到适当的数据库，Vitess允许您的代码被结构化，就像它从单个MySQL数据库读取一样。
## Keyspace ID
Keyspace ID 是用来决定哪些分片给定行的生命值。基于范围的分片是指创建分别覆盖特定范围的keyspaces id的分片。

使用这种技术意味着您可以拆分给定分片，方法是将两个或更多新分片替换为覆盖原始密钥空间ID范围的新分片，而不必在其他分片中移动任何记录。

密钥空间ID本身是使用数据中的某个列的函数计算的，例如用户ID。Vitess允许您从各种功能（vindexes）中进行选择以执行此映射。这使您可以选择正确的数据以实现分片间数据的最佳分配。

## VSchema
一个VSchema允许您描述数据是如何keyspaces和shard内组织。此信息用于路由查询，也用于重新分片操作。

对于Keyspace，你可以指定它是否被分割。对于分片密钥空间，可以为每个表指定vindex的列表。

Vitess还支持序列生成器 ，可用于生成像MySQL自动增量列一样工作的新ID。VSchema允许您将表格列与序列表相关联。如果没有为这样的列指定值，那么VTGate将知道使用序列表为其生成一个新值。

### Shard 分片
a shard 是一个keyspaces中的分割。shard通常包含一个MySQL主服务器和许多MySQL从服务器。

shard中的每个MySQL实例都具有相同的数据（除了一些复制滞后）。slaves可以提供只读流量（最终一致性保证），执行长时间运行的数据分析工具或执行管理任务（备份，恢复，差异等）。

An unsharded keyspace实际上具有one shard。Vitess按照惯例命名碎片0。分片时，密钥空间具有N 非重叠数据的碎片。
## Resharding 重新shard
Vitess支持动态重新分片，其中在活动群集中更改分片数量。这可以是将一个或多个shard分割成smaller pieces，也可以将相邻的碎片合并为更大的碎片。

在动态重新分片期间，将源分片中的数据复制到目标分片中，允许跟上复制，然后与原始分片进行比较以确保数据完整性。然后，实时服务基础架构转移到目标碎片，并删除源碎片。

## Tablet
  Tablet是一个MySQL进程和相应的vttablet过程中，通常在相同的机器上运行。

  每个tablet都分配有tablet type，用于指定当前执行的角色。
### Tablet Types
- **master** - A replica tablet that happens to currently be the MySQL master for its shard.
- **replica** - A MySQL slave that is eligible to be promoted to master. Conventionally, these are reserved for serving live, user-facing requests (like from the website's frontend).
  有资格升级为master。通常，这些保留用于提供实时的，面向用户的请求
- **rdonly** - A MySQL slave that cannot be promoted to master. Conventionally, these are used for background processing jobs, such as taking backups, dumping data to other systems, heavy analytical queries, MapReduce, and resharding.
  无法升级为master的MySQL slave。通常，这些用于后台处理作业，例如：备份，将数据转储到其他系统，繁重的分析查询，MapReduce和重新分割等。
- **backup** - A tablet that has stopped replication at a consistent snapshot, so it can upload a new backup for its shard. After it finishes, it will resume replication and return to its previous type.
  停止一直快照复制的tablet，因此可以为其分片上传新的备份，完成后，它将恢复复制并返回之前的类型
- **restore** - A tablet that has started up with no data, and is in the process of restoring itself from the latest backup. After it finishes, it will begin replicating at the GTID position of the backup, and become either replica or rdonly.
  启动时没有数据的tablet，并正在从最新备份恢复自身。完成后，它将开始在备份的GTID位置进行复制，并成为 replica or rdonly
- **drained** - A tablet that has been reserved by a Vitess background process (such as rdonly tablets for resharding).
  Vitess后台进程保留的tablet(如用于重新shard的rdonly tablet)


## Keyspace Graph
描述keyspaces Graph允许Vitess决定哪些设置shard以用于给定的keyspaces，cell, and tablet type.

### Partitions 分区
在水平重新分割（分割或合并分片）期间，可能会出现重叠范围的分片。例如，分割的源碎片可以用于 同时其目的地碎片服务和分别。c0-d0c0-c8c8-d0

由于这些碎片需要在迁移过程中同时存在，因此密钥空间图维护一个分片的列表（称为分区或仅分区），其范围覆盖所有可能的密钥空间ID值，但是不重叠且连续。可以移入和移出碎片以确定它们是否处于活动状态。

密钥空间图为每一对存储单独的分区。这允许迁移分阶段进行：首先迁移rdonly和 副本请求，一次一个单元，最后迁移主请求。(cell, tablet type)

### Served From
在垂直重新划分期间（将表从一个键空间移出以形成新的键空间），可以有多个包含相同表的键空间。

由于这些表的多个副本需要在迁移过程中同时存在，因此密钥空间图支持被称为ServedFrom记录的密钥空间重定向 。这使得迁移流程如下所示：
- 创建new_keyspace并将其设置ServedFrom为指向old_keyspace。
- 更新应用程序以查找要移入的表new_keyspace。Vitess会自动将这些请求重定向到old_keyspace。
- 执行垂直拆分克隆将数据复制到新密钥空间并启动过滤复制。
- 删除ServedFrom重定向以开始实际提供服务new_keyspace。
- 从表中删除现在未使用的表副本old_keyspace。

ServedFrom每对可以有不同的记录。这允许迁移分阶段进行：首先迁移rdonly和 副本请求，一次一个单元，最后迁移主请求。(cell, tablet type)
## Replication Graph
复制图形识别主数据库和它们各自的副本之间的关系。在master故障转移期间，复制图使Vitess能够将所有现有副本指向新指定的master数据库，以便复制可以继续。
## Topology Service
Topology Service 是一组不同的服务器上运行的后端程序。这些服务器存储拓扑数据并提供分布式锁定服务。

Vitess使用插件系统来支持各种后端用于存储拓扑数据，这些数据假定提供分布式，一致的键值存储。默认情况下，我们的本地示例 使用ZooKeeper插件，而Kubernetes示例 使用etcd。

拓扑服务存在以下几个原因：

- 它使平板电脑能够作为一个集群进行协调。
- 它使Vitess能够发现平板电脑，因此它知道在哪里路由查询。
- 它存储数据库管理员提供的Vitess配置，该配置是群集中许多不同服务器所需的，并且必须在服务器重新启动之间保持不变。

Vitess集群具有一个全局拓扑服务和每个单元中的本地拓扑服务。由于集群是一个超负荷的术语，并且一个Vitess集群与另一个Vitess集群的区别在于每个Vitess集群都有自己的全局拓扑服务，所以我们将每个Vitess集群称为toposphere。
### Global Topology
全局拓扑存储不会频繁更改的Vitess范围的数据。具体而言，它包含有关密钥空间和分片的数据以及每个分片的主要平板别名。

全局拓扑用于某些操作，包括重新设置和重新分割。按照设计，全局拓扑服务器并没有太多使用。

为了使任何单个单元停机，全局拓扑服务应具有多个单元中的节点，并足以在单元故障时保持仲裁。
### Local Topology
每个本地拓扑都包含与其自己的单元相关的信息。具体而言，它包含有关单元格中的平板电脑的数据，该单元格的键空间图以及该单元格的复制图。

当平板电脑进出时，本地拓扑服务必须可用于Vitess发现平板电脑和调整路由。但是，在稳定状态下为查询服务的关键路径中不会调用拓扑服务。这意味着在拓扑临时不可用的情况下查询仍然处于服务状态

## Cell (Data Center)
Cell 是一组在一个区域并置，并从其它细胞中分离失效的服务器和网络基础设施。它通常是全数据中心或数据中心的子集，有时也称为区域或可用区域。Vitess优雅地处理小区级别的故障，例如当一个小区被切断网络时。

Vitess实现中的每个单元都有一个本地拓扑服务，该服务托管在该单元中。拓扑服务包含有关其单元中的Vitess平板电脑的大部分信息。这使得一个单元可以被拆除并重建为一个单元。

Vitess限制数据和元数据的跨单元流量。虽然也有能力将读取流量路由到单个单元格，但Vitess目前仅为本地单元格提供读取服务。必要时，写入将跨越单元，以便该分片的主人员驻留在该处。
