#!/usr/bin/env python
# _*_ coding:utf-8 _*_
from QcloudApi.qcloudapi import QcloudApi

import json
import yaml
import sys
reload(sys)
sys.setdefaultencoding('utf-8')

if len(sys.argv) != 2:
    print "Usages: python %s conf_file_name" % (sys.argv[0])
    exit(1)

conf_file=sys.argv[1]
module = 'cdb'
action = 'DescribeDBInstances'

def read_config(conf_file):
    f = open(conf_file)
    conf_yaml = yaml.load(f)
    config = conf_yaml
    return config

def request_put(module,config,action,params):
    service = QcloudApi(module, config)
    str_results = service.call(action, params)
    json_results = json.loads(str_results)
    return json_results


def main():
    config = read_config(conf_file)
    params = {'Limit':100}

    # print config
    region_list = config['Region']
    for region in region_list:
        config['Region'] = region
        # print config
        print module,config,action,params
    	json_results = request_put(module,config,action,params)
    	# print json_results
        print "totalCount: %s " % (json_results['data']['totalCount'],)
        info = 'instanceId\tName\tvip\tvport\tengine\tmemory\tqps\tstatus\tinitFlag\tzone'
        print info
    	for i in json_results['data']['items']:
            instanceId = i['instanceId']
            vip = i['vip']
            vport = i['vport']
            zone = i['zone']
            engineVersion = i['engineVersion']
            instanceName = i['instanceName']
            memory = i['memory']
            #region = i['region']
            qps = i['qps']
            status = i['status']
            initFlag = i['initFlag']
            info = '{0: <10} {1: >10}\t{2}\t{3}\t{4}\t{5}\t{6}\t{7}\t{8}\t{9}'.format(instanceId,instanceName,vip,vport,engineVersion,memory,qps,status,initFlag,zone)
            print info

if __name__ == '__main__':
    sys.exit(main())
