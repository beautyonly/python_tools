> [探索集群](https://www.elastic.co/guide/en/elasticsearch/reference/5.6/_exploring_your_cluster.html)

现在我们已经启动并运行了节点（和集群），下一步就是了解如何与它进行通信。幸运的是，Elasticsearch提供了一个非常全面和强大的REST API，您可以使用它与群集进行交互。使用API​​可以完成的几件事情如下：

- 检查您的群集，节点和索引运行状况，状态和统计信息
- 管理您的群集，节点和索引数据和元数据
- 根据索引执行CRUD（创建，读取，更新和删除）和搜索操作
- 执行高级搜索操作，例如分页，排序，过滤，脚本，聚合等等

# Cluster Health 集群健康
```
curl -X GET "10.1.16.152:9200/_cat/health?v"
curl -X GET "10.1.16.152:9200/_cat/health?json"
curl -X GET "10.1.16.152:9200/_cat/health"
```
集群健康判断
- Green - everything is good (cluster is fully functional)
- Yellow - all data is available but some replicas are not yet allocated (cluster is fully functional)
- Red - some data is not available for whatever reason (cluster is partially functional)

注：群集为红色时，它将继续提供来自可用碎片的搜索请求，但您可能需要尽快修复它，因为存在未分配的碎片。

获取集群节点列表，如下所示：
```
curl -X GET "10.1.16.152:9200/_cat/nodes?v"
```
# List All Indices 列出所有索引
```
curl -X GET "10.1.16.152:9200/_cat/indices?v"
```
# Create an Index 创建索引
创建一个名为customer的索引
```
curl -X PUT "10.1.16.152:9200/customer?pretty"
curl -X GET "10.1.16.152:9200/_cat/indices?v"
```
# Index and Query a Document 索引和查询文档
将一些数据放入到customer索引。
```
curl -X PUT "10.1.16.152:9200/customer/external/1?pretty" -H 'Content-Type: application/json' -d'
{
  "name": "John Doe"
}
'
返回结果：
{
  "_index" : "customer",
  "_type" : "external",
  "_id" : "1",
  "_version" : 1,
  "result" : "created",
  "_shards" : {
    "total" : 2,
    "successful" : 2,
    "failed" : 0
  },
  "created" : true
}
```

```
curl -X GET "10.1.16.152:9200/customer/external/1?pretty"
```
# Delete an Index 删除索引
```
curl -X DELETE "10.1.16.152:9200/customer?pretty"
curl -X GET "10.1.16.152:9200/_cat/indices?v"
```

总结：
```
<REST Verb> /<Index>/<Type>/<ID>
动词/索引/类型/ID
```
