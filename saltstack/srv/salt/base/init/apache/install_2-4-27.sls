include:
  - init.init.pkg-base

requrement-install:
  pkg.installed:
    - pkgs:
      - pcre 
      - pcre-devel 
      - expat-devel
    - require:
      - file: /etc/yum.repos.d/epel-{{ grains['osmajorrelease'] }}.repo

apache-source_packages:
  file.managed:
    - name: /data0/src/httpd-2.4.27.tar.bz2
    - source: salt://init/apache/files/httpd-2.4.27.tar.bz2
    - user: root
    - group: root
    - mode: 644

apache-apr:
  file.managed:
    - name: /data0/src/apr-1.6.2.tar.gz
    - source: salt://init/apache/files/apr-1.6.2.tar.gz
    - user: root
    - group: root
    - mode: 755

apache-apr-util:
  file.managed:
    - name: /data0/src/apr-util-1.6.0.tar.gz
    - source: salt://init/apache/files/apr-util-1.6.0.tar.gz
    - user: root
    - group: root
    - mode: 755

apache-install:
  cmd.run:
    - names: 
      - cd /data0/src/ && bzip2 -d httpd-2.4.27.tar.bz2 && tar -xf httpd-2.4.27.tar && tar -zxf apr-1.6.2.tar.gz && mv apr-1.6.2 httpd-2.4.27/srclib/apr && tar -zxf apr-util-1.6.0.tar.gz && mv apr-util-1.6.0 httpd-2.4.27/srclib/apr-util && cd httpd-2.4.27 && ./configure --prefix=/usr/local/httpd-2.4.27 --with-included-apr >/dev/null 2>&1 && make >/dev/null 2>&1 && make install >/dev/null 2>&1 && cd /usr/local/ && ln -s httpd-2.4.27/ httpd
    - unless: /usr/local/httpd/bin/apachectl -V|grep version|grep 2.4.27

apache-start:
  cmd.run:
    - names: 
      - /usr/local/httpd/bin/apachectl start
    - unless: ps -ef|grep httpd|grep -v grep
