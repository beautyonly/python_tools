# Docker知识
## Docker部署安装
``` bash
wget https://raw.githubusercontent.com/mds1455975151/tools/master/docker/install_docker_ce.sh
sh install_docker_ce.sh
```

## 快速启动docker应用
- centos
``` bash
docker pull centos:7.2.1511
docker run -d -it -p 20022:22 centos:7.2.1511 /bin/bash
```

## Dockerfiles
- https://github.com/jessfraz/dockerfiles
- 编写技巧

## 监控
- [ctop](https://github.com/bcicen/ctop)

## FQA
- Failed to get D-Bus connection: Operation not permitted

## 参考资料
