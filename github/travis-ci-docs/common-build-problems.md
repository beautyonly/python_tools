# Common Build Problems

# MY TESTS BROKE BUT WERE WORKING YESTERDAY 测试中断，但是昨天还是好的
查找最近一次成功的构建环境信息，确定各类依赖版本
# MY BUILD SCRIPT IS KILLED WITHOUT ANY ERROR 脚本中断没有任何错误
沙箱 内存耗尽
# MY BUILD FAILS UNEXPECTEDLY 构建意外失败
set -e
# SEGMENTATION FAULTS FROM THE LANGUAGE INTERPRETER (RUBY, PYTHON, PHP, NODE.JS, ETC.)

# RUBY: RSPEC RETURNS 0 EVEN THOUGH THE BUILD FAILED
# CAPYBARA: I’M GETTING ERRORS ABOUT ELEMENTS NOT BEING FOUND
# RUBY: INSTALLING THE DEBUGGER_RUBY-CORE-SOURCE LIBRARY FAILS
# RUBY: TESTS FROZEN AND CANCELLED AFTER 10 MINUTE LOG SILENCE
# MAC: OS X MAVERICKS (10.9) CODE SIGNING ERRORS
# MAC: MACOS SIERRA (10.12) CODE SIGNING ERRORS
# MAC: ERRORS RUNNING COCOAPODS
# SYSTEM: REQUIRED LANGUAGE PACK ISN’T INSTALLED
# LINUX: APT FAILS TO INSTALL PACKAGE WITH 404 ERROR
# TRAVIS CI DOES NOT PRESERVE STATE BETWEEN BUILDS
# SSH IS NOT WORKING AS EXPECTED
# GIT SUBMODULES ARE NOT UPDATED CORRECTLY
# GIT CANNOT CLONE MY SUBMODULES
# MY BUILDS ARE TIMING OUT 我的构建超时
遗憾的是，构建可能会超时，无论是在安装依赖项期间，还是在构建本身期间，例如由于命令运行时间较长而不产生任何输出。

我们的构建具有全局超时和基于输出的超时。如果在10分钟内没有收到构建的输出，则会由于不明原因而导致停滞，并随后被终止。

在其他时候，依赖关系的安装可能会超时。Bundler和RubyGems是一个相关的例子。我们的服务器之间的网络连接有时会影响与APT，Maven或其他存储库的连接。

解决这个问题的方法很少。
## Timeouts installing dependencies
### Bundler
### travis_retry
## Build times out because no output was received

# TROUBLESHOOTING LOCALLY IN A DOCKER IMAGE 在Docker images中本地故障排查
## Running a Container Based Docker Image Locally
1、Download and install Docker:
- Windows
- OS X
- Ubuntu Linux

2、Choose a Docker image

Select an image on Docker Hub for the language (“default” if no other name matches) using the table below:

language	Docker Hub image
- android	travisci/ci-amethyst:packer-1512508255-986baf0
- erlang	travisci/ci-amethyst:packer-1512508255-986baf0
- haskell	travisci/ci-amethyst:packer-1512508255-986baf0
- perl	travisci/ci-amethyst:packer-1512508255-986baf0
- default	travisci/ci-garnet:packer-1512502276-986baf0
- go	travisci/ci-garnet:packer-1512502276-986baf0
- jvm	travisci/ci-garnet:packer-1512502276-986baf0
- node_js	travisci/ci-garnet:packer-1512502276-986baf0
- php	travisci/ci-garnet:packer-1512502276-986baf0
- python	travisci/ci-garnet:packer-1512502276-986baf0
- ruby	travisci/ci-garnet:packer-1512502276-986baf0

3、Start a Docker container detached with /sbin/init:
ci-garnet image on Trusty
``` bash
docker run --name travis-debug -dit travisci/ci-garnet:packer-1490989530 /sbin/init
```
4、Open a login shell in the running container
``` bash
docker exec -it travis-debug bash -l
```
5、Switch to the travis user:
``` bash
su - travis
```
6、Clone your git repository into the home directory.
``` bash
git clone --depth=50 --branch=master https://github.com/travis-ci/travis-build.git
```
7、(Optional) Check out the commit you want to test
``` bash
git checkout 6b14763
```
8、Manually install dependencies, if any.

9、Manually run your Travis CI build command.

# RUNNING BUILDS IN DEBUG MODE
# LOG LENGTH EXCEEDED
# FTP/SMTP/OTHER PROTOCOL DOES NOT WORK
# I PUSHED A COMMIT AND CAN’T FIND ITS CORRESPONDING BUILD 推送了提交，找不到相应构建

# I’M RUNNING OUT OF DISK SPACE IN MY BUILD 内部磁盘空间不足
