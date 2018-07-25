#!/usr/bin/env python
# -*- coding:utf-8 -*-

import os
import sys
import commands

def Grains_Os_Users():
    '''
        return os user list of grains value
    '''
    grains = {}
    user_list = []
    try:
        f=open('/etc/passwd')
        for line in f.readlines(): 
            info = line.strip('\n')
            user = info.split(":")[0]
            user_list.append(user)
    except Exception,e:
        pass

    grains['user_list'] = user_list
    return grains
