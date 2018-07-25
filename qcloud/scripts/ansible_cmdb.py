from QcloudApi.qcloudapi import QcloudApi

import json
import yaml
import sys

reload(sys)
sys.setdefaultencoding('utf-8')

conf_file = "api.yml"
module = 'cvm'
action = 'DescribeInstances'


def read_config(conf_file):
    f = open(conf_file)
    conf_yaml = yaml.load(f)
    config = conf_yaml
    return config


def request_put(module, config, action, params):
    service = QcloudApi(module, config)
    str_results = service.call(action, params)
    json_results = json.loads(str_results)
    return json_results


def main():
    config = read_config(conf_file)
    params = {'Limit': 100}
    json_results = request_put(module, config, action, params)
    # print json_results
    for i in json_results['Response']['InstanceSet']:
        name = i['InstanceName']
        wanip = i['PublicIpAddresses'][0]
        lanip = i['PrivateIpAddresses'][0]
        os = i['OsName']
        cpu = i['CPU']
        mem = i['Memory']
        # info = "%s\t" \
        #        "%score*%sG*20M*50G+300G\t" \
        #        "%s\t" \
        #        "%s\t" \
        #        "%s\t" % (name, cpu, mem,wanip, lanip, os,)
        info = "insert into hosts (hostname, conf, wan_ip, lan_ip, os) VALUES (\"%s\",\"%score*%sG*20M*50G+300G\",\"%s\",\"%s\",\"%s\");" % (name, cpu, mem, wanip, lanip, os,)
        print info


if __name__ == '__main__':
    sys.exit(main())
