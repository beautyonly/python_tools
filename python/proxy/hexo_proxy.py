# -*- coding=utf8 -*-

import time
import requests
from settings import PROXY_KEY
from settings import PROXY_USE_COUNT
from settings import REQUEST_RETRY_COUNT
from settings import TIMEOUT
from redis import Redis
from settings import (
    REDIS_URI
)

redis_client = Redis.from_url(REDIS_URI)

HEADERS = {
    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
    'Accept-Encoding': 'gzip, deflate, sdch',
    'Accept-Language': 'zh-CN,zh;q=0.8,en;q=0.6,zh-TW;q=0.4',
    'Cache-Control': 'no-cache',
    'Connection':'keep-alive',
    'Host':'api.github.com',
    'Pragma':'no-cache',
    'User-Agent':'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) '
                 'AppleWebKit/537.36 (KHTML, like Gecko) '
                 'Chrome/49.0.2623.87 Safari/537.36'
}


def get_proxy():
    """
    从redis获取代理
    """
    available_proxy = redis_client.zrangebyscore(PROXY_KEY, 0, PROXY_USE_COUNT)
    if available_proxy:
        return available_proxy[0]
    return None


def request_with_proxy(url):
    """
    proxy访问url
    """
    for i in range(REQUEST_RETRY_COUNT):
        proxy = get_proxy()
        print proxy
        if not proxy:
            time.sleep(10 * 60)

        try:
            proxy_map = {'http': 'http://{}'.format(proxy.decode('ascii'))}
            redis_client.zincrby(PROXY_KEY, proxy)
            print "使用代理：%s" % (proxy_map, )
            response = requests.get(url, proxies=proxy_map, headers=HEADERS, timeout=TIMEOUT)
            # response = requests.get(url, proxies=proxy_map, timeout=TIMEOUT)
        except Exception as exc:
            print exc
            redis_client.zrem(PROXY_KEY, proxy)
        else:
            if response.status_code == 200:
                # return response.json()
                return response.headers

if __name__ == '__main__':
    # url = "http://httpbin.org/ip"
    url = "http://www.baidu.com"
    a = request_with_proxy(url)
    print a
