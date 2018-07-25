# cygwin
## cygwin概述
官网：http://www.cygwin.com/

## Cynwin部署安装
- 安装源：http://www.cygwin.cn or http://mirrors.aliyun.com/cygwin/
- 安装包选择
  - gcc
  - gcc-c++
  - autoconf
  - automake
  - git
  - curl
  - wget
  - lynx
- 设置系统变量
- 安装[apt-cyg](https://github.com/transcode-open/apt-cyg)
``` bash
wget https://raw.githubusercontent.com/transcode-open/apt-cyg/master/apt-cyg
or 
curl https://raw.githubusercontent.com/transcode-open/apt-cyg/master/apt-cyg -o apt-cyg
install apt-cyg /bin/
```
- 添加鼠标右键
```
# cat cygwin.reg
Windows Registry Editor Version 5.00  
  
[HKEY_CLASSES_ROOT\Directory\Background\shell\OpenCygwin]  
  
[HKEY_CLASSES_ROOT\Directory\Background\shell\OpenCygwin\command]  
@="C:\\cygwin64\\Cygwin.bat" 
```
## FQA

## 参考资料

