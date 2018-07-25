mysql-install:
  pkg.installed:
    - pkgs:
      - mariadb
      - mariadb-server
mysql-config:
  file.managed:
    - name: /etc/my.cnf
    - source: salt://modules/mysql/files/my.cnf
    - user: root
    - group: root
    - mode: 644
