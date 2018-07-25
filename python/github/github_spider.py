#!/usr/bin/env python
# coding=UTF-8

from settings import FIRST_USER
from utils import *
import time

blog_list = []
follower_list = []

url = get_user_repo_list(FIRST_USER)
data = get_url_data(url)

for i in data:
    if i['name'] == "{}.github.io".format(FIRST_USER):
        print i["name"]
        blog_list.append(i["name"])


url = get_user_follower_list(FIRST_USER)
data = get_url_data(url)
for i in data:
    follower_list.append(i['login'])

for user in follower_list:
    print user
    url = get_user_repo_list(user)
    data = get_url_data(url)
    for i in data:
        if i['name'] == "{}.github.io".format(user):
            blog_list.append(i["name"])
            print "1", blog_list
    time.sleep(30)

print blog_list
print follower_list
