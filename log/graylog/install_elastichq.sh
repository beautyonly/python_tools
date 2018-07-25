#!/bin/env bash

yum install -y python34
python3.4 -V
mkdir -p /data0/src/
cd /data0/ && git clone https://github.com/ElasticHQ/elasticsearch-HQ
cd elasticsearch-HQ/
python3.4 install -r requirements.txt
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3.4 get-pip.py
pip3 install -r requirements.txt
#python3.4 application.py
#nohup python3.4 application.py &
cd /data0/src/ && wget https://raw.githubusercontent.com/mds1455975151/tools/master/supervisor/install_supervisor.sh
sh install_supervisor.sh

cat>/etc/supervisord.d/ElasticHQ.ini<<EOF
[program:ElasticHQ]
directory = /data0/elasticsearch-HQ/
command = python3.4 application.py
priority=1
numprocs=1
autostart=true
autorestart=true
stderr_logfile=/var/log/ElasticHQ_err.log
stdout_logfile=/var/log/ElasticHQ_out.log
EOF
systemctl restart supervisord.service
