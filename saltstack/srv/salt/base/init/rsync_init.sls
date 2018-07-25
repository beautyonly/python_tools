rsync:
  pkg:
    - name: rsync
    - pkgs:
      - rsync
    - installed

  cmd.run:
    - names:
      - /usr/bin/rsync --config=/etc/rsyncd.conf --daemon
      - echo "/usr/bin/rsync --config=/etc/rsyncd.conf --daemon" >>/etc/rc.local
    - unless: /bin/grep rsyncd.conf /etc/rc.local

  service.running:
    - name: rsync
    - enable: True
    - reload: True
    - watch:
      - pkg: rsync
      - file: /etc/rsyncd.conf

/etc/rsyncd.conf:
  file.managed:
    - source: salt://conf/rsync/rsyncd.conf
    - user: root
    - group: root
    - mode: 644
