#!/bin/env bash

download_dir="/data0/cdb_backup/slowlog"
cat mysql_slowlog_info.txt|while read file_name url type
do
    # echo "wget -O $file_name \"$url\""
    if [ ! -f $download_dir/$file_name ]
    then
        echo "start download $file_name"
        wget -O $download_dir/$file_name "$url"
        [ $? -eq 0 ] && echo "download $file_name is ok" || echo "download $file_name is fail"
    fi
done