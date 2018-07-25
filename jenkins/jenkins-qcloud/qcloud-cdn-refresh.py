from QcloudApi.qcloudapi import QcloudApi

import json
import sys
import os


def get_params(urls_type, urls_list):
    urls_type = urls_type.lower()
    cdn_params = {}
    for url in urls_list:
        urls_name = "%s.%s" % (urls_type, urls_list.index(url))
        cdn_params[urls_name] = url
    return cdn_params


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

    def cdn_flush(self):
        json_results = self.request_put()
        return json_results


def main():
    url_type = os.getenv("url_type")
    url_name = os.getenv("url_name")

    config = {'Region': 'ap-shanghai', 'secretId': 'xxx', 'secretKey': 'xxx', 'Version': '2017-03-20'}
    module = 'cdn'
    if url_type == "URLS":
        action = 'RefreshCdnUrl'
    elif url_type == "DIRS":
        action = 'RefreshCdnDir'
    else:
        print "url type error"
        exit(1)

    if url_name is None:
        print "url is none"
        exit(1)
    else:
        url_name_list = url_name.split('\n')
    # params = {'dirs.0': "http://xxx/xxx/", }
    # params = {'urls.0': "http://xxx/dev/xxx/gConfig.json", }
    params = get_params(url_type, url_name_list)
    print params

    s1 = MyApi(config, module, action, params)
    print s1.module
    result = s1.cdn_flush()
    if result['codeDesc'] == "Success":
        print "cdn flush ok"
        print result
    else:
        print "cdn flush fail"
        print result
        exit(1)


if __name__ == '__main__':
    sys.exit(main())
