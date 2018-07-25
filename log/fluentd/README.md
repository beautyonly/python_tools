# OVERVIEW 概述
## What is Fluentd?
## Why use Fluentd?
## User Testimonials 用户推荐
## FAQs
### What is Fluentd?
Fluentd是用于构建统一日志记录层的开源数据收集器。一旦安装在服务器上，它将在后台运行，以收集，分析，转换，分析和存储各种类型的数据。
### What is Fluent Bit?
Fluent Bit是Fluentd的轻量级数据转发器。Fluent Bit专门用于将数据从边缘转发到Fluentd聚合器。

# PLUG-INS  插件
## List of Data Sources
[数据来源](https://www.fluentd.org/datasources)
## List of Data Outputs
[数据输出](https://www.fluentd.org/dataoutputs)
## List of All Plugins
[插件](https://www.fluentd.org/plugins)
# RESOURCES 资源
## Documentation (Fluentd)
[官网文档](https://docs.fluentd.org/v1.0/articles/quickstart)
## Documentation (Fluent Bit)
## Guides & Recipes
## Videos
## Slides
# COMMUNITY 社区
## Blog
## Contributing
## Community List
## Related Projects
## Stickers / T-Shirts / Parkas
## Events
## Newsletter
# DOWNLOAD 下载

```
wget http://packages.treasuredata.com.s3.amazonaws.com/3/redhat/7/x86_64/td-agent-3.2.0-0.el7.x86_64.rpm
yum install td-agent-3.2.0-0.el7.x86_64.rpm
/etc/td-agent/td-agent.conf
systemctl start td-agent
systemctl status td-agent
/opt/td-agent/embedded/bin/fluent-gem install fluent-plugin-input-gelf
/opt/td-agent/embedded/bin/fluent-gem install fluent-plugin-rewrite-tag-filter
/opt/td-agent/embedded/bin/fluent-gem install fluent-plugin-record-reformer
curl -X POST -d 'json={"json":"message"}' http://localhost:8888/debug.test
```
