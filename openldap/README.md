# OpenLDAP知识
# OpenLDAP应用场景
- 数字证书管理，授权管理，单点登录
- 分布式系统的UDDI
- 网络资源管理，如DNS,Mail服务，用户管理

# to-do-list
- ~~部署及相关文档资料~~
- ~~监控(端口\定时执行一条查询等等)~~
  - cnmonitor
- ~~数据备份~~
- ~~系统接入~~
    - ~~SVN~~
    - ~~NAS~~
    - ~~jenkins~~
    - TeamCity
    - ~~confluence wik~~
    - ~~GitLab~~
    - Open-Falcon
- 日常管理
    - 用户增删改查
    - ~~大批量增加或者删除用户属性ldapmodify，例如增加mail,mobile等~~
- ~~域用户自助修改密码self-service-password~~
- 账号添加属性总结，例如：mail,tel等
- 常用的OpenLDAP[维护工具](https://github.com/ltb-project)
- self-service-password设置邮件及短信密码找回功能
    - ~~问题找回(最简单不需要依赖ldap信息)~~
    - ~~邮件(需要ldap信息)~~
    - ~~短信方式~~
> 在ldap中获取mail和tel信息 短信需要php调用腾讯sms服务发送短信

- 内网从节点
- 主从配置
- TLS加密信息传输
- 性能优化
    - ~~降低应用的同步周期120分钟即可，实时性要求不用那么高~~
    - jmeter压测
    - 分析OpenLDAP服务器性能

# 最佳实践

# 参考资料
https://ltb-project.org/start
