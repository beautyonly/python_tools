6 磁盘{

    df -Ph                                # 查看硬盘容量
    df -T                                 # 查看磁盘分区格式
    df -i                                 # 查看inode节点   如果inode用满后无法创建文件
    du -h 目录                            # 检测目录下所有文件大小
    du -sh *                              # 显示当前目录中子目录的大小
    mount -l                              # 查看分区挂载情况
    fdisk -l                              # 查看磁盘分区状态
    fdisk /dev/hda3                       # 分区
    mkfs -t ext3  /dev/hda3               # 格式化分区
    fsck -y /dev/sda6                     # 对文件系统修复
    lsof |grep delete                     # 释放进程占用磁盘空间  列出进程后，查看文件是否存在，不存在则kill掉此进程
    tmpwatch -afv 10   /tmp               # 删除10小时内未使用的文件  勿在重要目录使用
    cat /proc/filesystems                 # 查看当前系统支持文件系统
    mount -o remount,rw /                 # 修改只读文件系统为读写
    iotop                                 # 磁盘IO占用情况排序   yum install iotop
    smartctl -H /dev/sda                  # 检测硬盘状态  # yum install smartmontools
    smartctl -i /dev/sda                  # 检测硬盘信息
    smartctl -a /dev/sda                  # 检测所有信息
    e2label /dev/sda5                     # 查看卷标
    e2label /dev/sda5 new-label           # 创建卷标
    ntfslabel -v /dev/sda8 new-label      # NTFS添加卷标
    tune2fs -j /dev/sda                   # ext2分区转ext3分区
    tune2fs -l /dev/sda                   # 查看文件系统信息
    mke2fs -b 2048 /dev/sda5              # 指定索引块大小
    dumpe2fs -h /dev/sda5                 # 查看超级块的信息
    mount -t iso9660 /dev/dvd  /mnt       # 挂载光驱
    mount -t ntfs-3g /dev/sdc1 /media/yidong        # 挂载ntfs硬盘
    mount -t nfs 10.0.0.3:/opt/images/  /data/img   # 挂载nfs 需要重载 /etc/init.d/nfs reload  重启需要先启动 portmap 服务
    mount -o loop  /software/rhel4.6.iso   /mnt/    # 挂载镜像文件

    磁盘IO性能检测{

        iostat -x 1 10

        % user     # 显示了在用户级(应用程序)执行时生成的 CPU 使用率百分比。
        % system   # 显示了在系统级(内核)执行时生成的 CPU 使用率百分比。
        % idle     # 显示了在 CPU 空闲并且系统没有未完成的磁盘 I/O 请求时的时间百分比。
        % iowait   # 显示了 CPU 空闲期间系统有未完成的磁盘 I/O 请求时的时间百分比。

        rrqm/s       # 每秒进行 merge 的读操作数目。即 delta(rmerge)/s
        wrqm/s       # 每秒进行 merge 的写操作数目。即 delta(wmerge)/s
        r/s          # 每秒完成的读 I/O 设备次数。即 delta(rio)/s
        w/s          # 每秒完成的写 I/O 设备次数。即 delta(wio)/s
        rsec/s       # 每秒读扇区数。即 delta(rsect)/s
        wsec/s       # 每秒写扇区数。即 delta(wsect)/s
        rkB/s        # 每秒读K字节数。是 rsect/s 的一半，因为每扇区大小为512字节。(需要计算)
        wkB/s        # 每秒写K字节数。是 wsect/s 的一半。(需要计算)
        avgrq-sz     # 平均每次设备I/O操作的数据大小 (扇区)。delta(rsect+wsect)/delta(rio+wio)
        avgqu-sz     # 平均I/O队列长度。即 delta(aveq)/s/1000 (因为aveq的单位为毫秒)。
        await        # 平均每次设备I/O操作的等待时间 (毫秒)。即 delta(ruse+wuse)/delta(rio+wio)
        svctm        # 平均每次设备I/O操作的服务时间 (毫秒)。即 delta(use)/delta(rio+wio)
        %util        # 一秒中有百分之多少的时间用于 I/O 操作，或者说一秒中有多少时间 I/O 队列是非空的。即 delta(use)/s/1000 (因为use的单位为毫秒)

        IO性能衡量标准{

            1、 如果 %util 接近 100%，说明产生的I/O请求太多，I/O系统已经满负荷，该磁盘可能存在瓶颈。
            2、 idle 小于70% IO压力就较大了,一般读取速度有较多的wait.
            3、 同时可以结合 vmstat 查看查看b参数(等待资源的进程数)和wa参数(IO等待所占用的CPU时间的百分比,高过30%时IO压力高)
            4、 svctm 一般要小于 await (因为同时等待的请求的等待时间被重复计算了),svctm 的大小一般和磁盘性能有关,CPU/内存的负荷也会对其有影响,请求过多也会间接导致 svctm 的增加. await 的大小一般取决于服务时间(svctm) 以及 I/O 队列的长度和 I/O 请求的发出模式. 如果 svctm 比较接近 await,说明 I/O 几乎没有等待时间;如果 await 远大于 svctm,说明 I/O 队列太长,应用得到的响应时间变慢,如果响应时间超过了用户可以容许的范围,这时可以考虑更换更快的磁盘,调整内核 elevator 算法,优化应用,或者升级 CPU
            5、 队列长度(avgqu-sz)也可作为衡量系统 I/O 负荷的指标，但由于 avgqu-sz 是按照单位时间的平均值，所以不能反映瞬间的 I/O 洪水。

        }

    }

    创建swap文件方法{

        dd if=/dev/zero of=/swap bs=1024 count=4096000            # 创建一个足够大的文件
        # count的值等于1024 x 你想要的文件大小, 4096000是4G
        mkswap /swap                      # 把这个文件变成swap文件
        swapon /swap                      # 启用这个swap文件
        /swap swap swap defaults 0 0      # 在每次开机的时候自动加载swap文件, 需要在 /etc/fstab 文件中增加一行
        cat /proc/swaps                   # 查看swap
        swapoff -a                        # 关闭swap
        swapon -a                         # 开启swap

    }

    新硬盘挂载{

        fdisk /dev/sdc
        p    #  打印分区
        d    #  删除分区
        n    #  创建分区，（一块硬盘最多4个主分区，扩展占一个主分区位置。p主分区 e扩展）
        w    #  保存退出
        mkfs -t ext3 -L 卷标  /dev/sdc1        # 格式化相应分区
        mount /dev/sdc1  /mnt                  # 挂载
        vi /etc/fstab                          # 添加开机挂载分区
        LABEL=/data            /data                   ext3    defaults        1 2      # 用卷标挂载
        /dev/sdb1              /data4                  ext3    defaults        1 2      # 用真实分区挂载
        /dev/sdb2              /data4                  ext3    noatime,defaults        1 2

        第一个数字"1"该选项被"dump"命令使用来检查一个文件系统应该以多快频率进行转储，若不需要转储就设置该字段为0
        第二个数字"2"该字段被fsck命令用来决定在启动时需要被扫描的文件系统的顺序，根文件系统"/"对应该字段的值应该为1，其他文件系统应该为2。若该文件系统无需在启动时扫描则设置该字段为0
        当以 noatime 选项加载（mount）文件系统时，对文件的读取不会更新文件属性中的atime信息。设置noatime的重要性是消除了文件系统对文件的写操作，文件只是简单地被系统读取。由于写操作相对读来说要更消耗系统资源，所以这样设置可以明显提高服务器的性能.wtime信息仍然有效，任何时候文件被写，该信息仍被更新。

    }

    大磁盘2T和16T分区{

        parted /dev/sdb                # 针对磁盘分区
        (parted) mklabel gpt           # 设置为 gpt
        (parted) print
        (parted) mkpart  primary 0KB 22.0TB        # 指定分区大小
        Is this still acceptable to you?
        Yes/No? Yes
        Ignore/Cancel? Ignore
        (parted) print
        Model: LSI MR9271-8i (scsi)
        Disk /dev/sdb: 22.0TB
        Sector size (logical/physical): 512B/512B
        Partition Table: gpt
        Number  Start   End     Size    File system  Name     Flags
         1      17.4kB  22.0TB  22.0TB               primary
        (parted) quit

        mkfs.ext4 /dev/sdb1        # e2fsprogs升级后支持大于16T硬盘

        # 大于16T的单个分区ext4格式化报错，需要升级e2fsprogs
        Size of device /dev/sdb1 too big to be expressed in 32 bits using a blocksize of 4096.

        yum -y install xfsprogs
        mkfs.xfs -f /dev/sdb1              # 大于16T单个分区也可以使用XFS分区,但inode占用很大,对大量的小文件支持不太好

    }

    raid原理与区别{

        raid0至少2块硬盘.吞吐量大,性能好,同时读写,但损坏一个就完蛋
        raid1至少2块硬盘.相当镜像,一个存储,一个备份.安全性比较高.但是性能比0弱
        raid5至少3块硬盘.分别存储校验信息和数据，坏了一个根据校验信息能恢复
        raid6至少4块硬盘.两个独立的奇偶系统,可坏两块磁盘,写性能非常差

    }

}
