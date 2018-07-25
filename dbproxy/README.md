# dbproxy总结
## dbproxy
- https://github.com/highras/fpnn
- https://github.com/highras/dbproxy
- https://github.com/highras/tableCache

## dbproxy部署搭建
- 机器初始化
``` bash 
wget https://raw.githubusercontent.com/mds1455975151/tools/master/shell/host_init.sh
sh host_init.sh
```
- MySQL环境
``` bash
wget https://raw.githubusercontent.com/mds1455975151/tools/master/mysql/install_mysql.sh
sh install_mysql.sh
```

``` bash
yum -y groupinstall 'Development tools'
yum install -y libcurl-devel
yum install -y openssl-devel
yum install -y gperftools
yum remove -y php-mysql
yum install -y php-mysqlnd
yum install -y mysql-devel # 补充 缺mysql-config

mkdir -p /data0/dbproxy
cd /data0/dbproxy
git clone https://github.com/highras/fpnn.git infra-fpnn
cd infra-fpnn
make

wget https://raw.githubusercontent.com/mds1455975151/tools/master/supervisor/install_supervisor.sh
sh install_supervisor.sh

cat>/etc/supervisord.d/DBProxy.ini<<EOF
[program:DBProxy]
directory = /data0/dbproxy/infra-fp-mysql-dbproxy/DBProxy/
command = /data0/dbproxy/infra-fp-mysql-dbproxy/DBProxy/DBProxy DBProxy.conf
priority=1
numprocs=1
autostart=true
autorestart=true
stderr_logfile=/var/log/DBProxy_err.log
stdout_logfile=/var/log/DBProxy_out.log
EOF
supervisorctl update
supervisorctl start DBProxy
```
