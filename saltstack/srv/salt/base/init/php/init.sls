php-install:
  pkg.installed:
    - pkgs:
      - php
      - php-mysql
      - php-pdo
      - php-cli 


php-config:
  file.managed:
    - name: /etc/php.ini
    - source: salt://php/files/php.ini
    - user: root
    - group: root
    - mode: 644
