/etc/resolv.conf:
  file.managed:
    - source: salt://init/init/files/resolv.conf
    - user: root
    - gourp: root
    - mode: 644
