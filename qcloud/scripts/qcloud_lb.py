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
module = 'lb'
action = 'DescribeLoadBalancers'

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
    params = {'Limit':100, 'forward':-1}

    # print config
    region_list = config['Region']
    for region in region_list:
        config['Region'] = region
        # print config
    	json_results = request_put(module,config,action,params)
    	for i in json_results['loadBalancerSet']:
            domain = i['domain']
            loadBalancerName = i['loadBalancerName']
            info = '%s,%s' % (domain,loadBalancerName)
            print info

if __name__ == '__main__':
    sys.exit(main())
