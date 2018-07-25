> 保护Graylog http://docs.graylog.org/en/2.4/pages/securing.html

为了保护graylog设置，不应该使用我们的预配置镜像，创建您自己的独特安装，您可以在其中了解每个组件并通过设计保护环境。仅使用TLS/SSL和某些身份认证，公开所需的服务并尽可能保护它们。不要将预先创建的设备用于关键生产环境。

在graylog设备上，MongoDB和Elasticsearch正在监听外部端口。这使得集群的创建更容易，并演示了graylog的工作方式。永远不要在不安全的网络中运行它。

使用Amazon Web Services和我们预先配置的AMI时，请勿打开安全组中的所有端口。不要将服务器暴露在互联网上。仅从您的VPC中访问Graylog。为通信启用加密。

# Default ports 默认端口

# Configuring TLS ciphers
# Logging user activity 记录用户活动
## Configuring the Access Log 配置访问日志
## X-Forwarded-For HTTP header support
# Using ModSecurity
