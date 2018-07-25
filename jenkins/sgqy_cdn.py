#!/usr/bin/env python

import sys
import re
import commands

print sys.argv[0]
print sys.argv[1]
print sys.argv[2]
cdn_languages = sys.argv[1]
cdn_version = sys.argv[2]
result = re.findall('^(\d+)', cdn_version)
if result:
    if cdn_languages == 'mg-sgqy-cn':
        status, output = commands.getstatusoutput(
            'scp -r /data0/cdn/sgqy/%s root@cn.cdn:/data0/cdn/sgqy/%s' % (cdn_version, cdn_version))
        if status == 0:
            print "update cn.cdn----%s sucessed" % cdn_version
    elif cdn_languages == 'mg-sgqy-tw':
        status, output = commands.getstatusoutput(
            'scp -r /data0/cdn/sgqy/%s root@tw.cdn:/data0/cdn/sgqy/%s' % (cdn_version, cdn_version))
        if status == 0:
            print "update tw.cdn---%s  sucessed" % cdn_version
else:
    status, output = commands.getstatusoutput(
        "scp -r /data0/game_packages/sgqy/apk/%s root@cn.cdn:/data0/cdn/sgqy/%s" % (cdn_version, cdn_version))
    print status
    print type(status)
    if status == 0:
        print "upload apk---%s  sucessed" % cdn_version
