# replication
A replica set 在MongoDB是一组mongod其保持相同的数据集的过程。副本集提供冗余和高可用性，并且是所有生产部署的基础。本节介绍MongoDB中的复制以及副本集的组件和体系结构。该部分还提供了与副本集相关的常见任务教程。

# Redundancy and Data Availability 冗余和数据可用性
复制提供冗余并增加数据可用性。借助不同数据库服务器上的多个数据副本，复制提供了一定的容错能力，以防止单个数据库服务器的丢失。

在某些情况下，复制可以提供更高的读取容量，因为客户端可以将读取操作发送到不同服务器 在不同数据中心维护数据副本可以提高分布式应用程序的数据本地化和可用性。您还可以维护用于专用目的的其他副本，例如灾难恢复，报告或备份。

# Replication in MongoDB MongoDB中的复制

# Asynchronous Replication 异步复制
辅助程序异步应用来自主服务器的操作。通过在主要操作之后应用操作，即使一个或多个成员失败，集合仍可继续运行。有关复制机制的更多信息，请参阅副本集设置Oplog和 副本集数据同步。

# Automatic Failover 自动故障转移
# Read Operations 阅读操作
# Additional Features 附加功能
