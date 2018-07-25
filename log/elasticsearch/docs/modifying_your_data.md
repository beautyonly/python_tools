> [修改数据](https://www.elastic.co/guide/en/elasticsearch/reference/5.6/_modifying_your_data.html)

Elasticsearch几乎提供实时数据操作和搜索功能。默认情况下，从索引/更新/删除数据开始，直到它出现在搜索结构中的时间，您可以预计会由一秒的延迟(刷新间隔)。这是与SQL等其他平台的重要区别，其中数据在事务完成后立即可用。

# Indexing/Replicing Document 索引/替换文档
```
新建
curl -X PUT "10.1.16.152:9200/customer/external/1?pretty" -H 'Content-Type: application/json' -d'
{
  "name": "John Doe"
}
'
修改
curl -X PUT "10.1.16.152:9200/customer/external/1?pretty" -H 'Content-Type: application/json' -d'
{
  "name": "Jane Doe"
}
'
指定新建
curl -X PUT "10.1.16.152:9200/customer/external/2?pretty" -H 'Content-Type: application/json' -d'
{
  "name": "Jane Doe"
}
'
未指定则随机生成ID新建
curl -X POST "10.1.16.152:9200/customer/external?pretty" -H 'Content-Type: application/json' -d'
{
  "name": "Jane Doe"
}
'
```

## Updating Documents 更新文档
```
curl -X POST "localhost:9200/customer/external/1/_update?pretty" -H 'Content-Type: application/json' -d'
{
  "doc": { "name": "Jane Doe" }
}
'

curl -X POST "localhost:9200/customer/external/1/_update?pretty" -H 'Content-Type: application/json' -d'
{
  "doc": { "name": "Jane Doe", "age": 20 }
}
'

curl -X POST "localhost:9200/customer/external/1/_update?pretty" -H 'Content-Type: application/json' -d'
{
  "script" : "ctx._source.age += 5"
}
'

```
## Deleting Documents 删除文档
```
curl -X DELETE "localhost:9200/customer/external/2?pretty"
```
## Batch Processing 批量处理
```
curl -X POST "localhost:9200/customer/external/_bulk?pretty" -H 'Content-Type: application/json' -d'
{"index":{"_id":"1"}}
{"name": "John Doe" }
{"index":{"_id":"2"}}
{"name": "Jane Doe" }
'

curl -X POST "localhost:9200/customer/external/_bulk?pretty" -H 'Content-Type: application/json' -d'
{"update":{"_id":"1"}}
{"doc": { "name": "John Doe becomes Jane Doe" } }
{"delete":{"_id":"2"}}
'
```
批量API不会因其中一个操作失败而失败。如果一个动作因任何原因失败，它将继续处理其后的其余动作。当批量API返回时，它将为每个操作提供一个状态（按照它发送的相同顺序），以便您可以检查特定操作是否失败。
