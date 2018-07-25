#!/bin/sh

NowDate=`date +%Y%m%d%H%M`
#Date1=`date +%Y%m%d`
#Date2=`date -d "-90 day" +%Y%m%d`
Date1="20150518"
Date2="20150618"
Scripts="/data2/xxx/fenghao_217.sh"
SelectLog="/data2/xxx/fenghao_217.log"
FtpServer="xxx"
FtpUsername="xx"
FtpPassword="xxx"
FtpPort="2021"
RemoteDir="fenghao/"
LocalDir="/data2/xxx/"
FtpGet="mget"
FtpPut="mput"
InFile="account.txt"
OutFile="account_result.txt"

function Ftp_results(){
/usr/kerberos/bin/ftp -v -n $FtpServer $FtpPort<<EOF
user $FtpUsername $FtpPassword
binary
prompt
lcd $LocalDir
cd $RemoteDir
$1 $2
bye
EOF
echo "$NowDate FTP get is OK" >>$SelectLog
}

}
# 下载文件
Ftp_results $FtpGet $InFile 

# 上传文件 
Ftp_results $FtpPut $OutFile

#待补充
#1、批量上传很多文件
