# encoding: utf-8

import commands
import xml.etree.ElementTree as ET

def ciData():
    """ 
       
    """
    #homes = _home()
    homes = ["/data0/tomcat_gmserver_ss","/data0/tomcat_gmserver"]
    print homes
    grains = {}
    for home in homes:
        print home
        confFile = home + "/conf/server.xml"
        print confFile
        verSh = home + "/bin/version.sh"
        datas = {}
        # 获取安装路径
        datas['home'] = home
        
        #获取web服务端口
        port = "8080"
        root = ET.parse(confFile).getroot()
        for connector in root.find("Service").findall("Connector"):
            if "HTTP" in connector.get("protocol"):
                port = connector.get("port",port)
        datas["port"] = port
        
        # 获取Tomcat版本信息
        cmd = verSh + "|grep -i 'Server version'|awk -F\: '{print $2}'"
        version = commands.getstatusoutput(cmd)[1].strip()
        datas['version'] = version
       
        # 获取最大线程数
        maxThreads = "150" 
        root = ET.parse(confFile).getroot()
        for executor in root.find("Service").findall("Executor"):
            if "ThreadPool" in executor.get("name"):
                maxThreads = executor.get("maxThreads", maxThreads)
        datas['maxThreads'] = maxThreads
      
        key = 'Tomcat_' + str(port)
        grains[key] = datas
    return grains

if __name__ == "__main__":
    data = ciData()
    print data
