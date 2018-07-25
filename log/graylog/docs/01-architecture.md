# Architectural considerations 架构
伸缩Graylog资源时有几条经验法则：
- Graylog节点关注CPU内容，也提供浏览器的用户界面
- Elasticsearch节点应该拥有尽可能多的RAM和最快的磁盘。一切都取决于IO速度
- MongoDB存储元数据和配置数据，并且不需要很多资源

note: 传入的消息只存储在Elasticsearch中。如果您在Elasticsearch集群中有数据丢失，则消息将丢失，除非您创建了索引的备份。

# Minimum setup 最低配置
这是可用的最小，非关键或者测试配置的最小Graylog配置。没有任何多余组件，很容易和快速设置。
![images](https://github.com/mds1455975151/tools/blob/master/graylog/docs/images/01.png)
我们虚拟机默认使用这种设计，将nginx作为前端代理部署。

# Bigger production setup 更大生产配置
这是适用于更大生产环境的设置。它在负载均衡后面有几个Graylog节点来分配处理负载。

负载均衡器可以通过Graylog REST API上的HTTP对Graylog节点进行ping操作，以检查它们是否处于活动状态，并将死节点从集群中取出。
![images](https://github.com/mds1455975151/tools/blob/master/graylog/docs/images/02.png)

我们的多节点安装指南中介绍了如何规划和配置这样的设置。

有关Graylog Marketplace的一些指南还提供了关于如何使用RabbitMQ或者Apache Kafka为您的设置添加排队的一些想法。

# Graylog Architecture Deep Dive 更高级设置
略
