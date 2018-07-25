#!/usr/bin/env python
# --encoding:utf8--

import os
import json
import requests
import time

# Define the variables used when Falcon reports data
falconTs = int(time.time())
# falconEndpoint = "Endpoint"                               # use users define value
falconEndpoint = os.popen('echo $HOSTNAME').read().strip()  # default use hostname as endpoint
falconEndpoint ="{{ endpoint }}-SH-QCLOUD-{{ wan_ip }}"      # use users define value
falconTimeStamp = 60
falconPayload = []
falconTag = "DBProxy"
falconAgentUrl = "http://127.0.0.1:1988/v1/push"


def get_fpnn_data():
    result = os.popen('cd /home/infra-fp-mysql-dbproxy &&./cmd 127.0.0.1 12321 *infos {} 1 1').read()
    result = result.replace('Return:', '')
    json_data = json.loads(result)
    return json_data


def generate_data():
    json_data = get_fpnn_data()
    value = json_data['FPNN.status']['server']['status']['currentConnections']
    temp_dict = {
        "endpoint": falconEndpoint,
        "metric": "FPNN.server.currentConnections",
        "timestamp": falconTs,
        "step": falconTimeStamp,
        "value": value,
        "counterType": "GAUGE",
        "tags": falconTag,
    }
    falconPayload.append(temp_dict)
    fpnn_stat_dict = json_data['FPNN.status']['server']['stat']
    for key, value in fpnn_stat_dict.items():
        for akey, avalue in value.items():
            stat_dict = {
                "endpoint": falconEndpoint,
                "metric": "FPNN.server.stat" + key + "." + akey,
                "timestamp": falconTs,
                "step": falconTimeStamp,
                "value": avalue,
                "counterType": "GAUGE",
                "tags": falconTag,
            }
            falconPayload.append(stat_dict)
    return falconPayload


if __name__ == "__main__":
    falconPayload = generate_data()
    r = requests.post(falconAgentUrl, data=json.dumps(falconPayload))
    print r.text
