#!/bin/env bash

device_flag="vdb"
device_name="/dev/${device_flag}"
if [ ! -b ${device_name} ]
then
    echo "${device_name} is not exist!!!"
    exit 1
else
count=`df -Th|grep ${device_name}1|wc -l`
if [ ! ${count} -eq 1 ]
then
echo "start fdisk ${device_name}"
fdisk ${device_name} <<EOF
n
p
1


w
EOF
    echo "start format ${device_name}1"
    mkfs.ext4 ${device_name}1

    echo "start mount ${device_name}1"
    mkdir -p /data0/src
    mount ${device_name}1 /data0

    echo "add mount config ${device_name}1"
    sed -i "/\/dev\/${device_flag}1/d" /etc/fstab
    echo "${device_name}1            /data0               ext4       defaults              0 0" >> /etc/fstab
else    
    echo "${device_name}1 is mounted"
fi

fi
