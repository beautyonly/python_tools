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
action = 'DescribeBackupConfig'

def read_config(conf_file):
    f = open(conf_file)
    conf_yaml = yaml.load(f)
    config = conf_yaml
    return config

def request_put(module,config,action,params):
    service = QcloudApi(module, config)
    print(service.generateUrl(action, params))
    str_results = service.call(action, params)
    json_results = json.loads(str_results)
    return json_results


def main():
    config = read_config(conf_file)
    params = {'InstanceId': "cdb-4i0yggsn"}

    #print config
    region_list = config['Region']
    for region in region_list:
        config['Region'] = region
        # print config
        # print module,config,action,params
    	json_results = request_put(module,config,action,params)
        
    	print json_results

if __name__ == '__main__':
    sys.exit(main())
