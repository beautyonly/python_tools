# Nginx
## Nginx概述
官网地址：https://docs.nginx.com/nginx/admin-guide/

## 性能优化
### 内核参数
``` bash

```
### 配置参数
``` bash
# cat /etc/nginx/nginx.conf
# For more information on configuration, see:
#   * Official English Documentation: http://nginx.org/en/docs/
#   * Official Russian Documentation: http://nginx.org/ru/docs/

user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;
worker_rlimit_nofile 65535;

# Load dynamic modules. See /usr/share/nginx/README.dynamic.
include /usr/share/nginx/modules/*.conf;

events {
    use epoll;
    worker_connections 65535;
}

http {
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile            on;
    tcp_nopush          on;
    tcp_nodelay         on;
    keepalive_timeout   65;
    types_hash_max_size 2048;
    server_tokens       off;

    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;

    gzip on;
    gzip_min_length   1k;
    gzip_buffers     4 16k;
    gzip_http_version 1.0;
    gzip_comp_level 2;
    gzip_types       text/plain application/x-javascript text/css application/xml;
    gzip_vary on;

    # Load modular configuration files from the /etc/nginx/conf.d directory.
    # See http://nginx.org/en/docs/ngx_core_module.html#include
    # for more information.
    include /etc/nginx/conf.d/*.conf;

    server {
        listen       80 default_server;
        listen       [::]:80 default_server;
        server_name  _;
        root         /usr/share/nginx/html;

        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;

        location / {
        }

        error_page 404 /404.html;
            location = /40x.html {
        }

        error_page 500 502 503 504 /50x.html;
            location = /50x.html {
        }
    }

# Settings for a TLS enabled server.
#
#    server {
#        listen       443 ssl http2 default_server;
#        listen       [::]:443 ssl http2 default_server;
#        server_name  _;
#        root         /usr/share/nginx/html;
#
#        ssl_certificate "/etc/pki/nginx/server.crt";
#        ssl_certificate_key "/etc/pki/nginx/private/server.key";
#        ssl_session_cache shared:SSL:1m;
#        ssl_session_timeout  10m;
#        ssl_ciphers HIGH:!aNULL:!MD5;
#        ssl_prefer_server_ciphers on;
#
#        # Load configuration files for the default server block.
#        include /etc/nginx/default.d/*.conf;
#
#        location / {
#        }
#
#        error_page 404 /404.html;
#            location = /40x.html {
#        }
#
#        error_page 500 502 503 504 /50x.html;
#            location = /50x.html {
#        }
#    }

}
```
## nginx禁止svn目录访问
``` bash
nginx
location ~ .*.(svn|git|cvs) {
    deny all;
}

apache
<Directory "/opt/www/svip/gift/webroot">
    RewriteEngine On
    RewriteRule .svn/  /404.html 
</Directory>

整理了一些方法供大家参考
禁止访问某些文件/目录
增加Files选项来控制，比如要不允许访问 .inc 扩展名的文件，保护php类库：
<Files ~ ".inc$">
   Order allow,deny
   Deny from all
</Files>

禁止访问某些指定的目录：（可以用 来进行正则匹配）
<Directory ~ "^/var/www/(.+/)*[0-9]{3}">
   Order allow,deny
   Deny from all
</Directory>

通过文件匹配来进行禁止，比如禁止所有针对图片的访问：
<FilesMatch .(?i:gif|jpe?g|png)$>
   Order allow,deny
   Deny from all
</FilesMatch>

针对URL相对路径的禁止访问：
<Location /dir/>
   Order allow,deny
   Deny from all
</Location>

针对代理方式禁止对某些目标的访问（ 可以用来正则匹配），比如拒绝通过代理访问111cn.net：
<Proxy http://www.111cn.net/*>
   Order allow,deny
   Deny from all
</Proxy>
```

# 防止恶意解析的域名
对正常域名的请求返回200，对恶意指向的域名的请求或IP均返回508，以防被运营商探测出来，导致IP被封。

```
nginx version: nginx/1.12.2

server {
    listen       80 default_server;
    listen       [::]:80 default_server;
    server_name  _;

    return       508;
}

server {
    listen       80;
    listen       [::]:80;
    server_name  *.xxx.cn; 

    root         /home/xxx/public;
    # Load configuration files for the default server block.
    include /etc/nginx/default.d/*.conf;

    index index.php index.html index.htm;
    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }
    location ~ \.php$ {
        try_files $uri /index.php =404;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass unix:/dev/shm/fpm-cgi.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }
    error_page 404 /404.html;
        location = /40x.html {
    }

    error_page 500 502 503 504 /50x.html;
        location = /50x.html {
    }
}
```
## 参考资料
