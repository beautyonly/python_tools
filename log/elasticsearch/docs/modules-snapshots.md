> [快照和恢复](https://www.elastic.co/guide/en/elasticsearch/reference/5.6/modules-snapshots.html)

快照和还原模块允许创建单个索引或者整个机器的快照到远程存储库，如共享文件系统、s3或者hdfs。这些快照对于备份非常有用，因为它们可以相对快速地进行恢复，但它们不存档，因为它们只能恢复到可以读取索引的Elasticsearch版本。

# Repositories 存储库
在执行快照或恢复操作之前，应该在Elasticsearch中注册快照库。存储库设置是特定于存储库类型的，请参考下文：
```
PUT /_snapshot/my_backup
{
  "type": "fs",
  "settings": {
        ... repository specific settings ...
  }
}

curl -X GET "localhost:9200/_snapshot/my_backup"
```
有关多个存储库的信息可以通过使用以逗号分隔的存储库名称列表一次性提取。也支持*通配符。例如
```
GET /_snapshot/repo*,*backup*
```

不指定存储库名称，或_all将返回当前集群中注册的所有相关存储库信息
```
GET /_snapshot
or
GET /_snapshot/_all
```

**共享文件系统存储库**

共享文件系统存储库使用共享文件系统来存储快照。为了注册共享文件系统库，有必要将相关的共享文件系统安装到所有主节点和数据节点上的相同位置。该位置必须path.repo在所有主节点和数据节点上的设置中注册。

假设共享文件系统已经安装到/mount/backups/my_backup，则应将以下设置添加到elasticsearch.yml文件中
```
path.repo: ["/mount/backups", "/mount/longterm_backups"]
```
path.repo只要服务器名称和共享被指定为前缀并且反斜杠正确转义，这样设置就支持Microsoft Window UNC路径
```
path.repo: ["\\\\MY_SERVER\\Snapshots"]
```

在所有节点重新启动后，可以使用以下命令以名称注册共享文件系统存储库my_backup
```
$ curl -XPUT 'http://localhost:9200/_snapshot/my_backup' -H 'Content-Type: application/json' -d '{
    "type": "fs",
    "settings": {
        "location": "/mount/backups/my_backup",
        "compress": true
    }
}'
```

如果存储库位置被指定为相对路径，则将根据以下路径中指定的第一个路径解析该路径path.repo
```
$ curl -XPUT 'http://localhost:9200/_snapshot/my_backup' -H 'Content-Type: application/json' -d '{
    "type": "fs",
    "settings": {
        "location": "my_backup",
        "compress": true
    }
}'
```
location: 快照位置
compress: 打开快照文件的压缩，压缩仅适用于元数据文件。数据文件不压缩，默认为true
chunk_size: 如果需要，可以在快照过程中将大文件分解为块
max_restore_bytes_per_sec：每个节点恢复率
max_snapshot_bytes_per_sec：每节点快照率
readonly：是存储库制度，默认为false

**只读URL存储库**

# Snapshot 快照
# Restore 还原
# Snapshot status 快照状态
# Monitoring snapshot/restore progress 监控快照/恢复进度
# Stopping currently running snapshot and restore operations 中断当前正在运行的快照和恢复操作
# Effect of cluster blocks on snapshot and restore operations 集群块对快照和恢复操作的影响
