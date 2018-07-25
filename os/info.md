硬件信息{

    more /proc/cpuinfo                                       # 查看cpu信息
    lscpu                                                    # 查看cpu信息
    cat /proc/cpuinfo | grep name | cut -f2 -d: | uniq -c    # 查看cpu型号和逻辑核心数
    getconf LONG_BIT                                         # cpu运行的位数
    cat /proc/cpuinfo | grep 'physical id' |sort| uniq -c    # 物理cpu个数
    cat /proc/cpuinfo | grep flags | grep ' lm ' | wc -l     # 结果大于0支持64位
    cat /proc/cpuinfo|grep flags                             # 查看cpu是否支持虚拟化   pae支持半虚拟化  IntelVT 支持全虚拟化
    more /proc/meminfo                                       # 查看内存信息
    dmidecode                                                # 查看全面硬件信息
    dmidecode | grep "Product Name"                          # 查看服务器型号
    dmidecode | grep -P -A5 "Memory\s+Device" | grep Size | grep -v Range       # 查看内存插槽
    cat /proc/mdstat                                         # 查看软raid信息
    cat /proc/scsi/scsi                                      # 查看Dell硬raid信息(IBM、HP需要官方检测工具)
    lspci                                                    # 查看硬件信息
    lspci|grep RAID                                          # 查看是否支持raid
    lspci -vvv |grep Ethernet                                # 查看网卡型号
    lspci -vvv |grep Kernel|grep driver                      # 查看驱动模块
    modinfo tg2                                              # 查看驱动版本(驱动模块)
    ethtool -i em1                                           # 查看网卡驱动版本
    ethtool em1                                              # 查看网卡带宽

}
