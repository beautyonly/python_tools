# curl
## curl常用案例
- 发邮件

    [curl酷炫技巧:使用curl命令发送邮件](https://www.hi-linux.com/posts/54000.html)

- 请求API
  ``` bash 
  curl -u xxx:xxx --head http://127.0.0.1:9000/api
  curl -u xxx:xxx -H 'Accept: application/json' -X GET 'http://127.0.0.1:9000/api/cluster?pretty=true'
  ```
- 执行脚本
``` bash
curl -s https://raw.githubusercontent.com/oscm/shell/master/os/centos7.sh | bash
```
## 参考资料

