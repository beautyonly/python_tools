# 操作系统相关问题
- [Linux基础](#)
  - [Linux系统入门](https://computefreely.org/)
  - [Linux教程](https://linuxjourney.com/)
  - [CentOS系统安装](https://github.com/mds1455975151/tools/blob/master/os/CentOS.md)

## CentOS
- 关闭ipv6协议
- 禁ping和开启ping操作
  ``` bash
  echo 1 > /proc/sys/net/ipv4/icmp_echo_ignore_all  # 禁止ping
  echo 0 > /proc/sys/net/ipv4/icmp_echo_ignore_all  # 开启ping
  ```
- 挂载iso文件
  ``` bash
  mount -o loop -t iso9660 /media/Linux/CentOS-6.5-i386-bin-DVD1.iso /mnt
  ```
- 文件描述符
``` bash
# cat >>/etc/security/limits.conf<<EOF
* hard nofile 102400   
* soft nofile 102400
* soft nproc  20240
* hard nproc  30480
EOF
# ulimit -n
10240
# ulimit -a
-t: cpu time (seconds)              unlimited
-f: file size (blocks)              unlimited
-d: data seg size (kbytes)          unlimited
-s: stack size (kbytes)             8192
-c: core file size (blocks)         0
-m: resident set size (kbytes)      unlimited
-u: processes                       31422
-n: file descriptors                10240
-l: locked-in-memory size (kbytes)  64
-v: address space (kbytes)          unlimited
-x: file locks                      unlimited
-i: pending signals                 31422
-q: bytes in POSIX msg queues       819200
-e: max nice                        0
-r: max rt priority                 0
-N 15:                              unlimited
```
- 服务器性能排除
  
  - [htop](http://hisham.hm/htop/index.php)\top

  - nethogs\iperf
  - [网络测速speed-test](https://github.com/sindresorhus/speed-test)
  - [下载测速fast-cli](https://github.com/sindresorhus/fast-cli)
  - [vtop](https://parall.ax/blog/view/3071/introducing-vtop-a-terminal-activity-monitor-in-node-js) - Easily-extendable activity monitor.
- 显示中文
``` bash
# export LANG='zh_CN.UTF-8'
```
## Linux OOM killer
[Linux OOM killer](https://segmentfault.com/a/1190000008268803)

## 有用的网站
- Compute Freely
- AlternativeTo
- Linux Foundation
- Linux.com
- Linux.org
- Kernel.org
- Opensource.com
- Linux.die

## Ubuntu

## Other
### 协议
- mdns 即多播dns（Multicast DNS）：主要实现了在没有传统DNS服务器的情况下使局域网内的主机实现相互发现和通信，使用的端口为5353，遵从dns协议，使用现有的DNS信息结构、名语法和资源记录类型。并且没有指定新的操作代码或响应代码。
- 链路本地多播名称解析（LLMNR）是一个基于协议的域名系统（DNS）数据包的格式，使得双方的IPv4和IPv6的主机来执行名称解析为同一本地链路上的主机。
