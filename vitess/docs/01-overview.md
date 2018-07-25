## Overview 概述
  Vitess是用于deploying, scaling and managing大型MySQL实例集群的数据库解决方案。它的架构可以像在专用硬件上那样有效的在公有云或私有云架构中运行。它结合并扩展了许多重要的MySQL功能和NoSQL数据库的可扩展性。Vitess可以帮助你解决如下问题：
- 允许您对MySQL数据库进行shard来Scaling a MySQL database，同时将应用程序更改保持在最低延迟下
- 从裸机迁移至私有云或公有云
- Deploying and managing a large number of MySQL instances.

Vitess包含使用本地查询协议的兼容JDBC和Go数据库驱动程序。此外它还实现了几乎与任何其他语言兼容的MySQL服务器协议。
Vitess自2011年以来一直服务于所有的YouTube数据库流量，并且现在已被许多企业用于满足其生产需求。
### Features 特性
 - Performance 性能
  - 连接池-将多个前端应用程序查询到MySQL连接池以优化性能
  - 查询重复删除
  - 事务管理器-限制并发事务的数量并管理期限以优化整体吞吐量
 - Protection 保护
  - 查询重写和清理
  - 查询黑名单-自定义规则以防止可能存在问题的查询触击您的数据库
  - 查询杀手-终止需要很长时间才能返回数据的查询
  - 表ACL-根据连接的用户为表指定访问控制列表（ACL）
 - Monitoring 监控
  - 性能分析-使用工具可以监视，诊断和分析数据库性能
  - 查询流式传输-使用传入查询列表来为OLAP工作负载提供服务
  - 更新流-服务器对数据库中更改的行进行流式处理，这可以用作将更改传播到其他数据存储的机制。
 - Topology Management Tools 拓扑管理工具
  - 主管理工具 (handles reparenting)
  - 基于web的管理GUI
  - 设计用于多个数据中心/地区
 - Sharding 拆分
  - Virtually seamless dynamic re-sharding 几乎无缝的动态重新分片
  - Vertical and Horizontal sharding support 垂直和水平分片支持
  - Multiple sharding schemes, with the ability to plug-in custom ones 多种分片方案，能够插入自定义分片
### Comparisons to other storage options 与其他存储选项进行比较
以下各节将Vitess与两种常见的替代方法进行比较，一个是vanilla MySQL实现一个NoSQL实现。
- Vitess vs. Vanilla MySQL

普通Mysql|Vitess
:------|:----
每个MySQL连接的内存开销在256KB到近3MB之间，具体的取决于你使用的MySQL版本;随着用户数量的增长，必须要添加RAM以支持其他连接，但是增加RAM并不能带来查询速度的提高。另外，获取更多连接的同时会增加CPU的成本。                  |Vitess基于gRPC协议创建的都是轻量级的连接，Vitess连接池功能使用Go的并发支持将这些轻量级连接映射到一个小型的MySQL连接池;因此，Vitess可以轻松处理数千个连接。
写的不好的查询（例如：sql中没有增加limit）会给数据库的所有用户带来负面的影响|Vitess采用SQL解析器，它使用一组可配置的规则来重写可能损害数据库性能的查询。
分片是对数据进行分区以提高可伸缩性和性能的过程。MySQL缺少本机分片支持，需要在应用程序中编写分片代码和嵌入分片逻辑|Vitess使用基于范围的分片；它支持水平和垂直重新分区，只需几秒钟的只读停机即可完成大多数数据转换。Vitess甚至可以适应您已有的自定义分片计划。
基于复制协议的MySQL集群包含一个主库和多个从库， 如果主库宕机，其中一个从库会被提升为主库继续提供服务； 这就需要管理数据库的生命周期同时告知应用当前系统的状态。|Vitess有助于管理数据库方案的生命周期。它支持并自动处理各种场景，包括主故障转移和数据备份。
MySQL集群可以具有针对不同工作负载的自定义数据库配置，例如用于写入的主库、为web客户端提供的快速只读从库、为批处理作业提供的较慢的只读副本等等。如果数据库具有水平分片，则需要为每个分片重复设置，应用程序需要编写逻辑来确认如何找到正确的数据库。|Vitess使用支持数据一致性的存储系统来存储拓扑结构，例如etcd或ZooKeeper。这意味着集群视图始终是最新的，并且对于不同的客户端都是一致的；Vitess还提供了一个代理，可以将查询有效地路由到最合适的MySQL实例。

