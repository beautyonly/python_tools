#!/bin/bash

## ���ִ�иýű�
## Nginx ��־�ļ����ڵ�Ŀ¼
LOGS_PATH=/usr/local/nginx/logs
## ��ȡ����� yyyy-MM-dd
YESTERDAY=$(date -d "yesterday" +%Y-%m-%d)
## �ƶ��ļ�
cd ${LOGS_PATH}
for i in `ls *.log`
do
	mv ${LOGS_PATH}/$i ${LOGS_PATH}/${i}_${YESTERDAY}
done
## �� Nginx �����̷��� USR1 �źš�USR1 �ź������´���־�ļ�
kill -USR1 $(cat /usr/local/nginx/logs/nginx.pid)

## ɾ��һ��ǰ����־�ļ�
DELDAY=`date -d "-1 week" +%Y-%m-%d`
rm -f *_${DELDAY}
