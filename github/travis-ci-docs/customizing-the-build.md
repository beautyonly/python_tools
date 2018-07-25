
# Customizing the Build 定制build
Travis CI为每种编程语言提供了一个默认的编译环境和一组默认的步骤。您可以在此过程中自定义任何步骤.travis.yml。Travis CI使用.travis.yml存储库根目录中的文件来了解您的项目以及您希望如何执行构建。.travis.yml可以非常简约或者有很多定制。几个例子说明你的.travis.yml文件可能有什么样的信息：

- 你的项目使用什么编程语言
- 您希望在每次构建之前执行哪些命令或脚本（例如，安装或克隆项目的依赖关系）
- 使用什么命令来运行测试套件
- Emails, Campfire and IRC rooms to notify about build failures


# THE BUILD LIFECYCLE build生命周期
A build on Travis CI is made up of two steps:

- install: install any dependencies required
- script: run the build script

You can run custom commands before the installation step (before_install), and before (before_script) or after (after_script) the script step.

In a before_install step, you can install additional dependencies required by your project such as Ubuntu packages or custom services.

You can perform additional steps when your build succeeds or fails using the after_success (such as building documentation, or deploying to a custom server) or after_failure (such as uploading log files) options. In both after_failure and after_success, you can access the build result using the $TRAVIS_TEST_RESULT environment variable.

The complete build lifecycle, including three optional deployment steps and after checking out the git repository and changing to the repository directory, is:

- 1、OPTIONAL Install apt addons 可选安装
- 2、OPTIONAL Install cache components 可选安装
- 3、before_install
- 4、install
- 5、before_script
- 6、script
- 7、OPTIONAL before_cache (for cleaning up cache) 可选用于清理缓存
- 8、after_success or after_failure 二选一
- 9、OPTIONAL before_deploy 可选
- 10、OPTIONAL deploy 可选
- 11、OPTIONAL after_deploy 可选
- 12、after_script 可选

# CUSTOMIZING THE INSTALLATION STEP 定制安装步骤
默认的依赖项安装命令取决于项目语言。例如，Java可以使用Maven或Gradle，这取决于存储库中存在哪个构建文件。当存储库中存在Gemfile时，Ruby项目使用Bundler。

您可以指定自己的脚本来运行以安装项目需要的任何依赖关系.travis.yml：
install: ./install-dependencies.sh

# CUSTOMIZING THE BUILD STEP 定制build步骤

# BREAKING THE BUILD 中断build

# DEPLOYING YOUR CODE 部署代码

# SPECIFYING RUNTIME VERSIONS 运行指定版本

# INSTALLING PACKAGES USING APT 使用apt安装软件包

# INSTALLING A SECOND PROGRAMMING LANGUAGE 安装第二种编程语言

# BUILD TIMEOUTS 构建超时
测试套件或构建脚本挂起是非常常见的。Travis CI对每个作业都有特定的时间限制，并且会在以下情况下停止构建并向构建日志添加错误消息：

- 当作业在10分钟内不产生日志输出时。
- 当公共存储库上的作业花费超过50分钟时。
- 当私人存储库上的作业花费超过120分钟时。

构建可能会挂起的一些常见原因：
- 等待键盘输入或其他类型的人机交互
- 并发问题（死锁，活锁等）
- 安装需要很长时间编译的本机扩展

构建没有超时; 只要每个作业都没有超时，只要所有作业都会执行，构建就会运行。

# LIMITING CONCURRENT JOBS 限制并发作业
并发作业的最大数量取决于系统的总负载，但您可能想要设置特定限制的一种情况是：

- 如果您的构建依赖于外部资源并且可能会遇到并发作业的竞争状况。
您可以在每个存储库的设置窗格中设置最大并发作业数。

# BUILDING ONLY THE LATEST COMMIT 只构建最新提交
实用功能

# GIT CLONE DEPTH Git Clone深度
# GIT SUBMODULES Git子模块
# GIT LFS Git LFS
# GIT SPARSE CHECKOUT
# BUILDING SPECIFIC BRANCHES 建立特定分支
# SKIPPING A BUILD 跳过build
如果你不想为任何原因为特定的提交运行构建，请添加[ci skip]或添加[skip ci]到git commit消息。

有提交[ci skip]或[skip ci]在提交信息的任何地方被特拉维斯CI忽略。

注意，若多次提交被推到一起时，[skip ci]或[ci skip]仅当存在于所述头部的提交消息提交生效。

# BUILD MATRIX 构建矩阵
# IMPLEMENTING COMPLEX BUILD STEPS 实施复杂的构建步骤
# CUSTOM HOSTNAMES 自定义主机名
# WHAT REPOSITORY PROVIDERS OR VERSION CONTROL SYSTEMS CAN I USE? 可以使用那些存储库提供程序或者版本控制系统
# WHAT YAML VERSION CAN I USE IN .TRAVIS.YAML可以使用那些yaml版本
# TROUBLESHOOTING 故障排查
