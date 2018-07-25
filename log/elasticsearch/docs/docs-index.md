> https://www.elastic.co/guide/en/elasticsearch/reference/5.6/docs-index_.html

```
curl -X PUT "10.1.16.154:9200/twitter/tweet/1" -H 'Content-Type: application/json' -d'
{
    "user" : "kimchy",
    "post_date" : "2009-11-15T14:12:12",
    "message" : "trying out Elasticsearch"
}
'

```

# Automatic Index Creation 自动创建索引
# Versioning 版本
# Operation Type 操作类型
# Automatic ID Generation 自动ID生成
# Routing 路由
# Parents & Children
# Distributed 分散
# Wait For Active Shards 等待活动分片
# Refresh 刷新
# Noop Updates Noop更新
# Timeout 超时
