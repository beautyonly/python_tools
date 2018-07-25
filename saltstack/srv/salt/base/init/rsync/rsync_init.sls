rsync-install:
  pkg.installed:
    - pkgs:
      - xinetd
      - rsync

rsync-config:
  file.managed:
    - name: /etc/rsyncd.conf
    - source: salt://init/rsync/files/rsyncd.conf
    - user: root
    - group: root
    - mode: 644

rsync-boot:
  cmd.run:
    - names:
      - sed -i 's/yes/no/g' /etc/xinetd.d/rsync
    - unless: grep disable /etc/xinetd.d/rsync|grep no
    - require:
      - pkg: rsync-install
      
xinetd-service:
  service.running:
    - name: xinetd
    - enable: True
    - require:
      - pkg: rsync-install
    - watch:
      - file: rsync-config

rsync-service:
  cmd.run:
    - name: /usr/bin/rsync --daemon
    - unless: ps -ef|grep -v grep |grep "/usr/bin/rsync --daemon"
    - require:
      - pkg: rsync-install
      - file: rsync-config
