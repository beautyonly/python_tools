include:
  - init.init.pkg-base

apache-source_packages:
  file.managed:
    - name: /data0/src/httpd-2.2.32.tar.gz
    - source: salt://init/apache/files/httpd-2.2.32.tar.gz
    - user: root
    - group: root
    - mode: 644

apache-config:
  file.managed:
    - name: /data0/src/config.nice
    - source: salt://init/apache/files/config.nice-2.2.32
    - user: root
    - group: root
    - mode: 755

apache_update:
  cmd.run:
    - names: 
      - cd /data0/src/ && tar -zxf httpd-2.2.32.tar.gz && cd httpd-2.2.32 && cp -a /data0/src/config.nice . && ./config.nice >/dev/null 2>&1 && make >/dev/null 2>&1 && make install >/dev/null 2>&1 && /usr/local/apache2/bin/apachectl -k graceful-stop && /usr/local/apache2/bin/apachectl -k start
    - unless: /usr/local/apache2/bin/apachectl -V|grep version|grep 2.2.32
