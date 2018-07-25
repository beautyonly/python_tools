sshd-config:
  file.managed:
    - name: /etc/ssh/sshd_config
    - source: salt://init/init/files/sshd_config
    - user: root
    - group: root
    - mode: 600

ssh-service:
  service.running:
    - name: sshd
    - enable: True
    - reload: True
    - watch:
      - file: sshd-config
