> http://docs.graylog.org/en/2.4/pages/sending_data.html

如果没有任何数据，graylog设置就毫无价值。本节介绍了将数据导入系统的基本原理，并解释了常见的错误理解。

# What are Graylog message inputs? 什么是graylog消息输入
消息输入是负责接受日志消息的Graylog部分。它们是从System - > Inputs部分中的Web界面（或REST API）启动的，无需重新启动系统的任何部分即可启动和配置。

# Content packs 内容包
内容包是Graylog输入，提取器，流，仪表板和输出配置的捆绑包，可以提供对数据源的完全支持。默认情况下，某些内容包随Graylog一起提供，一些内容包可从网站获得。可以使用Graylog Web界面导入从Graylog Marketplace下载的内容包。

您可以从Graylog Web界面的System - > Content Packs部分加载甚至创建自己的内容包。

# Syslog 系统日志
## Sending syslog from Linux hosts(需要掌握)
## Sending syslog from MacOS X hosts
# GELF / Sending from applications(需要掌握)
Graylog扩展日志格式（GELF）是一种日志格式，可以避免经典普通系统日志的缺点，非常适合从应用程序层进行日志记录。它带有可选的压缩，分块，最重要的是一个明确定义的结构。有许多GELF库可用于许多框架和编程语言，可帮助您入门。

在规范中阅读有关GELF的更多信息。
## GELF via HTTP
```
http://graylog.example.org:[port]/gelf (POST)

curl -XPOST http://graylog.example.org:12202/gelf -p0 -d '{"short_message":"Hello there", "host":"example.org", "facility":"test", "_foo":"bar"}'
```
# Using Apache Kafka as transport queue
# Using RabbitMQ (AMQP) as transport queue
# Microsoft Windows
# Heroku
# Ruby on Rails
# Raw/Plaintext inputs
# JSON path from HTTP API input(需要掌握)
# Reading from files
