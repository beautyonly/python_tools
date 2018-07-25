#!/bin/env bash

wget https://dl.google.com/go/go1.10.1.linux-amd64.tar.gz
tar -zxf go1.10.1.linux-amd64.tar.gz -C /usr/local/
grep -q GOPATH /etc/profile
[ ! $? -eq 0 ] && cat>>/etc/profile<<EOF

# setup go path env
export PATH=\$PATH:/usr/local/go/bin
export GOPATH="/data0/workspaces/go"
EOF
source /etc/profile
go env
mkdir -p /data0/workspaces/go
