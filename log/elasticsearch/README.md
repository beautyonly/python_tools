## Elasticsearch

- 官网文档：https://www.elastic.co/guide/en/elasticsearch/reference/current/index.html
- 5.6官网文档：https://www.elastic.co/guide/en/elasticsearch/reference/5.6/index.html

### API
#### Search APIs
#### Indices APIs
#### cat APIs
``` text
curl -X GET http://localhost:9200/_cat/indices?v		//获取索引列表
curl -X GET http://localhost:9200/_cat/health?v			//获取状态
curl -X GET http://localhost:9200/graylog_deflector		//获取指定索引信息graylog_deflector
curl -X PUT http://localhost:9200/customer?pretty		//创建索引customer
curl -X DELETE http://localhost:9200/customer?pretty	//删除索引customer
curl -X GET http://localhost:9200/graylog_deflector/_search?pretty		//在指定索引中搜索数据
```
#### Cluster APIs

How to add a new node to my Elasticsearch cluster

- [参考资料](https://stackoverflow.com/questions/35717790/how-to-add-a-new-node-to-my-elasticsearch-cluster)
- [验证过程](  https://github.com/mds1455975151/tools/blob/master/log/elasticsearch/docs/add_node_to_cluster.md)

http://10.1.16.152:9200/_cluster/settings?pretty

 - 确定节点version,保持节点版本一致性
  > http://10.1.16.152:9200/

es优化：https://mp.weixin.qq.com/s/0TMESj2Z-XK2PzwBQo0Mpg
# 相关工具
## 基础类工具
- head插件
```
ES集群状态查看、索引数据查看、ES DSL实现（增、删、改、查操作）
比较实用的地方：json串的格式化
```
GitHub地址：http://mobz.github.io/elasticsearch-head/

- Kibana
```
除了支持各种数据的可视化之外，最重要的是：支持Dev Tool进行RESTFUL API增删改查操作。比Postman工具和curl都方便很多。
```
地址：https://www.elastic.co/products/kibana

- ElasticHD
```
强势功能——支持sql转DSL，不要完全依赖，可以借鉴用。
```
GitHub地址：https://github.com/360EntSecGroup-Skylar/ElasticHD

## 集群监控工具
- cerebro
```
GitHub地址：https://github.com/lmenezes/cerebro
```

- Elaticsearch-HQ
```
管理elasticsearch集群以及通过web界面来进行查询操作
GitHub地址：https://github.com/royrusso/elasticsearch-HQ
```

## 集群迁移工具
- Elasticsearch-migration
```
支持多个版本间的数据迁移，使用scroll+bulk
地址：https://github.com/medcl/elasticsearch-migration
```

- Elasticsearch-Exporter
```
将ES中的数据向其他导出的简单脚本实现。
地址：https://github.com/mallocator/Elasticsearch-Exporter
```

- Elasticsearch-dump
```
移动和保存索引的工具。
地址：https://github.com/taskrabbit/elasticsearch-dump
```

## 集群数据处理工具
- elasticsearch-curator
```
elasticsearch官方工具，能实现诸如数据只保留前七天的数据的功能。
地址：https://pypi.python.org/pypi/elasticsearch-curator
另外 ES6.3（还未上线）  有一个 Index LifeCycle Management 可以很方便的管理索引的保存期限。
```

## 安全类工具
- x-pack
```
地址：https://www.elastic.co/downloads/x-pack
```
- search-guard
```
Search Guard  是 Elasticsearch 的安全插件。它为后端系统（如LDAP或Kerberos）提供身份验证和授权，并向Elasticsearch添加审核日志记录和文档/字段级安全性。
Search Guard所有基本安全功能（非全部）都是免费的，并且内置在Search Guard中。  Search Guard支持OpenSSL并与Kibana和logstash配合使用。
地址：https://github.com/floragunncom/search-guard
```
## 可视化类工具
- grafana
```
grafana工具与kibana可视化的区别：
- 如果你的业务线数据较少且单一，可以用kibana做出很棒很直观的数据分析。
- 而如果你的数据源很多并且业务线也多，建议使用grafana，可以减少你的工作量

对比：https://www.zhihu.com/question/54388690

官网地址：https://grafana.com/grafana
```
## 自动化运维工具
- Ansible
https://github.com/elastic/ansible-elasticsearch

- Puppet
https://github.com/elastic/puppet-elasticsearch

- Cookbook
https://github.com/elastic/cookbook-elasticsearch
## 类SQL查询
```
sql 一款国人NLP-china团队写的通过类似sql语法进行查询的工具
地址：https://github.com/NLPchina/elasticsearch-sql
ES6.3+以后的新版本会集成sql。
```
## 增强类工具
- Conveyor 工具
```
kibna插件——图形化数据导入工具
地址：http://t.cn/REOhwGT
```
- kibana_markdown_doc_view
```
Kibana文档查看强化插件，以markdown格式展示文档
地址：http://t.cn/REOhKgB
```

- indices_view
```
indices_view 是新蛋网开源的一个 kibana APP 插件项目，可以安装在 kibana 中，快速、高效、便捷的查看elasticsearch 中 indices 相关信息
地址：https://gitee.com/newegg/indices_view
```

- dremio
```
- 支持sql转DSL
- 支持elasticsearch、mysql、oracle、mongo、csv等多种格式可视化处理
- 支持ES多表的Join操作
地址：https://www.dremio.com/
```
## 报警类
- elastalert
```
ElastAlert是Yelp公司开源的一套用Python2.6写的报警框架。属于后来Elastic.co公司出品的Watcher同类产品。
官网地址: http://elastalert.readthedocs.org/

使用举例：当我们把ELK搭建好、并顺利的收集到日志，但是日志里发生了什么事，我们并不能第一时间知道日志里到底发生了什么，运维需要第一时间知道日志发生了什么事，所以就有了ElastAlert的邮件报警。
```

- sentinl
```
SENTINL 6扩展了Siren Investigate和Kibana的警报和报告功能，使用标准查询，可编程验证器和各种可配置操作来监控，通知和报告数据系列更改 - 将其视为一个独立的“Watcher” “报告”功能（支持PNG / PDF快照）。
SENTINL还旨在简化在Siren Investigate / Kibana 6.x中通过其本地应用程序界面创建和管理警报和报告的过程，或通过在Kibana 6.x +中使用本地监视工具来创建和管理警报和报告的过程。

官网地址：https://github.com/sirensolutions/sentinl
```
# to-do-list
- elasticsearch官网文档过一遍
- ~~Elasticsearch部署~~
- ~~Elasticsearch添加node~~
- Elasticsearch服务监控
- Elasticsearch数据备份和恢复

- Elasticsearch数据迁移
- [Elasticsearch索引迁移](https://blog.csdn.net/laoyang360/article/details/65449407)
  - [elaticserch-dump](https://github.com/taskrabbit/elasticsearch-dump)
  - [Elasticsearch-Exporter](https://github.com/mallocator/Elasticsearch-Exporter)
  - logstash定向索引迁移
  - elasticsearch-migration 升级elasticsearch使用
