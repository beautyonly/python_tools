include:
  - modules.mysql.slave

slave-start:
  file.managed:
    - name: /tmp/start_slave.sh
    - source: salt://shop-user/files/start_slave.sh
    - user: root
    - group: root
    - mode: 755
  cmd.run:
    - name: /bin/bash /tmp/start_slave.sh
    - unless: test -f /etc/my.cnf.d/slave.lock 
