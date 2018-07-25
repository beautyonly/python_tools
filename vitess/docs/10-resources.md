# Presentations 演讲
Percona Live 2016
CoreOS Meetup, January 2016
Oracle OpenWorld 2015
Percona Live 2015
Google I/O 2014 - Scaling with Go: YouTube's Vitess
# Blog 博客
https://blog.vitess.io/

# Roadmap 路线图
## Contents 内容
Vitess是一个活跃的开源项目。以下是团队关注的最近和即将发布的功能列表：请在论坛上与我们联系以获取更多信息。

## Vitess before 2.0 GA
Vitess现在已经在YouTube内部使用了几年，但第一个公开版本缺乏波兰语和文档。版本1.0主要是内部版本。

## Vitess 2.0 GA
Vitess 2.0 GA于2016年7月11日创建。这是第一个主要的公开发布。

它包含了Vitess产品的所有核心功能：

- 高级数据访问：
  - 自动查询路由到主动服务实例。
  - 通过分片的可扩展性，透明访问分片数据，而不需要专有的API。
  - Map-减少对数据仓库查询的支持。
  - 限制错误查询的负面影响。

- 先进的管理功能：
  - Orchestrator集成，在主站故障时自动重新启动。
  - 对Kubernetes的开箱即用支持
  - 无停机动态重新分割。
  - 公开用于高级监控和错误查询检测的数据。

## Vitess 2.1
Vitess 2.1正在积极开展工作。除了我们为解决一些小问题而进行的多次小改动之外，我们还增加了以下核心功能：

- 支持分布式事务，使用2阶段提交。
- 重新划分工作流程改进，以提高流程的可管理性。
- 在线模式交换，适用于复杂的模式更改，无需停机。
- 全新的动态用户界面（vtctld），在Angular 2中从头开始重写。我们仍然将Vitess 2.1中的旧用户界面作为后备，但它将在Vitess 2.2中删除。
- 更新流功能，以便应用程序订阅更改流（例如，针对缓存失效）。
- 对于分布不均匀的表，改进了Map-Reduce支持。
- 使用双层vtgate池（l2vtgate，适用于100+分片安装）增加大型安装可扩展性。
- 更好的Kubernetes支持（头盔支持，更好的脚本，...）。
- Zookeeper（zk2）和etcd（etcd2）的拓扑服务的新实现。在Vitess 2.1中，它们将成为推荐的实现，旧的zookeeper和etcd将被弃用。在Vitess 2.2中，只有新的 zk2和etcd2实现将保留，所以请在升级到Vitess 2.1后迁移。
- 增加了对Consul拓扑服务客户端的支持。
- 主缓冲功能的初始版本。它允许在进行故障转移时缓冲主通信量，并以额外的延迟交易停机时间。
-  我们已经削减了 2.1.0-alpha.1版本，目前我们正在完成最后的细节。发布ETA大约在2017年初。

## Vitess Moving Forward Vitess继续前进
以下列表包含了当前一组更改之后我们想要关注的领域。让我们知道这些领域之一是否对您的应用程序特别感兴趣！
### Data Access 数据访问
- 对交叉分片结构（IN子句，排序和过滤...）的额外支持。
- ExecuteBatch改进（例如提高批量导入的性能）。
- 多值插入（跨越分片或不）。

### Manageability 可管理性
- 更好地支持MySQL DDL结构。
- 支持MySQL 8.0。
- 额外的Kubernetes集成。
- 在控制面板UI（vtctld）中包含重新分片工作流程。
- 支持垂直分割到现有的键空间，所以任何表都可以移动到任何键空间。首先仅用于未柔化的密钥空间。
- 与Promotheus进行开箱即用的整合以进行监控。
### Scaling 伸缩
- 更好的资源利用率/更少的CPU使用率

### Future Work 未来的工作
我们正在考虑在我们的路线图中整合/实施以下技术。对于特定功能，请与我们联系，讨论合作或优先处理一些工作的机会：
- 与Mesos和DC / OS集成。
- 与Docker Swarm集成。
- 改进了对基于行的复制的支持（例如，用于更新流）。
- 与Apache Spark更好的集成（原生而不是依赖于Hadoop InputSource）。

# Design Docs 设计文档
## Vitess Sequences Vitess序列
### Contents 内容
本文档介绍了Vitess Sequences功能，以及如何使用它。

### Motivation 动机
### When not to Use Auto-Increment
#### Security Considerations 安全考虑
#### Alternatives 备选方案
### MySQL Auto-increment Feature MySQL自动递增功能
### Vitess Sequences
#### Creating a Sequence
#### Accessing a Sequence
### TO-DO List
#### DDL Support

## MySQL Server Protocol MySQL协议
### Contents 内容
MySQL二进制协议

Vitess支持MySQL二进制协议。这允许现有的应用程序直接连到到Vitess而无需任何修改，或者不使用新的驱动程序或连接器。现在这是连接Vitess的推荐和最流行的协议。

SQL协议不支持RPC协议的功能
### Bind Variables 绑定变量
RPC协议支持绑定变量，它允许Vitess缓存提供更好执行时间的查询计划。
### Event Tokens 事件令牌
RPC协议允许您使用事件标记来获取最新的二进制日志位置。这些可用于缓存失效。
### Update Stream 更新流
更新流允许您订阅更改的行。
### Query Multiplexing 查询复用
能够在同一个TCP连接上复用多个请求/响应。

## Vitess and Replication
### Contents
### Statement vs Row Based Replication 语句与基于行的复制
### Rewriting Update Statements 重写更新语句
### Vitess Schema Swap
### Update Stream
### Semi-Sync
### Appendix: Adding support for RBR in Vitess

## Update Stream 更新流

## Row Based Replication 基于行的复制
