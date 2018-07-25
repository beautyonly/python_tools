include:
  - modules.apache.init

php-config:
  file.managed:
    - name: /etc/php.ini
    - source: salt://shop-user/files/php.ini
    - user: root
    - group: root
    - mode: 644
php-redis-config:
  file.managed:
    - name: /etc/httpd/conf.d/php.conf
    - source: salt://shop-user/files/php.conf
    - user: root
    - group: root
    - mode: 644

web-config:
  file.managed:
    - name: /etc/httpd/conf.d/shop-user.conf
    - source: salt://shop-user/files/shop-user.conf
    - user: root
    - group: root
    - mode: 644
    - watch_in:
      - service: apache-service
