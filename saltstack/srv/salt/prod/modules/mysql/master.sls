include:
  - modules.mysql.install

master-config:
  file.managed:
    - name: /etc/my.cnf.d/mariadb-server.cnf
    - source: salt://modules/mysql/files/mariadb-server-master.cnf
    - user: root
    - group: root
    - mode: 644

master-service:
  service.running:
    - name: mariadb
    - enable: True
