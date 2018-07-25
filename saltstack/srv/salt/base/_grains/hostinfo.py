#coding=utf-8
import salt.client as sc
import json
 
###salt调用
local = sc.LocalClient()
###目标主机指定
tgt = "*"
 
###获取grains，disk信息
grains = local.cmd(tgt,"grains.items")
diskusage = local.cmd(tgt,"disk.usage")
 
###主要应用列表即文件开头
app_name = ["tomcat","zookeeper","redis","mysql","nginx"]
cols = "主机名,IP地址,内存(GB),CPU核数,操作系统,数据盘/data(GB),所属项目,主要应用"
 
###打开一个.csv文件，以便写入
ret_file = open("ret.csv","w")
###首先写入开头，有点字段名的意思
ret_file.write(cols + "\n")
try:
    for i in grains.keys():
        ###打印信息可注释掉
        print grains[i]["nodename"]
        print "ipv4" + ":" ,grains[i]["ipv4"]
        print "mem_total" + ":" , grains[i]["mem_total"] / 1024 + 1
        print "num_cpus" + ":" , grains[i]["num_cpus"]
        print "osfullname" + ":" , grains[i]["osfullname"]
        print "release" + ":" , grains[i]["lsb_distrib_release"]
        ###可能一些主机没有/data数据盘1048576是1024x1024
        if "/data" not in diskusage[i]:
            print "diskusage" + ":" + "have no /data disk"
        else:
            data_vol = int(diskusage[i]["/data"]["1K-blocks"])
            print "diskusage" + ":" , data_vol / 1048576 
        ###去掉127.0.0.1这个地址
        ipv4 = str(grains[i]["ipv4"]).replace(", '127.0.0.1'","")
         
        ###因为一些历史遗留问题，这里取得不是主机名，而是salt-minion的id名，用以判断主要应用
        hostname = grains[i]["id"]
        ipv4 = str(grains[i]["ipv4"]).replace(", '127.0.0.1'","")
        ipv4 = ipv4.replace(",","and")
        mem = grains[i]["mem_total"] / 1024 + 1
        num_cpu = grains[i]["num_cpus"]
        OS = grains[i]["osfullname"] + grains[i]["lsb_distrib_release"]
        if "/data" not in diskusage[i]:
            disk_data = "None"
        else:
            disk_data = data_vol / 1048576
         
        ###项目名为空
        project = ""
        ###通过minion ID名来判断主要运行服务，比如xx-mysql-1，则运行mysql
        for j in app_name:
            if j in hostname.lower():
                app =  j
                break
            else:
                app = "undefined"
        c = ","
         
        ###连接并写入
        line = hostname + c + ipv4 + c + str(mem) + c + str(num_cpu) + c + str(OS) + c + str(disk_data) + c + project + c + app
        ret_file.write(line + "\n")
except Exception,e:
    print "Exception:\n",e
finally:
    ret_file.close()
