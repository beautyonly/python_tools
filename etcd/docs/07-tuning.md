# Operating etcd clusters 运行etcd集群
## System configuration 系统配置
### Tuning 调整优化
#### Page Contents
etcd中的默认设置应适用于平均网络延迟较低的本地网络上的安装。但是，在多个数据中心或高延迟网络上使用etcd时，心跳间隔和选举超时设置可能需要调整。

网络不是延迟的唯一来源。每个请求和响应可能会受到领导者和追随者上的慢速磁盘的影响。这些超时中的每一个都表示从其他计算机的请求到成功响应的总时间。

#### Time parameters 时间参数
#### Snapshots 快照
#### Disk 磁盘
#### Network 网络
### Performance benchmarking 性能基准测试
