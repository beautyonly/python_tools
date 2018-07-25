#!/bin/env bash

shell_retry(){
n=0
timeout=3
until [ $n -ge $timeout ]
do
    ls -al /tmpx
    if [ $? -eq 0 ]
    then
        return
    fi
    n=$((n+1))
    echo "sleep 1 second"
    sleep 1
done
}

main(){
shell_retry
}

main
