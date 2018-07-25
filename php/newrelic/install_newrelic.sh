#!/bin/env bash
# os: CentOS 7

time_flag=`date +%Y%m%d%H%M%S`
license_key="cfc8926965a3111ec0b28e5a69f114d657a40074"
newrelic_appname=`echo ${time_flag}|md5sum|awk '{print $1}'`

install_newrelic(){
# yum install -y php php-fpm
rpm -Uvh http://yum.newrelic.com/pub/newrelic/el5/x86_64/newrelic-repo-5-3.noarch.rpm
yum install -y newrelic-php5
echo ${license_key}|newrelic-install install

cp /etc/php.d/newrelic.ini{,.`date +%Y%m%d`}
cat >/etc/php.d/newrelic.ini<<EOF
extension = "newrelic.so"
[newrelic]
newrelic.license = "${license_key}"
newrelic.logfile = "/var/log/newrelic/php_agent.log"
newrelic.appname = "${newrelic_appname}"
newrelic.daemon.logfile = "/var/log/newrelic/newrelic-daemon.log"
newrelic.daemon.port = "@newrelic-daemon"
newrelic.transaction_tracer.threshold = "10ms"
EOF
\cp /etc/newrelic/newrelic.cfg.template /etc/newrelic/newrelic.cfg
sed -i 's$#port="/tmp/.newrelic.sock"$port="@newrelic-daemon"$g' /etc/newrelic/newrelic.cfg
sed -i 's$#pidfile=$pidfile=/var/run/newrelic-daemon.pid$g' /etc/newrelic/newrelic.cfg
sed -i 's$#logfile=/var/log/newrelic/newrelic-daemon.log$logfile=/var/log/newrelic/newrelic-daemon.log$g' /etc/newrelic/newrelic.cfg
sed -i 's$#utilization.detect_aws=true$utilization.detect_aws=true$g' /etc/newrelic/newrelic.cfg
/etc/init.d/newrelic-daemon restart
/etc/init.d/newrelic-daemon restart
/etc/init.d/newrelic-daemon restart
systemctl restart php-fpm.service
systemctl restart nginx.service 

# or 
# /usr/bin/newrelic-daemon --agent --pidfile /var/run/newrelic-daemon.pid --logfile /var/log/newrelic/newrelic-daemon.log --port @newrelic-daemon --tls --define utilization.detect_aws=true --define utilization.detect_azure=true --define utilization.detect_gcp=true --define utilization.detect_pcf=true --define utilization.detect_docker=true -no-pidfile
}

main(){
install_newrelic
}

main
