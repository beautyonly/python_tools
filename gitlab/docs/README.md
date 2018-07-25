
1、GitLab官网模块
Feature	特性
Product	制品
Install	安装
Community	社区
Blog	博客
Contact	联系

2、Gitlab Feature
官网地址：https://about.gitlab.com/features/
本节列出了Gitlab中所有可用功能。功能按照解决方案分组，解决方案是DevOps生命周期的阶段或Gitlab的质量属性。
并非所有功能都适用于所有版本。每个功能旁边都有一个图标，用于指示CE\EES或EEP中是否可用。要比较版本，请参考我们的产品页面。

DevOps生命周期的各个阶段：
Plan    
Create   
Verify   
Package    
Release   
Configure    
Monitor   
Gitlab的质量属性：
Scalability    
Availability    
Compliance    
Security    
Services    
Wiki    
Pages    
Service Desk    
Innersourcing    
Integration    
Import    
Open core    
Efficiency    
GitLab.com    
Missing   

3、Gitlab Product 
官网文档：https://about.gitlab.com/products/

4、Gitlab Installation
官网文档：https://about.gitlab.com/installation/

推荐：4G可用内存
4.1 Omnibus package installation (recommended) 软件包安装推荐
https://about.gitlab.com/installation/#centos-7?version=ce
Omnibus Gitlab文档：https://docs.gitlab.com/omnibus/README.html#installation-and-configuration-using-omnibus-package
Omnibus是一种打包运行Gitlab所需的不同服务和工具的方法，因此大多数用户可以在不费力的配置的情况下安装它。
Package information	 包信息
Checking the versions of bundled software	检查捆绑软件的版本
Package defaults	包默认
Deprecated Operating Systems	弃用的操作系统
Signed Packages	签名软件包
Deprecation Policy	弃用政策

Installation 	安装
Prerequisites 先决条件
	Installation Requirements（https://docs.gitlab.com/ce/install/requirements.html）
	If you want to access your GitLab instance via a domain name, like mygitlabinstance.com, make sure the domain correctly points to the IP of the server where GitLab is being installed. You can check this using the command host mygitlabinstance.com
	If you want to use HTTPS on your GitLab instance, make sure you have the SSL certificates for the domain ready. (Note that certain components like Container Registry which can have their own subdomains requires certificates for those subdomains also)
	If you want to send notification emails, install and configure a mail server (MTA) like sendmail. Alternatively, you can use other third party SMTP servers, which is described below.
Installation and Configuration using omnibus package 使用omnibus软件包安装和配置
Note: This section describes the commonly used configuration settings. Check configuration section of the documentation for complete configuration settings.
Installing GitLab	安装Gitlab
Manually downloading and installing a GitLab package

yum install -y curl policycoreutils-python openssh-server openssh-clients
systemctl enable sshd
systemctl start sshd

yum install postfix
systemctl enable postfix
systemctl start postfix

curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.rpm.sh | sudo bash

EXTERNAL_URL="http://192.168.200.117" yum install -y gitlab-ce

Setting up a domain name/URL for the GitLab Instance so that it can be accessed easily		为gitlab设置域名，方便访问
# vim /etc/gitlab/gitlab.rb
external_url "http://gitlab.example.com"
# gitlab-ctl reconfigure
# netstat -tunlp
访问页面：http://192.168.200.117
首次登陆设置密码，账号默认为root

