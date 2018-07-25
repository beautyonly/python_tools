#!/bin/bash

. /etc/init.d/functions

RED_COLOR='\E[1;31m'
GREEN_COLOR='\E[1;32m'
YELLOW_COLOR='\E[1;33m'
BLUE_COLOR='\E[1;34m'
RES='\E[0m'

SVNBOOT='/application/svndata'
SVNAUTH='/application/svnpasswd'
SVNBACKUP='/application/svnback'

if [ $# != 1 ]; then
        echo -e "${GREEN_COLOR}Useage:$0 svnname ${RES}"
        exit 1
fi

SVNNAME=$1
svn_install(){
rpm -qa|grep subversion >/dev/null 2>&1
if [ $? -eq 1 ]
then
    yum install -y subversion
fi

[ -d $SVNBOOT ] || mkdir -p $SVNBOOT
[ -d $SVNAUTH ] || mkdir -p $SVNAUTH

cd $SVNBOOT && svnadmin create $SVNNAME
[ ! -f $SVNAUTH/authz ] && cp $SVNBOOT/$SVNNAME/conf/authz $SVNAUTH
[ ! -f $SVNAUTH/passwd ] && cp $SVNBOOT/$SVNNAME/conf/passwd $SVNAUTH

sed -i 's/# anon-access = read/anon-access = none/g' $SVNBOOT/$SVNNAME/conf/svnserve.conf   
sed -i 's/# auth-access = write/auth-access = write/g' $SVNBOOT/$SVNNAME/conf/svnserve.conf  
sed -i "s@# password-db = passwd@password-db = ${SVNAUTH}/passwd@g" $SVNBOOT/$SVNNAME/conf/svnserve.conf  
sed -i "s@# authz-db = authz@authz-db = ${SVNAUTH}/authz@g"  $SVNBOOT/$SVNNAME/conf/svnserve.conf  
sed -i 's/# realm = My First Repository/realm = gyyx game Repository/g'  $SVNBOOT/$SVNNAME/conf/svnserve.conf

cat >> $SVNAUTH/passwd<<EOF
$SVNNAME = admin
nor_publish_account = publish123
test_publish_account = publish456
test = test
EOF
sed -i '$d' $SVNAUTH/passwd

sed -i "21 aadmin = $SVNNAME" $SVNAUTH/authz
cat >> $SVNAUTH/authz<<EOF
 
[$SVNNAME:/]  
@admin = rw
  
[$SVNNAME:/]  
test = r
EOF

cd $SVNAUTH && chmod 700 *					
pkill svnserve
svnserve -d -r $SVNBOOT --listen-port=3000
grep -q svnserve /etc/rc.local 
if [ $? -eq 1 ]
then
    echo -e "\n#svn sevser start by mads `date +%Y%m%d`\nsvnserve -d -r $SVNBOOT --listen-port=3000" >>/etc/rc.local 
fi

cd /tmp && mkdir -p svndata/{branch,tags,trunk}
svn import /tmp/svndata/ file:///$SVNBOOT/$SVNNAME/ -m "Initsvn import"
echo -e ${GREEN_COLOR}account:$SVNNAME---password:admin123---authorization:rw${RES}
echo -e ${GREEN_COLOR}account:test---password:test123456---authorization:r${RES}
}

svn_backup(){
[ -d $SVNBACKUP ] || mkdir -p $SVNBACKUP
[ ! -f $SVNBACKUP/svn_back.sh ] && [ -f ./svn_back.sh ] && cp svn_back.sh $SVNBACKUP/svn_back.sh
[ ! -f $SVNBACKUP/svn_back.sh ] && wget -O $SVNBACKUP/svn_back.sh -q http://208.gyyx.cn/mds/mads/svn/svn_back.sh
chmod +x $SVNBACKUP/svn_back.sh
grep -q $SVNBOOT/$SVNNAME /var/spool/cron/root
if [ $? -eq 1 ]
then
    echo -e "\n#svn sevser bacup $SVNBOOT/$SVNNAME start by mads `date +%Y%m%d`\n0 0 * * * /bin/bash $SVNBACKUP/svn_back.sh $SVNNAME >/dev/null 2>&1 " >>/var/spool/cron/root
fi
}

svn_install
svn_backup
