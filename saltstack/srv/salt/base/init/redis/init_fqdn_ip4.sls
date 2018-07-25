redis-install:
  pkg.installed:
    - name: redis

redis-config:
  file.managed:
    - name: /etc/redis.conf
    - source: salt://redis/files/redis.conf
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - defaults:
        PORT: 6379
        # IPADDR: {{ grains['fqdn_ip4'][0] }}
        IPADDR: {{ grains['ip4_interfaces']['eth1'] }}

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
    # - unless: test {{ grains['fqdn_ip4'][0] }} == "192.168.56.12"
    - unless: test {{ grains['ip4_interfaces']['eth1'] }} == "192.168.56.12"
