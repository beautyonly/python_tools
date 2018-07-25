# 概述
分片是一种在多台机器上分配数据的方法。MongoDB使用分片来支持具有非常大的数据集和高吞吐量操作的部署。

具有大量数据集或高吞吐量应用程序的数据库系统可能会挑战单个服务器的容量。例如，高查询率可能会耗尽服务器的CPU容量。大于系统内存的工作集大小会压缩磁盘驱动器的I / O容量。

有两种解决系统增长的方法：垂直和水平缩放。

垂直缩放涉及增加单个服务器的容量，例如使用更强大的CPU，增加更多RAM或增加存储空间量。可用技术的限制可能会限制单台机器对于给定的工作负载足够强大。此外，基于可用硬件配置的基于云的提供商具有坚硬的上限。因此，垂直缩放有一个实际的最大值。

横向扩展包括将系统数据集和负载分配到多个服务器上，添加额外的服务器以根据需要增加容量。尽管单台机器的整体速度或容量可能并不高，但每台机器可处理整个工作负载的一部分，可能比单台高速大容量服务器提供更高的效率。扩展部署的容量只需要根据需要添加额外的服务器，与单台机器的高端硬件相比，这可能会降低总体成本。这种折衷是增加了部署的基础设施和维护的复杂性。

MongoDB支持通过分片进行水平缩放。

# Sharded Cluster 分片集群

# Shard Keys 分片keys
# Chunks 块
# Advantages of Sharding sharding的优势
# Considerations Before Sharding 分片之前的注意事项
# Sharded and Non-Sharded Collections 分片和非分片集合
# Connecting to a Sharded Cluster 连接到分片集群
# Sharding Strategy 分片策略
# Zones in Sharded Clusters 分片集群中的区域
# Collations in Sharding 分片中的排序规则
# Additional Resources 其他资源
