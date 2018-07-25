# Download and build 下载和构建
## Page Contents 本文内容
## System requirements 系统要求
etcd性能基准测试在8个vCPU，16GB RAM，50GB SSD GCE实例上运行etcd，但任何相对较新的低延迟存储和几GB内存的机器都可满足大多数使用情况。由于数据保存在匿名内存中，而不是从文件映射到内存，所以具有大型v2​​数据存储的应用程序所需的内存将比大型v3数据存储所需的内存多。为了在云提供商上运行etcd，我们建议在AWS上至少使用一个中型实例，或在GCE上使用标准1实例。

## Download the pre-built binary 下载预编译二进制包
获取etcd的最简单方法是使用可用于OSX，Linux，Windows，appc和Docker的预构建版本二进制文件之一。使用这些二进制文件的说明位于[GitHub发布页面](https://github.com/coreos/etcd/releases/)上。

## Build the latest version 构建最新版本
对于那些想要尝试最新版本的人，请从master分支构建etcd 。开发版本1.8+是构建最新版本的etcd所必需的。为了确保etcd是针对经过良好测试的库而构建的，etcd供应商正式发布二进制文件的依赖关系。但是，etcd的vendoring也是可选的，以避免在嵌入etcd服务器或使用etcd客户端时潜在的导入冲突。

在没有使用官方脚本的情况下etcd从master分支构建：GOPATHbuild
``` bash
$ git clone https://github.com/coreos/etcd.git
$ cd etcd
$ ./build
$ ./bin/etcd
```
通过以下途径etcd从master分店建立一个售货机go get：
``` bash
# GOPATH should be set
$ echo $GOPATH
/Users/example/go
$ go get github.com/coreos/etcd/cmd/etcd
$ $GOPATH/bin/etcd
```
etcd从master没有出售的分支构建（可能由于上游冲突而无法构建）：
``` bash
# GOPATH should be set
$ echo $GOPATH
/Users/example/go
$ go get github.com/coreos/etcd
$ $GOPATH/bin/etcd
```

## Test the installation 测试安装
通过启动etcd并设置密钥来检查etcd二进制文件是否正确构建。

启动etcd：
``` bash
$ ./bin/etcd
```
设置密钥：
``` bash
$ ETCDCTL_API=3 ./bin/etcdctl put foo bar
OK
```
如果确定被打印，那么etcd正在工作！
