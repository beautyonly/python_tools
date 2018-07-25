jdk-file-rsync:
  file.managed:
    - name: /data0/src/jdk-8u112-linux-x64.tar.gz
    - source: salt://init/jdk/files/jdk-8u112-linux-x64.tar.gz
    - user: root
    - group: root
    - mode: 644

jdk-install:
  cmd.run:
    - name: mkdir -p /data0/jdk/ && cd /data0/src/ && tar -zxf jdk-8u112-linux-x64.tar.gz -C /data0/jdk/
    - unless: test -d /data0/jdk/jdk1.8.0_112

jdk-env-config:
  file.append:
    - name: /etc/profile
    - text:
      - export JAVA_PATH=/data0/jdk/jdk1.8.0_112/bin
      - export JAVA_HOME=/data0/jdk/jdk1.8.0_112
      - export CLASSPATH=.::/lib/dt.jar:/lib/tools.jar
      - export JRE_HOME=/data0/jdk/jdk1.8.0_112/jre
      - export PATH=$PATH:$JAVA_PATH
      - export LC_ALL="zh_CN.GBK"
      - export LANG="zh_CN.GBK"
    - unless: grep -E "export JAVA_HOME|export CLASSPATH" /etc/profile
