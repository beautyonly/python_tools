# twemproxy知识总结

## twemproxy概述
- GitHub地址：https://github.com/twitter/twemproxy

- 其他相关项目

    - [nutcracker-web](https://github.com/kontera-technologies/nutcracker-web)


## twemproxy安装及配置说明
### twemproxy安装
``` bash
wget https://raw.githubusercontent.com/mds1455975151/tools/master/twemproxy/install_twemproxy.sh
sh install_twemproxy.sh
```
### twemproxy配置
配置案例：https://github.com/twitter/twemproxy/blob/v0.4.1/conf/nutcracker.yml
```
# twemproxy -t   检测配置文件有无语法问题
twemproxy: configuration file '/etc/twemproxy.yml' syntax is ok
- 账号密码配置
所有redis实例要求密码一致,库只能使用0库
```

配置说明：
可以通过进程启动时使用-c or --conf-file指定YAML文件进行配置。配置文件用于指定twemproxy管理的每个池中的服务器池和服务器。

- **listen：** 监听地址和端口或该服务器池的sock文件的绝对路径(/var/run/nutcracker.sock)
- **hash：** 散列函数名称
  - one_at_a_time
  - md5
  - crc16
  - crc32 (crc32 implementation compatible with libmemcached)
  - crc32a (correct crc32 implementation as per the spec)
  - fnv1_64
  - fnv1a_64
  - fnv1_32
  - fnv1a_32
  - hsieh
  - murmur
  - jenkins
- **hash_tag：** 一个两个字符的字符串，它指定用于散列的密钥部分，例如："{}" or "$$"。只要标签中的部分密钥一直，hash_tag就可以将不同的密钥映射到统一服务器
- **distribution:** 密钥分配模式，可能的值是：
  - ketama
  - modula
  - random
- **timeout：** 等待建立到服务器的连接或从服务器接收响应的超时值（以毫米为单位）。默认情况下，我们无限期地等待。
- **backlog：** TCP参数，默认512
- **preconnect：** 一个布尔值，用于控制twemproxy是否应在进程启动时预先连接此池中的所有服务器，默认false.
- **redis：** 一个布尔值，用于控制服务器池是否使用redis或memcached协议，默认false.
- **redis_auth：** 在连接时向Redis服务器进行身份认证
- **redis_db：** 在池服务器上使用的数据库编号。默认为0，注意：Twemproxy将始终以客户端DB 0的身份呈现给客户端.
- **server_connections：** 可以向每个服务器打开的最大连接数。默认情况下，我们最多打开1个服务器连接。
- **auto_eject_hosts：** 一个布尔值，用于控制服务连续server_failure_limit次失败时是否应暂时弹出。查看有关信息的活跃建议。默认为false。
- **server_retry_timeout：** 当auto_eject_host设置为true时，在临时弹出的服务器上重试之前等待的超时值（以毫秒为单位）。默认为30000毫秒。
- **server_failure_limit：** 当auto_eject_host设置为true时，服务器上导致临时弹出的连续失败次数。默认为2。
- **servers：** 此服务器池的服务器地址，端口和权重（name:port:weight or ip:port:weight）列表
## 性能测试
- set测试
```
twemproxy:
redis-benchmark -h 127.0.0.1 -p 6379 -c 100 -t set -d 100 -l –q

redis:
redis-benchmark -h 10.0.0.46 -p 6379 -c 100 -t set -d 100 -l –q
redis-benchmark -h 10.0.0.42 -p 6379 -c 100 -t set -d 100 -l –q

redis-benchmark -h xxx -p 6379 -a crs-1znib6aw:xxx -t set -c 3500 -d 128 -n 25000000 -r 5000000
-h: redis实例IP
-p: redis实例port
-a: redis实例password
-t: 测试 Only run the comma separated list of tests. The test names are the same as the ones produced as output.
-c: 请求量 Total number of requests (default 100000)
-d: set/get value大小 Data size of SET/GET value in bytes (default 2)
-n: 总请求数量
-r: 随机值
-l: Loop. Run the tests forever
-q: Quiet. Just show query/sec values
```
- get测试
```
twemproxy:
redis-benchmark -h 127.0.0.1 -p 6379 -c 100 -t get -d 100 -l -q

redis:
redis-benchmark -h 10.0.0.46 -p 6379 -c 100 -t get -d 100 -l -q
redis-benchmark -h 10.0.0.42 -p 6379 -c 100 -t get -d 100 -l -q
```
- 查看键值分布
```
redis1:
redis-cli -h 10.0.0.42 -a 'xxx' info|grep db0

redis2:
redis-cli -h 10.0.0.46 -a 'xxx' info|grep db0
```
- 性能测试遇到报错
```
问题1：Could not connect to Redis at 127.0.0.1:6379: Can\'t create socket: Too many open files
ulimit -n 10000 设置相对大的文件描述符
```

## FQA
- [2016-06-17 09:12:29.376] nc_redis.c:1092 parsed unsupported command 'keys'
> twemproxy代理redis的情况，不支持一些指令。这里错误说的是Keys指令不支持
支持Redis的命令：https://github.com/twitter/twemproxy/blob/master/notes/redis.md

- 大量TIME_WAIT
``` bash
# netstat -tunlpa|grep 127.0.0.1:6379 |more
tcp        0      0 127.0.0.1:6379          0.0.0.0:*               LISTEN      19641/twemproxy     
tcp        0      0 127.0.0.1:56291         127.0.0.1:6379          TIME_WAIT   -                   
tcp        0      0 127.0.0.1:34812         127.0.0.1:6379          TIME_WAIT   -                   
tcp        0      0 127.0.0.1:54433         127.0.0.1:6379          TIME_WAIT   -                   
tcp        0      0 127.0.0.1:56282         127.0.0.1:6379          TIME_WAIT   -                   
tcp        0      0 127.0.0.1:32894         127.0.0.1:6379          TIME_WAIT   -                   
tcp        0      0 127.0.0.1:56663         127.0.0.1:6379          TIME_WAIT   -                   
tcp        0      0 127.0.0.1:39547         127.0.0.1:6379          TIME_WAIT   -                   
tcp        0      0 127.0.0.1:47716         127.0.0.1:6379          TIME_WAIT   -  
```
## 参考资料
