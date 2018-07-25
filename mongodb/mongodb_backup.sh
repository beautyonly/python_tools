#!/bin/env bash

mkdir -p /data0/backups/mongodb-`date +%Y%m%d`

#mongodump -h 10.1.16.152 -d graylog -o /data0/backups/mongodb-`date +%Y%m%d`
mongodump -h 10.1.16.152 -o /data0/backups/mongodb-`date +%Y%m%d`
