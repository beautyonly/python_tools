close_selinux:
  file.managed:
    - name: /etc/selinux/config
    - source: salt://init/files/selinux-config
    - user: root
    - group: root
    - mode: 0644
  cmd.run:
    - name: setenforce 0 || echo ok
