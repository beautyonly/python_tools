> 索引模型 http://docs.graylog.org/en/2.4/pages/configuration/index_model.html

# Overview 概述
graylog透明的管理一组或多组Elasticsearch索引，以优化搜索和分析操作，以实现速度和低资源消耗。

为了能够管理具有不同映射、分析器和复制设置的索引，graylog使用所谓的索引集，这些索引集时所有这些设置的抽象。
![image](https://github.com/mds1455975151/tools/blob/master/log/graylog/docs/images/index_set_overview.png)
每个索引集都包含graylog创建，管理和填充Elasticsearch索引以及处理特定需要的索引切换和数据保留所必须的设置。
![image](https://github.com/mds1455975151/tools/blob/master/log/graylog/docs/images/index_set_details.png)
Graylog维护每个索引集的索引别名，该索引别名始终指向该索引集的当前写入活动索引。在满足配置的轮换标准（文档数，索引大小或索引年龄）之前，始终只有一个索引要写入新消息。

后台任务不断检查是否已满足索引集的旋转标准，并在发生时创建并准备新索引。索引准备就绪后，索引别名将自动切换到它。这意味着所有Graylog节点都可以将消息写入别名，甚至不知道索引集的当前写入活动索引是什么。
![image](https://github.com/mds1455975151/tools/blob/master/log/graylog/docs/images/index_set_maintenance.png)
几乎每个读取操作都在给定的时间范围内执行。由于Graylog按顺序将消息写入Elasticsearch，因此可以保留每个索引所涵盖的时间范围的信息。它在提供时间范围时选择要查询的索引列表。如果没有提供时间范围，它将搜索它知道的所有指数。
![image](https://github.com/mds1455975151/tools/blob/master/vitess/docs/images/VitessOverview.png)
## Eviction of indices and messages
Graylog在给定索引集中管理的最大索引数有配置设置。

根据配置的保留策略，当达到配置的最大索引数时，将自动关闭，删除或导出索引集的最旧索引。

删除由后台线程中的Graylog主节点执行，后台线程不断地将索引数与配置的最大值进行比较：
```
INFO : org.graylog2.indexer.rotation.strategies.AbstractRotationStrategy - Deflector index <graylog_95> should be rotated, Pointing deflector to new index now!
INFO : org.graylog2.indexer.MongoIndexSet - Cycling from <graylog_95> to <graylog_96>.
INFO : org.graylog2.indexer.MongoIndexSet - Creating target index <graylog_96>.
INFO : org.graylog2.indexer.indices.Indices - Created Graylog index template "graylog-internal" in Elasticsearch.
INFO : org.graylog2.indexer.MongoIndexSet - Waiting for allocation of index <graylog_96>.
INFO : org.graylog2.indexer.MongoIndexSet - Index <graylog_96> has been successfully allocated.
INFO : org.graylog2.indexer.MongoIndexSet - Pointing index alias <graylog_deflector> to new index <graylog_96>.
INFO : org.graylog2.system.jobs.SystemJobManager - Submitted SystemJob <f1018ae0-dcaa-11e6-97c3-6c4008b8fc28> [org.graylog2.indexer.indices.jobs.SetIndexReadOnlyAndCalculateRangeJob]
INFO : org.graylog2.indexer.MongoIndexSet - Successfully pointed index alias <graylog_deflector> to index <graylog_96>.
```

# Index Set Configuration 索引集配置
索引集具有与Graylog如何将消息存储到Elasticsearch集群相关的各种不同设置。
![image]()
- 标题：索引集的描述性名称。
- 描述：人类消费指数集的描述。
- 索引前缀：用于由索引集管理的弹性搜索索引的唯一前缀。前缀必须以字母或数字开头，并且只能包含字母，数字_，-和+。索引别名将相应地命名，例如，graylog_deflector如果索引前缀是graylog。
- Analyzer :(默认值standard：）索引集的Elasticsearch 分析器。
- 索引分片 :(默认值：4）每个索引使用的Elasticsearch分片数。
- 索引副本 :(默认值：0）每个索引使用的Elasticsearch副本数。
- 最大。段数 :(默认值：1）索引优化（强制合并）后每个Elasticsearch索引的最大段数，有关详细信息，请参阅段合并。
- 旋转后禁用索引优化：在索引旋转后禁用Elasticsearch 索引优化（强制合并）。只有在优化过程中出现Elasticsearch集群性能严重问题时才激活此项。

## Index rotation 索引轮询
- 消息计数：在写入特定数量的消息后旋转索引。
- 索引大小：在达到磁盘上的大致大小（优化之前）后旋转索引。
- 索引时间：在特定时间（例如1小时或1周）后旋转索引。
![image](https://github.com/mds1455975151/tools/blob/master/vitess/docs/images/VitessOverview.png)
## Index retention 索引保留
- 删除：删除 Elasticsearch中的索引以最小化资源消耗。
- 关闭：关闭 Elasticsearch中的索引以减少资源消耗。
- 没做什么
- 存档：商业功能，请参阅存档。
![image](https://github.com/mds1455975151/tools/blob/master/vitess/docs/images/VitessOverview.png)
# Maintenance 维护
## Keeping the index ranges in sync 保持索引范围同步
一旦创建了新索引，Graylog将自动计算索引范围。

如果存储的有关索引时间范围的元数据不同步，Graylog将通过Web界面通知您。如果手动删除索引或删除已经“关闭”索引的消息，则会发生这种情况。

系统将为您提供重新生成所有时间范围信息。这可能需要几秒钟，但对于Graylog来说这是一项简单的任务。

手动删除索引或执行可能导致同步问题的其他更改后，您可以轻松地自行重新构建信息：
```
$ curl -XPOST http://127.0.0.1:9000/api/system/indices/ranges/rebuild
```
这将触发系统作业
```
INFO : org.graylog2.indexer.ranges.RebuildIndexRangesJob - Recalculating index ranges.
INFO : org.graylog2.system.jobs.SystemJobManager - Submitted SystemJob <9b64a9d0-dcac-11e6-97c3-6c4008b8fc28> [org.graylog2.indexer.ranges.RebuildIndexRangesJob]
INFO : org.graylog2.indexer.ranges.RebuildIndexRangesJob - Recalculating index ranges for index set Default index set (graylog2_*): 5 indices affected.
INFO : org.graylog2.indexer.ranges.MongoIndexRangeService - Calculated range of [graylog_96] in [7ms].
INFO : org.graylog2.indexer.ranges.RebuildIndexRangesJob - Created ranges for index graylog_96: MongoIndexRange{id=null, indexName=graylog_96, begin=2017-01-17T11:49:02.529Z, end=2017-01-17T12:00:01.492Z, calculatedAt=2017-01-17T12:00:58.097Z, calculationDuration=7, streamIds=[000000000000000000000001]}
[...]
INFO : org.graylog2.indexer.ranges.RebuildIndexRangesJob - Done calculating index ranges for 5 indices. Took 44ms.
INFO : org.graylog2.system.jobs.SystemJobManager - SystemJob <9b64a9d0-dcac-11e6-97c3-6c4008b8fc28> [org.graylog2.indexer.ranges.RebuildIndexRangesJob] finished in 46ms.
```
## Manually rotating the active write index 手动轮询写入索引
有时您可能希望手动旋转活动写入索引，而不是等到最新索引中已配置的旋转条件满足，例如，如果您更改了索引映射或每个索引的分片数。

您可以通过针对Graylog主节点的REST API的HTTP请求或通过Web界面执行此操作：
```
$ curl -XPOST http://127.0.0.1:9000/api/system/deflector/cycle
```
触发此作业会产生类似于以下行的日志输出：
```
INFO : org.graylog2.rest.resources.system.DeflectorResource - Cycling deflector for index set <58501f0b4a133077ecd134d9>. Reason: REST request.
INFO : org.graylog2.indexer.MongoIndexSet - Cycling from <graylog_97> to <graylog_98>.
INFO : org.graylog2.indexer.MongoIndexSet - Creating target index <graylog_98>.
INFO : org.graylog2.indexer.indices.Indices - Created Graylog index template "graylog-internal" in Elasticsearch.
INFO : org.graylog2.indexer.MongoIndexSet - Waiting for allocation of index <graylog_98>.
INFO : org.graylog2.indexer.MongoIndexSet - Index <graylog_98> has been successfully allocated.
INFO : org.graylog2.indexer.MongoIndexSet - Pointing index alias <graylog_deflector> to new index <graylog_98>.
INFO : org.graylog2.system.jobs.SystemJobManager - Submitted SystemJob <024aac80-dcad-11e6-97c3-6c4008b8fc28> [org.graylog2.indexer.indices.jobs.SetIndexReadOnlyAndCalculateRangeJob]
INFO : org.graylog2.indexer.MongoIndexSet - Successfully pointed index alias <graylog_deflector> to index <graylog_98>.
INFO : org.graylog2.indexer.retention.strategies.AbstractIndexCountBasedRetentionStrategy - Number of indices (5) higher than limit (4). Running retention for 1 index.
INFO : org.graylog2.indexer.retention.strategies.AbstractIndexCountBasedRetentionStrategy - Running retention strategy [org.graylog2.indexer.retention.strategies.DeletionRetentionStrategy] for index <graylog_94>
INFO : org.graylog2.indexer.retention.strategies.DeletionRetentionStrategy - Finished index retention strategy [delete] for index <graylog_94> in 23ms.
```
