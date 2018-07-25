# nginx
- [gzip](http://nginx.org/en/docs/http/ngx_http_gzip_module.html)
```
gzip              on;
gzip_min_length   1000;
gzip_proxied      expired no-cache no-store private auth;
gzip_types        text/plain application/xml;
gzip_buffers      32 4k;	
gzip_comp_level   1;
gzip_http_version 1.1;
gzip_vary         on;
```

```
worker_connections 51200;

/etc/security/limits.conf
fastcgi参数

```
# php-fpm
```

```
