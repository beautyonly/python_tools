#!/usr/bin/env python
# -*- coding:utf-8 -*-

import os
import sys
import commands

def Grains_yttx_game_version():
    '''
        return game version of grains value
    '''
    grains = {}
    datas = {}

    try:
        f = open('/data0/version')
        for line in f.readlines():                        
            if "version" in line:
                info = line.strip('\n')
                print info
                version_info = info.split(" ")
                key = version_info[0].strip('\t')
                value = version_info[1].strip('\t')
                datas["yttx_"+key] = value
    except Exception,e:
        pass

    try:
        f = open('/data0/wg_config/game_server_config/game_server.cfg.js')
        for line in f.readlines():                        
            if "serverId" in line:
                info = line.strip('\n')
                serverid = info.split("=")[1].strip('\r')
                datas["serverId"] = serverid
            elif "config.serverDomain" in line:
                info = line.strip('\n')
                serverDomain = info.split("\"")[1]
                serverName = info.split("\"")[1].split(".")[0]
                datas["serverDomain"] = serverDomain
                datas["serverName"] = serverName
        else:
            pass
    except Exception,e:
        pass

    try:
        f = open('/usr/local/workspace/agent/cfg.json')
        for line in f.readlines():                        
            if "hostname" in line:
                info = line.strip('\n')
                endpoint = info.split("\"")[3]
    except Exception,e:
        pass

    _openfalcon_endpoint=endpoint
    datas['openfalcon_endpoint'] = _openfalcon_endpoint

    key = 'game'
    grains[key] = datas
    return grains
