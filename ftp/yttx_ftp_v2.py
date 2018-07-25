#!/bin/env bash
"""
    yttx download program packages from file server
"""

import sys
import socket
import ftplib
from ftplib import FTP

ftp_ip = "172.16.0.14"
ftp_user = "xx"
ftp_passwd = "xxx"
remote_dir = "yttx/zip"
buf_size = 1024


def main(file, ip, user, password, size):
    try:
        ftp = FTP()
        ftp.connect(ip)
    except (socket.error, socket.gaierror):
        print('ERROR:cannot reach " %s"' % ftp_ip)
        return

    try:
        ftp.login(user, password)
    except ftp:
        print('ERROR: cannot login anonymously')
        ftp.quit()
        return

    try:
        ftp.cwd(remote_dir)
    except ftplib.error_perm:
        print('ERRORL cannot CD to "%s"' % remote_dir)
        ftp.quit()
        return
    for f in file.split(","):
        file = f
        for i in ftp.nlst():
            if file in i:
                file = i
                file_handle = open(file, "wb").write
                try:
                    ftp.retrbinary("RETR %s" % file, file_handle, size)
                except ftplib.error_perm:
                    print('ERROR: cannot read file "%s"' % file)
                else:
                    print("down %s is ok" % file)
    ftp.quit()


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usages: python %s filename or packages_id") % sys.argv[0]
        print("Example: python %s 180717") % sys.argv[0]
        print("Example: python %s gm_server_7.4.0.0_20170527-180717.zip") % sys.argv[0]
        print("Example: python %s 103459,180330,180717") % sys.argv[0]
        sys.exit(1)

    filename = sys.argv[1]
    main(filename, ftp_ip, ftp_user, ftp_passwd, buf_size)
