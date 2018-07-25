#!/usr/bin/env python
# -*- coding: utf-8 -*-
import redis
import time
 
start = time.clock()
 
redisClient = redis.StrictRedis(host='localhost',port=6379,db=0,password='123456')
f = open('result.txt','r')
while True:
    line = f.readline()
    if not line:
        break
    lines = line.replace("\n","").replace("\r\n","").split("----")
    redisClient.hset(lines[0],"id",lines[0])
    redisClient.hset(lines[0],"name",lines[1])
    redisClient.hset(lines[0],"password",lines[2])
    redisClient.hset(lines[0],"email",lines[3])
    redisClient.hset(lines[0],"phone",lines[4])
f.close()
 
end = time.clock()
 
print "used:", end -start
