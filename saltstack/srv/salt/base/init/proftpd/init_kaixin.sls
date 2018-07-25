proftpd-env-init:
  pkg.installed:
    - pkgs:
      - ftp
      - httpd
      - gcc
      - gcc-c++
      - autoconf
      - automake

proftpd-install:
  file.managed:
    - name: /tmp/proftpd-1.3.3e.tar.gz
    - source: salt://init/proftpd/files/proftpd-1.3.3e.tar.gz
    - user: root
    - group: root
    - mode: 644
    - unless: test -f /tmp/proftpd-1.3.3e.tar.gz
  cmd.run:
    - name: cd /tmp/ && tar -zxf proftpd-1.3.3e.tar.gz && cd proftpd-1.3.3e && ./configure --prefix=/usr/local/proftpd --sysconfdir=/usr/local/proftpd/etc/ >/dev/null 2>&1 && make >/dev/null 2>&1 && make install >/dev/null 2>&1
    - unless: test -d /usr/local/proftpd
    - require:
      - pkg: proftpd-env-init

proftpd-config-file:
  file.managed:
    - name: /usr/local/proftpd/etc/proftpd.conf
    - source: salt://init/proftpd/files/proftpd.conf
    - user: root
    - group: root
    - mode: 644

proftpd-auth-file:
  file.managed:
    - name: /usr/local/proftpd/etc/authuser
    - source: salt://init/proftpd/files/authuser
    - user: root
    - group: root
    - mode: 644
    - unless: test -f /usr/local/proftpd/etc/authuser

proftpd-service:
  cmd.run:
    - name: /usr/local/proftpd/sbin/proftpd
    - unless: ps -ef|grep proftpd|grep -v grep
  
proftpd-boot:
  cmd.run:
    - name: echo -e "\n# proftpd service start at `date +%Y%m%d` by mads\n/usr/local/proftpd/sbin/proftpd">>/etc/rc.local
    - unless: grep -q "proftpd service start" /etc/rc.local

proftpd-readme:
  file.managed:
    - name: /usr/local/proftpd/etc/readme.txt
    - source: salt://init/proftpd/files/readme.txt
    - user: root
    - group: root
    - mode: 644
    - unless: test -f /usr/local/proftpd/etc/readme.txt
  cmd.run:
    - name: echo "please read /usr/local/proftpd/etc/readme.txt"