Enabling HTTPS	启用https
Enabling notification EMails	启用通知email
Enabling replying via email	通过邮件启用回复
Installing and configuring postfix
Enabling container registry on GitLab	在gitlab上启用容器注册表
You will require SSL certificates for the domain used for container registry
Enabling GitLab Pages	启用gitlab页面
If you want HTTPS enabled, you will have to get wildcard certificates
Enabling Elasticsearch	启用elasticsearch
GitLab Mattermost Set up the Mattermost messaging app that ships with Omnibus GitLab package.
GitLab Prometheus Set up the Prometheus monitoring included in the Omnibus GitLab package.
GitLab High Availability Roles
Using docker image 使用Docker镜像
You can also use the docker images provided by GitLab to install and configure a GitLab instance. Check the documentation to know more.
Maintenance 	维护
Get service status	获取服务状态
Starting and stopping	启动和停止
Invoking Rake tasks	调试rake任务
Starting a Rails console session	启动rails控制台回话
Starting a Postgres superuser psql session	启动Postgres超级用户psql回话
Container registry garbage collection	容器注册表垃圾收集
Configuring 	配置
Configuring the external url
Configuring a relative URL for Gitlab (experimental)
Storing git data in an alternative directory
Changing the name of the git user group
Specify numeric user and group identifiers
Only start omnibus-gitlab services after a given filesystem is mounted
Disable user and group account management
Disable storage directory management
Configuring Rack attack
SMTP
NGINX
LDAP
Unicorn
Redis
Logs
Database
Reply by email
Environment variables
gitlab.yml
Backups
Pages
SSL
Updating 	更新
Upgrade support policy
Upgrade from Community Edition to Enterprise Edition
Updating to the latest version
Downgrading to an earlier version
Upgrading from a non-Omnibus installation to an Omnibus installation using a backup
Upgrading from non-Omnibus PostgreSQL to an Omnibus installation in-place
Upgrading from non-Omnibus MySQL to an Omnibus installation (version 6.8+)
RPM error: 'package is already installed'
Note about updating from GitLab 6.6 and higher to 7.10 or newer
Updating from GitLab 6.6.0.pre1 to 6.6.4
Updating from GitLab CI version prior to 5.4.0 to the latest version
Troubleshooting 故障排除
Hash Sum mismatch when installing packages
Apt error: 'The requested URL returned error: 403'.
GitLab is unreachable in my browser.
Emails are not being delivered.
Reconfigure freezes at ruby_block[supervise_redis_sleep] action run.
TCP ports for GitLab services are already taken.
Git SSH access stops working on SELinux-enabled systems.
Postgres error 'FATAL: could not create shared memory segment: Cannot allocate memory'.
Reconfigure complains about the GLIBC version.
Reconfigure fails to create the git user.
Failed to modify kernel parameters with sysctl.
I am unable to install omnibus-gitlab without root access.
gitlab-rake assets:precompile fails with 'Permission denied'.
'Short read or OOM loading DB' error.
'pg_dump: aborting because of server version mismatch'
'Errno::ENOMEM: Cannot allocate memory' during backup or upgrade
NGINX error: 'could not build server_names_hash'
Reconfigure fails due to "'root' cannot chown" with NFS root_squash
Omnibus GitLab developer documentation 	Omnibus Gitlab开发人员文档
Development Setup
Omnibus GitLab Architecture
Adding a new Service to Omnibus GitLab
Creating patches
Release process
Building your own package
Building a package from a custom branch
Adding deprecation messages


直接下载RPM包：https://packages.gitlab.com/gitlab/gitlab-ce

4.2 Other official installation methods	其他官网安装方式
4.3 Community contributed 社区贡献

5、GitLab CE手册
https://docs.gitlab.com/ce/README.html

6、Gitlab handbook	团队手册
官网地址：https://about.gitlab.com/handbook/

General	一般
Values	价值观
General Guidelines	一般准则
Handbook Usage	手册使用
Communication
Security	安全
Anti-Harassment Policy	反骚扰政策
Signing legal documents 签署法律文件
Working remotely	远程工作
Tools and tips	工具和技巧
Leadership	领导
Secret Snowflake	密钥
Using Git to update this website	使用git更新网站
People Operations	人员操作
Benefits
Spending Company Money
Travel
Paid time off
Incentives
Onboarding
Hiring
Offboarding
Visas
Engineering
Support
Infrastructure
Database Team
Gitaly Team
Production Team
Security Team
Backend
CI/CD Team
Discussion Team
Platform Team
Prometheus Team
Frontend
Quality
Edge
UX
Build
Marketing
Marketing and Sales development
Content Marketing
Field Marketing
Online Marketing
SDR Handbook
Design
Product Marketing
Marketing Operations
Blog
Social Marketing
Social Media Guidelines
Developer Relations
Sales
Account Management
Customer Success
Sales Operations
Demo
Revenue Operations
Customer Lifecycle
Database Management
Reporting
Finance
Stock Options
Board meetings
Product
Release posts
Live streaming
Making Gifs
Data analysis
Technical Writing
Markdown Guide
Legal
