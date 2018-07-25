# 插件收集
- Dependency Graph Viewer Plugin:多job依赖关系图
![images](https://github.com/mds1455975151/tools/blob/master/jenkins/docs/images/01.png)
- Build-timeout Plugin：任务构建超时插件
- Naginator Plugin：任务重试插件
- Build User Vars Plugin：用户变量获取插件
- Build Pipeline Plugin View ：Pipeline 管道流图表展示插件

- Build Flow Plugin：工作流插件，支持DSL脚本定义工作流
- Build Graph View Plugin：build Flow插件视图（安装后需要重新才能生效）
- Multijob Plugin：多任务插件
- Build-timeout Plugin：job构建超时插件
- Build Timestamp Plugin ：任务log时间戳插件，使得job log的每次输出前面都增加当时的时间
- Parameterized Trigger Plugin：这是一个扩展型的插件，使各个job连接的时候可以传递一些job相关的信息
- Join Plugin：这也是一个触发job的插件，亮点在于它触发job的条件是等待所有当前job的下游的job都完成才会发生。
- Files Found Trigger：检测指定的目录，如果发现指定模式的文件则启动build。
- BuildResultTrigger Plugin：根据其他的job的成功或失败来启动此build。
- Publish Over SSH Plugin：通过ssh发布文件
- Rebuild Plugin：重新执行插件
- ws-cleanup Plugin ：workspace清理插件
- Cron Column Plugin： 通过定时任务例行的运行一些job
- Job Configuration History Plugin：使用心得：使job具备版本管理的能力，diff和rollback功能更是非常赞
- HTTP Request Plugin：使用心得：在构建前后可以通过该插件以http形式调用各种api接口实现和内部系统的联动
- Periodic Backup：使用心得：备份是运维一个系统必须要保障的事情，该插件的恢复功能可能不可用，需要手工进行，好处在于可以定时备份
- Job Import Plugin:使用心得：可以快速导入其他jenkins集群的已有job，需要认证的jenkins系统导入需要提供凭证才可以
- Status Monitor Plugin：构建状态插件
- Build Monitor View ：使用心得：基于该插件可以实现dashboard功能
- Build Environment Plugin：构建环境插件，可以进行构建环境比较。
- Monitoring：Monitoring of Jenkins
- jQuery Plugin：jQuery插件


# 针对DevOps的10款最佳Jenkins插件
- Job DSL Plugin
- Job Generator Plugin
- Performance Plugin
- Gitlab Merge Request Builder Plugin
- JIRA Plugin
- Kubernetes Plugin
- Build Pipeline plugin
- SCM Sync Configuration Plugin
- Jenkins Maven plugin
- Jenkins Subversion plugin

原文：http://www.infoq.com/cn/news/2018/07/devops-10best-jenkins-plugins
