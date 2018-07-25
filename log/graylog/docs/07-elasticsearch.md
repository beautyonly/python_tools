> Elasticsearch http://docs.graylog.org/en/2.4/pages/configuration/elasticsearch.html

强烈建议使用专用的elasticsearch集群进行graylog设置。

如果使用的共享Elasticsearch设置，则与graylog无关的索引问题可能会将集群状态变为黄色或红色，并影响graylog设置的可用性和性能。
# Elasticsearch versions 版本
从版本2.3开始，Graylog使用HTTP协议连接到您的Elasticsearch集群，因此它不再需要Elasticsearch版本。我们可以放心地假设从2.x开始的任何版本都在工作。

警告：Graylog 2.4 不适用于Elasticsearch 6.x！

注意: Graylog可以使用Elasticsearch 5.3.x或更高版本与Amazon Elasticsearch Service一起使用。

# Configuration 配置
## Graylog
成功连接的最重要设置是一个以逗号分隔的URI到一个或多个Elasticsearch节点的列表。Graylog需要知道elasticsearch_hosts设置中给出的至少一个其他Elasticsearch节点的地址。指定的值至少应包含此节点的方案（http://对于未加密https://的加密连接），主机名或IP以及HTTP侦听器的端口（9200除非另有配置）。（可选）如果您的Elasticsearch节点使用Shield / X-Pack或Search Guard，您还可以指定包含用户名和密码的身份验证部分，或者您有一个中间HTTP代理，需要在Graylog服务器和Elasticsearch节点之间进行身份验证。此外，您可以在URI的末尾指定可选的路径前缀。

示例规范elasticsearch_hosts可能如下所示：
```
elasticsearch_hosts = http://es-node-1.example.org:9200/foo,https://someuser:somepassword@es-node-2.example.org:19200
```
警告: Graylog假定集群中的所有节点都运行相同版本的Elasticsearch。虽然它可能在补丁级别不同时起作用，但我们强烈建议保持版本一致。

警告:Graylog不再对外部触发的索引更改（创建/关闭/重新打开/删除索引）做出反应。所有这些操作都需要通过Graylog REST API执行，以保持索引一致性。

### Available Elasticsearch configuration tunables 可选配置

### Automatic node discovery 自动节点发现
警告: 如果正在使用自动节点发现，则无法使用Elasticsearch集群进行身份验证。

警告: 使用Amazon Elasticsearch Service时自动节点发现不起作用，因为Amazon会阻止某些Elasticsearch API端点。

Graylog使用自动节点发现在运行时收集集群中所有可用Elasticsearch节点的列表，并在它们之间分发请求以潜在地提高性能和可用性。要启用此功能，您需要设置elasticsearch_discovery_enabled为true。（可选）您可以定义一个过滤器，允许使用该设置选择性地包含/排除已发现的节点（详细说明如何在Elasticsearch文档中指定节点过滤器）elasticsearch_discovery_filter，或使用elasticsearch_discovery_frequency配置选项调整节点发现的频率。

## Configuration of Elasticsearch nodes 节点配置
### Control access to Elasticsearch ports 控制对Elasticsearch端口的访问
如果您没有使用Shield/X-Pack或Search Guard来验证对Elasticsearch节点的访问，请确保限制对Elasticsearch端口的访问（默认值：9200 / tcp和9300 / tcp）。否则，任何有权通过网络访问机器的人都可以读取数据。

### Open file limits
由于Elasticsearch必须同时打开大量文件，因此需要更高的打开文件限制，这是通常的操作系统默认允许的。将其设置为至少64000个打开的文件描述符。

当Elasticsearch集群中的节点具有过低的打开文件限制时，Graylog将在Web界面中显示通知。

阅读有关如何在相应的2.x / 5.x文档页面中提高打开文件限制的信息。

### Heap size 堆大小
强烈建议提高分配给Elasticsearch的堆内存的标准大小。只需将ES_HEAP_SIZE环境变量设置为例如24g分配24GB即可。我们建议将大约50％的可用系统内存用于Elasticsearch（在专用主机上运行时），为Elasticsearch使用的系统缓存留出足够的空间。但请注意不要超过32 GB！

