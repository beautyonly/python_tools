- 1、检查原es节点版本

http://10.1.16.152:9200/

version.number 5.6.7

- 2、部署要添加的es节点
```
ssh-copy-id 10.1.16.154
cd /etc/ansible/playbook/
ansible-playbook host-init-test.yml -l 10.1.16.154
ansible-playbook install_elasticsearch.yml -l 10.1.16.154
```
简单查看下配置
- 确认版本信息一致(http://10.1.16.154:9200/)
- 检查索引等情况正常(http://10.1.16.151:5000)

- 3、停止graylog及nginx 确保数据无法写入
```
systemctl stop nginx.service
systemctl stop graylog-server.service
```

- 4、旧停止es节点
```
/etc/init.d/elasticsearch stop
```

- 5、备份数据
```
cd /data0/
cp -rf elasticsearch elasticsearch.`date +%Y%m%d`
```

- 6、调整配置
```
# vim /etc/elasticsearch/elasticsearch.yml
discovery.zen.ping.unicast.hosts: ["10.1.16.152", "10.1.16.154"]
discovery.zen.minimum_master_nodes: 1

启动前确保新节点服务启动正常
/etc/init.d/elasticsearch start

观察日志有误异常报错，是否正常识别新节点
tail -f /data0/elasticsearch/logs/graylog.log

同时观察
graylog02待加入节点日志
tail -f /data0/elasticsearch/logs/graylog.log
```
> Elasticsearch主节点会自动选举
node.name: elk-master-205
node.master: true
node.data: true

- 7、登录ElasticHQ观察索引是否正常，新节点是否添加成功
http://10.1.16.151:5000

- 8、调整graylog配置，启动并观察日志
```
vim /etc/graylog/server/server.conf
elasticsearch_hosts = http://10.1.16.152:9200,http://10.1.16.154:9200
systemctl start graylog-server.service
```
- 9、启动graylog及nginx
```
systemctl start nginx.service
```

- 10、检查graylog
system-->Indices-->Default index set索引是否正常
看日志是否正常写入
