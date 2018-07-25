#!/bin/env bash

export FALCON_HOME=/home/work
export WORKSPACE=$FALCON_HOME/open-falcon

open_falcon_start(){
cd $WORKSPACE
./open-falcon start graph
./open-falcon start hbs
./open-falcon start judge
./open-falcon start transfer
./open-falcon start nodata
./open-falcon start aggregator
./open-falcon start agent
./open-falcon start gateway
./open-falcon start api
./open-falcon start alarm
}

open_falcon_stop(){
cd $WORKSPACE
./open-falcon stop graph
./open-falcon stop hbs
./open-falcon stop judge
./open-falcon stop transfer
./open-falcon stop nodata
./open-falcon stop aggregator
./open-falcon stop agent
./open-falcon stop gateway
./open-falcon stop api
./open-falcon stop alarm
}

check(){
cd $WORKSPACE
./open-falcon check
}

# See how we were called.
case "$1" in
start)
    open_falcon_start
    ;;
stop)
    open_falcon_stop
    ;;
check)
    check
    ;;
*)
    echo $"Usage: $0 {start|stop|check}"
    exit 2
esac
