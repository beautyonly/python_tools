> Graylog REST API  http://docs.graylog.org/en/2.4/pages/configuration/rest_api.html

raylog REST API的功能非常全面; 甚至Graylog Web界面也只使用Graylog REST API与Graylog集群进行交互。

要使用Web浏览器连接到Graylog REST API，只需添加api-browser到当前rest_listen_uri设置或使用节点概述页面上的API浏览器按钮（Web界面中的系统/节点）。

例如，如果您的Graylog REST API正在侦听http://192.168.178.26:9000/api/，则API浏览器将可用于http://192.168.178.26:9000/api/api-browser/。

注意: Graylog使用的Swagger UI的自定义版本目前仅适用于Google Chrome和Firefox。

# Using the API browser 使用API浏览器
提供凭据（用户名和密码）后，您可以浏览Graylog REST API的所有可用HTTP资源。

# Interacting with the Graylog REST API 与Graylog Rest API交互
虽然拥有Graylog REST API的图形用户界面非常适合交互式使用和探索性学习，但使用Graylog REST API进行自动化或将Graylog集成到另一个系统（如监控系统或故障单系统）时，真正的强大功能展现出来。

当然，API浏览器提供的相同操作可以在命令行或脚本中使用。用于此类交互的非常常见的HTTP客户端是curl。

注意：在以下示例中，用户名GM和密码superpower将用于演示如何使用运行的Graylog REST API http://192.168.178.26:9000/api。

以下命令将Graylog集群信息显示为JSON，与Web界面在“ 系统/节点”页面上显示的信息完全相同：
```
curl -u GM:superpower -H 'Accept: application/json' -X GET 'http://192.168.178.26:9000/api/cluster?pretty=true'
```
Graylog REST API将响应以下信息：
```
{
  "71ab6aaa-cb39-46be-9dac-4ba99fed3d66" : {
    "facility" : "graylog-server",
    "codename" : "Smuttynose",
    "node_id" : "71ab6aaa-cb39-46be-9dac-4ba99fed3d66",
    "cluster_id" : "3adaf799-1551-4239-84e5-6ed939b56f62",
    "version" : "2.1.1+01d50e5",
    "started_at" : "2016-09-23T10:39:00.179Z",
    "hostname" : "gm-01-c.fritz.box",
    "lifecycle" : "running",
    "lb_status" : "alive",
    "timezone" : "Europe/Berlin",
    "operating_system" : "Linux 3.10.0-327.28.3.el7.x86_64",
    "is_processing" : true
  },
  "ed0ad32d-8776-4d25-be2f-a8956ecebdcf" : {
    "facility" : "graylog-server",
    "codename" : "Smuttynose",
    "node_id" : "ed0ad32d-8776-4d25-be2f-a8956ecebdcf",
    "cluster_id" : "3adaf799-1551-4239-84e5-6ed939b56f62",
    "version" : "2.1.1+01d50e5",
    "started_at" : "2016-09-23T10:40:07.325Z",
    "hostname" : "gm-01-d.fritz.box",
    "lifecycle" : "running",
    "lb_status" : "alive",
    "timezone" : "Europe/Berlin",
    "operating_system" : "Linux 3.16.0-4-amd64",
    "is_processing" : true
  },
  "58c57924-808a-4fa7-be09-63ca551628cd" : {
    "facility" : "graylog-server",
    "codename" : "Smuttynose",
    "node_id" : "58c57924-808a-4fa7-be09-63ca551628cd",
    "cluster_id" : "3adaf799-1551-4239-84e5-6ed939b56f62",
    "version" : "2.1.1+01d50e5",
    "started_at" : "2016-09-30T13:31:39.051Z",
    "hostname" : "gm-01-u.fritz.box",
    "lifecycle" : "running",
    "lb_status" : "alive",
    "timezone" : "Europe/Berlin",
    "operating_system" : "Linux 4.4.0-36-generic",
    "is_processing" : true
  }
```
## Creating and using Access Token 创建和使用token
## Creating and using Session Token 创建和使用会话令牌
