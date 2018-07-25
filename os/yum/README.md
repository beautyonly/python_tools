# yum源知识
## 自建yum源
``` bash
# yum install -y nginx
# cat >/etc/nginx/conf.d/repo.conf<<EOF
server {
    listen       8080; 
    server_name  localhost;
    root         /data0/repo;

    location / {
    autoindex on;             #开启索引功能  
    autoindex_exact_size off; # 关闭计算文件确切大小（单位bytes），只显示大概大小（单位kb、mb、gb）  
    autoindex_localtime on;   # 显示本机时间而非 GMT 时间  
    }

    error_page 404 /404.html;
        location = /40x.html {
    }

    error_page 500 502 503 504 /50x.html;
        location = /50x.html {
    }
}
EOF
# mkdir -p /data0/repo
# systemctl enable nginx
# systemctl start nginx
# sed -i 's/keepcache=0/keepcache=1/g' /etc/yum.conf
# yum install -y tree
# \cp /var/cache/yum/x86_64/7/os/packages/tree-1.6.0-10.el7.x86_64.rpm /data0/repo/
# yum install -y createrepo
# cd /data0/repo && createrepo /data0/repo/
# cat >/etc/yum.repos.d/local.repo<<EOF
[local]
name=local repo
baseurl=http://193.112.50.123:8080/
failovermethod=priority
enabled=1
gpgcheck=0
EOF
# cat >/etc/yum.repos.d/local.repo<<EOF
[local]
name=local repo
baseurl=file:///data0/repo/
failovermethod=priority
enabled=1
gpgcheck=0
EOF
# yum remove -y tree
# yum install -y tree
```
