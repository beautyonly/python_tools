include:
  - modules.apache.php

apache-install:
  pkg.installed:
    - name: httpd

apache-config:
  file.managed:
    - name: /etc/httpd/conf/httpd.conf
    - source: salt://modules/apache/files/httpd.conf
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - defaults:
      PORT: 8080
    - watch_in:
      - service: apache-service

apache-service:
  service.running:
    - name: httpd
    - enable: True
    - reload: True
