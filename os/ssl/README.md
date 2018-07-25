# 免费SSL证书
https://certbot.eff.org

# 免费SSL证书优缺点
- 优点
  - 免费

- 缺点
  - 大规模使用复杂 过期管理

# 证书过期时间检查及报警
- https://github.com/matteocorti/check_ssl_cert (推荐)
- https://github.com/Matty9191/ssl-cert-check
- https://github.com/srvrco/checkssl
- https://github.com/selivan/https-ssl-cert-check-zabbix
- https://github.com/adfinis-sygroup/check-ssl

```
./check_ssl_cert -H develop.gs.worldoflove.cn|awk -F '[=;]+' '{print $2}'  # 计算还有多少天证书过期
```
```
yum -y install yum-utils
yum-config-manager --enable rhui-REGION-rhel-server-extras rhui-REGION-rhel-server-optional
yum install python2-certbot-nginx
certbot --nginx

certbot --nginx certonly

cos-cdn.xxx.cn

certbot -d nas.dev.xx.cn --manual --preferred-challenges dns certonly -m xxx@gmail.com
根据提示添加域名text记录

cd /etc/letsencrypt/live/
for i in `ls|grep -v txt`;do cat $i/*.pem>$i.txt;done

添加定时更新证书
0 0,12 * * * python -c 'import random; import time; time.sleep(random.random() * 3600)' && certbot renew

申请通配符域名
https://github.com/Neilpang/acme.sh/wiki/%E8%AF%B4%E6%98%8E
acme.sh
export DP_Id="xxx"
export DP_Key="xxx"
acme.sh --issue --dns dns_dp -d xxx.cn -d *.xxx.cn 
acme.sh --issue --dns dns_dp -d *gs.xxx.cn

~/.acme.sh/account.conf

https://blog.csdn.net/wr410/article/details/79559369
```

# FQA
- 问题1
```
[root@cdn01 ~]# certbot -d xxx --manual --preferred-challenges dns certonly -m dongsheng.ma@lemongrassmedia.cn
Traceback (most recent call last):
  File "/usr/bin/certbot", line 9, in <module>
    load_entry_point('certbot==0.24.0', 'console_scripts', 'certbot')()
  File "/usr/lib/python2.7/site-packages/pkg_resources/__init__.py", line 476, in load_entry_point
    return get_distribution(dist).load_entry_point(group, name)
  File "/usr/lib/python2.7/site-packages/pkg_resources/__init__.py", line 2700, in load_entry_point
    return ep.load()
  File "/usr/lib/python2.7/site-packages/pkg_resources/__init__.py", line 2318, in load
    return self.resolve()
  File "/usr/lib/python2.7/site-packages/pkg_resources/__init__.py", line 2324, in resolve
    module = __import__(self.module_name, fromlist=['__name__'], level=0)
  File "/usr/lib/python2.7/site-packages/certbot/main.py", line 20, in <module>
    from certbot import client
  File "/usr/lib/python2.7/site-packages/certbot/client.py", line 13, in <module>
    from acme import client as acme_client
  File "/usr/lib/python2.7/site-packages/acme/client.py", line 36, in <module>
    urllib3.contrib.pyopenssl.inject_into_urllib3()
  File "/usr/lib/python2.7/site-packages/urllib3/contrib/pyopenssl.py", line 118, in inject_into_urllib3
    _validate_dependencies_met()
  File "/usr/lib/python2.7/site-packages/urllib3/contrib/pyopenssl.py", line 153, in _validate_dependencies_met
    raise ImportError("'pyOpenSSL' module missing required functionality. "
ImportError: 'pyOpenSSL' module missing required functionality. Try upgrading to v0.14 or newer.
```
解决：
```
Steps: Install virtualenv

pip install virtualenv --upgrade
Create a virtualenv

virtualenv -p /usr/bin/python2.7 certbot
Activate the certbot virtualenv

. /root/certbot/bin/activate
Your prompt might turn into something like this

(certbot) [root@hostname ~]#

Then pip install certbot

pip install certbot
Once complete you can test certbot command under the certbot virtualenv, but this is not practical if you are going to use cron to setup certbot renewals. So deactivate the virtual environment,

(certbot) [root@hostname ~]# deactivate
Now run the certbot command from

/root/certbot/bin/certbot
```
# 工具
- https://github.com/Neilpang/acme.sh
- https://github.com/geerlingguy/ansible-role-certbot
