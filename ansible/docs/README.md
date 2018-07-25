# Ansible 重点常用内容总结
## Ansible Playbook
### 错误处理
- 忽略错误继续执行
``` yml
- name: this will not be counted as a failure
  command: /bin/false
  ignore_errors: yes
```
