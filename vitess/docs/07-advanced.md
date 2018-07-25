# Advanced Features 高级特性
## Overview 概述
此导航条目下的页面“高级功能”可以理解为“用户指南”的补充。这里我们描述您可能想要在生产设置中启用或调整的高级Vitess功能。

截至2017年10月，许多这些功能尚未记录。我们计划稍后为他们添加页面。

未记录的功能示例：

- vttablet中的热行保护
- 用于无损故障转移的vtgate缓冲区
- vttablet合并器（避免重复读取查询到MySQL，默认开启）
- vtexplain

## Messaging 消息
### Contents 内容
### Overview  概述
Vitess消息传递为应用程序提供了一种简单的方法来安排和管理需要异步执行的工作。在封面之下，消息存储在传统的MySQL表中，因此享有以下属性：

- 可扩展性：由于vitess的分片能力，消息可以扩展到非常大的QPS或大小。
- 保证交付：消息将被无限期地重试，直到收到成功的确认。
- 非阻塞：如果发送方积压，则新消息继续被接受以进行最终传送。
- 自适应：传递失败的消息按指数规律回退。
- 分析：消息的保留期限由应用程序决定。可能会选择不删除任何消息并使用这些数据执行分析。
- 事务处理：消息可以作为现有事务的一部分创建或确认。只有提交成功，该操作才会完成。

消息的属性由应用程序选择。但是，每条消息都需要一个唯一可识别的密钥。如果消息存储在分片表中，则密钥也必须是表的主vindex。

尽管消息通常会按照创建的顺序传递，但这并不是系统的明确保证。重点更多的是跟踪需要完成的工作并确保其完成。消息适用于：

- 把工作交给另一个系统。
- 记录需要异步完成的潜在耗时工作。
- 计划未来交付。
- 积累可以在非高峰时段完成的工作。

消息不适合以下用例：

- 将事件广播给多个用户。
- 有序交付。
- 实时交付。
### Creating a message table 创建消息表
当前的实现需要一个固定的模式。这将在未来变得更加灵活。还会有一个自定义的DDL语法。现在，消息表必须像这样创建：
``` bash
create table my_message(
  time_scheduled bigint,
  id bigint,
  time_next bigint,
  epoch bigint,
  time_created bigint,
  time_acked bigint,
  message varchar(128),
  primary key(time_scheduled, id),
  unique index id_idx(id),
  index next_idx(time_next, epoch)
) comment 'vitess_message,vt_ack_wait=30,vt_purge_after=86400,vt_batch_size=10,vt_cache_size=10000,vt_poller_interval=30'
```

与应用程序相关的列如下所示：

id：可以是任何类型。必须是唯一的。
message：可以是任何类型。
time_scheduled：必须是bigint。它将用于存储以十亿分之一秒为单位的unix时间。如果未指定，Now则插入该值。
建议使用上述指标以获得最佳性能。然而，可以允许一些变化来实现不同的性能平衡。

注释部分指定了其他配置参数。这些字段如下所示：

vitess_message：表示这是一个消息表。
vt_ack_wait=30：等待30秒，确认第一条消息。如果没有收到，重新发送。
vt_purge_after=86400：清除早于86400秒（1天）的acked邮件。
vt_batch_size=10：每个RPC数据包发送最多10条消息。
vt_cache_size=10000：缓存中最多可存储10000条消息。如果需求更高，其余的项目将不得不等待下一个轮询周期。
vt_poller_interval=30：每30秒轮询一次即将发送的消息。
如果上述任何一个字段丢失，vitess将无法加载表。在未加载的表格上不允许执行任何操作。

### Enqueuing messages 排队消息

### Receiving messages 接收消息
#### Subsetting
### Acknowledging messages 确认消息
### Exponential backoff 指数退避
### Purging 清洗
### Advanced usage 高级用法
### Undocumented features 未记录的功能
### Known limitations 已知的限制
