#!/bin/env bash

import sys
from ftplib import FTP
ftp_ip = "172.16.0.14"
ftp_user = "xxxx"
ftp_passwd = "xxx"
remote_dir = "yttx/zip"
buf_size = 1024

if len(sys.argv) < 2:
    print("Usages: python %s filename or packages_id") % sys.argv[0]
    print("Example: python %s 180717") % sys.argv[0]
    print("Example: python %s gm_server_7.4.0.0_20170527-180717.zip") % sys.argv[0]
    print("Example: python %s 103459,180330,180717") % sys.argv[0]
    sys.exit(1)

filename = sys.argv[1]

ftp = FTP()
ftp.connect(ftp_ip)
ftp.login(ftp_user, ftp_passwd)
# print(ftp.getwelcome())
ftp.cwd(remote_dir)
for file in filename.split(","):
    filename = file
    for i in ftp.nlst():
        if filename in i:
            filename = i
            file_handle = open(filename, "wb").write
            ftp.retrbinary("RETR %s" % filename, file_handle, buf_size)
            print("download %s is ok" % filename)
ftp.quit()