#!/bin/env bash

sed -i '/set for nodejs/d' /etc/profile
sed -i '/NODE_HOME/d' /etc/profile

cat>>/etc/profile<<EOF

# set for nodejs
export NODE_HOME=/usr/local/node
export PATH=\$NODE_HOME/bin:\$PATH
EOF
source /etc/profile

