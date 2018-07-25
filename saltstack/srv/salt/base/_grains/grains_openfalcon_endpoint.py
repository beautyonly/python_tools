#!/usr/bin/env python
# -*- coding:utf-8 -*-

import os
import sys
import commands

def Grains_openfalcon_endpoint():
    '''
        return openfalcon endpoint of grains value
    '''
    grains = {}

    try:
        f = open('/usr/local/workspace/agent/cfg.json')
        for line in f.readlines():                        
            if "hostname" in line:
	        info = line.strip('\n')
		endpoint = info.split("\"")[3]
    except Exception,e:
        pass

    _openfalcon_endpoint=endpoint
    grains['openfalcon_endpoint'] = _openfalcon_endpoint
    return grains

