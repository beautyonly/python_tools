#!/usr/bin/python
# -*- coding: UTF-8 -*-
# yum install -y MySQL-python

import MySQLdb
import sys

if len(sys.argv) != 2:
    print "Usages: python %s endpoint" % (sys.argv[0])
    sys.exit()

endpoint_name = sys.argv[1]

db = MySQLdb.connect("localhost", "root", "", "falcon_portal")
cursor = db.cursor()
rows = cursor.execute("select id from graph.endpoint where endpoint='%s';" % (endpoint_name))
if int(rows) != 0:
    endpoint_id = cursor.fetchone()[0]
    print "endpoint_id : %s" % (endpoint_id)
    cursor.execute("delete from falcon_portal.host where hostname=\"%s\";" % (endpoint_name))
    cursor.execute("delete from graph.endpoint where id=\"%s\";" % (endpoint_id))
    cursor.execute("delete from graph.endpoint_counter where endpoint_id=\"%s\"" % (endpoint_id))
    cursor.execute("delete from graph.tag_endpoint where endpoint_id=\"%s\";" % (endpoint_id))
    print "exec delete is ok"
else:
    print "not find %s endpoint" % (endpoint_name)
db.commit()
db.close()
