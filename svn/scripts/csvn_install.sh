#!/bin/bash

. /etc/init.d/functions

RED_COLOR='\E[1;31m'
GREEN_COLOR='\E[1;32m'
YELLOW_COLOR='\E[1;33m'
BLUE_COLOR='\E[1;34m'
RES='\E[0m'

URL='208.gyyx.cn/mds/mads'
work_dir='/root'
jdk_version='jdk-7u71-linux-x64.rpm'
csvn_version='CollabNetSubversionEdge-5.1.0_linux-x86_64.tar.gz'
csvn_install_dir='/data'

jdk_install(){
wget ${URL}/${jdk_version}
rpm -ivh ${jdk_version}
cat>>/etc/profile<<EOF
#set java environment
JAVA_HOME=/usr/java/jdk1.7.0_71
JAVA_BIN=/usr/java/jdk1.7.0_71/bin
CLASSPATH=.:\$JAVA_HOME/lib/dt.jar:\$JAVA_HOME/lib/tools.jar
PATH=\$JAVA_BIN:\$PATH
export PATH JAVA_HOME CLASSPATH
EOF

source /etc/profile
java -version
}

csvn_install(){
grep -q csvn /etc/passwd
if [ $? -eq 0 ]
then
	echo -e "${RED_COLOR}csvn user is exit!!!${RES}"
else
	useradd csvn
fi

mkdir -p  ${csvn_install_dir}
wget ${URL}/${csvn_version}
tar -zxf ${csvn_version} -C ${csvn_version}
cd ${csvn_install_dir} && chown -R csvn:csvn csvn
echo "csvn ALL=(root) NOPASSWD: ALL">>/etc/sudoers
visudo -c
su - csvn -s /bin/bash sudo -E ${csvn_install_dir}/csvn/bin/csvn install
chown root:csvn ${csvn_install_dir}/csvn/lib/httpd_bind/httpd_bind
chmod u+s ${csvn_install_dir}/csvn/lib/httpd_bind/httpd_bind 
su - csvn -s ${csvn_install_dir}/csvn/bin/csvn start
/etc/init.d/csvn status
netstat -tunlp
}

jdk_install
csvn_install
