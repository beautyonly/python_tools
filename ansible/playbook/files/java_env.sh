#!/bin/env bash


sed -i '/# JAVA bin PATH setup/d' /etc/profile
sed -i '/jdk1.8.0_161/d' /etc/profile
sed -i '/JAVA_HOME/d' /etc/profile
sed -i '/JRE_HOME/d' /etc/profile
sed -i '/CLASSPATH/d' /etc/profile

cat>>/etc/profile<<EOF

# JAVA bin PATH setup
export JAVA_HOME=/usr/java/jdk1.8.0_161/
export CLASSPATH=.:\$JAVA_HOME/jre/lib/rt.jar:\$JAVA_HOME/lib/dt.jar:\$JAVA_HOME/lib/tools.jar
export PATH=\$PATH:\$JAVA_HOME/bin
EOF
source /etc/profile
