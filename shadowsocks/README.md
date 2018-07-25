# shadowsocks总结
## 需求
访问Google或者其他海外网站的同学可能都使用过shadowsocks，在Windows、Mac、Android、IOS都有现成可用的客户端来协助完成科学上网。
Linux下的如何解决呢?
总结方案：ss-server+ss-local+polipo(proxychains)
## 准备工作
- 海外服务器一台搭建ss服务器端or购买的shadowsocks服务

## ss-server端
- shadowsocks安装
``` bash
yum install python-pip
pip install shadowsocks
```
- shadowsocks配置
``` bash
# cat>/etc/shadowsocks.json<<EOF
{
    "server":"服务器的ip",
    "server_port":19175,
    "local_address":"127.0.0.1",
    "local_port":1080,
    "password":"密码",
    "timeout":300,
    "method":"aes-256-cfb"
}
EOF
sslocal -c /etc/shadowsocks.json
or
pip install supervisord
# /etc/supervisord.conf
[program:shadowsocks]
command=ssserver -c /etc/shadowsocks.json
autostart=true
autorestart=true
user=root
log_stderr=true
logfile=/var/log/shadowsocks.log
# ss -lntup|grep ssserver
```
## client端
> 安装、配置shadowsocks，启动ss-local,安装配置polipo或者proxychains

- shadowsocks安装
``` bash
yum install python-pip
pip install shadowsocks
```
- shadowsocks配置
``` bash
# cat>/etc/shadowsocks.json<<EOF
{
    "server":"服务器的ip",
    "server_port":19175,
    "local_address":"127.0.0.1",
    "local_port":1080,
    "password":"密码",
    "timeout":300,
    "method":"aes-256-cfb"
}
EOF
sslocal -c /etc/shadowsocks.json
or
pip install supervisord
# /etc/supervisord.conf
[program:shadowsocks]
command=sslocal -c /etc/shadowsocks.json
autostart=true
autorestart=true
user=root
log_stderr=true
logfile=/var/log/shadowsocks.log
# ss -lntup|grep ssserver
```
- polipo安装及配置
``` bash
安装polipo将socks5协议转为http协议
yum install -y texinfo
git clone https://github.com/jech/polipo.git
cd polipo
make all
make install

# mkdir -p /etc/polipo/
# cat>/etc/polipo/config<<EOF
socksParentProxy = "127.0.0.1:1080"
socksProxyType = socks5
logFile = /var/log/polipo
logLevel = 99
logSyslog = true
EOF
# polipo -c /etc/polipo/config
# ss -lntup|grep polipo
tcp LISTEN 0 128 127.0.0.1:8123 *:* users:(("polipo",23399,5))
export http_proxy=http://localhost:8123
curl ip.gs
```
- Proxychains

## 设置代理
``` bash
export http_proxy=http://localhost:8123
unset http_proxy
```
## 参考资料
- https://www.cnblogs.com/thatsit/p/6481820.html?utm_source=itdadao&utm_medium=referral
- https://github.com/teddysun/shadowsocks_install
- https://github.com/pritunl/pritunl
