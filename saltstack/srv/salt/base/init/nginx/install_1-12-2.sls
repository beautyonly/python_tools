include:
  - init.init.pkg-base
 
pcre-install:
  file.managed:
    - name: /data0/src/pcre-8.40.zip
    - source: salt://init/nginx/files/pcre-8.40.zip
    - user: root
    - group: root
    - mode: 644
  cmd.run:
    - name: cd /data0/src/ && unzip pcre-8.40.zip && mv pcre-8.40 /usr/local/pcre
    - unless: test -d /usr/local/pcre

pcre-clear:
  cmd.run:
    - name: cd /data0/src/ && rm -rf pcre-8.40

nginx-files:
  file.managed:
    - name: /data0/src/nginx-1.12.2.tar.gz
    - source: salt://init/nginx/files/nginx-1.12.2.tar.gz
    - user: root
    - group: root
    - mode: 644

nginx-user:
  cmd.run: 
    - name: useradd -s /sbin/nologin www
    - unless: id www
  
nginx-install:
  cmd.run:
    - name: cd /data0/src/ && tar -zxf nginx-1.12.2.tar.gz && cd nginx-1.12.2 && ./configure --prefix=/usr/local/nginx --with-pcre=/usr/local/pcre --user=www --group=www --with-http_ssl_module --with-http_realip_module --with-http_addition_module --with-http_sub_module --with-http_dav_module --with-http_flv_module --with-http_mp4_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_random_index_module --with-http_secure_link_module --with-http_stub_status_module --with-http_auth_request_module --with-threads --with-stream --with-stream_ssl_module --with-http_slice_module --with-mail --with-mail_ssl_module --with-file-aio --with-http_v2_module --with-ipv6 >/dev/null 2>&1 && make >/dev/null 2>&1 && make install >/dev/null 2>&1
    - unless: test -d /usr/local/nginx

nginx-service:
  file.managed:
    - name: /etc/init.d/nginx
    - source: salt://init/nginx/files/nginx
    - user: root
    - group: root
    - mode: 755
  cmd.run:
    - name: chkconfig --add nginx && chkconfig nginx on && /etc/init.d/nginx start
    - unless: netstat -tunlp | grep -v grep | grep -q nginx

nginx-clear:
  cmd.run:
    - name: cd /data0/src/ && rm -rf nginx-1.12.2

nginx-log-storage:
  cmd.run:
    - name: mkdir -p /data0/logs/{nginx,php} && cd /usr/local/nginx/ && mv logs/ /data0/logs/nginx/ && ln -s /data0/logs/nginx/logs/ logs &&/etc/init.d/nginx restart
    - unless: test -d /data0/logs/nginx

nginx-cut-log:
  file.managed:
    - name: /usr/local/nginx/sbin/cut-log.sh
    - source: salt://init/nginx/files/cut-log.sh
    - user: root
    - group: root
    - mode: 755
  cmd.run:
    - name: echo -e "# nginx cut log at `date +%Y%m%d`\n00 00 * * * /bin/bash /usr/local/nginx/sbin/cut-log.sh  > /dev/null 2>&1 &" >>/var/spool/cron/root
    - unless: grep -q cut-log.sh /var/spool/cron/root