- Vitess vs. NoSQL

如果你考虑一个NoSQL解决方案主要是出于对MySQL的可扩展性的担忧，那么Vitess可能是您的应用程序最佳的选择。虽然NoSQL为非结构化数据提供了极大的支持，但Vitess仍然提供了NoSQL数据存储中不可用的几个优点：

NoSQL|Vitess
:------|:----
NoSQL数据库不定义数据库表之间的关系，并且只支持SQL语言的一个子集。|Vitess不是一个简单的键值存储,它支持复杂的查询语义，如where子句，JOINS，聚合函数等。
NoSQL数据存储不支持事务。|Vitess支持单分片中的事务。我们还在探索使用2PC支持跨分片事务的可行性。
NoSQL解决方案具有定制API，从而导致定制架构，应用程序和工具。|Vitess对MySQL增加很少的变动(一个大多数人已经习惯于使用的数据库)。
与MySQL相比，NoSQL解决方案对数据库索引提供有限的支持。|Vitess允许您使用所有MySQL的索引功能来优化查询性能。
### Architecture 架构
 Vitess平台由许多服务器进程，命令行实用程序和基于web的实用程序组成，并由一致的元数据存储提供支持。

 根据您的应用程序的当前状态，您可以通过许多不同的流程实现完整的Vitess实施。例如：如果您要从头开始构建服务，那么使用Vitess的第一步就是定义数据库拓扑。但是，如果您需要扩展现有数据库，则可能首先部署连接代理。

 Vitess工具和服务器旨在为您提供帮助，无论您是从一组完整的数据库开始，还是从小规模开始，随着时间的推移开始扩展。对于较小的实现，连接池和查询重写等vttablet功能可帮助您从现有硬件中获得更多。Vitess的自动化工具为大型实施提供了额外的好处。

 下图说明了Vitess的组件：

 ![image](https://github.com/mds1455975151/tools/blob/master/vitess/docs/images/VitessOverview.png)
- Topology 拓扑
  > 该拓扑服务是一个元数据存储，其中包含有关于running servers, the sharding scheme,，并the replication graph。该拓扑由一个一致的数据存储支持。您可以使用vtctl(命令行)和vtctld（web）来浏览拓扑。

  > 在Kubernetes中，数据库存储是etcd。Vitess源代码还附带Apache ZooKeeper支持。

- vtgate
  > vtgate是一个轻型代理服务器，可将流量路由到正确的vttablet（s）并将合并结果返回给客户端。它是应用程序向其发送查询的服务器。因此，客户端可以非常简单，因为它只需要能够找到一个vtgate实例。

  >为了路由查询，vtgate考虑了分片方案，所需的延迟以及水平扩展及其基础MySQL实例的可用性。

- vttablet
  > vttablet是位于MySQL数据库之前的代理服务器。Vitess实现对每个MySQL实例都有一个vttablet。

  > vttablet执行的任务是尝试最大化吞吐量，并保护MySQL免受有害查询的影响。其功能包括连接池，查询重写，查询重复。另外vttablet执行vtctl启动的管理任务，并提供用于过滤复制和数据导出的流服务。

- vtctl
  > vtctl是用于管理Vitess集群的命令行工具。它允许人或应用程序轻松地与Vitess实现进行交互。使用vtctl，您可以识别主数据库和副本数据库，创建表，启动故障转移，执行分片（和重新分片）操作等等。

  > 当vtctl执行操作时，它根据需要更新锁服务器。其他Vitess服务器观察这些变化并作出相应的反应。例如，如果您使用vtctl故障转移到新的主数据库，vtgate会看到更改并将将来的写操作指向新的master。

- vtctld
  > vtctld是一个HTTP服务器，可让您浏览存储在锁定服务器中的信息。这对于故障排除或获取服务器及其当前状态的高级概述很有用。

- vtworker

  vtworker承载长时间运行的进程。它支持插件架构并提供库，以便您可以轻松选择要使用的平板电脑。插件可用于以下类型的作业：
  - 在分片分割和连接过程中重新划分不同的作业检查数据完整性
  - 垂直分割不同作业检查垂直分割和连接期间的数据完整性

  vtworker还允许您轻松添加其他验证过程。例如，如果一个密钥空间中的索引表引用了另一个密钥空间中的数据，则可以执行内嵌式完整性检查以验证外键类似关系或跨分片完整性检查。

- Other support tools
  Vitess还包含以下工具：
  - mysqltl:管理MySQL实例
  - vtcombo:包含Vitess所有组件的单个二进制文件。它可用于在持续集成环境中测试查询。
  - vtexplain：一种命令行工具，用于探索Vitess如何根据用户提供的模式和拓扑处理查询，而无需设置完整集群。
  - zk：命令行ZooKeeper客户端和资源管理器
  - zkctl：管理ZooKeeper实例

### Vitess on Kubernetes 运行与Kubernetes上的Vitess
Kubernetes是Docker容器的开源协调系统，Vitess可以作为Kubernetes感知的云本地分布式数据库运行。

Kubernetes在计算集群的节点上处理调度，主动管理这些节点上的工作负载，并将包含应用程序的容器分组，以便于管理和发现。这为Vitess在YouTube上运行的前身Kubernetes提供了一个类似的开源环境。

运行Vitess最简单的方法是通过Kubernetes。但是，这不是要求，还会使用其他类型的部署。
### History
自2011年以来，Vitess一直是YouTube基础设施的基本组成部分，本节简要总结了导致Vitess创建的事件序列：  
1. YouTube的MySQL数据库达到了一个点，当高峰流量将很快超过数据库的服务容量，为了暂时缓解这个问题，YouTube为写入流量创建了主数据库，为读取流量创建了一个副本数据库。
2. 随着对cat视频的需求达到一个历史最高点，只读流量仍然高到足以使副本数据库过载。因此，YouTube添加了更多副本，再次提供了一个临时解决方案。
3. 最终，写流量变得太高，以至于master数据库无法处理；要求YouTube分割数据以处理传入的流量，如果单个MySQL实例数据量太大，那么分片也将变得必要）。
4. YouTube修改了应用程层代码，以便在执行任何数据库操作之前，通过代码识别特定的查询到达正确的数据库分片。

Vitess让YouTube从源代码中删除逻辑代码，在应用程序和数据库之间引入代理，通过路由来管理和数据库间的交互。从此以后，YouTube已将用户群规模扩大了50倍，大大增加了其页面的服务能力，处理新上传的视频，等等。更重要的是，Vitess是一个可以继续扩展的平台。  

YouTube选择使用Go语言开发Vitess，因为Go语言优秀的表现能力和性能。它几乎和Python一样富有表现力，非常易于维护。但是，它的性能与Java相同，在某些情况下接近C++。此外，该语言非常适合并发编程，并具有非常高质量的标准库。
### Open Source First
Vitess的开源版本与YouTube使用的版本非常相似，虽然有一些变化让YouTube可以利用Google的基础设施，但核心功能是一样的。当开发新功能时，Vitess团队首先使它们在开源树中工作，在某些情况下，团队编写一个使用Google特定技术的插件。这种方法确保Vitess的开源版本维持与内部版本相同的质量水平。  
绝大多数Vitess开发发生在开放的GitHub上。因此，Vitess的构建具有可扩展性，以便您可以根据您的基础设施的需求进行调整。
