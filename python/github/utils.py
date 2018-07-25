#!/usr/bin/env python
# coding=UTF-8

from settings import GITHUB_API
from settings import GITHUB_HOST
import urllib2
try:
    import json
except:
    import simplejson as json


def get_user_page_url(user_name):
    """
    获取用户主页url
    :param user_name: 用户名
    :return:
    """
    url = "https://{}/users/{}".format(GITHUB_API, user_name,)
    return url


def get_user_follower_list(user_name):
    """
    获取用户关注者的信息
    :param user_name:
    :return:
    """
    url = "https://{}/users/{}/following".format(GITHUB_API, user_name,)
    return url


def get_user_repo_list(user_name):
    """
    获取用户的repo
    :param user_name:
    :return:
    """
    url = "https://{}/users/{}/repos".format(GITHUB_API, user_name,)
    return url


def get_url_data(url):
    """
    根据用户提供的url，获取返回值
    :param url:
    :return:
    """
    data = urllib2.urlopen(url).read()
    json_data = json.loads(data)
    return json_data


def get_search_repo(keywords):
    """
    api地址：https://developer.github.com/v3/search/#search-repositories
    在GitHub上搜索符合规则的repo库
    :param keywords:
    :return:
    """
    q = "%s" % (keywords,)
    sort = "stars"
    order = "desc"
    args = "q=%s&sort=%s&order=%s" % (q, sort, order,)
    url = "https://{}/search/repositories?{}".format(GITHUB_API, args)
    return url