### Merge throttling 合并限制
Elasticsearch限制Lucene段的合并以允许极快的搜索。但是，此限制具有非常保守的默认值，与Graylog一起使用时可能导致摄取速度变慢。您会看到消息日志在Elasticsearch节点上没有真正指示CPU或内存压力的情况下增长。它通常与Elasticsearch INFO日志消息一样：

now throttling indexing

在像SSD或SAN这样的快速IO上运行时，我们建议将indices.store.throttle.max_bytes_per_sec您 的值elasticsearch.yml增加到150MB：

indices.store.throttle.max_bytes_per_sec: 150mb
使用此设置，直到达到最佳性能。

### Tuning Elasticsearch 调整
Graylog已经为它管理的每个索引设置了特定的配置。这足以调整很多用例和设置。

有关Elasticsearch配置的更多详细信息，请参阅官方文档。

# Avoiding split-brain and shard shuffling 避免脑裂和碎片混合
## Split-brain events 脑裂事件
Elasticsearch牺牲了一致性以确保可用性和分区容错。其背后的原因是短期的不良行为比短期的不可用性问题少。换句话说，当群集中的Elasticsearch节点无法复制对数据的更改时，它们将继续为Graylog等应用程序提供服务。当节点能够复制其数据时，它们将尝试聚合副本并实现最终的一致性。

Elasticsearch通过选择主节点来解决前面的问题，主节点负责数据库操作，例如创建新索引，在群集节点周围移动分片等等。主节点与其他节点主动协调其操作，确保数据可以由非主节点汇聚。不允许非主节点的群集节点进行会破坏群集的更改。

在某些情况下，先前的机制可能会失败，从而导致裂脑事件。当Elasticsearch集群分为两个方面时，都认为它们是主服务器，因为主服务器独立地处理数据，数据一致性就会丢失。因此，节点将对相同的查询做出不同的响应。这被认为是灾难性事件，因为来自两个主人的数据无法自动重新加入，并且需要相当多的手动工作来纠正这种情况。
### Avoiding split-brain events 避免脑裂事件
Elasticsearch节点对谁是主人进行简单的多数投票。如果大多数人同意他们是主人，那么很可能是断绝的少数民族也得出结论，他们不能成为主人，一切都很好。这种机制要求至少3个节点可靠地工作，因为一个或两个节点不能形成多数。

必须手动配置选择主节点所需的最小主节点数量elasticsearch.yml
```
# At least NODES/2+1 on clusters with NODES > 2, where NODES is the number of master nodes in the cluster
discovery.zen.minimum_master_nodes: 2
```
配置值通常应为例如：

主节点	minimum_master_nodes	注释
1	1	 
2	1	使用2，另一个节点停止将阻止群集工作！
3	2	 
4	3	 
5	3	 
6	4	 

一些主节点可以是专用主节点，这意味着它们被配置为仅处理轻量级操作（集群管理）职责。他们不会处理或存储任何群集的数据。这些节点的功能类似于其他数据库产品上的所谓见证服务器，并且在专用见证站点上设置它们将大大降低Elasticsearch集群不稳定的可能性。

专用主节点具有以下配置elasticsearch.yml：
```
node.data: false
node.master: true
```
## Shard shuffling 分片重排
当群集状态发生更改时（例如，由于节点重新启动或可用性问题），Elasticsearch将自动开始重新平衡群集中的数据。群集的工作原理是确保分片和副本的数量符合群集配置。如果状态更改只是暂时的，则会出现问题。在群集中移动分片和副本需要大量资源，并且只应在必要时进行。

### Avoiding unnecessary shuffling 避免不必要的重排
Elasticsearch有几个配置选项，这些选项设计为在使用shard shuffling启动恢复过程之前允许短时间不可用。可以配置3种设置elasticsearch.yml：
```
# Recover only after the given number of nodes have joined the cluster. Can be seen as "minimum number of nodes to attempt recovery at all".
gateway.recover_after_nodes: 8
# Time to wait for additional nodes after recover_after_nodes is met.
gateway.recover_after_time: 5m
# Inform ElasticSearch how many nodes form a full cluster. If this number is met, start up immediately.
gateway.expected_nodes: 10
```
应设置配置选项，以便仅容许最小的节点不可用性。例如，服务器重启很常见，应该以托管方式完成。逻辑是，如果丢失了大部分集群，您可能应该开始重新调整分片和副本，而不会容忍这种情况。

