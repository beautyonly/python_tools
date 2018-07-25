# Installing Graylog 安装Graylog
Graylog可以使用很多不同方式进行安装，可以选择最适合您的任何方式。我们建议从虚拟设备机器开始，以最快的方式开始，然后选择其他更灵活的安装方式之一来构建更易扩展的设置。

# Choose an installation method 选择安装方式
- Virtual Machine Appliances
- Operating System Packages
    - Ubuntu installation
    - Debian installation
    - CentOS installation
    - SLES installation
- Chef, Puppet, Ansible
- Docker
- Vagrant
- OpenStack
- Amazon Web Services
- Microsoft Windows
- Manual Setup

# System requirements 系统要求
The Graylog server application has the following prerequisites:
  - Some modern Linux distribution (Debian Linux, Ubuntu Linux, or CentOS recommended)
  - Elasticsearch 2.3.5 or later
  - MongoDB 2.4 or later (latest stable version is recommended)
  - Oracle Java SE 8 (OpenJDK 8 also works; latest stable update is recommended)

Caution
> Graylog prior to 2.3 does not work with Elasticsearch 5.x!
> Graylog 2.4 does not work with Elasticsearch 6.x yet!
