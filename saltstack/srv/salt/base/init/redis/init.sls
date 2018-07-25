redis-install:
  pkg.installed:
    - name: redis

redis-config:
  file.managed:
    - name: /etc/redis.conf
{% if grains['osmajorrelease'] == '6' and grains['os'] == 'CentOS' %}
    - source: salt://init/redis/files/redis-2.4.10.conf
{% elif grains['osmajorrelease'] == '7' and grains['os'] == 'CentOS' %}
    - source: salt://init/redis/files/redis-3.2.8.conf
{% endif %}
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - defaults:
        PASSWD: redis
        PORT: 6379
        IPADDR: {{ grains['ip4_interfaces']['eth1'][0] }}

redis-service:
  service.running:
    - name: redis
    - enable: True
    - require:
      - pkg: redis-install
      - file: redis-config
    - reload: True
    - watch:
      - file: redis-config

redis-slave:
  cmd.run:
    - name: redis-cli -h 192.168.56.12 slaveof 192.168.56.11 6379
    - unless: test {{ grains['ip4_interfaces']['eth1'][0] }} != "192.168.56.12"
