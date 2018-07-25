redis-install:
  pkg.installed:
    - name: redis

redis-config:
  file.managed:
    - name: /etc/redis.conf
    - source: salt://modules/redis/files/redis.conf
    - user: root
    - gourp: root
    - mode: 644
    - template: jinja
    - defaults:
      PORT: 6379
      IPADDR: {{ grains['fqdn_ip4'][0] }}

redis-service:
  service.running:
    - name: redis
    - enable: True
    - reload: True
    - watch:
      - file: redis-config
