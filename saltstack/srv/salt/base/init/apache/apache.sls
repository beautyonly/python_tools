apache:
  pkg.installed:
    - name: httpd

/etc/httpd/conf/httpd.conf:
  file.managed:
    - source: salt://web/files/httpd.conf
    - user: root
    - group: root
    - mode: 644

/etc/httpd/conf/php.ini:
  file.managed:
    - source: salt://web/files/php.ini
    - user: root
    - group: root
    - mode: 644
