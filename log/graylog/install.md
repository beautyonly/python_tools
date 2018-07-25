``` bash
yum install java-1.8.0-openjdk
cat>/etc/yum.repos.d/mongodb-org-3.6.repo<EOF
[mongodb-org-3.6]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/3.6/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-3.6.asc
EOF
yum install -y mongodb-org
systemctl enable mongod.service
systemctl start mongod.service
rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
cat>/etc/yum.repos.d/elasticsearch.repo<EOF
[elasticsearch-5.x]
name=Elasticsearch repository for 5.x packages
baseurl=https://artifacts.elastic.co/packages/5.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF
yum install elasticsearch
vim /etc/elasticsearch/elasticsearch.yml
cluster.name: graylog
systemctl enable elasticsearch.service
systemctl restart elasticsearch.service

rpm -Uvh https://packages.graylog2.org/repo/packages/graylog-2.4-repository_latest.rpm
yum install graylog-server
yum install -y pwgen
pwgen -N 1 -s 96
echo -n admin | sha256sum
vim /etc/graylog/server/server.conf
password_secret = WPtR8CI1TohZqvV0Co8elMugzkHLUS5fyEBLRTIKJC4kt0IYXGb4cNE1iQLImHXay94StebMesPT7Vd7gxKzg7nuWMvjwJ5r
root_password_sha2 = 5ee0333e2563c2f26787082ff20785bd717e07bb26b78dd3f4839a69e04c3662
root_timezone = Asia/Shanghai

systemctl start graylog-server.service
systemctl enable graylog-server.service

yum install -y nginx
cat>/etc/nginx/conf.d/graylog.conf<EOF
server
{
        listen 80;
        server_name xxxx;

        location /
        {
            proxy_set_header    X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header    Host $http_host;
            proxy_set_header    X-Graylog-Server-URL http://xxx/api;
            proxy_pass          http://127.0.0.1:9000;
        }
}
EOF
nginx -t
systemctl enable nginx
systemctl start nginx

排错：
cd /var/log/graylog-server/
tail -f server.log
tail -f /var/log/nginx/*
```
