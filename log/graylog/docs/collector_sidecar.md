# Graylog Collector Sidecar
Graylog Collector Sidecar是一款适用于不同日志收集器的轻量级配置管理系统，也称为Backends。Graylog节点充当包含日志收集器配置的集中式中心。在支持的消息生成设备/主机上，Sidecar可以作为服务（Windows主机）或守护进程（Linux主机）运行。

这些配置通过graylog web界面以图形方式集中管理。对于特定需求，可以选择将原始后端配置直接存储到graylog中。

Sidecar守护程序会定期使用REST API获取目标的所有相关配置。实际获取的配置取决于主机的Sidecar配置文件中定义的“标签”。例如，Web服务器主机可以包括linux和nginx标签。

在第一次运行时，或者在检测到配置更改时，Sidecar将生成（呈现）相关的后端配置文件。然后它将启动或重新启动那些重新配置的日志收集器。

Graylog Collector Sidecar（用Go编写）和后端（用各种语言编写，如C和Go）对于已弃用的，基于Java的Graylog Collector来说是一个小型替代品。

# Backends 后端
目前Sidecar正在支持NXLog，Filebeat和Winlogbeat。它们都共享相同的Web界面。切换配置页面上的选项卡以为使用的收集器创建资源。支持的功能几乎相同。对于所有收集器，可以使用具有SSL加密的GELF输出。最常用的输入选项，如文件拖尾或Windows事件记录确实存在。在服务器端，您可以与多个收集器共享输入。例如，所有Filebeat和Winlogbeat实例都可以将日志发送到单个Graylog-Beats输入中。

# Installation
目前，我们在项目的Github发布页面上提供预编译的包。一旦Sidecar项目结算并成熟，我们将把包添加到DEB和YUM在线存储库中。让Sidecar工作下载一个软件包并将其安装在目标系统上。

请按照版本矩阵选择正确的包：

边车版	Graylog服务器版本
0.0.9	2.1.x的
0.1.x	2.2.x中，2.3.x版本，2.4.x的
应在要从中收集日志数据的远程计算机上执行以下所有命令。
## Beats backend
## NXLog backend
# Configuration
## First start
## Sidecar Status
