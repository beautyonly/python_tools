> [探索数据](https://www.elastic.co/guide/en/elasticsearch/reference/5.6/_exploring_your_data.html)

基本知识了解后，研究一个更真实的数据集。准备一个关于银行客户账号信息的虚拟json文档样本。每个文档都有如下字段：
``` json
{
    "account_number": 0,
    "balance": 16623,
    "firstname": "Bradshaw",
    "lastname": "Mckenzie",
    "age": 29,
    "gender": "F",
    "address": "244 Columbus Place",
    "employer": "Euron",
    "email": "bradshawmckenzie@euron.com",
    "city": "Hobucken",
    "state": "CO"
}
```
数据生成方法：https://next.json-generator.com/

# 加载示例数据
```
wget -O accounts.json "https://github.com/elastic/elasticsearch/blob/master/docs/src/test/resources/accounts.json?raw=true"
curl -H "Content-Type: application/json" -XPOST "10.1.16.152:9200/bank/account/_bulk?pretty&refresh" --data-binary "@accounts.json"
curl "10.1.16.152:9200/_cat/indices?v"
```
成功将1000条记录批量索引到bank索引 account类型

## The Search API 搜索API
开始一些简单搜索。运行检索两种方式：1、通过发送搜索参数REST request URI 2、发送REST request body

用于搜索的REST API可以从_search访问。本示例返回bank index中所有信息：
```
curl -X GET "10.1.16.152:9200/bank/_search?q=*&sort=account_number:asc&pretty"
```
q=* : 指示Elasticsearch匹配index中所有document
sort=account_number:asc : 表示按每个document中account_number字段进行升序排序
pretty：返回json结构

the response 响应部分，包括如下部分：
- took: 执行搜索时间(毫秒为单位)
- timed_out：搜索是否超时
- _ shards : 告诉我们搜索了多少shard,已经搜索shard成功/失败的次数
- hits：搜索结果
- hits.total:符合搜索条件的document总数
- hits.hits：实际的搜索结果数据(默认为前10个document)
- hits.sort:结果排序
- hits._ score and max_score 忽略这些字段

使用替代request body method进行相同的精确搜索：
```
curl -X GET "10.1.16.152:9200/bank/_search" -H 'Content-Type: application/json' -d'
{
  "query": { "match_all": {} },
  "sort": [
    { "account_number": "asc" }
  ]
}
'

```
## Introducing the Query Language 介绍查询语言
```
match_all:在指定在所有的所有document中进行搜索
curl -X GET "localhost:9200/bank/_search" -H 'Content-Type: application/json' -d'
{
  "query": { "match_all": {} }
}
'
添加size参数，不指定默认为10
curl -X GET "localhost:9200/bank/_search" -H 'Content-Type: application/json' -d'
{
  "query": { "match_all": {} },
  "size": 1
}
'


返回10-19号document， from不指定，默认为0 (实现分页搜索时非常有用)
curl -X GET "localhost:9200/bank/_search" -H 'Content-Type: application/json' -d'
{
  "query": { "match_all": {} },
  "from": 10,
  "size": 10
}
'

实例：按照账户余额降序排列，返回前10个记录
curl -X GET "localhost:9200/bank/_search" -H 'Content-Type: application/json' -d'
{
  "query": { "match_all": {} },
  "sort": { "balance": { "order": "desc" } }
}
'
```
## Executing Searches 执行搜索
深入了解查询DSL

默认情况下，完整的json文档作为所有搜索的一部分返回。这被称为源_source，如果不希望整个源文档被返回，我们有能力只需要返回源内的几个字段。
```
curl -X GET "10.1.16.152:9200/bank/_search" -H 'Content-Type: application/json' -d'
{
  "query": { "match_all": {} },
  "_source": ["account_number", "balance"]
}
'
```
请注意，上述示例只是简化了_source字段。它们仍然只会返回名为_source，在其中，只有account_number和balance也包括在内。

如果有sql知识，上述内容在概念上和sql select from字段列表有些相似

match查询 针对特定字段或字段集合进行的搜索
```
示例:返回编号20的账号
curl -X GET "localhost:9200/bank/_search" -H 'Content-Type: application/json' -d'
{
  "query": { "match": { "account_number": 20 } }
}
'

示例：返回地址中包含mail的所有账号
curl -X GET "localhost:9200/bank/_search" -H 'Content-Type: application/json' -d'
{
  "query": { "match": { "address": "mill" } }
}
'

示例：返回地址中包含mail 或 lane的所有账号
curl -X GET "localhost:9200/bank/_search" -H 'Content-Type: application/json' -d'
{
  "query": { "match": { "address": "mill lane" } }
}
'

示例：返回地址中包含mail lane的所有账号 match方法的变种
curl -X GET "localhost:9200/bank/_search" -H 'Content-Type: application/json' -d'
{
  "query": { "match_phrase": { "address": "mill lane" } }
}
'

bool查询 允许我们撰写较小的查询到布尔逻辑更大的查询
本示例组成两个match查询并返回地址中包含mail lane的所有账号
curl -X GET "localhost:9200/bank/_search" -H 'Content-Type: application/json' -d'
{
  "query": {
    "bool": {
      "must": [
        { "match": { "address": "mill" } },
        { "match": { "address": "lane" } }
      ]
    }
  }
}
'


curl -X GET "localhost:9200/bank/_search" -H 'Content-Type: application/json' -d'
{
  "query": {
    "bool": {
      "should": [
        { "match": { "address": "mill" } },
        { "match": { "address": "lane" } }
      ]
    }
  }
}
'
curl -X GET "localhost:9200/bank/_search" -H 'Content-Type: application/json' -d'
{
  "query": {
    "bool": {
      "must_not": [
        { "match": { "address": "mill" } },
        { "match": { "address": "lane" } }
      ]
    }
  }
}
'

示例:返回任何40岁但未居住在id的人的所有账号
curl -X GET "localhost:9200/bank/_search" -H 'Content-Type: application/json' -d'
{
  "query": {
    "bool": {
      "must": [
        { "match": { "age": "40" } }
      ],
      "must_not": [
        { "match": { "state": "ID" } }
      ]
    }
  }
}
'
```

## Executing Filters 执行过滤器
[官网文档](https://www.elastic.co/guide/en/elasticsearch/reference/5.6/_executing_filters.html)

_ score搜索结果中的字段细节。score是一个数值，它是文档与我们制定的搜索查询匹配度的相对度量。越高越相关，越低文档的相关性越低

查询并不总是需要生成分数，特别是当它们仅用于过滤文档集时，Elasticsearch检测这些情况并自动优化查询执行，以便不计算无用分数。

介绍下range查询，允许我们通过一系列值来过滤文档。这些通常用于数字或日期过滤。

此示例使用bool查询返回余额介于20000和30000之间的所有账号。换句话说，我们希望查找余额大于或等于20000且小于等于30000的账号
```
curl -X GET "localhost:9200/bank/_search" -H 'Content-Type: application/json' -d'
{
  "query": {
    "bool": {
      "must": { "match_all": {} },
      "filter": {
        "range": {
          "balance": {
            "gte": 20000,
            "lte": 30000
          }
        }
      }
    }
  }
}
'
```
bool查询包含match_all查询和range查询。我们可以将任何其他查询替换为查询和过滤器部分。在上述情况下，range查询非常有意义，因为落入该房屋的文档全部匹配相同，即没有文档比另一个文档更相关。

## Executing Aggregations 执行聚合
[官网文档](https://www.elastic.co/guide/en/elasticsearch/reference/5.6/_executing_aggregations.html)

聚合提供了从数据中分组和提取统计数据的功能。考虑聚合的最简单方法是将其大致等同于SQL Group by和SQL聚合函数。

示例:按状态对所有账号进行分组
```
curl -X GET "localhost:9200/bank/_search" -H 'Content-Type: application/json' -d'
{
  "size": 0,
  "aggs": {
    "group_by_state": {
      "terms": {
        "field": "state.keyword"
      }
    }
  }
}
'
```
SQL中，上面的聚合在概念上类似于：
```
SELECT state, COUNT(*) FROM bank GROUP BY state ORDER BY COUNT(*) DESC
```
