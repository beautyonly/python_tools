# 网络相关
## 办公设备
## 基本网络质量监控
- https://github.com/gy-games/smartping
## TCP or UDP端口测试
### UDP方法
```
nc -vuz ipAddress port
```
### TCP方法
```
telnet ipAddress port
```
## 网络抓包
- wireshark
- tcpdump


5 网络{

    rz   # 通过ssh上传小文件
    sz   # 通过ssh下载小文件
    ifconfig eth0 down                  # 禁用网卡
    ifconfig eth0 up                    # 启用网卡
    ifup eth0:0                         # 启用网卡
    mii-tool em1                        # 查看网线是否连接
    traceroute www.baidu.com            # 测试跳数
    vi /etc/resolv.conf                 # 设置DNS  nameserver IP 定义DNS服务器的IP地址
    nslookup www.moon.com               # 解析域名IP
    dig -x www.baidu.com                # 解析域名IP
    dig +trace -t A 域名                # 跟踪dns
    dig +short txt hacker.wp.dg.cx      # 通过 DNS 来读取 Wikipedia 的hacker词条
    host -t txt hacker.wp.dg.cx         # 通过 DNS 来读取 Wikipedia 的hacker词条
    lynx                                # 文本上网
    wget -P 路径 -O 重命名 http地址       # 下载  包名:wgetrc   -q 安静
    dhclient eth1                       # 自动获取IP
    mtr -r www.baidu.com                # 测试网络链路节点响应时间 # trace ping 结合
    ipcalc -m "$ip" -p "$num"           # 根据IP和主机最大数计算掩码
    curl -I www.baidu.com               # 查看网页http头
    curl -s www.baidu.com               # 不显示进度
    queryperf -d list -s DNS_IP -l 2    # BIND自带DNS压力测试  [list 文件格式:www.turku.fi A]
    telnet ip port                      # 测试端口是否开放,有些服务可直接输入命令得到返回状态
    echo "show " |nc $ip $port          # 适用于telnet一类登录得到命令返回
    nc -l -p port                       # 监听指定端口
    nc -nv -z 10.10.10.11 1080 |grep succeeded                            # 检查主机端口是否开放
    curl -o /dev/null -s -m 10 --connect-timeout 10 -w %{http_code} $URL  # 检查页面状态
    curl -X POST -d "user=xuesong&pwd=123" http://www.abc.cn/Result       # 提交POST请求
    curl -s http://20140507.ip138.com/ic.asp                              # 通过IP138取本机出口外网IP
    curl http://IP/ -H "X-Forwarded-For: ip" -H "Host: www.ttlsa.com"     # 连到指定IP的响应主机,HTTPserver只看 Host字段
    ifconfig eth0:0 192.168.1.221 netmask 255.255.255.0                   # 增加逻辑IP地址
    echo 1 > /proc/sys/net/ipv4/icmp_echo_ignore_all                      # 禁ping
    net rpc shutdown -I IP_ADDRESS -U username%password                   # 远程关掉一台WINDOWS机器
    wget --random-wait -r -p -e robots=off -U Mozilla www.example.com     # 递归方式下载整个网站
    sshpass -p "$pwd" rsync -avzP /dir  user@$IP:/dir/                    # 指定密码避免交互同步目录
    rsync -avzP --delete /dir user@$IP:/dir                               # 无差同步目录 可以快速清空大目录
    rsync -avzP -e "ssh -p 22 -e -o StrictHostKeyChecking=no" /dir user@$IP:/dir         # 指定ssh参数同步

    抓包{

        -i eth1          # 只抓经过接口eth1的包
        -t               # 不显示时间戳
        -s 0             # 抓取数据包时默认抓取长度为68字节。加上-S 0 后可以抓到完整的数据包
        -c 100           # 只抓取100个数据包
        dst port ! 22    # 不抓取目标端口是22的数据包
        tcpdump tcp port 22                 # 抓包
        tcpdump -n -vv udp port 53          # 抓udp的dns包 并显示ip
        tcpdump port 10001 -A -s0           # 完整显示ascii数据包

    }

    网卡流量查看{

        watch more /proc/net/dev    # 实时监控流量文件系统 累计值
        iptraf                      # 网卡流量查看工具
        nethogs -d 5 eth0 eth1      # 按进程实时统计网络流量 epel源nethogs
        iftop -i eth0 -n -P         # 实时流量监控

        sar {
            -n参数有6个不同的开关: DEV | EDEV | NFS | NFSD | SOCK | ALL
            DEV显示网络接口信息
            EDEV显示关于网络错误的统计数据
            NFS统计活动的NFS客户端的信息
            NFSD统计NFS服务器的信息
            SOCK显示套 接字信息
            ALL显示所有5个开关

            sar -n DEV 1 10

            rxpck/s   # 每秒钟接收的数据包
            txpck/s   # 每秒钟发送的数据包
            rxbyt/s   # 每秒钟接收的字节数
            txbyt/s   # 每秒钟发送的字节数
            rxcmp/s   # 每秒钟接收的压缩数据包
            txcmp/s   # 每秒钟发送的压缩数据包
            rxmcst/s  # 每秒钟接收的多播数据包

        }

    }

    netstat{

        # 几十万并发的情况下netstat会没有响应，建议使用 ss 命令
        -a     # 显示所有连接中的Socket
        -t     # 显示TCP连接
        -u     # 显示UDP连接
        -n     # 显示所有已建立的有效连接
        netstat -anlp           # 查看链接
        netstat -tnlp           # 只查看tcp监听端口
        netstat -r              # 查看路由表
    }

    ss{

        # netstat是遍历/proc下面每个PID目录，ss直接读/proc/net下面的统计信息。所以ss执行的时候消耗资源以及消耗的时间都比netstat少很多
        ss -s          # 列出当前socket详细信息
        ss -l          # 显示本地打开的所有端口
        ss -tnlp       # 显示每个进程具体打开的socket
        ss -ant        # 显示所有TCP socket
        ss -u -a       # 显示所有UDP Socekt
        ss dst 192.168.119.113         # 匹配远程地址
        ss dst 192.168.119.113:http    # 匹配远程地址和端口号
        ss dst 192.168.119.113:3844    # 匹配远程地址和端口号
        ss src 192.168.119.103:16021   # 匹配本地地址和端口号
        ss -o state established '( dport = :smtp or sport = :smtp )'        # 显示所有已建立的SMTP连接
        ss -o state established '( dport = :http or sport = :http )'        # 显示所有已建立的HTTP连接
        ss -x src /tmp/.X11-unix/*         # 找出所有连接X服务器的进程

    }

    并发数查看{

        netstat -n | awk '/^tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}'
        SYN_RECV     # 正在等待处理的请求
        ESTABLISHED  # 正常数据传输状态,既当前并发数
        TIME_WAIT    # 处理完毕，等待超时结束的请求
        CLOSE_WAIT   # 客户端异常关闭,没有完成4次挥手  如大量可能存在攻击行为

    }

    ssh{

        ssh -p 22 user@192.168.1.209                            # 从linux ssh登录另一台linux
        ssh -p 22 root@192.168.1.209 CMD                        # 利用ssh操作远程主机
        scp -P 22 文件 root@ip:/目录                             # 把本地文件拷贝到远程主机
        scp -l 100000  文件 root@ip:/目录                        # 传输文件到远程，限制速度100M
        sshpass -p '密码' ssh -n root@$IP "echo hello"           # 指定密码远程操作
        ssh -o StrictHostKeyChecking=no $IP                     # ssh连接不提示yes
        ssh -t "su -"                                           # 指定伪终端 客户端以交互模式工作
        scp root@192.168.1.209:远程目录 本地目录                   # 把远程指定文件拷贝到本地
        pscp -h host.ip /a.sh /opt/sbin/                        # 批量传输文件
        ssh -N -L2001:remotehost:80 user@somemachine            # 用SSH创建端口转发通道
        ssh -t host_A ssh host_B                                # 嵌套使用SSH
        ssh -t -p 22 $user@$Ip /bin/su - root -c {$Cmd};        # 远程su执行命令 Cmd="\"/sbin/ifconfig eth0\""
        ssh-keygen -t rsa                                       # 生成密钥
        ssh-copy-id -i xuesong@10.10.10.133                     # 传送key
        vi $HOME/.ssh/authorized_keys                           # 公钥存放位置
        sshfs name@server:/path/to/folder /path/to/mount/point  # 通过ssh挂载远程主机上的文件夹
        fusermount -u /path/to/mount/point                      # 卸载ssh挂载的目录
        ssh user@host cat /path/to/remotefile | diff /path/to/localfile -                # 用DIFF对比远程文件跟本地文件
        su - user -c "ssh user@192.168.1.1 \"echo -e aa |mail -s test mail@163.com\""    # 切换用户登录远程发送邮件

        SSH反向连接{

            # 外网A要控制内网B

            ssh -NfR 1234:localhost:2223 user1@123.123.123.123 -p22    # 将A主机的1234端口和B主机的2223端口绑定，相当于远程端口映射
            ss -ant   # 这时在A主机上sshd会listen本地1234端口
            # LISTEN     0    128    127.0.0.1:1234       *:*
            ssh localhost -p1234    # 在A主机连接本地1234端口

        }
    }

    网卡配置文件{

        vi /etc/sysconfig/network-scripts/ifcfg-eth0

        DEVICE=eth0
        BOOTPROTO=none
        BROADCAST=192.168.1.255
        HWADDR=00:0C:29:3F:E1:EA
        IPADDR=192.168.1.55
        NETMASK=255.255.255.0
        NETWORK=192.168.1.0
        ONBOOT=yes
        TYPE=Ethernet
        GATEWAY=192.168.1.1
        #ARPCHECK=no     # 进制arp检查

    }

    route {

        route                           # 查看路由表
        route add default  gw 192.168.1.1  dev eth0                        # 添加默认路由
        route add -net 172.16.0.0 netmask 255.255.0.0 gw 10.39.111.254     # 添加静态路由网关
        route del -net 172.16.0.0 netmask 255.255.0.0 gw 10.39.111.254     # 删除静态路由网关

    }

    静态路由{

        vim /etc/sysconfig/static-routes
        any net 192.168.12.0/24 gw 192.168.0.254
        any net 192.168.13.0/24 gw 192.168.0.254

    }

    解决ssh链接慢{

        sed -i 's/GSSAPIAuthentication yes/GSSAPIAuthentication no/' /etc/ssh/sshd_config
        sed -i '/#UseDNS yes/a\UseDNS no' /etc/ssh/sshd_config
        /etc/init.d/sshd reload

    }

    ftp上传{

        ftp -i -v -n $HOST <<END
        user $USERNAME $PASSWORD
        cd /ftp
        mkdir data
        cd data
        mput *.tar.gz
        bye
END

    }

    nmap{

        nmap -PT 192.168.1.1-111             # 先ping在扫描主机开放端口
        nmap -O 192.168.1.1                  # 扫描出系统内核版本
        nmap -sV 192.168.1.1-111             # 扫描端口的软件版本
        nmap -sS 192.168.1.1-111             # 半开扫描(通常不会记录日志)
        nmap -P0 192.168.1.1-111             # 不ping直接扫描
        nmap -d 192.168.1.1-111              # 详细信息
        nmap -D 192.168.1.1-111              # 无法找出真正扫描主机(隐藏IP)
        nmap -p 20-30,139,60000-             # 端口范围  表示：扫描20到30号端口，139号端口以及所有大于60000的端口
        nmap -P0 -sV -O -v 192.168.30.251    # 组合扫描(不ping、软件版本、内核版本、详细信息)

        # 不支持windows的扫描(可用于判断是否是windows)
        nmap -sF 192.168.1.1-111
        nmap -sX 192.168.1.1-111
        nmap -sN 192.168.1.1-111

    }

    流量切分线路{

        # 程序判断进入IP线路，设置服务器路由规则控制返回
        vi /etc/iproute2/rt_tables
        #添加一条策略
        252   bgp2  #注意策略的序号顺序
        ip route add default via 第二个出口上线IP(非默认网关) dev eth1 table bgp2
        ip route add from 本机第二个ip table bgp2
        #查看
        ip route list table 252
        ip rule list
        #成功后将语句添加开机启动

    }

    snmp{

        snmptranslate .1.3.6.1.2.1.1.3.0    # 查看映射关系
            DISMAN-EVENT-MIB::sysUpTimeInstance
        snmpdf -v 1 -c public localhost                            # SNMP监视远程主机的磁盘空间
        snmpnetstat -v 2c -c public -a 192.168.6.53                # SNMP获取指定IP的所有开放端口状态
        snmpwalk -v 2c -c public 10.152.14.117 .1.3.6.1.2.1.1.3.0  # SNMP获取主机启动时间
        # MIB安装(ubuntu)
        # sudo apt-get install snmp-mibs-downloader
        # sudo download-mibs
        snmpwalk -v 2c -c public 10.152.14.117 sysUpTimeInstance   # SNMP通过MIB库获取主机启动时间

    }

    TC流量控制{

        # 针对ip段下载速率控制
        tc qdisc del dev eth0 root handle 1:                                                              # 删除控制1:
        tc qdisc add dev eth0 root handle 1: htb r2q 1                                                    # 添加控制1:
        tc class add dev eth0 parent 1: classid 1:1 htb rate 12mbit ceil 15mbit                           # 设置速率
        tc filter add dev eth0 parent 1: protocol ip prio 16 u32 match ip dst 10.10.10.1/24 flowid 1:1    # 指定ip段控制规则

        # 检查命令
        tc -s -d qdisc show dev eth0
        tc class show dev eth0
        tc filter show dev eth0

        限制上传下载{

            tc qdisc del dev tun0 root
            tc qdisc add dev tun0 root handle 2:0 htb
            tc class add dev tun0 parent 2:1 classid 2:10 htb rate 30kbps
            tc class add dev tun0 parent 2:2 classid 2:11 htb rate 30kbps
            tc qdisc add dev tun0 parent 2:10 handle 1: sfq perturb 1
            tc filter add dev tun0 protocol ip parent 2:0 u32 match ip dst 10.18.0.0/24 flowid 2:10
            tc filter add dev tun0 parent ffff: protocol ip u32 match ip src 10.18.0.0/24 police rate 30kbps burst 10k drop flowid 2:11


            tc qdisc del dev tun0 root                                     # 删除原有策略
            tc qdisc add dev tun0 root handle 2:0 htb                      # 定义最顶层(根)队列规则，并指定 default 类别编号，为网络接口 eth1 绑定一个队列，类型为 htb，并指定了一个 handle 句柄 2:0 用于标识它下面的子类
            tc class add dev tun0 parent 2:1 classid 2:10 htb rate 30kbps  # 设置一个规则速度是30kbps
            tc class add dev tun0 parent 2:2 classid 2:11 htb rate 30kbps
            tc qdisc add dev tun0 parent 2:10 handle 1: sfq perturb 1      # 调用随机公平算法
            tc filter add dev tun0 protocol ip parent 2:0 u32 match ip dst 10.18.0.0/24 flowid 2:10  # 规则2:10应用在目标地址上，即下载
            tc filter add dev tun0 parent ffff: protocol ip u32 match ip src 10.18.0.0/24 police rate 30kbps burst 10k drop flowid 2:11 # 上传限速

        }

    }

}
