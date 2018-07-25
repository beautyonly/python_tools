> https://www.elastic.co/guide/en/elasticsearch/reference/5.6/api-conventions.html

API约定

该Elasticsearch REST API使用http返回json

除非另有说明，否则本章中列出的约定可以在整个REST API中应用
- 多个索引
- 索引名称中日期
- 常见选项
- 基于URL的访问控制


# multi-index 多个索引
# date-math-index-names 索引名称中的日期数学支持
# common-options 常见选项
以下选项可应用于所有REST API
## Pretty Results 漂亮的结果
```
?pretty=true 返回json被格式化
?format=yaml yaml格式返回结果
```
## Human readable output 人类可读的输出

## Date Math 日期数字

## Response Filtering 响应过滤
```
curl -X GET "localhost:9200/_search?q=elasticsearch&filter_path=took,hits.hits._id,hits.hits._score/_search?q=elasticsearch&filter_path=took,hits.hits._id,hits.hits._score"

```
## Flat Settings 平面设置
## Parameters 参数
## Boolean Values 布尔值
## Number Values 数值
## Time units 时间单位
## Byte size units 字节大小单位
## Unit-less quantities 无单位数量
## Distance Units 距离单位
## Fuzziness 模糊
## Enabling stack traces 启用堆栈跟踪
## Request body in query string 在查询字符串中请求正文
## Content-Type auto-detection 内容类型自动检测

# url-access-control 基于URL的访问控制
