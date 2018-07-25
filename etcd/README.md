# etcd总结
## etcd概述
- 官网地址：https://coreos.com/etcd/
- GitHub地址：https://github.com/coreos/etcd/
- 最新官网文档：https://coreos.com/etcd/docs/latest/v2/README.html
## etcd使用场景
和zk类似，etcd有很多应用场景，包括：
- 配置管理
- 服务注册与发现
- 选主
- 应用调度
- 分布式队列
- 分布式锁

## etcd安装部署
### 单机YUM安装
``` bash
wget https://raw.githubusercontent.com/mds1455975151/tools/master/etcd/install_etcd.sh
sh install_etcd.sh
```
### 多机器集群YUM部署安装
- 安装
  ``` bash
  git clone https://github.com/mds1455975151/tools.git
  vim tools/ansible/hosts.etcd  # 修改集群配置信息
  cd tools/ansible/playbook
  ansible-playbook -i ../hosts.etcd install_etcd.yml -l etcd
  ```
- 卸载
  ``` bash
  cd tools/ansible/playbook
  ansible-playbook -i ../hosts.etcd uninstall_etcd.yml -l etcd
  ```

### 单机集群YUM安装
略

### 验证
``` bash
# export ETCD_ENDPOINTS="http://192.168.200.100:2379,http://192.168.200.101:2379,http://192.168.200.102:2379"
# etcdctl --endpoints=${ETCD_ENDPOINTS} cluster-health
member 53a837086c146c is healthy: got healthy result from http://192.168.200.102:2379
member 1742246ade150219 is healthy: got healthy result from http://192.168.200.101:2379
member 96abf53cb727b756 is healthy: got healthy result from http://192.168.200.100:2379
cluster is healthy
# etcdctl --endpoints=${ETCD_ENDPOINTS} member list                                                                                     
53a837086c146c: name=etcd3 peerURLs=http://192.168.200.102:2380 clientURLs=http://192.168.200.102:2379,http://192.168.200.102:4001 isLeader=true
1742246ade150219: name=etcd2 peerURLs=http://192.168.200.101:2380 clientURLs=http://192.168.200.101:2379,http://192.168.200.101:4001 isLeader=false
96abf53cb727b756: name=etcd1 peerURLs=http://192.168.200.100:2380 clientURLs=http://192.168.200.100:2379,http://192.168.200.100:4001 isLeader=false
```
## 日常管理
### 管理工具etcdctl
``` bash
curl http://192.168.200.100:2379/v2/members
```
- 更新节点
- 新增节点
- 删除节点

### 节点迁移
在生产环境中，不可避免遇到机器硬件故障。当遇到硬件故障发生的时候，我们需要快速恢复节点。ETCD集群可以做到在不丢失数据的，并且不改变节点ID的情况下，迁移节点。
具体办法是：
- 停止待迁移节点上的etc进程；
- 将数据目录打包复制到新的节点；
- 更新该节点对应集群中peer url，让其指向新的节点；
- 使用相同的配置，在新的节点上启动etcd进程

### 备份还原
``` bash
https://raw.githubusercontent.com/mds1455975151/tools/master/etcd/etcd_backup.sh
```
### 监控报警
### 性能压测
## 参考资料
