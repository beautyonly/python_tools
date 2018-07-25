ip=`awk -F '[-"]+' '/hostname/{print $(NF-1)}' /usr/local/workspace/agent/cfg.json`
sed -i "s/118.89.54.135/${ip}/g" /usr/local/filebeat/filebeat.yml
awk '/name/{print $0}' /usr/local/filebeat/filebeat.yml

