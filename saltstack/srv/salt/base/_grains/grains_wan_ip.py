#!/usr/bin/env python
# -*- coding:utf-8 -*-

import os
import sys
import commands
import re
import urllib2


def visit(url):
    opener = urllib2.urlopen(url)
    if url == opener.geturl():
        str = opener.read()
    return re.search('\d+\.\d+\.\d+\.\d+',str).group(0)

def Grains_Get_Wan_Ip():
   '''
      return os wan ip of grains value
   '''
   grains = {}

   try:
       myip = visit("http://city.ip138.com/ip2city.asp?")
   except:
       try:
           myip = visit("http://www.bliao.com/ip.phtml")
       except:
           try:
               myip = visit("http://ip.chinaz.com/getip.aspx")
           except:
               myip = "None"
   grains['ipv4_wan'] = myip
   return grains
