##

### 简介
编写的一套基于云的持续集成基础架构的脚本(基于CentOS 7.x系统)。

### 准备工作：密钥
- ~/.ssh/keys/hibernate-keys-aws.pem
> 注意：修改key权限为600
### Ansible Install
- sh ansible_install.sh

### Ansible Playbook
- ansible-playbook -i hosts site.yml --check
- ansible-playbook -i hosts site.yml
- ansible-playbook -i hosts site.yml --limit remote
- ansible-playbook -i hosts site.yml --limit remote --list-hosts
- ansible-playbook -i hosts site.yml --list-tags
- ansible-playbook -i hosts site.yml --limit remote --tags "generate-script"

### ansible-galaxy
- ansible-galaxy install username.rolename
```
# vim /etc/ansible/ansible.cfg
roles_path    = /etc/ansible/roles
```
### 声明
### Ansible CMDB
- [ansible-cmdb](https://github.com/fboender/ansible-cmdb)

### 参考
- https://github.com/manala/ansible-roles
- https://github.com/kuailemy123/Ansible-roles
- https://github.com/arbabnazar/ansible-roles
- https://github.com/contiv/ansible
- https://github.com/adithyakhamithkar/ansible-playbooks
- https://github.com/kbrebanov
- [基于Ansible的自动化代码发布工具](https://github.com/geekwolf/flamingo)
