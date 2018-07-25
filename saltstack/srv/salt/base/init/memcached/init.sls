memcached-install:
  pkg.installed:
    - pkgs:
      - memcached
      - libevent

memcached-config:
  file.managed:
    - name: /etc/sysconfig/memcached
    - source: salt://init/memcached/files/memcached
    - user: root
    - group: root
    - mode: 644

memcached-service:
  service.running:
    - name: memcached
    - enable: True
    - require:
      - pkg: memcached-install
    - reload: True
    - watch:
      - file: memcached-config
