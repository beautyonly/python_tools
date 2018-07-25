
## Launching  发射
### Scalability Philosophy  可扩展性哲学
#### Contents 内容
可用多种方法解决可伸缩性的问题。本文档描述了Vitess解决这些问题的方法。

#### Small instances 小实例
当决定将数据库分割或分割成更小的部分时，很容易将它们分解成适合一台机器的分支。在行业中，每个主机只运行一个MySQL实例是很常见的。

Vitess建议将实例分解为更小，并且不要回避每台主机运行多个实例。净资源使用率将大致相同。但是当MySQL实例很小时，可管理性大大提高。跟踪端口和分离MySQL实例的路径是复杂的。然而，一旦跨越这个障碍，一切都变得更简单。

需要担心的锁竞争更少，复制更加快乐，中断的生产影响变小，备份和恢复速度更快，并且可以实现更多的次要优势。例如，您可以对实例进行洗牌以获得更好的机器或机架多样性，从而减少停机时对生产的影响，并提高资源使用率。

##### Cloud Vs Baremetal
尽管Vitess设计为在云中运行，但它完全可以在裸机配置上运行，而且许多用户仍然可以。如果部署在云中，服务器和端口的分配将从管理员处抽象出来。在裸机上，操作员仍然有这些责任。

我们提供了示例配置，以帮助您开始使用Kubernetes， 因为它与Borg（ Vitess现在在YouTube上运行的Kubernetes的前身）最为相似。如果您更熟悉Mesos，Swarm，Nomad或DC / OS等替代方案，我们欢迎您为Vitess提供示例配置。

这些编排系统通常使用容器 来隔离小型实例，以便它们可以高效地打包到机器上，而无需争用端口，路径或计算资源。然后一个自动调度程序完成混洗实例的工作，以实现故障恢复和最佳利用率。

#### Durability through replication 通过复制实现持久性
传统的数据存储软件在将数据刷新到磁盘后立即处理数据。但是，这种方法在当今商品硬件世界中是不切实际的。这种方法也不能解决灾难情况。

通过将数据复制到多台机器甚至是地理位置来实现耐久性的新方法。这种耐用性解决了设备故障和灾难的现代问题。

Vitess中的许多工作流程都是以这种方法为基础构建的。例如，强烈建议打开半同步复制。这允许Vitess在主站关闭时故障切换到新副本，而不会丢失数据。Vitess还建议您避免恢复崩溃的数据库。相反，请从最近的备份中创建一个新的备份并让它跟上。

依靠复制还可以让你放松一些基于磁盘的耐久性设置。例如，您可以关闭sync_binlog，这可以大大减少磁盘IOPS的数量，从而提高有效吞吐量。

#### Consistency model 一致性模型

##### No multi-master
##### Big data queries 大数据查询
- Batch queries 批量查询
- MapReduce

#### Multi-cell
#### Lock server
#### Monitoring 监控
运行生产系统中最有压力的部分是人们试图排查持续中断的情况。您必须能够快速找到根本原因并找到正确的补救措施。这是监控变得至关重要的一个领域，Vitess已经过了战斗测试。Vitess通过/ debug / vars和其他URL连续导出大量内部状态变量和计数器。还有一些工作正在与第三方监测工具如Prometheus进行整合。

Vitess在过度报告方面犯了错误，但你可以挑剔你想要监控哪些变量。这是重要的，并建议绘制这些数据的图表，因为很容易发现变化的时间和幅度。设置各种基于阈值的警报也非常重要，这些警报可用于主动防止中断。

#### Development workflow 开发流程
Vitess提供二进制文件和脚本，使应用程序代码的单元测试非常简单。有了这些工具，我们建议尽可能对所有应用程序功能进行单元测试。

Vitess集群的生产环境涉及拓扑服务，多个数据库实例，vtgate池和至少一个vtctld进程，可能位于多个数据中心。vttest库使用vtcombo二进制将所有Vitess进程合并为一个。各种数据库也组合成一个MySQL实例（每个分片使用不同的数据库名称）。数据库模式在启动时被初始化。（可选）VSchema也在启动时初始化。

有几件事需要考虑：

- 在测试中使用与生产模式相同的数据库模式。
- 在测试中使用与生产VSchema相同的VSchema。
- 当生产密钥空间分片时，也使用分片测试密钥空间。只需两个碎片就足够了，以尽量缩短测试启动时间，同时仍然重新生产生产环境。
- vtcombo也可以启动vtctld组件，所以测试环境在Vitess UI中可见。
- 有关 更多信息，请参见 vttest.proto。

