> [配置](https://www.elastic.co/guide/en/elasticsearch/reference/5.6/settings.html)

Elasticsearch提供了很好的默认配置，并且只需要很少的配置。使用集群更新设置API可以在运行的集群上更改大多数设置。

配置文件应包含特定于节点的设置，例如：node.name和path,或者node为了能够加入集群而需要的设置，例如：cluster.name和network.host

# Config file location 配置文件位置
- elasticsearch.yml 主配置
- log4j2.properties 配置日志记录

这些文件位于config目录中，默认为$ES_HOME/config/。Debian和RPM将config目录位置设置为/etc/elasticsearch/

config目录位置可以通过path.conf配置，如下所示：
```
./bin/elasticsearch -Epath.conf=/path/to/my/config/
```

# Config file format 配置文件格式
配置文件格式yaml，更改数据和日志目录路径的示例：
```
path:
    data: /var/lib/elasticsearch
    logs: /var/log/elasticsearch
```
或者如下格式
```
path.data: /var/lib/elasticsearch
path.logs: /var/log/elasticsearch
```

# Environment variable substitution 环境变量替换
使用${}配置文件中的符号引用的环境变量将替换为环境变量的值，例如：
```
node.name：$ {HOSTNAME}
network.host：$ {ES_NETWORK_HOST}
```
# Prompting for settings 提示设置
对于不希望存储在配置文件中的设置，可以使用该值${prompt.text}或${prompt.secret}在前台启动Elasticsearch。${prompt.secret}已禁用回显，以便输入的值不会显示在您的终端中; ${prompt.text}将允许您在输入时查看该值。例如：
```
node:
  name: ${prompt.text}
```
When starting Elasticsearch, you will be prompted to enter the actual value like so:
```
Enter value for [node.name]:
```
# Logging configuration 记录配置

# Configuring logging levels 配置日志级别
# Deprecation logging 弃用记录
