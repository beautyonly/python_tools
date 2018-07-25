include:
  - init.init.pkg-base
 
php-require:
  pkg.installed:
    - names:
      - freetype
      - libxml2
      - xml2
      - libxml2-devel
      - libxml2-static
      - libcurl-devel
      - readline
      - readline-devel
      - readline-static

php-install:
  file.managed:
    - name: /data0/src/php-7.1.11.tar.gz
    - source: salt://init/php/files/php-7.1.11.tar.gz
    - user: root
    - group: root
    - mode: 644
  cmd.run:
    - name: cd /data0/src/ && tar -zxf php-7.1.11.tar.gz && cd php-7.1.11 && ./configure --prefix=/usr/local/php --enable-fpm --with-readline --with-curl --with-openssl --enable-pcntl --enable-exif --with-zlib --enable-mbstring=all --with-mysql >/dev/null 2>&1 && make >/dev/null 2>&1 && make install >/dev/null 2>&1
    - unless: test -d /usr/local/php

php-ln:
  cmd.run:
    - name: ln -s /usr/local/php/bin/php /usr/bin/php
    - unless: test -f /usr/bin/php

php-ext-mcrypt:
  pkg.installed:
    - names:
      - libmcrypt
      - libmcrypt-devel
  cmd.run:
    - name: cd /data0/src/php-7.1.11/ext/mcrypt/ && /usr/local/php/bin/phpize && ./configure -with-php-config=/usr/local/php/bin/php-config >/dev/null 2>&1 && make >/dev/null 2>&1 && make install >/dev/null 2>&1

php-ext-soap:
  cmd.run:
    - name: cd /data0/src/php-7.1.11/ext/soap/ && /usr/local/php/bin/phpize && ./configure -with-php-config=/usr/local/php/bin/php-config >/dev/null 2>&1 && make >/dev/null 2>&1 && make install >/dev/null 2>&1

php-ext-bcmach:
  cmd.run:
    - name: cd /data0/src/php-7.1.11/ext/bcmath/ && /usr/local/php/bin/phpize && ./configure -with-php-config=/usr/local/php/bin/php-config >/dev/null 2>&1 && make >/dev/null 2>&1 && make install >/dev/null 2>&1

php-ext-pdo_mysql:
  cmd.run:
    - name: cd /data0/src/php-7.1.11/ext/pdo_mysql/ && /usr/local/php/bin/phpize && ./configure -with-php-config=/usr/local/php/bin/php-config >/dev/null 2>&1 && make >/dev/null 2>&1 && make install >/dev/null 2>&1

php-ext-phpredis:
  file.managed:
    - name: /data0/src/phpredis-3.1.4.tar.gz
    - source: salt://init/php/files/phpredis-3.1.4.tar.gz
    - user: root
    - group: root
    - mode: 644
  cmd.run:
    - name: cd /data0/src/ && tar -zxf phpredis-3.1.4.tar.gz && cd phpredis-3.1.4 && /usr/local/php/bin/phpize && ./configure -with-php-config=/usr/local/php/bin/php-config >/dev/null 2>&1 && make >/dev/null 2>&1 && make install >/dev/null 2>&1

php-config:
  cmd.run:
    - name: \cp /data0/src/php-7.1.11/php.ini-production /usr/local/php/lib/php.ini
    - unless: test -f /usr/local/php/lib/php.ini

php-fpm-config:
  cmd.run:
    - name: cd /usr/local/php/etc/ && \cp php-fpm.conf.default php-fpm.conf
    - unless: test -f /usr/local/php/etc/php-fpm.conf

php-service:
  file.managed:
    - name: /etc/init.d/php-fpm
    - source: salt://init/php/files/php-fpm
    - user: root
    - group: root
    - mode: 755
  cmd.run:
    - name: chkconfig --add php-fpm && chkconfig php-fpm on && /etc/init.d/php-fpm start
    - unless: netstat -tunlp | grep -v grep | grep -q php-fpm

php-clear:
  cmd.run:
    - name: cd /data0/src/ && rm -rf php-7.1.11

php-log-storage:
  cmd.run:
    - name: mkdir -p /data0/logs/{nginx,php} && cd /usr/local/php/var/ && mv log/ /data0/logs/php/ && ln -s /data0/logs/php/log/ log && /etc/init.d/php-fpm restart
    - unless: test -d /data0/logs/php

php-cut-log:
  file.managed:
    - name: /usr/local/php/sbin/cut-logs-php.sh
    - source: salt://init/php/files/cut-logs-php.sh
    - user: root
    - group: root
    - mode: 755
  cmd.run:
    - name: echo -e "# php cut log at `date +%Y%m%d`\n00 00 * * * /bin/bash /usr/local/php/sbin/cut-logs-php.sh  > /dev/null 2>&1 &" >>/var/spool/cron/root
    - unless: grep -q cut-log-php.sh /var/spool/cron/root
