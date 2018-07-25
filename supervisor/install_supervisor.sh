#!/bin/env bash

pip_install(){
yum install -y python-pip
pip install supervisor
mkdir -p /etc/supervisord.d
echo_supervisord_conf >/etc/supervisord.conf
sed -i 's#;[include]#[include]#g' /etc/supervisord.conf
sed -i 's#;files = relative/directory/*.ini#files = /etc/supervisord.d/*.ini#g' /etc/supervisord.conf

grep -q 09348c20a019be0318387c08df7a783d /etc/supervisord.conf
[ $? ! -eq 0 ] && cat>>/etc/supervisord.conf<<EOF

[inet_http_server]
port=0.0.0.0:9001
username=supervisor
password=09348c20a019be0318387c08df7a783d
EOF

supervisord -c /etc/supervisord.conf
}

yum_install(){
yum install -y supervisor
systemctl start supervisord.service 
systemctl enable supervisord.service
}

main(){
# pip_install
yum_install
}

main
