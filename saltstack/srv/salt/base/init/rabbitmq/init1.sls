rabbitmq-install:
  pkg.installed:
    - pkgs: 
      - rabbitmq-server
      - librabbitmq
      - librabbitmq-devel
      - librabbitmq-tools

rabbitmq-config:
  file.managed:
    - name: /etc/rabbitmq/rabbitmq.conf
    - source: salt://init/rabbitmq/files/rabbitmq.conf
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - defaults:
        PASSWD: redis
        PORT: 6379

rabbitmq-service:
  service.running:
    - name: rabbitmq-server
    - enable: True
    - require:
      - pkg: rabbitmq-install
      - file: rabbitmq-config
    - reload: True
    - watch:
      - file: rabbitmq-config

#rabbitmq-adduser:
#  cmd.run:
#    - name: rabbitmqctl add_user test test && rabbitmqctl set_permissions test ".*" ".*" ".*"   # 添加 admin用户 密码admin 给`admin`用户配置写和读权限

rabbitmq-remove-guest:
  rabbitmq_user.absent:
    - name: guest

rabbitmq-create-test:
  rabbitmq_user.present:
    - name: test
    - password: test
    - perms:
      - '/':
        - '.*'
        - '.*'
        - '.*'
    
rabbitmq-web:
  cmd.run:
    - name: /usr/lib/rabbitmq/bin/rabbitmq-plugins enable rabbitmq_management      # 启动页面

rabbitmq-readme:
  cmd.run:
    - name: echo "http://{{ grains['ip4_interfaces']['eth1'][0] }}:15672/ username:guest password:guest"
