# SSH相关
## SSH密钥
```
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/loveserver-deploy
```
## Apps
- .ssh/config
  - [advanced-ssh-config](https://github.com/moul/advanced-ssh-config):Transparent wrapper (ProxyCommand) that adds regex, aliases, gateways, includes, dynamic hostnames to SSH and ssh-config.
  - [storm](https://github.com/emre/storm): 管理SSH config配置
  - [ansible-ssh-config](https://github.com/gaqzi/ansible-ssh-config):使用Ansible管理SSH Config配置
  - [ec2ssh](https://github.com/mirakui/ec2ssh):AWS EC2 ssh_config管理工具
  - [ssh-config](https://github.com/dbrady/ssh-config): ssh_config管理工具
- 基于SSH协议的工具
  - scp
  - rsync
  - sftp
  - curl
- 服务
  - [teleport](https://github.com/gravitational/teleport)
  - [ssh2docker](https://github.com/moul/ssh2docker)
  - [whosthere](https://github.com/FiloSottile/whosthere)
  - [ssh-chat](https://github.com/shazow/ssh-chat)
  - [sshcommand](https://github.com/dokku/sshcommand)

参考资料：https://github.com/moul/awesome-ssh

## SSH密钥生成
## SSH密钥分发
## 其他常用技能
- ~/.ssh/config管理
  
  - [onfig管理工具manssh](https://github.com/xwjdsh/manssh)

  - [~/.ssh/config.d/*方式](https://superuser.com/questions/247564/is-there-a-way-for-one-ssh-config-file-to-include-another-one?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa)
  - 通过ssh反向隧道及nginx反向代理实现外网控制内网
    - https://blog.csdn.net/fg607/article/details/52123833
    - https://www.cnblogs.com/makefile/p/5410722.html
    - 案例：ssh -fN -R 1.1.1.1:50000:2.2.2.2:80 root@1.1.1.1 -p 22  （1.1.1.1公网IP，2.2.2.2内外IP）
    - ngrok一款内网穿透+记录HTTP请求的神器(支持HTTPS)

## 内网穿透
- ngrok
  - [GitHub地址](https://github.com/inconshreveable/ngrok)
  - [ngrok官网](https://ngrok.com/)
  - [ittun-ngrok](https://www.ittun.com/)
  - [sunny-ngrok](https://www.ngrok.cc/)
- fpr
  - [GitHub地址](https://github.com/fatedier/frp)

## 安卓手机连接服务器
- juicessh
## 测试ssh连接质量
- https://github.com/spook/sshping
## 参考资料
- https://github.com/StreisandEffect/streisand
