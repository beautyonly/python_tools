#!/usr/bin/env python
# --encoding:utf8--

import os
import json
import requests
import time

domain_name_list = [
'www.baidu.com',
'www.jd.com',
'www.sina.com.cn',
]

# Define the variables used when Falcon reports data
falconTs = int(time.time())
# falconEndpoint = "Endpoint"                                 # use users define value
# falconEndpoint = os.popen('echo $HOSTNAME').read().strip()  # default use hostname as endpoint
falconEndpoint ="SSL-CHECK-xxx"
falconTimeStamp = 60
falconPayload = []
# falconTag = "ssl.cert.expires.days"
falconAgentUrl = "http://127.0.0.1:1988/v1/push"


def get_ssl_cert_data(domain_name):
    result = os.popen("./check_ssl_cert -H %s|awk -F '[=;]+' '{print $2}'" % domain_name).read()
    # print result
    json_data = json.loads(result)
    return json_data


def generate_data():
    for i in domain_name_list:
        # print i
        json_data = get_ssl_cert_data(i)
        value = json_data
        temp_dict = {
            "endpoint": falconEndpoint,
            "metric": "ssl.cert.expires.days",
            "timestamp": falconTs,
            "step": falconTimeStamp,
            "value": value,
            "counterType": "GAUGE",
            "tags": "domain=%s" % (i,),
        }
        falconPayload.append(temp_dict)
    # print falconPayload
    return falconPayload


if __name__ == "__main__":
    falconPayload = generate_data()
    r = requests.post(falconAgentUrl, data=json.dumps(falconPayload))
    print r.text
