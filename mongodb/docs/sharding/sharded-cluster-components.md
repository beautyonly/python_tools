# Sharded Cluster Components 分片集群组件
A MongoDB sharded cluster consists of the following components:

- **shard:** Each shard contains a subset of the sharded data. As of MongoDB 3.6, shards must be deployed as a replica set.
- **mongos:** The mongos acts as a query router, providing an interface between client applications and the sharded cluster.
- **config servers:** Config servers store metadata and configuration settings for the cluster. As of MongoDB 3.4, config servers must be deployed as a replica set (CSRS).

# Production Configuration 生产配置
在生产群集中，确保数据是多余的，并确保您的系统具有高可用性。考虑生产分片群集部署的以下内容：

- 将配置服务器部署为3个成员副本集
- 将每个Shard部署为3个成员副本集
- 部署一个或多个mongos路由器
## Replica Set Distribution 副本集分布
## Number of Shards
## Number of mongos and Distribution 

# Development Configuration 开发配置
