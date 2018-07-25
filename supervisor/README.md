# supervisor知识总结

## supervisor概述
- 官网文档：http://supervisord.org/installing.html

## 部署安装
```
wget https://raw.githubusercontent.com/mds1455975151/tools/master/supervisor/install_supervisor.sh
sh install_supervisor.sh
```
## 日常管理
- supervisord
  ``` text
  supervisorctl stop programxxx：停止某一个进程(programxxx)，programxxx为[program:chatdemon]里配置的值，这个示例就是chatdemon。
  supervisorctl start programxxx：启动某个进程
  supervisorctl restart programxxx：重启某个进程
  supervisorctl stop groupworker：重启所有属于名为groupworker这个分组的进程(start,restart同理)
  supervisorctl stop all：停止全部进程，注：start、restart、stop都不会载入最新的配置文件。
  supervisorctl reload：载入最新的配置文件，停止原有进程并按新的配置启动、管理所有进程。
  supervisorctl update：根据最新的配置文件，启动新配置或有改动的进程，配置没有改动的进程不会受影响而重启。
  注意：显示用stop停止掉的进程，用reload或者update都不会自动重启。
  ```
- supervisorctl
- web管理界面(inet_http_server)
- 案例模板
```
cat>/etc/supervisord.d/test.ini<<EOF
[program:test]
directory = /tmp
command = ping www.baidu.com
priority=1
numprocs=1
autostart=true
autorestart=true
stderr_logfile=/var/log/test_err.log
stdout_logfile=/var/log/test_out.log
EOF
```

## supervisor集中管理的方案
- Django-Dashvisor（功能简陋，项目更新不及时）

Web-based dashboard written in Python. Requires Django 1.3 or 1.4.

- Nodervisor

Web-based dashboard written in Node.js.

项目地址：https://github.com/TAKEALOT/nodervisor

- Supervisord-Monitor

Web-based dashboard written in PHP.

- Supvisors

- SupervisorUI

Another Web-based dashboard written in PHP.

supervisord-monitor（改进版）

https://github.com/mlazarov/supervisord-monitor

- supervisord-monitor（改进版）界面效果

1）配置每个主机supervisor配置
```
修改配置文件supervisord.conf
[inet_http_server]
port=*:9001
```
2）lnmp环境
```
supervisor-monitor这个web控制台控制着多台服务器的程序运行,自然是非常重要,所以访问时应该输入用户名和密码

wget https://raw.githubusercontent.com/mds1455975151/tools/master/lnmp/install_lnmp_c7.sh
sh install_lnmp_c7.sh

yum -y install httpd-tools
htpasswd -c /etc/nginx/conf.d/.htpasswd admin
New password: [admin]
Re-type new password: [admin]
Adding password for user admin
# 如果还想增加用户
htpasswd -m /etc/nginx/conf.d/.htpasswd tom
# 这么重要的文件,当然要做好授权
chown root.nginx .htpasswd
chmod 640 .htpasswd
ll .htpasswd
-rw-r----- 1 root nginx 86 Nov 24 16:18 .htpasswd

    server {
        listen 80;
        server_name  10.1.16.152;
        set $web_root  /usr/share/nginx/html/supervisord-monitor/public_html/;
        root $web_root;

        index  index.php index.html index.htm;

        location / {
            try_files $uri $uri/ /index.php;
            auth_basic "Basic Auth";
            auth_basic_user_file "/etc/nginx/conf.d/.htpasswd";
        }

        location ~ /*\.php$ {
            fastcgi_index index.php;
            fastcgi_param  SCRIPT_FILENAME $web_root$fastcgi_script_name;
            fastcgi_param  SCHEME $scheme;
            include        fastcgi_params;
            fastcgi_pass 127.0.0.1:9000;
        }
    }
    
systemctl reload nginx
```
3）配置supervisord-monitor环境
```
cd /usr/share/nginx/html/
git clone https://github.com/mlazarov/supervisord-monitor.git
cp supervisord-monitor/application/config/supervisor.php.example supervisord-monitor/application/config/supervisor.php
cd supervisord-monitor/application/config/
vim supervisor.php
        '10.1.16.152' => array(
                'url' => 'http://10.1.16.152/RPC2',
                'port' => '9001',
                'username' => 'supervisor',
                'password' => '09348c20a019be0318387c08df7a783d'
        ),
        '10.1.16.155' => array(
                'url' => 'http://10.1.16.155/RPC2',
                'port' => '9001',
                'username' => 'supervisor',
                'password' => '09348c20a019be0318387c08df7a783d'
        ),

```
4）测试

![images](https://github.com/mds1455975151/tools/blob/master/supervisor/images/01.png)

## Ansible + Supervisor
- [ansible supervisor](http://docs.ansible.com/ansible/latest/modules/supervisorctl_module.html#supervisorctl-module)

## 参考资料
