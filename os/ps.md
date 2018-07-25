ps{

    ps aux |grep -v USER | sort -nk +4 | tail       # 显示消耗内存最多的10个运行中的进程，以内存使用量排序.cpu +3
    # USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
    %CPU     # 进程的cpu占用率
    %MEM     # 进程的内存占用率
    VSZ      # 进程虚拟大小,单位K(即总占用内存大小,包括真实内存和虚拟内存)
    RSS      # 进程使用的驻留集大小即实际物理内存大小
    START    # 进程启动时间和日期
    占用的虚拟内存大小 = VSZ - RSS

    ps -eo pid,lstart,etime,args         # 查看进程启动时间

}
