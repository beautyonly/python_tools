limits-config:
  file.managed:
    - name: /etc/security/limits.conf
    - source: salt://init/files/limits.conf
    - user: root
    - group: root
    - mode: 644
