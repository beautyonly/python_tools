#!/bin/env python

if [ ! $# -eq 1 ]
then
    echo "Usages:$0 key_name"
    exit 1
fi
key_name=$1
cd /etc/salt/pki/master/minions
if [ -f ${key_name} ]
then
    rm -f ${key_name}
    if [ $? -eq 0 ]
    then
        echo "remove ${key_name} is ok"
    else
        echo "remove ${key_name} is fail"
    fi
else
    echo "${key_name} is not exist !!!"
fi
