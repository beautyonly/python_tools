# LNMP环境
## LNMP概述
LNMP就是Linux+Nginx+MySQL+PHP，Linux作为服务器的操作系统，MySQL即为数据库。本文主要介绍PHP和Nginx的关系。

Nginx为一款高性能Web服务器，本身是不能处理PHP的，当接收到请求时，判断如果是PHP请求就会将请求交给PHP解释器处理，然后将结果返回给Client。Nginx一般把请求转发给fast-cgi管理进程处理，fast-cgi管理进程再选择cgi子进程处理请求，然后把结果返给Nginx。

### Apache+PHP和Nginx+PHP区别
Apache一般是把PHP当做自己的一个模块来启动；而Ngnix则是把http请求变量转发给PHP进程，即PHP独立进程，与Ngnix通信，这种方式叫做Fast-CGI运行方式。所以Apache所编译的PHP不能用于Nginx。
Nginx+PHP的基本结构图如下：
![images](https://github.com/mds1455975151/tools/blob/master/lnmp/images/01.png)

### 什么是Fast-CGI
Fast-CGI是一个可伸缩的、高速的在HTTP server和动态脚本语言间通信的接口。多数流行的HTTP server都支持Fast-CGI，包括Apache、Nginx和lighttpd等。同时，Fast-CGI也被许多脚本语言支持，其中就有PHP。

Fast-CGI是从CGI发展改进而来的。传统CGI接口方式的主要缺点是性能很差，因为每次HTTP服务器遇到动态程序时都需要重新启动脚本解析器来执行解析，然后将结果返回给HTTP服务器。这在处理高并发访问时几乎是不可用的。另外传统的CGI接口方式安全性也很差，现在已经很少使用了。

FastCGI接口方式采用C/S结构，可以将HTTP服务器和脚本解析服务器分开，同时在脚本解析服务器上启动一个或者多个脚本解析守护进程。当HTTP服务器每次遇到动态程序时，可以将其直接交付给Fast-CGI进程来执行，然后将得到的结果返回给浏览器。这种方式可以让HTTP服务器专一地处理静态请求或者将动态脚本服务器的结果返回给客户端，这在很大程度上提高了整个应用系统的性能。
### Nginx+Fast-CGI运行原理
Nginx不支持对外部程序的直接调用或者解析，所有的外部程序（包括PHP）必须通过Fast-CGI接口来调用。Fast-CGI接口在Linux下是socket（这个socket可以是文件socket，也可以是ip socket）。

wrapper：为了调用CGI程序，还需要一个Fast-CGI的wrapper（wrapper可以理解为用于启动另一个程序的程序），这个wrapper绑定在某个固定socket上，如端口或者文件socket。当Nginx将CGI请求发送给这个socket的时候，通过Fast-CGI接口，wrapper接收到请求，然后Fork（派生）出一个新的线程，这个线程调用解释器或者外部程序处理脚本并读取返回数据；接着，wrapper再将返回的数据通过Fast-CGI接口，沿着固定的socket传递给Nginx；最后，Nginx将返回的数据（html页面或者图片）发送给客户端。这就是Nginx+Fast-CGI的整个运作过程。
  
![images](https://github.com/mds1455975151/tools/blob/master/lnmp/images/02.png)

所以，我们首先需要一个wrapper，这个wrapper需要完成的工作：

> 1、通过调用fast-cgi（库）的函数通过socket和Nginx通信（读写socket是fast-cgi内部实现的功能，对wrapper是非透明的） 

> 2、调度thread，进行fork和kill

> 3、和application（php）进行通信

### 简述php-fpm
PHP-FPM是一个PHP FastCGI管理器，是只用于PHP的，它其实是PHP源代码的一个补丁，旨在将Fast-CGI进程管理整合进PHP包中。必须将它patch到你的PHP源代码中，在编译安装PHP后才可以使用。新版的PHP已经集成了php-fpm，在./configure的时候带 –enable-fpm参数即可开启PHP-FPM。

## 部署说明
### Linux
- https://lnmp.org/install.html，[GitHub](https://github.com/licess/lnmp)
- https://bbs.vpser.net/forum-25-1.html
- https://www.wdlinux.cn/bbs/forum-5-1.html
- https://blog.linuxeye.cn/31.html
- https://oneinstack.com/

### Windows
- https://www.apachefriends.org/zh_cn/index.html
- http://www.wampserver.com/en/

## FQA

## 参考资料
