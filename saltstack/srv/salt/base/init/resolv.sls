/etc/resolv.conf:  
  file.managed:  
    - source: salt://conf/dns/resolv.conf
    - user: root
    - group: root
    - mode: 644
    - template: jinja
