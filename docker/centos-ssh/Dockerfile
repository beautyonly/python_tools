#Docker for CentoS
FROM centos:7

#Who
MAINTAINER dongsheng.ma@lemongrassmedia.cn

# systemctl
ENV container docker

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;
VOLUME [ "/sys/fs/cgroup" ]

#PKG
RUN rm -f /etc/yum.repos.d/*
ADD epel-7.repo Centos-7.repo /etc/yum.repos.d/
RUN yum install -y wget net-tools openssl-devel openssh-clients openssh-server supervisor ntpdate && yum clean all

# time
RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && ntpdate cn.pool.ntp.org

#FOR SSH
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key
RUN ssh-keygen -A -t dsa -f /etc/ssh/ssh_host_dsa_key

#SET root password
RUN echo "root:123456" | chpasswd

#Supervisor
ADD supervisord.conf /etc/supervisord.conf
ADD sshd.ini /etc/supervisord.d/sshd.ini
ADD init.ini /etc/supervisord.d/init.ini

EXPOSE 22

CMD ["/usr/bin/supervisord","-c","/etc/supervisord.conf"]
