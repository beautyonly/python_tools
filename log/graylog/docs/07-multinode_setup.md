> 多节点设置 http://docs.graylog.org/en/2.4/pages/configuration/multinode_setup.html

本指南不提供构建多节点graylog集群的分步教程，只是对设置过程中可能出现的问题提供一些建议。

对于这样的项目来说，了解安装过程中的每一步并预先做一些规划是非常重要的。

graylog应该是您在设置中安装的最后一个组件。它的依赖关系，及MongoDB和Elasticsearch,必须首先启动并运行。

> notes: 本指南不包括在不受信任的网络中运行多节点graylog集群的说明。我们假设主机之间的连接是可信的，不必单独保护。

# 先决条件
- 安装文档中建议的软件版本
- NTP设置
- DNS解析设置
- 可以正常连接网络
# MongoDB副本集
建议部署一个MongoDB副本集

MongoDB不必再专用集群上运行graylog，但应该遵循MongoDB文档中有关的建议。最重要的是，副本集中有奇数个MongoDB服务器。

在大多数设置中，每个graylog服务器还将托管作为同一副本集的一部分的MongoDB实例，并与集群中的所有其他节点共享数据。

> notes: 为了避免对MongoDB数据库的未经授权的访问，应该使用认证来设置MongoDB副本集。

正确的工作步骤顺序如下:
- 创建副本集(rs)
- 创建数据库(graylog)
- 创建一个用于访问数据库的用户账号，该数据库具有角色readWrite和dbadmin

如果您的MongoDB需要通过网络访问，则应bind_ip在配置中设置IP

# Elasticsearch集群
Elasticsearch安装文档会帮助您安装并配置一个强大的Elasticsearch.

将Elasticsearch集群命名为elasticsearch是非常重要的，以避免与使用默认配置的Elasticsearch节点发生意外冲突。只需选择其他任何内容（我们建议使用graylog），因为这是默认名称，并且在同一网络中启动的任何Elasticsearch实例都将尝试连接到此群集。

Elasticsearch服务器需要一个可通过网络设置访问的IP network.host以及群集中的某些参与者discovery.zen.ping.unicast.hosts。这足以拥有最小的群集设置。

使用用户身份验证保护Elasticsearch时，您需要向Graylog配置添加凭据，以便能够将安全的Elasticsearch群集与Graylog一起使用。

# Graylog多节点
安装Graylog之后，您应该注意只有一个Graylog节点配置为使用配置设置的主节点。is_master = true

rest_listen_uri（或rest_transport_uri）中配置的URI 必须对群集的所有Graylog节点均可访问。
## Graylog连接MongoDB
mongodb_uri配置设置必须包括形成副本集，副本集的名称，以及与访问该副本集先前配置的用户帐户的所有MongoDB的节点。配置设置是普通的MongoDB连接字符串。

最后，Graylog配置文件中的MongoDB连接字符串应如下所示：
```
mongodb_uri = mongodb://USERNAME:PASSWORD@mongodb-node01:27017,mongodb-node02:27017,mongodb-node03:27017/gray
```
## Graylog连接到Elasticsearch
Graylog将连接到Elasticsearch REST API

为了避免连接到Elasticsearch集群的问题，您应该添加一些Elasticsearch节点的网络地址elasticsearch_hosts。

## Graylog web界面
默认情况下，Web界面可用于每个没有使用配置设置禁用它的Graylog实例。web_enable = false

可以在所有Graylog服务器前使用负载均衡器，请参阅使Web界面与负载均衡器/代理一起使用以获取更多详细信息。

根据您的设置，可以使用硬件负载均衡器进行TLS / HTTPS终止，反向代理，或者只是在Graylog节点中启用它。
# 伸缩
多节点设置中的每个组件都可以根据个人需要进行扩展。

根据消息消息的数量和消息应该可用于直接搜索的时间长短，Elasticsearch集群将需要安装程序中的大部分资源。

密切关注群集中每个部分的度量标准。一种选择是使用telegraf获取importand metrics并将它们存储在您最喜欢的公制系统中（例如Graphite，Prometheus或Influx）。

Elasticseach Metrics和一些管理可以使用Elastic HQ或Cerebro完成。这些将帮助您了解Elasticsearch集群的运行状况和行为。

可以使用Graylog Metrics Reporter插件监控Graylog指标，这些插件可以将内部Graylog指标发送到您最喜欢的指标收集器（例如Graphite或Prometheus）。

直到今天，我们几乎从未遇到过MongoDB副本需要特别关注的问题。但是当然你仍然应该监控它并存储它的指标 - 只是为了确定。
# 排错
- 每次配置更改或服务重新启动后，请查看您已处理的应用程序的日志文件。有时其他日志文件也可以为您提供有关错误的提示。例如，如果您正在配置Graylog并尝试找出与MongoDB的连接不起作用的原因，那么MongoDB日志可以帮助识别问题。
- 如果已为Graylog REST API启用了HTTPS，则还需要为Graylog Web界面设置HTTPS。
