# KVM总结
# KVM概述
- 官网：http://www.linux-kvm.org/page/Main_Page
- 官网文档：http://www.linux-kvm.org/page/Documents

# KVM部署
- [CentOS 7.x](http://linux.dell.com/files/whitepapers/KVM_Virtualization_in_RHEL_7_Made_Easy.pdf)
## Windows 10 安装
``` bash
qemu-img create -f raw /data0/kvm/win10-kvm.raw 50G
qemu-img info /data0/kvm/win10-kvm.raw
virt-install --name window10 --ram 8192 --cdrom=/data0/cn_windows_10_business_editions_version_1803_updated_march_2018_x64_dvd_12063730.iso --boot cdrom --cpu core2duo --network bridge=br0,model='e1000' --graphics vnc,listen=0.0.0.0 --disk path=/data0/kvm/win10-kvm.raw,bus='ide' --noautoconsole --os-type=windows
```
报错1：ERROR    Host does not support domain type kvm for virtualization type 'hvm' arch 'x86_64'
> 去掉--virt-type kvm 参数

报错2：WARNING  KVM acceleration not available, using 'qemu'
> 检查系统BIOS设置，开启CPU虚拟化设置

## CentOS 7.x 安装
``` bash
qemu-img create -f raw /data0/kvm/centos7-kvm.raw 50G
virt-install --name centos-7.4-01 --ram 2048 --cdrom=/data0/CentOS-7-x86_64-DVD-1804.iso --boot cdrom --network bridge=br0 --graphics vnc,listen=0.0.0.0 --disk path=/data0/kvm/centos7-kvm.raw --noautoconsole --os-type=linux
```
- 设置IP地址及DNS
- 设置远程桌面
- 调整配置

## 日常管理工具
### 日常管理命令
``` bash
virsh start windows20031
virsh reboot win7
virsh shutdown win7  # 正常关机
virsh destroy window10 # 暴力关机
```
如果不能正常关机进行设置
``` bash
[root@kvm_client_00 ~]# yum install acpid -y
[root@kvm_client_00 ~]# /etc/init.d/acpid restart       //重新启动acpic服务，安装后默认会加入到开机启动的
```

### 调整配置
- 调整内存可以动态实现，不用关机
``` bash
virsh dominfo win7
virsh setmem win7 524288
virsh dominfo win7
```
- 增加CPU需要关机
``` bash
virsh shutdown win7
virsh edit win7
virsh create /etc/libvirt/qemu/win7.xml
```
### 备份及还原
``` bash
virsh list --all
virsh save --bypass-cache win7 /data0/kvm/win7-`date +%Y%m%d`.img --running

```
### 设置开机启动
``` bash
virsh autostart win7
```

### 删除虚拟机
``` bash
virsh list --all
virsh destroy window10
virsh undefine window10
```
# FQA
- web管理相关
  - https://github.com/welliamcao/VManagePlatform
  - https://github.com/kimchi-project/kimchi
- 日常管理
  - https://github.com/xiaoli110/kvm_vm_setup
  - https://github.com/opengers

# 参考资料
