# Multi-node Setup

官网文档:http://docs.graylog.org/en/latest/pages/configuration/multinode_setup.html

## Prerequisites
- 软件版本
- 系统时间同步，dns解析
- 连接到外网

## MongoDB replica set
部署MongoDB副本集，参考地址:https://docs.mongodb.com/manual/tutorial/deploy-replica-set/

MongoDB不必在专用服务器上运行，可以运行在graylog上。最重要的时副本集有奇数个MongoDB服务器。

在大多数设置中，每个graylog服务器还将托管作为同一副本集的一部分的MongoDB实例，并与集群中的所有其他节点共享数据。

> 为了避免对MongoDB数据库的未经授权的访问，[应该使用认证来设置MongoDB副本集](https://docs.mongodb.com/v2.6/tutorial/deploy-replica-set-with-auth/)。

正确的工作步骤顺序如下:
- 创建副本集 rs01
- 创建数据库 graylog
- 创建一个用于访问数据库的用户账号，该数据库具有角色readwrite和dbadmin

如何您的MongoDB需要通过网络可达，设置bind_ip在配置中设置IP


## Elasticsearch cluster
该[Elasticsearch安装文档](https://www.elastic.co/guide/en/elasticsearch/reference/5.4/setup.html)会帮助你与一个强大的基本配置安装Elasticsearch。

将Elasticsearch集群命名为elasticsearch是非常重要的，以避免与使用默认配置的Elasticsearch节点发生意外冲突。只需选择其他任何东西（我们建议使用graylog），因为这是默认名称，任何在同一网络中启动的Elasticsearch实例都会尝试连接到此群集。

Elasticsearch服务器需要一个IP，可通过network.host集群中的网络和某些参与者访问discovery.zen.ping.unicast.hosts。这足以实现最小的群集设置。

当您通过用户身份验证确保您的Elasticsearch安全时，您需要向Graylog配置添加凭据，以便能够将安全的Elasticsearch集群与Graylog配合使用。

## Graylog Multi-node
在安装Graylog之后，您应该注意只有一个Graylog节点被配置为主配置设置。is_master = true

rest_listen_uri（或rest_transport_uri）中配置的URI 必须对群集的所有Graylog节点均可访问。
**部署从节点设置**
```
cd /etc/ansible/playbook/
ansible-playbook host-init-test.yml -l 10.1.16.154
ansible-playbook install_graylog_server.yml -l 10.1.16.154
```

### Graylog to MongoDB connection
### Graylog to Elasticsearch connection
### Graylog web interface
haproxy替换为腾讯云ELB

## Scaling
这个多节点设置中的每个组件都可以根据个人需求进行扩展。

根据消息消息的数量和消息应该可用于直接搜索的时间长短，Elasticsearch集群将需要安装程序中的大部分资源。

密切关注群集每个部分的度量标准。一种选择是使用telegraf获取importand metrics并将它们存储在您最喜欢的公制系统中（例如Graphite，Prometheus或Influx）。

Elasticseach Metrics和一些管理可以使用Elastic HQ或Cerebro完成。这些将帮助您了解Elasticsearch集群的运行状况和行为。

可以使用Graylog Metrics Reporter插件监控Graylog指标，这些插件可以将内部Graylog指标发送到您最喜欢的指标收集器（例如Graphite或Prometheus）。

直到今天，我们几乎从未遇到过MongoDB副本需要特别关注的问题。但是，当然你仍然应该监控它并存储它的指标 - 只是可以肯定的。
## Troubleshooting
