官网文档: https://www.elastic.co/guide/en/elastic-stack/5.6/index.html

## [入门 Getting Started](https://github.com/mds1455975151/tools/blob/master/log/elasticsearch/docs/getting-started.md)
#### [基本概念 Basic Concepts](https://github.com/mds1455975151/tools/blob/master/log/elasticsearch/docs/basic_concepts.md)
#### [部署 Installation](https://github.com/mds1455975151/tools/blob/master/log/elasticsearch/docs/installation.md)
#### [探索集群 Exploring Your Cluster](https://github.com/mds1455975151/tools/blob/master/log/elasticsearch/docs/exploring_your_cluster.md)
#### [修改数据 Modifying Your Data](https://github.com/mds1455975151/tools/blob/master/log/elasticsearch/docs/modifying_your_data.md)
#### [探索数据 Exploring Your Data](https://github.com/mds1455975151/tools/blob/master/log/elasticsearch/docs/exploring_your_data.md)
#### [结论 Conclusion](https://github.com/mds1455975151/tools/blob/master/log/elasticsearch/docs/conclusion.md)

## [配置 Set up Elasticsearch](https://github.com/mds1455975151/tools/blob/master/log/elasticsearch/docs/setup.md)
#### [安装 Installing Elasticsearch](https://github.com/mds1455975151/tools/blob/master/log/elasticsearch/docs/install-elasticsearch.md)
#### [配置 Configuring Elasticsearch](https://github.com/mds1455975151/tools/blob/master/log/elasticsearch/docs/settings.md)
#### [重要配置 Important Elasticsearch configuration](https://github.com/mds1455975151/tools/blob/master/log/elasticsearch/docs/important-settings.md)
#### [安全设置 Secure Settings](https://github.com/mds1455975151/tools/blob/master/log/elasticsearch/docs/secure-settings.md)
#### [引导检查 Bootstrap Checks](https://github.com/mds1455975151/tools/blob/master/log/elasticsearch/docs/bootstrap-checks.md)
#### [重要系统配置 Important System Configuration](https://github.com/mds1455975151/tools/blob/master/log/elasticsearch/docs/system-config.md)
#### [升级elasticsearch Upgrading Elasticsearch](https://github.com/mds1455975151/tools/blob/master/log/elasticsearch/docs/setup-upgrade.md)
#### [停止Elasticsearch Stopping Elasticsearch](https://github.com/mds1455975151/tools/blob/master/log/elasticsearch/docs/system-config.md)

# [Set up X-Pack](https://github.com/mds1455975151/tools/blob/master/log/elasticsearch/docs/setup-xpack.md)
# Breaking changes
# [API Conventions](https://github.com/mds1455975151/tools/blob/master/log/elasticsearch/docs/docs.md)
# [Document APIs](https://github.com/mds1455975151/tools/blob/master/log/elasticsearch/docs/system-config.md)
# Search APIs
# Aggregations
# Indices APIs
# cat APIs
# Cluster APIs
官网文档:https://www.elastic.co/guide/en/elasticsearch/reference/5.6/cluster.html
## Cluster Health
## Cluster State
## Cluster Stats
## Pending cluster tasks
## Cluster Reroute
## Cluster Update Settings
## Nodes Stats
## Nodes Info
## Remote Cluster Info
## Task Management API
## Nodes hot_threads
## Cluster Allocation Explain API
# Query DSL
# Mapping
# Analysis
# Modules
## Cluster
## Discovery
## Local Gateway
## HTTP
## Indices
## Network Settings
## Node
## Plugins
## Scripting
## **Snapshot And Restore**
## Thread Pool
## Transport
## Tribe node
## Cross Cluster Search
# Index Modules
# Ingest Node
# X-Pack APIs
# X-Pack Commands
# How To
# Testing
# Glossary of terms
# Release Highlights
# Release Notes


http://10.1.16.152:9200/_cluster/settings

http://10.1.16.152:9200/_cluster/health


1. 获取当前所有index配置
```
curl -XGET http://10.1.16.152:9200/_settings
```

2. 获取某些index的配置
```
curl -XGET http://10.1.16.152:9200/graylog_0/_settings
curl -XGET http://10.1.16.152:9200/graylog_*/_settings
```

3. 动态修改某些index配置，增加replica
```
curl -XPUT http://10.1.16.152:9200/graylog_1/_settings -d '{"number_of_replicas":1}'
```

4. 动态修改某些index配置，删除replica
```
curl -XPUT http://10.1.16.152:9200/graylog_1/_settings -d '{"number_of_replicas":0}'
```

https://www.elastic.co/guide/en/elasticsearch/reference/5.6/indices.html
