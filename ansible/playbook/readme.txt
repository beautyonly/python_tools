git clone https://github.com/ansible/ansible-examples.git
cd ansible-examples
git pull

mkdir -p ./{files,handlers,meta,tasks,templates,vars}

mysql_install roles
hosts         文件
files         存放文件
handlers      重启的东东
meta          galaxy_info的信息
tasks         操作的任务流程
templates     模板
vars          变量

easy_install pip

--- change user password
---
- hosts: ios_gs04
  remote_user: root
  tasks:
   - name: configure gameserver
     shell: sh /root/lyjl_sysfirst.sh 35 78 118.26.236.155 db41 android 1947

--- copy file
---
- hosts: ios_gs04
  remote_user: root
  tasks:
   - name: copy shell scripts to client /root/
     template: src=/root/ansible/lyjl_sysfirst.sh dest=/root mode=755

--- host shutdown
--- one function
- hosts: webservers
  remote_user: root
  tasks:
- name: reboot the servers
  action: command /sbin/reboot -t now


- name: reboot the servers
  command: /sbin/reboot -t now
  or
  command: /sbin/shutdown -t now


ERROR: action is not a legal parameter of an Ansible Play

- name: ntp setup
  hosts: test01_gs_42.62.121.48
  tasks:
  - name: Install ntpd
    yum: name=ntpd state=restarted