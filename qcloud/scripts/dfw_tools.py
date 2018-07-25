#!/usr/bin/python
# -*- coding: utf-8 -*-

from QcloudApi.qcloudapi import QcloudApi

import json
import yaml
import sys

reload(sys)
sys.setdefaultencoding('utf-8')

conf_file = "api.yml"


class MyApi:

    def __init__(self, config, module, action, params):
        self.config = config
        self.module = module
        self.action = action
        self.params = params

    def request_put(self):
        service = QcloudApi(self.module, self.config)
        str_results = service.call(self.action, self.params)
        json_results = json.loads(str_results)
        return json_results

    def dfw_list(self):
        json_results = self.request_put()
        print json_results
        print(json_results['data']['totalNum'])
        for i in json_results['data']['detail']:
            sgId = i['sgId']
            projectId = i['projectId']
            sgName = i['sgName']
            createTime = i['createTime']
            sgRemark = i['sgRemark']

            info = "sgId=%s\t" \
                   "projectId=%s\t" \
                   "sgName=%s\t" \
                   "createTime=%s\t" \
                   "sgRemark=%s\t" % (sgId, projectId, sgName, createTime, sgRemark,)
            print info

    def dfw_create(self):
        json_results = self.request_put()
        print json_results

    def create_prolicy(self):
        json_results = self.request_put()
        return json_results


def read_config(conf_file):
    f = open(conf_file)
    conf_yaml = yaml.load(f)
    config = conf_yaml
    return config


def main():
    config = read_config(conf_file)
    # params = {'Limit': 100}
    # params = {'projectId': 0, 'sgName': "模板组", 'sgRemark': '安全组模板'}
    params = {'sgId': "sg-47u1q9wu",
              'direction': "ingress",
              'index': "0",
              'policys': "安全组模板",
              'policys.0.ipProtocol': "tcp",
              'policys.0.cidrIp': "10.0.0.0/8",
              'policys.0.action': "ACCEPT",
              'policys.0.portRange': "22",
              'policys.0.desc': "内网入流量tcp协议22端口禁止访问",
              'policys.0.action': "ACCEPT",
              'policys.0.ipProtocol': "tcp",
              'policys.0.desc': "内网tcp出流量放通",
              'policys.0.cidrIp': "10.0.0.0/8",
              }
    module = 'dfw'
    # action = 'DescribeSecurityGroupEx'
    # action = 'CreateSecurityGroup'
    action = 'CreateSecurityGroupPolicy'
    s1 = MyApi(config, module, action, params)
    # s1.dfw_list()
    # s1.dfw_create()
    s1.create_prolicy()


if __name__ == '__main__':
    sys.exit(main())
