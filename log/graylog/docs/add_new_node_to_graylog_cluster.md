- 确认graylog版本
- 部署新graylog节点
```
ansible-playbook install_graylog_server.yml -l 10.1.16.154
```
调整配置
```
# vim /etc/graylog/server/server.conf
is_master = false
elasticsearch_hosts = http://10.1.16.152:9200,http://10.1.16.154:9200
mongodb_uri = mongodb://10.1.16.152/graylog
```
与主节点配置对比，查看配置区别，应该只要两点区别
```
  - is_master = false
  - mongodb_uri(可以调整成一致)
```
- 启动服务并测试
```
systemctl start graylog-server.service 
tail -f /var/log/graylog-server/server.log
```
检查如下几项:
- web是否可以正常登陆 http://10.1.16.154
- streams是否可以刷新到最新日志
- alert是否正常，有误报警信息
- system--overview查看Graylog cluster信息
- system--nodes信息确认，可以区分主节点及其他节点
- system--indices信息确认，查看索引是否都OK
- 观察es集群是否OK http://10.1.16.151:5000
