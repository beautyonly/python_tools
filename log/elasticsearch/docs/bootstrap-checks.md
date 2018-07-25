> [bootstrap检查](https://www.elastic.co/guide/en/elasticsearch/reference/5.6/bootstrap-checks.html)

总的来说，我们有许多用户遭遇意外问题的经验，因为他们没有配置重要的设置。在以前的Elasticsearch版本中，其中一些设置的配置错误被记录为警告。可以理解的是，用户有时会错过这些日志消息。为确保这些设置获得应有的关注，Elasticsearch在启动时进行引导检查。

这些引导检查检查各种Elasticsearch和系统设置，并将它们与Elasticsearch操作安全的值进行比较。如果Elasticsearch处于开发模式，那么失败的任何引导检查都将显示为Elasticsearch日志中的警告。如果Elasticsearch处于生产模式，任何失败的引导检查都会导致Elasticsearch拒绝启动。

有一些引导程序检查始终强制执行，以防止Elasticsearch在不兼容的设置下运行。这些检查单独记录。

# Development vs. production mode 开发与生产模式
默认情况下，Elasticsearch绑定到用于HTTP 和传输（内部）通信的环回地址。这对于下载和使用Elasticsearch以及日常开发很好，但对于生产系统来说没用。要加入群集，必须通过传输通信访问Elasticsearch节点。要通过非回送地址加入群集，节点必须将传输绑定到非回送地址，而不是使用单节点发现。因此，如果Elasticsearch节点无法通过非回送地址与另一台机器形成群集，并且处于生产模式（如果它可以通过非回送地址加入群集），那么我们认为Elasticsearch节点处于开发模式。

请注意，HTTP和传输可以通过http.host和独立配置 transport.host; 这对于配置单个节点可通过HTTP进行测试而不触发生产模式很有用。

# Single-node discovery 单节点发现
我们认识到有些用户需要绑定传输到外部接口来测试他们对传输客户端的使用情况。对于这种情况，我们提供发现类型single-node（通过设置discovery.type来 配置它single-node）; 在这种情况下，节点将自己选择主节点，并且不会与其他任何节点一起加入群集。

# Forcing the bootstrap checks 强制引导检查
如果您在生产环境中运行单个节点，则可以避开引导程序检查（通过不将绑定绑定到外部接口，或将绑定绑定到外部接口并将发现类型设置为 single-node）。对于这种情况，可以通过将系统属性设置es.enforce.bootstrap.checks为true （在设置JVM选项中设置此值，或者通过添加-Des.enforce.bootstrap.checks=true 到环境变量中ES_JAVA_OPTS）来强制执行引导程序检查。如果您处于这种特定情况，我们强烈建议您这样做。该系统属性可用于强制执行独立于节点配置的引导程序检查。

## Heap size check 堆大小检查
如果JVM以初始和最大堆大小不等的方式启动，则在系统使用过程中调整JVM堆的大小时，容易导致暂停。为了避免这些调整大小暂停，最好使用初始堆大小等于最大堆大小来启动JVM。此外，如果 bootstrap.memory_lock启用，JVM将在启动时锁定堆的初始大小。如果初始堆大小不等于最大堆大小，那么在调整大小后，将不会出现所有JVM堆都锁定在内存中的情况。要通过堆大小检查，您必须配置堆大小。

## File descriptor check
## Memory lock check
## Maximum number of threads check
## Maximum size virtual memory check
## Max file size check
## Maximum map count check
## Client JVM check
## Use serial collector check
## System call filter check
## OnError and OnOutOfMemoryError checks
## Early-access check
## G1GC check
