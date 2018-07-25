#!/bin/env bash

/etc/init.d/elasticsearch stop
systemctl disable elasticsearch
rpm -e elasticsearch-5.6.7-1.noarch
[ -d /data0/elasticsearch ] && mv /data0/elasticsearch /data0/elasticsearch.`date +%Y%m%d`
