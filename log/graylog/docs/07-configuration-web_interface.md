# Web interface
官网地址：http://docs.graylog.org/en/latest/pages/configuration/web_interface.html

当您的Graylog实例/集群启动并运行时，您通常要做的下一件事就是查看我们的Web界面，该界面为您提供了搜索和分析索引数据以及配置Graylog环境的强大功能。默认情况下，您可以使用浏览器访问它http://<graylog-server>:9000/api/。

## Overview 概述
Graylog网页界面在JavaScript for 2.0中被重写为客户端单页面浏览器应用程序。这意味着它的代码仅在您的浏览器中运行，通过您的Graylog服务器的REST API通过HTTP（S）获取所有数据。

## Single or separate listeners for web interface and REST API?
## Configuration Options 配置选项
## How does the web interface connect to the Graylog server? Web界面如何连接到graylog服务器

## Browser Compatibility 浏览器兼容

## Making the web interface work with load balancers/proxies web界面适用的负载均衡
nginx
apache
haproxy
