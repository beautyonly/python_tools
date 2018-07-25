#!/bin/env bash

docker_version="docker-ce-17.06.2.ce"
docker_version="docker-ce-18.03.1.ce" # 2018.07.15

install_repo(){
wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
}

install_docker_ce(){
yum remove -y docker docker-common docker-selinux docker-engine
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum-config-manager --enable docker-ce-edge
yum-config-manager --enable docker-ce-test
yum list docker-ce --showduplicates | sort -r |grep stable
yum install -y ${docker_version}
systemctl start docker
systemctl enable docker

mkdir -p /etc/docker                                            # 为了后期方便添加阿里云的加速镜像站
tee /etc/docker/daemon.json <<-'EOF'
{
 "registry-mirrors": ["https://k9lgui7f.mirror.aliyuncs.com"]
}
EOF
systemctl daemon-reload
systemctl restart docker
yum install -y docker-compose
docker version
}

main(){
#install_repo
install_docker_ce
}

main
