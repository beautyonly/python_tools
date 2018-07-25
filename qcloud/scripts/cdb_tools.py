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

    def cdb_list(self):
        json_results = self.request_put()
        # print json_results
        for i in json_results['data']['items']:
            instanceId = i['instanceId']
            instanceName = i['instanceName']
            vip = i['vip']
            qps = i['qps']
            vport = i['vport']
            zone = i['zone']
            engineVersion = i['engineVersion']
            memory = i['memory']
            initFlag = i['initFlag']
            # info = "type=%s\t" \
            #        "instanceId=%s\t" \
            #        "instanceName=%s\t" \
            #        "vip=%s\t" \
            #        "qps=%s\t" \
            #        "vport=%s\t" \
            #        "zone=%s\t" \
            #        "engineVersion=%s\t" \
            #        "memory=%s\t" \
            #        "initFlag=%s" \
            #        % (self.module, instanceId, instanceName, vip, qps, vport, zone, engineVersion, memory, initFlag,)
            info = "instanceId=%s\t" \
                   "instanceName=%s\t" \
                   "vip=%s\t" \
                   "qps=%s\t" \
                   "vport=%s\t" \
                   "engineVersion=%s\t" \
                   "memory=%s\t" \
                   "initFlag=%s" % (
                    instanceId, instanceName, vip, qps, vport, engineVersion, memory, initFlag,)
            print info

    def cdb_backup_list(self):
        json_results = self.request_put()
        print json_results

    def lb_list(self):
        json_results = self.request_put()
        return json_results


def read_config(conf_file):
    f = open(conf_file)
    conf_yaml = yaml.load(f)
    config = conf_yaml
    return config


def main():
    config = read_config(conf_file)
    params = {'Limit': 100}
    module = 'cdb'
    action = 'DescribeDBInstances'
    s1 = MyApi(config, module, action, params)
    s1.cdb_list()


if __name__ == '__main__':
    sys.exit(main())
