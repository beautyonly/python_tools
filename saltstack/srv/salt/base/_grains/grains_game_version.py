#!/usr/bin/env python
# -*- coding:utf-8 -*-

import os
import sys
import commands

def Grains_yttx_game_version():
    '''
        return yttx game version of grains value
    '''
    grains = {}

    try:
        f = open('/data0/version')
        for line in f.readlines():                        
            if "version" in line:
                info = line.strip('\n')
                print info
                version_info = info.split(" ")
                key = version_info[0].strip('\t')
                value = version_info[1].strip('\t')
                grains["yttx_"+key] = value
    except Exception,e:
        pass

    try:
        f = open('/data0/wg_config/game_server_config/game_server.cfg.js')
        for line in f.readlines():                        
            if "serverId" in line:
                info = line.strip('\n')
                serverid = info.split("=")[1].strip('\r')
                grains["serverId"] = serverid
            elif "config.serverDomain" in line:
                info = line.strip('\n')
                serverDomain = info.split("\"")[1]
                serverName = info.split("\"")[1].split(".")[0]
                grains["serverDomain"] = serverDomain
                grains["serverName"] = serverName
        else:
            pass
    except Exception,e:
        pass

    return grains

