# User Guide 用户指南
## Introduction 介绍
### Contents
### Platform support 平台支持

  我们不断测试Ubuntu 14.04（Trusty）和Debian 8（Jessie）。其他Linux发行版也应该可以工作。
### Database support 数据库支持

  Vitess支持MySQL 5.6， MariaDB 10.0以及MySQL 5.7等新版本.Vitess还支持Percona对这些版本的变体。

#### Relational capabilities 关系能力

    Vitess试图充分利用底层MySQL实例的功能。在这方面，任何可以传递给单个keyspaces，shard或shards的查询将按原样发送到MySQL服务器。

    只要关系和约束位于一个shard（or unsharded keyspace）内，这种方法就可以利用MySQL的全部功能。

    对于超越shards关系，Vitess提供通过支持VSchema。

#### Schema management 模式管理

    Vitess支持多种功能，用于查看您的架构并验证同一个shard中的tablet或keyspaces中的所有shards之间的一致性。

    另外，Vitess支持create, modify, or delete database tables的数据定义语句。Vitess在每个shard中的master tablet上执行模式更改，然后这些更改通过复制传播到slave tablets。Vitess不支持其他类型的DDL语句，例如影响存储过程或授权的DDL语句。

    在执行模式更改之前，Vitess将验证SQL语法并确定更改的影响。它还会进行运行前检查以确保可以将更新应用于您的模式。此外，为了避免降低整个系统的可用性，Vitess拒绝超出特定范围的更改。

    有关 更多信息，请参阅本指南的“ 架构管理”部分。

### Supported clients 支持的客户端

  VTGate服务器是应用程序用于连接Vitess的主要入口点。

  VTGate了解MySQL二进制协议。因此，任何可以直接与MySQL交谈的客户端也可以使用Vitess。

  另外，VTGate通过支持多种语言的gRPC API 公开其功能 。

  通过gRPC访问Vitess比MySQL协议有一些小优点：
  - 您可以使用绑定变量发送请求，这比构建全文查询稍有效率和安全。
  - 你可以利用连接的无状态。例如，您可以使用一台VTGate服务器启动事务，然后使用另一台VTGate服务器完成事务。

  Vitess目前为Java（JDBC）和Go（数据库/ sql）提供基于gRPC的连接器。所有其他人都可以使用本地MySQL驱动程序。Java和Go的本地MySQL驱动程序也应该可以工作。

### Backups

  Vitess支持将数据备份到网络挂载（例如NFS）或BLOB存储。备份存储通过可插拔界面实现，目前我们有Google Cloud Storage，Amazon S3和Ceph可用的插件。

  有关使用Vitess创建和恢复数据备份的更多信息，请参阅本指南的备份数据部分。
