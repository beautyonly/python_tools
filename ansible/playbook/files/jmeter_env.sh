#!/bin/env bash

sed -i '/JMETER bin PATH setup/d' /etc/profile
sed -i '/apache-jmeter-4.0/d' /etc/profile
sed -i '/ApacheJMeter_core.jar/d' /etc/profile

cat>>/etc/profile<<EOF

# JMETER bin PATH setup
JMETER=/usr/local/jmeter/apache-jmeter-4.0
CLASSPATH=\$JMETER/lib/ext/ApacheJMeter_core.jar:\$JMETER/lib/jorphan.jar:\$JMETER/lib/logkit-2.0.jar:\$CLASSPATH
export PATH=\$PATH:\$JMETER/bin
EOF
source /etc/profile

