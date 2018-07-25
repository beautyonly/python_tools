``` bash
git clone --depth 2 https://github.com/mds1455975151/tools.git
cd tools/docker/centos-ssh
docker pull centos:7
docker build . -t centos-ssh:7

docker rm $(docker ps -a -q) 

id=n  # 1 2 3 .. 9
# 无需systemctl管理服务
docker run -d -it -p 20${id}0${id}:22 --name os-0${id} centos-ssh:7.2

# 需要systemctl管理服务
docker run --privileged -d -it -p 20${id}0${id}:22 -v /sys/fs/cgroup:/sys/fs/cgroup:ro --name os-0${id} centos-ssh:7

docker run -d -it -p 20101:22 --name os-01 centos-ssh:7.2
docker run -d -it -p 20202:22 --name os-02 centos-ssh:7.2
docker run -d -it -p 20303:22 --name os-03 centos-ssh:7.2


docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' os-01
ssh -p 22 172.17.0.2

镜像默认账号密码：root:123456
```
# 制作镜像常见问题
- 1、控制体积

- 2、时区及时间同步

- 3、systemctl
