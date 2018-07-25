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

    def cns_list(self):
        json_results = self.request_put()
        print json_results
        for i in json_results['data']['domains']:
            id = i['id']
            name = i['name']
            src_flag = i['src_flag']
            status = i['status']
            ttl = i['ttl']
            records = i['records']
            info = "%s\t" \
                   "%s\t" \
                   "%s\t" \
                   "%s\t" \
                   "%s\t" \
                   "%s\t" % (id, name, src_flag, status, ttl, records)
            print info

    def cns_recode_list(self):
        json_results = self.request_put()
        # print json_results
        for i in json_results['data']['records']:
            id = i['id']
            name = i['name']
            value = i['value']
            enabled = i['enabled']
            ttl = i['ttl']
            line = i['line']
            type = i['type']
            info = "%s\t" \
                   "%s\t" \
                   "%s\t" \
                   "%s\t" \
                   "%s\t" \
                   "%s\t" \
                   "%s\t" \
                   "%s\t" % (id, enabled, ttl, ttl, line, type, name, value,)
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
    # params = {'Limit': 100}
    params = {'domain': "worldoflove.cn"}
    module = 'cns'
    # action = 'DomainList'
    action = 'RecordList'
    s1 = MyApi(config, module, action, params)
    # s1.cns_list()
    s1.cns_recode_list()


if __name__ == '__main__':
    sys.exit(main())
