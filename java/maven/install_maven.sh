#!/bin/env bash

source_install(){
java -version

wget http://apache.communilink.net/maven/maven-3/3.5.3/binaries/apache-maven-3.5.3-bin.tar.gz
tar -zxf apache-maven-3.5.3-bin.tar.gz -C /usr/local/

}

yum_install(){
yum install -y maven
mvn -v
}

main(){
yum_install
}
