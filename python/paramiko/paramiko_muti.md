#### 背景介绍

&emsp;作为一个技术人员, 一个快速发展的公司是最能锻炼自己技术的平台, 因为每天有大量的不确定的需求等着你使用技术来解决, 在解决问题的过程中, 你的技术也可以有很大的提高, 这就是一个互利共赢的局面, 对公司好, 对自己的未来也好!

#### 开始学习

&emsp;下面开始学习使用paramiko

```python
import paramiko

# 初始化一个SSHClient实例
client = SSHClient()
# 自动添加到known_hosts而不用手工点击yes/no
client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
# 连接主机, 可以使用密码, 也可以使用密钥, 如果不填写密码/密钥, 只填写主机名称的话
# 默认的查找顺序是先查找私钥, 然后查找密码, 其他设置比如超时时间等可以查看官方文档
client.connect("192.168.1.1", 22, "root", "password")
#client.connect("192.168.1.1", 22, "root", key_filename="/home/xxx/.ssh/id_rsa")
#执行命令
stdin, stdout, stderr = client.exec_command("ls -l")
#读取结果, 跟python的file对象具有相同的读写方法, 只能读取一次, 所以建议保存到一个变量中来使用
print(stdout.readlines())
#关闭连接
client.close()
```

上面是使用paramiko执行远程命令的基础用法, 下面写一个使用多线程获取远程系统的主机名称并保存到本地文件的脚本, 保存到本地的文件是为了说明如何获取多线程远程执行命令的返回结果!

```python
#!/usr/bin/env python3
import io
import threading

import paramiko


class RemoteExecutor:
    def __init__(self, username, password, cmd, servers):
        self.username = username
        self.password = password
        self.cmd = cmd
        self.servers = servers.split(",")

    def execute(self, cmd, server):
        client = paramiko.SSHClient()
        client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        client.connect(server.strip(), 22, self.username, self.password)
        stdin, stdout, stderr = client.exec_command(self.cmd)
        err = stderr.read()
        out = stdout.read()
        if err:
            print(err)
        else:
            print(out)
            result.write("{0} ----> {1}".format(server, out.decode()))
        client.close()

    def run(self):
        global result
        result = io.StringIO()
        threads = []
        for server in self.servers:
            t = threading.Thread(target=self.execute, args=(self.cmd, server,))
            t.start()
            threads.append(t)
        for thread in threads:
            thread.join()
        if result.getvalue():
            with open("/tmp/result.txt", "w") as f:
                f.write(result.getvalue())
        else:
            print("No result returned!")


if __name__ == "__main__":
    servers = "192.168.1.1, 192.168.1.2"
    cmd = "hostname"
    r = RemoteExecutor("root", "123456", cmd, servers)
    r.run()
```



#### 写在后面
跟fabric相比, paramiko更加的底层, 更加可定制化, 适合爱折腾的程序员!
