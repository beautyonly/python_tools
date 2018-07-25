> https://www.elastic.co/guide/en/elasticsearch/reference/5.6/setup-upgrade.html

升级前需要哪些准备:
- 请参考重大更改文档
- 使用Elasticsearch Migration Plugin 在升级之前检测潜在问题。
- 在升级生产集群之前，可以在开发环境中测试升级
- 在升级之前始终备份数据。你不能回退，除非你有你的数据备份到一个较早的版本。
- 如果您在使用的是自定义插件，请检查兼容版本是否可用。

Elasticsearch通常可以使用滚动升级过程进行升级，从而不会中断服务。本节详细介绍如何通过完全群集重新启动执行滚动升级和升级。

# Rolling upgrades 滚动升级
> https://www.elastic.co/guide/en/elasticsearch/reference/5.6/rolling-upgrades.html

滚动升级允许Elasticsearch集群一次升级一个节点，最终用户无需停机。不支持在同一集群中运行多个版本的Elasticsearch超过升级所需的任何时间长度，因为不会将更新版本的碎片复制到旧版本。

请参阅此表以验证您的Elasticsearch版本是否支持滚动升级。
- 1、Disable shard allocation 禁用shard分配
当您关闭节点时，分配过程将等待一分钟，然后开始将该节点上的分片复制到群集中的其他节点，从而导致大量浪费的I / O. 在关闭节点之前禁用分配可以避免这种情况：
```
PUT _cluster/settings
{
  "transient": {
    "cluster.routing.allocation.enable": "none"
  }
}
```

- 2、Stop non-essential indexing and perform a synced flush (Optional)
- 3、Stop and upgrade a single node
# Full cluster restart upgrade 完全机器重启升级
略
# Reindex to upgrade Reinder升级
略
