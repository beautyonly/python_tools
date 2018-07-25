# Redis知识总结
## Redis概述

## Redis安装部署
``` bash
wget https://raw.githubusercontent.com/mds1455975151/tools/master/redis/install_redis.sh
sh install_redis.sh
```
## Redis日常使用
``` text
127.0.0.1:6381> dbsize  // 查看key数量
(integer) 3112
```
## Redis多实例
``` bash
cp /etc/redis-6380.conf /etc/redis-6381.conf
sed -i 's/6380/6381/g' /etc/redis-6381.conf
mkdir -p /var/lib/redis-6381
redis-server /etc/redis-6381.conf
netstat -tunlp
cat>>/etc/rc.local<<EOF
redis-server /etc/redis-6381.conf
EOF
```
## Redis性能压测
## twemproxy
- 编译
- 安装
- 配置
- 性能测试
## codis
## 可视化管理工具
- redis的图形化工具 
  - redis-stat 
  - redis-browser 
  - redis-live
- [redis desktop manager](https://redisdesktop.com/download)

## 参考资料
