#!/bin/bash

. /etc/init.d/functions

RED_COLOR='\E[1;31m'
GREEN_COLOR='\E[1;32m'
YELLOW_COLOR='\E[1;33m'
BLUE_COLOR='\E[1;34m'
RES='\E[0m'

if [ $# != 1 ]; then
   echo -e "${GREEN_COLOR}Useage:$0 svnname ${RES}"
   exit 1
fi

SVNNAME=$1

SVNBOOT='/application/svndata'
SVNAUTH='/application/svnpasswd'
LOGFILE="/tmp/svn_backup_${SVNNAME}.log"
NOWTIME=`date +%Y%m%d`
BACKUPDIR="/backup/svn/${SVNNAME}"


[ -d $BACKUPDIR ] || mkdir -p $BACKUPDIR
#配置文件备份
if [ -d ${SVNBOOT}/$SVNNAME ]
then
	cd ${SVNBOOT}/$SVNNAME && tar -zcf $BACKUPDIR/svn_`basename ${SVNNAME}`_${NOWTIME}.tar.gz ./conf/*
else
	echo "SVN `basename ${SVNBOOT}/${SVNNAME}` is not exist !!!"
fi

#全量备份
curr=`/usr/bin/svnlook youngest ${SVNBOOT}/$SVNNAME`  #此处是查询工程目录的最新版本
/usr/bin/svnadmin dump ${SVNBOOT}/$SVNNAME --revision 0:$curr --incremental  >$BACKUPDIR/0-"$curr"_svn_`basename ${SVNNAME}`.$NOWTIME
echo $curr >$LOGFILE
