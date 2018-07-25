keepalived-install:
  pkg.installed:
    - pkgs:
      - keepalived

keepalived-config:
  file.managed:
    - name: /etc/keepalived/keepalived.conf
    - source: salt://keepalived/files/keepalived.conf
    - user: root
    - group: root
    - mode: 644

keepalived-service:
  service.running:
    - name: keepalived
    - enable: True
