ntpdate:
  pkg:
    - name: ntpdate
    - pkgs:
      - ntpdate
    - installed

src_rsync:
  file.recurse:
    - name: /srv/salt/ntpd
    - source: salt://conf/ntpd
    - user: root
    - group: root
    - makedirs: True
    - include_empty: True

setup_conf:
  cmd.run:
    - cwd: /srv/salt/ntpd
    - names:
      - cp /etc/ntp.conf{,.`date +%Y%m%d`}
      - cp /srv/salt/ntpd/ntp.conf /etc/
    - unless: test -f /srv/salt/ntpd/ntp.conf
    - require:
      - file: src_rsync 

setup_ntpdate:
  cmd.run:
    - names:
      - echo "5 * * * * /usr/sbin/ntpdate clepsydra.dec.com time.nist.gov >/dev/null 2>&1" >>/var/spool/cron/root
    - unless: test -d /var/spool/cron/root
    - unless: grep clepsydra.dec.com /var/spool/cron/root
    - require:
      - file: src_rsync