# Custom index mappings 自定义索引映射
有时，不依赖于Elasticsearch的动态映射，而是为消息定义更严格的模式是有用的。

如果索引映射与要发送到Elasticsearch的实际消息冲突，则索引该消息将失败。

graylog本身是使用默认映射包括用了设置timestamp，message，full_message，和source索引的消息的字段：
```
$ curl -X GET 'http://localhost:9200/_template/graylog-internal?pretty'
{
  "graylog-internal" : {
    "order" : -2147483648,
    "template" : "graylog_*",
    "settings" : { },
    "mappings" : {
      "message" : {
        "_ttl" : {
          "enabled" : true
        },
        "_source" : {
          "enabled" : true
        },
        "dynamic_templates" : [ {
          "internal_fields" : {
            "mapping" : {
              "index" : "not_analyzed",
              "type" : "string"
            },
            "match" : "gl2_*"
          }
        }, {
          "store_generic" : {
            "mapping" : {
              "index" : "not_analyzed"
            },
            "match" : "*"
          }
        } ],
        "properties" : {
          "full_message" : {
            "analyzer" : "standard",
            "index" : "analyzed",
            "type" : "string"
          },
          "streams" : {
            "index" : "not_analyzed",
            "type" : "string"
          },
          "source" : {
            "analyzer" : "analyzer_keyword",
            "index" : "analyzed",
            "type" : "string"
          },
          "message" : {
            "analyzer" : "standard",
            "index" : "analyzed",
            "type" : "string"
          },
          "timestamp" : {
            "format" : "yyyy-MM-dd HH:mm:ss.SSS",
            "type" : "date"
          }
        }
      }
    },
    "aliases" : { }
  }
}
```
为了扩展Elasticsearch和Graylog的默认映射，您可以创建一个或多个自定义索引映射，并将它们作为索引模板添加到Elasticsearch。

假设我们的数据模式如下：

字段名称	字段类型	例
http_method	串	得到
http_response_code	长	200
ingest_time	日期	2016-06-13T15：00：51.927Z
took_ms	长	56
这将转换为Elasticsearch中的以下附加索引映射：
```
"mappings" : {
  "message" : {
    "properties" : {
      "http_method" : {
        "type" : "string",
        "index" : "not_analyzed"
      },
      "http_response_code" : {
        "type" : "long"
      },
      "ingest_time" : {
        "type" : "date",
        "format": "strict_date_time"
      },
      "took_ms" : {
        "type" : "long"
      }
    }
  }
}
```
ingest_time有关格式映射参数的Elasticsearch文档中描述了该字段的格式。另外，请确保检查有关Field数据类型的Elasticsearch文档。

为了在Graylog在Elasticsearch中创建新索引时应用其他索引映射，必须将其添加到索引模板中。Graylog默认模板（graylog-internal）具有最低优先级，并将由Elasticsearch与自定义索引模板合并。

警告: 如果无法合并默认索引映射和自定义索引映射（例如，由于字段数据类型冲突），Elasticsearch将抛出异常并且不会创建索引。所以对自定义索引映射要非常谨慎和保守！

## Creating a new index template
将自定义索引映射的以下索引模板保存到名为的文件中graylog-custom-mapping.json

