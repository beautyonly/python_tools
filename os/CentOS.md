# 前言
> 警告：最小的权限+最少的服务=最大的安全

# CentOS 6.x安装
## 系统安装
- 获取镜像文件
  ``` text
  阿里云镜像站点：https://opsx.alibaba.com/mirror  (ps：改版后更优化，使用更便利)
  例如：CentOS 6.9
  https://mirrors.aliyun.com/centos/6/isos/x86_64/CentOS-6.9-x86_64-bin-DVD1.iso
  https://mirrors.aliyun.com/centos/6/isos/x86_64/CentOS-6.9-x86_64-bin-DVD2.iso
  ```
- 选择系统引导方式
- 检查安装光盘介质
- 选择安装过程语言
- 选择键盘布局
- 选择物理设备
- 初始化硬盘提示
- 设置主机名及网络配置
- 系统时钟及时区设置
- 设置root管理密码

## 其他补充说明
- 硬盘分区说明
- 软件包选择
  ``` text
  Base System
    Base
    Compatibility libraries
    Debugging Tools
    Dial-up Networking Support
    Hardware monitoring utilities
    Performance Tools
  Development
    Development tools
  ```
- 安装完毕基础配置

# CentOS 7.x安装
# CentOS 6.x vs CentOS 7.x 差异
- 服务管理方式
- MariaDB代替MySQL数据库
- 网卡命名
  > net.ifnames=0 biosdevname=0
# U盘启动盘制作
# FQA
## 1、获取公网IP地址接口
- http://pv.sohu.com/cityjson?ie=utf-8

# 参考资料
