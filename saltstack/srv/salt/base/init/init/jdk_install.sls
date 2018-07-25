jdk-file-rsync:
  file.managed:
    - name: /tmp/jdk.bin
    - user: root
    - group: root
    - mode: 644

jdk-install:
  cmd.run:
    - name: rpm -ivh /tmp/jdk.bin
  unless: rpm -qa|grep jdk

jdk-env-config:
  file.append:
    - name: /etc/profile
    - text:
      - export JAVA_HOME=/data0/jdk7/usr/java/jdk1.7.0_15
      - export CLASSPATH=.:$CLASSPATH:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
      - export PATH=$JAVA_HOME/bin:$PATH
      - export JRE_HOME=$JAVA_HOME/jre
      - export LC_ALL=zh_CN.GBK
      - export LANG=zh_CN.GBK
    - unless: grep -E "export JAVA_HOME|export CLASSPATH" /etc/profile