```
{
  "template": "graylog_*",
  "mappings" : {
    "message" : {
      "properties" : {
        "http_method" : {
          "type" : "string",
          "index" : "not_analyzed"
        },
        "http_response_code" : {
          "type" : "long"
        },
        "ingest_time" : {
          "type" : "date",
          "format": "strict_date_time"
        },
        "took_ms" : {
          "type" : "long"
        }
      }
    }
  }
}
```
最后，使用以下命令将索引映射加载到Elasticsearch：
```
$ curl -X PUT -d @'graylog-custom-mapping.json' 'http://localhost:9200/_template/graylog-custom-mapping?pretty'
{
  "acknowledged" : true
}
```
从那时起创建的每个Elasticsearch索引都将具有由原始graylog-internal索引模板和新graylog-custom-mapping模板组成的索引映射：
```
$ curl -X GET 'http://localhost:9200/graylog_deflector/_mapping?pretty'
{
  "graylog_2" : {
    "mappings" : {
      "message" : {
        "_ttl" : {
          "enabled" : true
        },
        "dynamic_templates" : [ {
          "internal_fields" : {
            "mapping" : {
              "index" : "not_analyzed",
              "type" : "string"
            },
            "match" : "gl2_*"
          }
        }, {
          "store_generic" : {
            "mapping" : {
              "index" : "not_analyzed"
            },
            "match" : "*"
          }
        } ],
        "properties" : {
          "full_message" : {
            "type" : "string",
            "analyzer" : "standard"
          },
          "http_method" : {
            "type" : "string",
            "index" : "not_analyzed"
          },
          "http_response_code" : {
            "type" : "long"
          },
          "ingest_time" : {
            "type" : "date",
            "format" : "strict_date_time"
          },
          "message" : {
            "type" : "string",
            "analyzer" : "standard"
          },
          "source" : {
            "type" : "string",
            "analyzer" : "analyzer_keyword"
          },
          "streams" : {
            "type" : "string",
            "index" : "not_analyzed"
          },
          "timestamp" : {
            "type" : "date",
            "format" : "yyyy-MM-dd HH:mm:ss.SSS"
          },
          "took_ms" : {
            "type" : "long"
          }
        }
      }
    }
  }
}
```
注意: 使用不同的索引集时，每个索引集都可以有自己的映射。

## Deleting custom index templates
如果要从Elasticsearch中删除现有索引模板，只需DELETE向Elasticsearch 发出请求：
```
$ curl -X DELETE 'http://localhost:9200/_template/graylog-custom-mapping?pretty'
{
  "acknowledged" : true
}
```
删除索引模板后，新索引将只具有原始索引映射：
```
$ curl -X GET 'http://localhost:9200/graylog_deflector/_mapping?pretty'
{
  "graylog_3" : {
    "mappings" : {
      "message" : {
        "_ttl" : {
          "enabled" : true
        },
        "dynamic_templates" : [ {
          "internal_fields" : {
            "mapping" : {
              "index" : "not_analyzed",
              "type" : "string"
            },
            "match" : "gl2_*"
          }
        }, {
          "store_generic" : {
            "mapping" : {
              "index" : "not_analyzed"
            },
            "match" : "*"
          }
        } ],
        "properties" : {
          "full_message" : {
            "type" : "string",
            "analyzer" : "standard"
          },
          "message" : {
            "type" : "string",
            "analyzer" : "standard"
          },
          "source" : {
            "type" : "string",
            "analyzer" : "analyzer_keyword"
          },
          "streams" : {
            "type" : "string",
            "index" : "not_analyzed"
          },
          "timestamp" : {
            "type" : "date",
            "format" : "yyyy-MM-dd HH:mm:ss.SSS"
          }
        }
      }
    }
  }
}
```
注意: 模板中的设置和索引映射仅适用于新索引。添加，修改或删除索引模板后，必须手动旋转索引集的写入活动索引才能使更改生效。

## Rotate indices manually 手动切换索引
通过单击索引集的名称在Graylog Web界面的页面上选择所需的索引集，然后从“维护”下拉菜单中选择“旋转活动写入索引”。System / Indices

# Cluster Status explained 集群状态说明
Elasticsearch提供了群集运行状况的分类。

群集状态适用于不同级别：
- 碎片级别 - 请参阅下面的状态说明
- 索引级别 - 继承最差分片状态的状态
- 集群级别 - 继承最差索引状态的状态

这意味着即使其他索引/分片都没问题，如果单个索引或分片出现问题，Elasticsearch集群状态也会变为红色。

注意：Graylog在索引消息时检查当前写入索引的状态。如果那个是绿色或黄色，Graylog将继续将消息写入Elasticsearch，而不管整个群集状态如何。

不同状态级别的说明：
## RED
RED状态表示部分或全部主分片不可用。

在此状态下，在恢复所有主分片之前，不能执行任何搜索。
## YELLOW
黄色状态表示所有主分片都可用，但部分或全部分片副本不可用。

如果只有一个Elasticsearch节点，则群集状态不能变为绿色，因为无法分配分片副本。

在大多数情况下，这可以通过向集群添加另一个Elasticsearch节点或通过减少索引的复制因子来解决（但这意味着对节点中断的弹性较小）。
## GREEN
群集完全可以运行。所有主分片和副本分片都可用。
