ntpdate-install:
  pkg.installed:
    - name: ntpdate

ntpd-config:
  file.managed:
    - name: /etc/ntp.conf
    - source: salt://init/init/ntp.conf
    - user: root
    - group: root
    - mode: 644

ntpd-service:
  service.running:
    - name: ntpd
    - enable: True
    - reload: True
    - watch:
      - file: ntpd-config
    - require:
      - file: ntpd-config
