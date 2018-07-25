## Custom Docker Build  自定义Docker构建
地址：https://vitess.io/getting-started/docker-build/

默认情况下，Kubernetes将配置指向Docker hub vitess/lite上的images.

我们将lite images创建为master images的精简版本，base这样 Kubernetes pod可以更快的启动。该lite images并不经常发生变化，由Vitess团队每个版本手动更新。相反，base每次推送到GitHub master branch后，images都会自动更新。有关我们提供的不同images的更多信息，请阅读docker/README.md文件。

如果你的目标是运行最新的Vitess代码，最简单的解决方案是使用更大的base images，而不是lite。

另一种选择是定时我们的Docker images并自己构建它们。这在下面进行描述，并涉及base首先构建images。然后，您可以使用我们的构建脚本，lite从内置base images中提取Vitess二进制文件。

1、安装Docker环境
2、注册Docker Hub账号
3、获取源码
4、获取MySQL images
5、构建MySQL base
6、构建MySQL lite
7、tag push
8、Kubernetes configs
