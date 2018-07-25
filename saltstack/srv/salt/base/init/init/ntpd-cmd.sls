install-ntpdate:
  pkg.installed:
    - name: ntpdate

cron-ntpdate:
  cron.present:
    - name: /usr/sbin/ntpdate clepsydra.dec.com time.nist.gov
    - user: root
    - minute: '*/5'
