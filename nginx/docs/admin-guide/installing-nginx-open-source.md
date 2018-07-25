# Installing NGINX Open Source 安装Nginx开源版本

原文地址：https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-open-source/

## Choosing Between a Stable or a Mainline Version
版本选择
  - mainline
  - stable

## Choosing Between a Prebuilt Package and Compiling from Source 选择预编译包和从源码编译
### Installing a Prebuilt Package 
#### Installing Prebuilt CentOS and RHEL Packages
``` bash
yum install epel-release
vi /etc/yum.repos.d/nginx.repo
[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/mainline/centos/7/$basearch/
gpgcheck=0
enabled=1
yum install -y nginx
nginx -v
curl -I 127.0.0.1
```
#### Installing Prebuilt Debian Packages
略
#### Installing Prebuilt Ubuntu Packages
略
#### Installing SUSE Packages
略
### Compiling and Installing from Source 
略
