# jmeter web(Python版本)
## 部署方法
``` bash
yum install -y nginx
cp nginx.conf /etc/nginx/nginx.conf
cp jmeter.conf /etc/nginx/default.d/
mkdir -p /home/work/report
nginx -t
systemctl start nginx
systemctl enable nginx
cp -rf jmeter_web_report /home/work/report
cp -rf nginx-2018-05-23_23:06:00 /home/work/report
cd /home/work/report/jmeter_web_report && pip install -r requirements.txt
cd /home/work/report/jmeter_web_report && uwsgi config.ini
```
## 展示
![images](https://github.com/mds1455975151/tools/blob/master/jmeter/jmeter_web/01.png)
![images](https://github.com/mds1455975151/tools/blob/master/jmeter/jmeter_web/02.png)

## FQA

## 参考资料
- https://github.com/magaofei/jmeterWebReport
