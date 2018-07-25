include:
  - modules.mysql.install

slave-config:
  file.managed:
    - name: /etc/my.cnf.d/mariadb-server.cnf
    - source: salt://modules/mysql/files/mariadb-server-slave.cnf
    - user: root
    - group: root
    - mode: 644

slave-service:
  service.running:
    - name: mariadb
    - enable: True
