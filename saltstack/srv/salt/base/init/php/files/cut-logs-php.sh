#!/bin/bash

LOGS_PATH=/usr/local/php/var/log
## 获取昨天的 yyyy-MM-dd
YESTERDAY=$(date -d "yesterday" +%Y-%m-%d)
## 移动文件
cd ${LOGS_PATH}
for i in `ls *.log`
do
        mv ${LOGS_PATH}/$i ${LOGS_PATH}/${i}_${YESTERDAY}
done
## 向 php-fpm 主进程发送 USR1 信号。USR1 信号是重新打开日志文件
kill -USR1 $(cat /usr/local/php/var/run/php-fpm.pid)

## 删除一周前的日志文件
DELDAY=`date -d "-1 week" +%Y-%m-%d`
rm -f *_${DELDAY}
