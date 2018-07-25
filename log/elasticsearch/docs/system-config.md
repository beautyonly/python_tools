> 重要的系统配置 https://www.elastic.co/guide/en/elasticsearch/reference/5.6/system-config.html

理想情况下，Elasticsearch应该在服务器上单独运行并使用它可用的所有资源。为此，您需要配置操作系统以允许运行Elasticsearch的用户访问比默认允许的资源更多的资源。

在投入生产之前，必须解决以下设置：
# Configuring system settings 配置系统设置
> https://www.elastic.co/guide/en/elasticsearch/reference/5.6/setting-system-settings.html


# Set JVM heap size via jvm.options 通过jvm.options设置JVM堆大小
默认情况下，Elasticsearch告诉JVM使用最小和最大大小为2GB的堆。迁移到生产环境时，配置堆大小以确保Elasticsearch有足够的堆可用是很重要的。

Elasticsearch将 通过Xms（最小堆大小）和Xmx（最大堆大小）设置分配jvm.options中指定的整个堆。

这些设置的值取决于服务器上可用的RAM量。好的经验法则是：
- 最小堆大小和最大堆大小设置彼此相等
- Elasticsearch可用的堆越多，它可用于缓存的内存就越多。但请注意，过多的堆可能会使您陷入长时间的垃圾收集暂停。
- 将Xmx设置为不超过物理RAM的50％，以确保有足够的物理RAM用于内核文件系统缓存。
-
# Disable swapping 禁用交换
大多数操作系统尝试尽可能多地使用文件系统缓存的内存，并急切地交换未使用的应用程序内存。这可能导致部分JVM堆甚至其可执行页面被换出到磁盘。

交换对性能，节点稳定性非常不利，应该不惜一切代价避免。它可能导致垃圾收集持续数分钟而不是毫秒，并且可能导致节点响应缓慢甚至断开与群集的连接。在弹性分布式系统中，让操作系统终止节点更有效。

有三种方法可以禁用交换。首选选项是完全禁用交换。如果这不是一个选项，是否更喜欢最小化swappiness与内存锁定取决于您的环境。

## Disable all swap files 禁用所有交换文件
通常Elasticsearch是在服务器上运行的唯一服务，其内存使用量由JVM选项控制。应该不需要启用交换。在linux系统上，可以通过运行以下命令临时禁用交换
```
swapoff -a
```
要永久禁用它，需要编辑/etc/fstab文件并注释掉包含swap的任何行。
window配置方法略
## Configure swappiness 配置
使用sysctl值vm.swappiness设置为1。这降低了内核交换的倾向，在正常情况下不应导致交换，同时仍允许整个系统在紧急情况下交换。
## Enable bootstrap.memory_lock

# File Descriptors 文件描述符
> https://www.elastic.co/guide/en/elasticsearch/reference/5.6/file-descriptors.html

lasticsearch使用大量文件描述符或文件句柄。用完文件描述符可能是灾难性的，最有可能导致数据丢失。确保将运行Elasticsearch的用户的打开文件描述符数量限制增加到65,536或更高。
```
# curl -X GET "localhost:9200/_nodes/stats/process?filter_path=**.max_file_descriptors"
{"nodes":{"bx9CsUesQNS-LihZdGiv5w":{"process":{"max_file_descriptors":65536}},"MZNYd2gtST-naJ0FVjzG4Q":{"process":{"max_file_descriptors":65536}}}}
```
# Virtual memory 虚拟内存
# Number of threads 线程数
# DNS cache settings DNS缓存设置

**开发模式与生产模式**
默认情况下，Elasticsearch假定您正在开发模式下工作。如果未正确配置上述任何设置，则会向日志文件写入警告，但您将能够启动并运行Elasticsearch节点。

一旦配置了类似的网络设置network.host，Elasticsearch就会假定您正在转向生产并将上述警告升级为异常。这些异常将阻止您的Elasticsearch节点启动。这是一项重要的安全措施，可确保您不会因服务器配置错误而丢失数据。
