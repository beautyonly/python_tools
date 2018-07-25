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
        cdb_list = []
        json_results = self.request_put()
        for i in json_results['data']['items']:
            instanceId = i['instanceId']
            cdb_list.append(instanceId)
        return cdb_list

    def cdb_backup_list(self):
        json_results = self.request_put()
        # print(json_results)
        # print(json_results['message'])
        for i in json_results['data']['items']:
            file_name = i['name']
            download_wan_url = i['internetUrl']
            download_lan_url = i['intranetUrl']
            status = i['status']
            type = i['type']
            creator = i['creator']
            info = "%s\t" \
                   "%s\t" \
                   "%s\t" \
                   "%s\t" \
                   "%s\t" \
                   % (file_name, download_wan_url, type, creator, status,)
            print(info)
            info_file = "mysql_info.txt"
            f = open(info_file, "a+")
            f.write(info+'\n')
            f.close()


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
    cdb_list = s1.cdb_list()
    for i in cdb_list:
        action = 'DescribeBackups'
        params = {'instanceId': "%s" % i}
        s2 = MyApi(config, module, action, params)
        s2.cdb_backup_list()


if __name__ == '__main__':
    sys.exit(main())
