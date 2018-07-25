include:
  - init.init.pkg-base    

redis-files:
  file.managed:
    - name: /data0/src/redis-3.2.9.tar.gz
    - source: salt://init/redis/files/redis-3.2.9.tar.gz
    - user: root
    - group: root
    - mode: 644

redis-user:
  cmd.run: 
    - name: useradd -s /sbin/nologin redis
    - unless: id redis

redis-install:
  cmd.run:
    - name: cd /data0/src/ && tar -zxf redis-3.2.9.tar.gz && cd redis-3.2.9 && make PREFIX=/usr/local/redis-3.2.9 install >/dev/null 2>&1 && mkdir -p /usr/local/redis-3.2.9/{logs,conf,var/run} && mkdir -p /data0/redis && ln -s /usr/local/redis-3.2.9 /usr/local/redis && ln -s /data0/redis /usr/local/redis/data  && chown -R redis.redis /usr/local/redis/*
    - unless: test -d /usr/local/redis-3.2.9

redis-log:
  file.managed:
    - name: /etc/logrotate.d/redis
    - source: salt://init/redis/files/redis.logrotate
    - user: root
    - group: root
    - mode: 644

redis-service-script:
  file.managed:
    - name: /etc/init.d/redis
    - source: salt://init/redis/files/redis.source-service
    - user: root
    - group: root
    - mode: 755

redis-sysconfig:
  file.managed:
    - name: /etc/sysconfig/redis
    - source: salt://init/redis/files/redis.sysconfig
    - user: root
    - group: root
    - mode: 644

redis-config:
  file.managed:
    - name: //usr/local/redis-3.2.9/conf/redis.conf
    - source: salt://init/redis/files/redis-3.2.9.conf
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - defaults:
        PASSWORD: redispassword
        PORT: 6379
        IPADDR: 127.0.0.1

redis-service:
  service.running:
    - name: redis
    - enable: True
    - require:
      - cmd: redis-install
      - file: redis-config
    - reload: True
    - watch:
      - file: redis-config
  cmd.run:
    - name: /etc/init.d/redis start
    - unless: ps -ef|grep redis|grep -vc grep
