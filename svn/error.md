# 日常使用报错
``` bash
# svn add .       
svn: warning: W150002: '/tmp/ansible' is already under version control
svn: E200009: Could not add all targets because some targets are already versioned
svn: E200009: Illegal target for the requested operation

解决：有可能是svn版本支持问题
svn status            查看变更文件,单个提交
svn add filename
svn commit -m 'add file'
```
