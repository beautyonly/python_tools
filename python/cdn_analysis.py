#!/usr/bin/env python
# coding=UTF-8

import sys
"""
info.txt 文件格式 腾讯云后台下载 CDN--统计分析--使用量统计--选择时间、域名进行查询---选择流量TOP100 URL 下载全部数据
# cat info_test.txt
cdn.feidou.com/aaaa/tencent/assets/sound/10000.mp3	239777205284
cdn.feidou.com/bbbb/1.12.0.92/image/ui/homemain.pvr.ccz	197354564867
cdn.feidou.com/bbbb/1.12.0.90/image/ui/homemain.pvr.ccz	176199444187
cdn.feidou.com/bbbb/download/9.3.5/20171030-144844-0.apk	163989710001
cdn.feidou.com/cccc/download/9.3.5/43937-0.apk	152593752929

"""
if len(sys.argv) < 2:
    usg_msg = "\033[31;1m"
    usg_msg += "Usages: cdn_analysis.py money_total"
    usg_msg += "\033[0m"
    print usg_msg
    sys.exit(2)

money_total = float(sys.argv[1])

info_file = "info_test.txt"
f = open(info_file, 'r+')
all_lines = f.readlines()
f.close()

game_data = []
for line in all_lines:
    tmp_list = []
    # 游戏简称
    game_name = line.strip('\n').split('\t')[0].split("/")[1]
    # 游戏CDN流量
    data_num = int(line.strip('\n').split('\t')[1])/1000/1000/1000
    tmp_list.append(game_name)
    tmp_list.append(data_num)
    game_data.append(tmp_list)

d = {}
for item in game_data:
    if item[0] in d:
        d[item[0]] += int(item[1])
    else:
        d[item[0]] = int(item[1])

data_sum = sum(value for value in d.values())
print u"总流量：%sGB \t总费用：%s元" % (data_sum, money_total)
for key, value in d.items():
    data_per = format(float(value)/float(data_sum), '.2f')
    money = money_total * float(data_per)
    print u"%s流量：%sGB\t占比：%s\t费用为：%s元" % (key, value, data_per, money)
