#!/bin/env bash

select_db(){
mysql -uroot -p123456 -e "select * from dbproxy.server_info;"
mysql -uroot -p123456 -e "select * from dbproxy.split_table_info;"
mysql -uroot -p123456 -e "select * from dbproxy.table_info;"
mysql -uroot -p123456 -e "show databases;"
mysql -uroot -p123456 -e "use loveworld;show tables;"
mysql -uroot -p123456 -e "use loveworld_0;show tables;"
mysql -uroot -p123456 -e "use loveworld_1;show tables;"
}

clean_db(){
mysql -uroot -p123456 -e "drop database dbproxy;"
mysql -uroot -p123456 -e "drop database loveworld;"
mysql -uroot -p123456 -e "drop database loveworld_0;"
mysql -uroot -p123456 -e "drop database loveworld_1;"
mysql -uroot -p123456 -e "show databases;"
}

case "$1" in
  select)
        select_db
        ;;
  clean)
        clean_db
        ;;
  *)
        echo -e $"${GREEN_COLOR}Usage: $0 {select|clean}${RES}"
        exit 1
esac
