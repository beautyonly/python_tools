#!/bin/env bash
# 使用etcd自带命令etcdctl进行etc备份

date_time=`date +%Y%m%d`

mkdir -p /data0/backup/etcd_backup
etcdctl backup --data-dir /var/lib/etcd/default.etcd/ --backup-dir /data0/backup/etcd_backup/${date_time}

find /data0/backup/etcd_backup -ctime +7 -exec rm -r {} \;
