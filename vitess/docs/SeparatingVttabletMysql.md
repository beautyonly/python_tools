# SeparatingVttabletMysql 分离Vttablet和MySQL
本节探讨VTTablet和MySQL不在同一台服务器上或同一容器中运行的设置。这在使用托管MySQL服务器（例如：CloudSQL or RDS）时最为有用。

在这种情况下，Vitess不对任何master管理和备份负责，模式交换也是不可能的，因为它依赖于备份/恢复。

注意:本节是一项正在进行的工作，旨在集中关于此主题的所有调查结果。最后，我们希望有一个端到端的测试来证明这个设置可行，可能在使用CloudSQL的Kubernetes/GCE上。

# VTTablet Configuration   VTTablet 配置
需要对VTTablet命令行参数进行如下调整：
- 不指定-mycnf-file，相对的指定-mycnf_server_id参数
- 不要使用-mycnf_socket_file参数，没有本地MySQL unix socket file
- 使用-db-config-XXX-host and -db-config-XXX-port指定MySQL守护进程的host and port，不要指定-db-config-XXX-unixsocket参数
- 禁用还原和备份功能，通过不传递相关参数，即：-restore_from_backup and -backup_storage_implementation shoud not be set.

由于master管理和复制不由Vitess处理，因此我们只需要确保在运行VTTablet之前，the topology中the tablet type是正确的。通常，VTTablet可以用-init_tablet_type replica启动，即使对于master也是如此（作为master不被允许），并且将找出master并将其类型设置为master。当Vitess根本无法管理它时，运行vtctl InitShardMaster是不可能的，所以没有办法像使用vttablet的master一样启动。有两种解决方案：
- 首先使用-init_tablet_type replica启动master服务器，然后运行vtctl TabletExternallyReparented <tablet alias>激活
- 为master运行vtctl InitTablet ... master，然后使用-init... 参数运行vttablet.

# Other Configurations 其他配置
vtctl 和 vtctld可以使用-disable_active_reparents flag。这将使所有明确的重新命令无法访问（InitShardMaster or PlannedReparentShard）

vtgate和vtworker不需要任何特殊配置

# Runtime Differences 运行时差异
使用TCP连接到MySQL时会有一些细微差距，而不是使用unix套接字连接。主要的一点是当服务器关闭连接时，客户端在unix套接字上写入时会知道它，但只有在读取来自TCP套接字的响应时才会意识到。因此，使用TCP，很难区分在关闭连接上发送的查询中死亡的查询。这很重要，因为我们不想重试一个已经被杀死的查询，但我们希望重试在关闭的连接上发送的查询。

如果这成为一个问题，我们可以找到解决办法
# Resharding 重新分片
鉴于Vitess不能控制主管理服务器和复制，仍然有可能重新重新分片，以下功能是必需的：
- 能够在一个slave上启动或者关闭复制，所以我们可以在复制或者比较数据的同时保持一个特定的状态
- 有权限访问当前的复制位置，如MariaDB GTID or MySQL 5.6 GTIDSet.
- 能够作为复制从站连接到MySQL，并从任意过去的GTID开始，以支持过滤的复制

注意：在某些设置中，shard的主设备永远不会移动，并且通过永久驱动器可以使其持久。在这种情况下，可以使用文件名、文件位置来替代使用Vitess代码，过滤后的复制将始终需要领导到源shard的master，让我们知道你是否处于这种情况下，实施起来并不是很多工作。
