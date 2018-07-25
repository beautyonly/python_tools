# NodeJS知识
## 安装配置环境
``` bash
wget https://nodejs.org/dist/v8.10.0/node-v8.10.0-linux-x86.tar.gz
tar -zxf node-v8.10.0-linux-x86.tar.gz -C /usr/local/
cd /usr/local/ && ln -s node-v8.10.0-linux-x86/ node
cat>/etc/profile<<EOF

# set for nodejs
export NODE_HOME=/usr/local/node
export PATH=$NODE_HOME/bin:$PATH
EOF
source  /etc/profile
node -v
```

## FQA
- https://www.cnblogs.com/jwentest/p/8259770.html
