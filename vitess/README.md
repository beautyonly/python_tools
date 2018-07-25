# Vitess知识总结
## Vitess概述
- 官网文档地址：https://vitess.io/overview/
- GitHub仓库地址：https://github.com/vitessio/vitess
- godoc地址：https://godoc.org/github.com/youtube/vitess

## 实践操作
- 初始化机器
  - https://raw.githubusercontent.com/mds1455975151/tools/master/shell/host_init.sh
  
- Go环境
  - https://raw.githubusercontent.com/mds1455975151/tools/master/go/go_install.sh
  
- MySQL环境
  - https://raw.githubusercontent.com/mds1455975151/tools/master/mysql/install_mysql.sh
  
- JDK安装
  - 
- 下载Vitess源码并编译
  - https://codeload.github.com/vitessio/vitess/tar.gz/v2.1.1

  - http://apache.org/dist/zookeeper/zookeeper-3.4.10/zookeeper-3.4.10.tar.gz

  - https://github.com/coreos/etcd/releases/download/v3.1.0-rc.1/etcd-v3.1.0-rc.1-linux-amd64.tar.gz

  - https://releases.hashicorp.com/consul/0.7.2/consul_0.7.2_linux_amd64.zip
  
## 客户端
- [PHP](https://github.com/pixelfederation/vitess-php-pdo)
- [Java]()
- [Python]()
- [Go]()

## 相关项目
- https://github.com/square/shift
- https://github.com/github/orchestrator

## 常见MySQL水平扩展架构
- [mysql-proxy](https://github.com/mysql/mysql-proxy)
- [mycat](https://github.com/MyCATApache/Mycat-Server)
- [cobar](https://github.com/alibaba/cobar)
- [Atlas](https://github.com/Qihoo360/Atlas)
- [58同城Oceanus](https://github.com/58code/Oceanus)
- **[YouTube开源vitess](https://github.com/vitessio/vitess)**
- TDDL
- [heisenberg](https://github.com/brucexx/heisenberg)
- [非开源OneProxy](https://github.com/mark-neil-wang/OneProxy)
- [dble](https://github.com/actiontech/dble)
- [网易cetus](https://github.com/Lede-Inc/cetus)

## FQA
- Vitess+RDS

  - https://github.com/vitessio/vitess/issues/2518
  
- 常用端口

``` text
- vtctld_web_port=15000(vtctld)
- grpc_port=15999(vtctld)

- uid_base=${UID_BASE:-'100'}         # 未指定则为100
- port_base=$[15000 + $uid_base]
- grpc_port_base=$[16000 + $uid_base](vttablet)
- mysql_port_base=$[17000 + $uid_base](vttablet+MySQL)

- web_port=15001(vtgate)
- grpc_port=15991(vtgate)
- mysql_server_port=15306(vtgate)
```
- 概念和MySQL概念映射

``` text
- cell -- MySQL实例
- shard -- MySQL集群
- keyspace -- 一个数据库
- vttablet -- MySQL实例
```
- 研究进度
```
- 1、本地部署的情况下部署的MySQL实例主要功能
- ~~2、local案例里里面 新建的db table(messages)看不到是啥原因 需要使用vitess提供命令查看~~
- ~~3、节点之前会利用GTID进行复制，看不到slave状态是啥情况  需要使用vitess提供命令查看~~
- 4、数据备份还原方案
- 5、shard unshard方案
- 6、Vitess不使用自建MySQL搭配云数据库如何实现(例如：与腾讯云数据库结合)
- ~~7、如何连接vtgate，有初始化sql，但是使用权限无法登陆 可以登录~~
- 8、本地部署
- 9、k8s docker部署
```

## 参考资料
- http://jixiuf.github.io/blog/go_vitess_start.html/
- https://github.com/jixiuf/vitess-build-patch
- http://www.cnblogs.com/davygeek/p/6433296.html
- [Intro.pdf](https://github.com/mds1455975151/tools/blob/master/vitess/official-web-docs/pdf/Vitess%20-%20Percona%20Live%202016.pdf)
