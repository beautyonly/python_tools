wget https://mirrors.tuna.tsinghua.edu.cn/influxdata/yum/el7-x86_64/influxdb-1.6.0.x86_64.rpm
rpm -ivh influxdb-1.6.0.x86_64.rpm
systemctl start influxdb
systemctl enable influxdb

Create your first database
```
curl -XPOST "http://localhost:8086/query" --data-urlencode "q=CREATE DATABASE mydb"
```
Insert some data
```
curl -XPOST "http://localhost:8086/write?db=mydb" -d 'cpu,host=server01,region=uswest load=42 1434055562000000000'
curl -XPOST "http://localhost:8086/write?db=mydb" -d 'cpu,host=server02,region=uswest load=78 1434055562000000000'
curl -XPOST "http://localhost:8086/write?db=mydb" -d 'cpu,host=server03,region=useast load=15.4 1434055562000000000'
```
Query for the data
```
curl -G "http://localhost:8086/query?pretty=true" --data-urlencode "db=mydb" --data-urlencode "q=SELECT * FROM cpu WHERE host='server01' AND time < now() - 1d"
```
Analyze the data
```
curl -G "http://localhost:8086/query?pretty=true" --data-urlencode "db=mydb" \
--data-urlencode "q=SELECT mean(load) FROM cpu WHERE region='uswest'"
```

```
# influx -precision rfc3339
Connected to http://localhost:8086 version 1.6.0
InfluxDB shell version: 1.6.0
> show databases
name: databases
name
----
_internal
mydb
> use mydb
Using database mydb
> INSERT cpu,host=serverA,region=us_west value=0.64
> select * from cpu
name: cpu
time                           host     load region  value
----                           ----     ---- ------  -----
2015-06-11T20:46:02Z           server01 42   uswest  
2015-06-11T20:46:02Z           server02 78   uswest  
2015-06-11T20:46:02Z           server03 15.4 useast  
2018-07-12T14:50:18.631567713Z serverA       us_west 0.64
> 
```
