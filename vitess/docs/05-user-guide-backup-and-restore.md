## Backing Up Data  备份数据
### Contents 内容
  本文档介绍如何使用Vitess创建和恢复数据备份。Vitess使用备份有两个目的：
  - 提供数据的时间点备份 一个tablet的data
  - 在存在的shard下初始化一个新tablets

### Prerequisites 先决条件

Vitess将数据备份存储在备份存储服务上，这是一个可插拔的接口。

目前，我们支持如下插件：
  - A network-mounted path (e.g. NFS)
  - Google Cloud Storage
  - Amazon S3
  - Ceph

在备份和恢复tablet之前，你需要确保tablet知道您正在使用的备份存储系统。为此，请在启动tablet时设置可访问存储备份位置的vttablet时使用以下命令行标识。

> 略

#### Authentication 认证

请注意：对于Google Cloud Storage插件，我们目前仅支持 应用程序默认凭证。这意味着，由于您已经在Google Compute Engine或Container Engine中运行，因此可以自动授予对云存储的访问权限。

为此，必须使用授予对云存储的读写访问权的范围创建GCE实例。使用Container Engine时，您可以通过添加--scopes storage-rw到gcloud container clusters create命令中来 创建它创建的所有实例，如Kubernetes指南上的Vitess所示。

### Creating a backup 创建备份
运行以下vtctl命令创建备份：
> vtctl Backup <tablet-alias>

执行如下操作：

  - 1、将其类型切换为BACKUP,完成此步骤后，tablet将不再由vtgate提供任何查询
  - 2、停止复制，获取当前复制位置(与数据一起保存在备份中)
  - 3、关闭其mysqld进程
  - 4、将必要的文件复制到tablet启动时指定的备份存储设备。请注意，如果此操作失败，我们仍会继续操作，所以tablet不会因为存储故障而处于不稳定的状态
  - 5、重新启动mysqld
  - 6、将其切换回原来的类型。在此之后，它很可能会落后于复制，并且不会被vtgate用于服务，直到数据同步完成。

### Restoring a backup 恢复备份
当一个tablet启动时，Vitess会检查-restore_from_backup命令行标志的值，以确定是否将备份还原到该tablet.
  - 如果标志存在，Vitess尝试在启动tablet时从备份系统恢复最新的备份
  - 如果标志不存在，Vitess不会尝试将备份恢复到tablet，这相当于在新的shard中启动新的tablet

正如前提条件部分所述，该标志通常在shard中的所有tablets上始终处于启用状态。如果Vitess在备份存储系统中找不到备份，它就会将vttablet作为新的tablet启动。
``` bash
vttablet ... -backup_storage_implementation=file \
             -file_backup_storage_root=/nfs/XXX \
             -restore_from_backup
```
### Managing backups 管理备份
vtctl提供两个用于管理备份的命令：

- listbackups按照时间顺序显示现有备份
> vtctl ListBackups <keyspace/shard>

- removebackup删除指定备份
> RemoveBackup <keyspace/shard> <backup name>

### Bootstrapping a new tablet 初始化新tablet
初始化新tablet与恢复现有tablet几乎完全相同。唯一需要注意的tablet在拓扑中注册自己时指定了它的keyspace，shard和tablet type。具体而言，确保设置了以下vttablet参数：
``` bash
-init_keyspace <keyspace>
-init_shard <shard>
-init_tablet_type replica|rdonly
 ```
自动tablet将从备份中恢复数据，然后通过重新启动复制来应用备份后发生的更改。

### Backup Frequency 备份频率
我们建议定期备份，例如你应该为它设置一个cron job。

要确定创建备份的正确频率，请考虑保留复制日志的时间量，并在备份操作失败的情况下留出足够的时间来调查和解决问题。

例如，假设您通常保留四天的复制日志，并创建每日备份。在这种情况下，即使备份失败，您至少需要等待几天时间才能调查并解决问题。
### Concurrency 并发
备份和恢复过程同时复制并压缩或解压缩多个文件以提高吞吐量。您可以使用命令行标志控制并发性：

- vtctl Backup命令使用该 -concurrency标志。
- vttablet使用该-restore_concurrency标志。

如果网络链接足够快，则并发性与备份或还原过程中进程的CPU使用率相匹配。
