#########################################################################
# File Name: python_version_v1.0.sh 
# Author: mads
# Mail: 1455975151@qq.com
# Created Time: Wed 16 Sep 2015 09:37:43 AM CST
# Description : this is scripts use to 
# Version : v1.0
#########################################################################
#!/bin/bash

. /etc/init.d/functions

RED_COLOR='\E[1;31m'
GREEN_COLOR='\E[1;32m'
YELLOW_COLOR='\E[1;33m'
BLUE_COLOR='\E[1;34m'
RES='\E[0m'

python -V

python26(){
unlink /usr/bin/python
cd /usr/bin/ && ln -s python2.6 python
}

python27(){
unlink /usr/bin/python
cd /usr/bin/ && ln -s /usr/local/python27/bin/python python
}

case "$1" in
  2.6)
        python26
        ;;
  2.7)
        python27
        ;;
  *)
        echo -e $"${GREEN_COLOR}Usage: $0 {2.6|2.7}${RES}"
        exit 1
esac
