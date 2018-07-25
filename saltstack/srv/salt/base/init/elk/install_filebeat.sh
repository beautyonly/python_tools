#!/bin/bash

remote_host="27.131.222.29"
src_dir="/data0/src"
filename="filebeat-5.1.1-linux-x86_64.tar.gz"

filebeat_repare()
{
    yum install nmap -y
    nmap -sS 27.131.221.30 -p 9200
    if [ $? == 0 ];then
    	if [ ! -d $src_dir ]
            then
                mkdir $src_dir
        fi
    else
	echo "ELK server port 9200 connot connection"
	exit
    fi
}

filebeat_install()
{
    cd $src_dir
    rsync -av $remote_host::ZEUS/sadir/inithosts/src/elk/filebeat-5.1.1-linux-x86_64.tar.gz .
    rsync -av $remote_host::ZEUS/sadir/inithosts/src/elk/filebeat.yml .
    rsync -av $remote_host::ZEUS/sadir/inithosts/src/elk/filebeat .

    tar -xvf $filename -C /usr/local/
    cd /usr/local
    mv filebeat-5.1.1-linux-x86_64 filebeat
    
    if [ -f /usr/local/filebeat/filebeat.yml ]
    then
        cd /usr/local/filebeat
        mv filebeat.yml filebeat.yml.bak
        cp $src_dir/filebeat.yml .
    fi

    if [ ! -f /etc/init.d/filebeat ];then
	cp $src_dir/filebeat /etc/init.d/
    else
	mv /etc/init.d/filebeat /etc/init.d/filebeat.bak
	cp $src_dir/filebeat /etc/init.d/
    fi
    chmod +x /etc/init.d/filebeat

    if [ ! -f /var/log/filebeat ];then
	mkdir /var/log/filebeat
    fi
}

filebeat_config()
{
    name=`cat /usr/local/workspace/agent/cfg.json |grep hostname |awk -F '\"' '{print $4}'|awk -F '-' '{print $5}'`
    tags=`cat /usr/local/workspace/agent/cfg.json |grep hostname |awk -F '\"' '{print $4}'|awk -F '-' '{print $1}'`

    sed -i '/^name/{s/\: \"/&'$name'/}' /usr/local/filebeat/filebeat.yml 
    sed -i '/^tags/{s/\: \[\"/&'$tags'/}' /usr/local/filebeat/filebeat.yml 
}

filebeat_start()
{
    echo "/etc/init.d/filebeat start" >>/etc/rc.local 
    /etc/init.d/filebeat start &
}


main(){
filebeat_repare
filebeat_install
filebeat_config
filebeat_start
}
main



