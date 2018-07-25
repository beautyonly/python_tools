#!/bin/bash

. /etc/init.d/functions

RED_COLOR='\E[1;31m'
GREEN_COLOR='\E[1;32m'
YELLOW_COLOR='\E[1;33m'
BLUE_COLOR='\E[1;34m'
RES='\E[0m'

game_name="$2"

testa(){
    salt 'xxxx' saltutil.sync_all
    salt 'xxxx' sys.reload_modules
    salt 'xxxx' grains.items
}

dev(){
    salt 'xxxx' saltutil.sync_all
    salt 'xxxx' sys.reload_modules
    salt 'xxxx' grains.items
}

prod(){
    salt "${game_name}*" saltutil.sync_all
    salt "${game_name}*" sys.reload_modules
}

case "$1" in
    testa)
        testa && exit 0
        ;;
    dev)
        dev && exit 0
        ;;
    prod)
        prod || exit 0
        ;;
    *)
        echo -e $"${GREEN_COLOR}Usage: $0 {testa|dev|prod} {YTTX|SGQY}${RES}"
        exit 2
esac
