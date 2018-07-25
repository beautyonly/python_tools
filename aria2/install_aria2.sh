#!/bin/env bash

install_aria2(){
wget https://github.com/aria2/aria2/releases/download/release-1.33.1/aria2-1.33.1.tar.gz
tar -zxf aria2-1.33.1.tar.gz 
cd aria2-1.33.1/
./configure 
make && make install

aria2c --enable-rpc --rpc-listen-all --rpc-allow-origin-all -c  --dir /root/downloads -D
aria2c --conf-path aria2.conf --dir /root/downloads -D

mkdir -p /data0/
cd /data0/ && git clone https://github.com/ziahamza/webui-aria2
cd webui-aria2/ && python -m SimpleHTTPServer 9999
mkdir webui-aria2/logs
}

main(){
install_aria2
}

main
