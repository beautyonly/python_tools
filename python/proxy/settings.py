#!/usr/bin/env python
# coding=UTF-8

# redis配置
REDIS_URI = 'redis://127.0.0.1:6379'

# 每个代理的最大使用次数
PROXY_USE_COUNT = 100

# Redis key
PROXY_KEY = 'proxy_zset'

# 请求失败重试次数
REQUEST_RETRY_COUNT = 20

# 请求超时时间
TIMEOUT = 10
