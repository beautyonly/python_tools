#!/usr/bin/env python
# coding=UTF-8

import sys
import time
import json
reload(sys)
sys.setdefaultencoding("utf-8")
from utils import get_search_repo
from utils import get_url_data

today_time = time.strftime("%Y.%m.%d %H:%M:%S", time.localtime())
keywords = "hexo+themes"


def store(data):
    """
    存储json数据到文件
    :param data:
    :return:
    """
    with open('data.json', 'w') as json_file:
        json_file.write(json.dumps(data))


def load():
    """
    获取文件内容转成json格式
    :return:
    """
    with open('data.json') as json_file:
        data = json.load(json_file)
        return data


def get_github_data(keywords):
    query_url = get_search_repo(keywords)
    data = get_url_data(query_url)
    # print query_url, data
    if data:
        store(data)
    print "ok"

get_search_repo(keywords)
json_data = load()
items_info = json_data["items"]
title_line = "{0: <45} {1: <10} {2: <45}".format("|项目名称", "|stars量", "|GitHub地址",)
cc_line = "{0: <45} {1: <10} {2: <45}".format("|--", "|---------------", "|---------------",)
print title_line
print cc_line
for i in items_info:
    full_name = i["full_name"]
    description = i["description"]
    forks_count = i["forks_count"]
    stargazers_count = i["stargazers_count"]
    homepage = i["homepage"]
    html_url = i["html_url"]
    info_line = "|{0: <45} |{1: <10} |[点我]({2: <45})".format(full_name, stargazers_count, html_url,)
    print info_line

print "==============数据结果：截止到 %s============" % (today_time,)