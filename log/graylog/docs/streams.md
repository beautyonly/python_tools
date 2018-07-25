> 数据流 http://docs.graylog.org/en/2.4/pages/streams.html

# What are streams? 什么是流？
graylog流是一种在处理消息时将消息路由到不同类别的机制。您定义了指示graylog将那个消息路由到那个流的机制。想象一下将这三条消息发送给graylog。
```
message: INSERT failed (out of disk space)
level: 3 (error)
source: database-host-1

message: Added user 'foo'.
level: 6 (informational)
source: database-host-2

message: smtp ERR: remote closed the connection
level: 3 (error)
source: application-x
```
您可以使用流做的许多事情之一是创建一个名为数据库错误的流，它捕获来自您的一个数据库主机的每条错误消息。

使用这些规则创建新流，选择匹配所有规则的选项：
- 字段level必须大于4
- 字段source必须匹配正则表达式^database-host-\d+

这将路由每个新消息，其level值高于warn，source并将数据库主机正则表达式与流匹配。

消息将路由到其所有（或任何）规则匹配的每个流中。这意味着一条消息可以成为许多流的一部分，而不仅仅是一条。

流现在出现在流列表中，单击其标题将显示所有数据库错误。

在某些情况发生时，可以使用流警报。我们将介绍与警报中的警报相关的更多主题。

## What’s the difference to saved searches?
最大的区别是流是实时处理的。这允许实时警报并转发到其他系统。想象以下，通过定期从消息存储中读取数据库错误，将数据库错误转发到另一个系统或将它们写入文件。实时流做的更好。

另一个区别是，对复杂流规则集的搜索总是比较便宜，因为消息 在处理时用流ID 标记。无论您配置了多少个流规则，在内部搜索Graylog总是如下所示：
```
streams:[STREAM_ID]
```
使用所有规则构建查询会导致邮件存储的负载显着增加。
# How do I create a stream? 如何创建流？
- 顶部导航栏-streams
- 单击创建流
- 输入名称和说明后保存流。例如:所有错误消息和捕获来自所有源的所有错误消息。该流现已保存但尚未激活。
- 单击刚刚创建的流的编辑规则。这将打开一个页面，您可以在其他关联和测试流规则
- 选择您希望如何评估流规则以决定哪些消息进入流
  - 消息必须符合以下所有规则
  - 消息必须至少与以下规则之一匹配
- 添加流规则，通过指示您要检查的字段以及应该满足的条件。通过从输入加载或手动提供消息ID来尝试针对某些消息的规则。一旦您对结果感到满意，请单击“我已完成”。
- 流仍处于暂停状态，单击“开始流”按钮以激活流。
# Index Sets 索引集合
对于初学者，您应该阅读索引模式，以获取graylog中索引集合的全面描述。

每个流都分配 给一个索引集，该索引集控制如何将路由到该流的消息存储到Elasticsearch中，web界面中的流概述显示为每个流分配的索引集。
## Storage requirements
存储要求

# Outputs 输出
流输出系统允许您将路由到流中的每条消息转发到其他目标。

输出是全局管理的，而不是单个流。您可以创建新输出并根据需要为多个流激活它们。这样，您可以配置一次转发目标，并选择多个流来使用它。
graylog附带默认输出，可以使用插件进行扩展。
# Use cases 用例
以下是流的一些示例用例:
- 将一部分消息转发到其他数据分析或BI系统，以降低成本
- 监控整个环境中的异常或错误率，并按子系统进行细分
- 获取所有失败的ssh登录列表，并使用快速值分析受影响的用户名
- 捕获所有/login使用http302回答的HTTP POST请求，并将它们路由到名为successful user login的流中。现在获取用户登录时的图标，并使用快速值获取在搜索时间范围内执行登录次数最多的用户列表。

# How are streams processed internally? 流在内部如何处理？
进来的每条消息都与流的规则相匹配。对于满足所有或 至少一个流规则（如流中配置）的消息，该流的内部ID存储在streams已处理消息的数组中。

现在，绑定到流的所有分析方法和搜索都可以通过streams:[STREAM_ID]限制搜索来轻松缩小其操作 范围。这是由Graylog自动完成的，不必由用户提供。
internal_stream_processing.png

# Stream Processing Runtime Limits 流处理运行时限制
## How to configure the timeout values if the defaults do not match
## What could cause it?
## Summary: How do I solve it?
# Programmatic access via the REST API 通过REST API进行编程访问
许多组织已经运行监控基础架构，能够在检测到事件时向操作人员发出警报。这些系统通常能够定期轮询信息或推送新警报 - 本文介绍如何使用Graylog Stream Alert API轮询当前活动的警报，以便在第三方产品中进一步处理它们。
## Checking for currently active alert/triggered conditions 检查当前活动的警报/触发条件
## List of already triggered stream alerts
# FAQs
