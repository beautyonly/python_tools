# Nginx + PHP
- 1、2018/05/08 14:12:19 [info] 31490#0: *110 recv() failed (104: Connection reset by peer) while waiting for request, client: 61.129.7.228, server: 0.0.0.0:80

> 在php.ini和php-fpm.conf中分别有这样两个配置项：max_execution_time和request_terminate_timeout。这两项都是用来配置一个PHP脚本的最大执行时间的。当超过这个时间时，PHP-FPM不只会终止脚本的执行，还会终止执行脚本的Worker进程。所以Nginx会发现与自己通信的连接断掉了，就会返回给客户端502错误。
