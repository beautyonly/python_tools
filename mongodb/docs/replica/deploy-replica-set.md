# Deploy a Replica Set 部署副本集
本教程介绍如何从禁用访问控制的三个现有实例 创建三个成员的副本集。mongod

要部署具有已启用访问控制的副本集，请 参阅使用密钥文件访问控制部署新副本集。如果您希望从单个MongoDB实例部署副本集，请参阅 将单机版转换为副本集。有关副本集部署的更多信息，请参阅复制和 副本集部署体系结构文档。

## Overview 概述
三个成员副本集提供足够的冗余来承受大多数网络分区和其他系统故障。这些集合还具有足够的容量用于许多分布式读取操作。副本集应该总是有奇数个成员。这确保选举顺利进行。有关设计副本集的更多信息，请参阅复制概述
## Requirements 要求
对于生产部署，您应该通过将这些mongod 实例托管在单独的计算机上，尽可能保持成员之间的分离。将虚拟机用于生产部署时，应将每个mongod 实例放置在由冗余电源电路和冗余网络路径服务的单独主机服务器上。

在部署副本集之前，您必须在将成为副本集一部分的每个系统上安装MongoDB 。如果您尚未安装MongoDB，请参阅安装教程。

## Considerations When Deploying a Replica Set 注意事项
- Architecture 架构
- IP Binding
- Connectivity
- Configuration
- Procedure
  - Start each member of the replica set with the appropriate options.
  - Connect a mongo shell to one of the mongod instances
  - Initiate the replica set.
  - View the replica set configuration.
  - Ensure that the replica set has a primary.
## Procedure 程序