#### Application query patterns 查询支持

##### Commands specific to single MySQL instances 特定于单个MySQL实例的命令
##### Connecting to Vitess 连接到Vitess
##### Query support 查询支持

### Production Planning 计划生产
#### Contents 内容
#### Provisioning 评估总资源

##### Estimating total resources 评估总资源
尽管Vitess可以帮助您无限扩展，但各个层面都会消耗CPU和内存。目前，Vitess服务器的成本主要受我们使用的RPC框架支配：gRPC（gRPC是一个相对年轻的产品）。因此，随着时间的推移，Vitess服务器将会更加高效，因为gRPC以及Go运行时都有所改进。目前，您可以使用以下经验法则为Vitess预算资源：

每个为服务通信提供服务的MySQL实例都需要一个VTTablet，这反过来又会消耗相同数量的CPU。所以，如果MySQL消耗8个CPU，VTTablet可能会消耗8个CPU。

VTTablet消耗的内存取决于QPS和结果大小，但您可以从请求1 GB/CPU的经验法则开始。

至于VTGate，请将您分配给VTTablet的CPU总数加倍。这应该大约VTGates预计消耗多少。在内存方面，您应该再次预算约1 GB / CPU（需要验证）。

Vitess服务器将为他们的日志使用磁盘空间。平稳运行的服务器应该创建很少的日志垃圾邮件。但是，如果错误太多，日志文件可能会非常快速地增长。如果您担心磁盘已满，运行日志清除守护进程将是明智之举。

Vitess服务器也可能会增加每个MySQL调用的往返延迟大约2 ms。这可能会导致一些可能或可能不会忽略的隐藏成本。在应用方面，如果花费大量时间进行数据库调用，则可能需要运行其他线程或工作人员来补偿延迟，这可能会导致额外的内存需求。

客户端驱动程序的CPU使用情况可能与普通的MySQL驱动程序不同。这可能需要您为每个应用程序线程分配更多的CPU。

在服务器端，这可能会导致更长的运行事务，这可能会影响MySQL。

以上述数字为出发点，下​​一步将是建立产生生产代表性负荷的基准。如果你买不起这种奢侈品，你可能不得不进行一些超量配置的生产，以防万一。
##### Mapping topology to hardware 将拓扑映射到硬件
不同的Vitess组件具有不同的资源需求，例如与vttablet相比，vtgate只需要很少的磁盘。因此，组件应映射到不同的机器类别以获得最佳资源使用情况。如果您使用的是集群管理器（如Kubernetes），则自动调度程序将为您执行此操作。否则，您必须分配物理机器并计划如何将服务器映射到它们。

需要的机器类型：
- MySQL + vttablet

  You’ll need database-class machines that are likely to have SSDs, and enough RAM to fit the MySQL working set in buffer cache. Make sure that there will be sufficient CPU left for VTTablet to run on them.

  The VTTablet provisioning will be dictated by the MySQL instances they run against. However, soon after launch, it’s recommended to shard these instances to a data size of 100-300 GB. This should also typically reduce the per-MySQL CPU usage to around 2-4 CPUS depending on the load pattern.

- VTGate

  For VTGates, you’ll need a class of machines that would be CPU heavy, but may be light on memory usage, and should require normal hard disks, for binary and logs only.

  It’s advisable to run more instances than there are machines. VTGates are happiest when they’re consuming between 2-4 CPUs. So, if your total requirement was 400 CPUs, and your VTGate class machine has 48 cores each, you’ll need about 10 such machines and you’ll be running about 10 VTGates per box.

  You may have to add a few more app class machines to absorb any additional CPU and latency overheads.
#### Lock service setup 锁定服务器设置

#### Production testing 生产测试
Before running Vitess in production, please make yourself comfortable first with the different operations. We recommend to go through the following scenarios on a non-production system.

Here is a short list of all the basic workflows Vitess supports:

- Failover/Reparents 故障转移/恢复
- Backup/Restore 备份/恢复
- Schema Management / Schema Swap  架构管理/架构交换
- Resharding / Horizontal Resharding Tutorial 重新分片 / 水平分片教程
- Upgrading 升级user-guide/server-configurationuser-guide/server-configurationuser-guide
