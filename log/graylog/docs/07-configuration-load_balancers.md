# Load balancer integration
官网地址：http://docs.graylog.org/en/latest/pages/configuration/load_balancers.html

运行多个graylog服务器时，常见的部署方案是通过IP负载均衡器路由消息流量。通过这样做，我们可以通过简单的添加更多并行运行的服务器来提高可用性及提高消息处理吞吐量。

## Load balancer state 负载均衡器状态
负载均衡器通常需要某种方式来确定后端服务是否可访问且健康与否。为此graylog通过rest api访问负载均衡器状态。
负载均衡器状态有两种变化方式：
- 生命周期变化
- 通过rest api干预

例如:

GET /api/system/lbstatus

http://xxx/api/system/lbstatus

两种不同的状态：
- ALIVE
- DEAD

PUT /api/system/lbstatus/override/alive

PUT /api/system/lbstatus/override/dead
## Graceful shutdown 优雅关闭

## Web Interface
