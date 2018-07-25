# PHP
## PHP概述
- https://webtatic.com/packages/php71/

## 常用架构
- LNMP(推荐)
- LAMP
## 常见框架
- [Laravel](https://www.golaravel.com/)
- Yaf
- ThinkPHP 

## 常用模块
- opcache

## 性能分析
## FQA
- 有可能影响PHP读写MySQL库
  ``` bash
  # php -i | grep Client
  Client API library version => 5.5.50-MariaDB
  Client API header version => 5.5.56-MariaDB
  Client API version => 5.5.50-MariaDB
  
  yum remove -y php-mysql
  yum install -y php-mysqlnd
  ```
- 善用php -i排除问题
  ``` bash
  php.ini 配置修改完成，立即生效，如果发现不生效的情况，通过以下命令进行排查，可以存在多个php.ini文件
  php -i | grep "php.ini"
  ```
## 参考资料
- https://github.com/TIGERB/easy-tips
