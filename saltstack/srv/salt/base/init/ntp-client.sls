install-ntpdate:
  pkg.installed:
    - name: ntpdate

cron-ntpdate:
  cron.present:
    - name: ntpdate cn.pool.ntp.org
    - user: root
    - minute: '*/5'
