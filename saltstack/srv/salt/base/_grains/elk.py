#!/usr/bin/env python
#coding=utf-8

import datetime
from elasticsearch import Elasticsearch

# 请求elasticsearch节点的url
url = "http://kibana.xxxxxx.com:9200/"

# 使用的索引，因日期时区问题，所以要指定昨天和前天的索引名
index_name = "filebeat-20170517"
# 实例化Elasticsearch类，并设置超时间为120秒，默认是10秒的，如果数据量很大，时间设置更长一些
es = Elasticsearch(url,timeout=120)
res = es.get(index="filebeat-2017.04.21", id=01)
print(res)
