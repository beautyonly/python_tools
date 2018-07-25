## Run Vitess Locally 本地运行Vitess
### Contents  内容
您可以使用Docker或手动构建过程来构建Vitess

如果您还遇到问题或由任何疑问，请在我们的论坛上发帖。
### Docker Build  Docker构建
  在Docker中运行Vitess，您可以在Docker Hub上使用我们预先构建的images,或者自己构建它们。

- Docker Hub Images
  - 该vitess/base镜像包含一个完整的开发环境，能够建立Vitess和运行集成测试。
  - 该vitess/lite镜像只包含已编译的二进制文件Vitess，排除的ZooKeeper。它可以运行Vitess，但缺乏构建Vitess或运行测试所需的环境。它主要用于Kubernetes指南上的Vitess。

例如，您可以直接运行vitess/base，Docker会为您下载映像：
``` bash
$ sudo docker run -ti vitess/base bash
vitess@32f187ef9351:/vt/src/vitess.io/vitess$ make build
```
现在，您可以继续在刚刚启动的Docker容器内启动Vitess集群。请注意，如果您想从容器外部访问服务器，则需要按Docker Engine参考指南中所述公开端口。

对于本地测试，您还可以通过Docker访问为容器创建的本地IP地址上的服务器：
``` bash
$ docker inspect 32f187ef9351 | grep IPAddress
### example output:
#    "IPAddress": "172.17.3.1",
```
- Custom Docker Image 自定义Docker镜像
您还可以自己构建Vitess Docker镜像以包含您自己的修补程序或配置数据。该 Dockerfile 在Vitess树的根构建vitess/base图像。该搬运工 子目录包含用于构建其它图像，如脚本vitess/lite。

我们Makefile还包含构建图像的规则。例如：
``` bash
# Create vitess/bootstrap, which prepares everything up to ./bootstrap.sh
vitess$ make docker_bootstrap
# Create vitess/base from vitess/bootstrap by copying in your local working directory.
vitess$ make docker_base
```
### Manual Build 手动构建
#### Install Dependencies  安装依赖关系

我们目前经常在Ubuntu 14.04（Trusty）和Debian 8（Jessie）上测试Vitess。OS X 10.11（El Capitan）也应该可以工作，安装说明如下。

##### Ubuntu和Debian

另外，Vitess需要下面列出的软件和库。
- 安装Go 1.9+。
- 安装MariaDB 10.0或 MySQL 5.6。您可以使用任何安装方法（src / bin / rpm / deb），但一定要包含客户端开发头文件（libmariadbclient-dev或libmysqlclient-dev）。

  Vitess开发团队目前正在对MariaDB 10.0.21和MySQL 5.6.27进行测试。

  如果您正在安装MariaDB，请注意您必须安装10.0或更高版本。如果您正在使用apt-get，请确认您的存储库提供了安装该版本的选项。您也可以直接从mariadb.org下载源代码。

  如果您在MySQL 5.6中使用Ubuntu 14.04，则默认安装可能会丢失文件/usr/share/mysql/my-default.cnf。它会显示为类似的错误Could not find my-default.cnf。如果遇到这个问题，只需添加以下内容：
  ``` bash
  [mysqld]
  sql_mode=NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES
  ```
- 卸载或禁用AppArmor。某些版本的MySQL带有Vitess工具尚未识别的默认AppArmor配置。当Vitess通过该mysqlctl工具初始化MySQL实例时，这会导致各种权限失败。这只是测试环境的一个问题。如果AppArmor在生产中是必需的，则可以在不通过mysqlctl的情况下适当地配置MySQL实例。
  ``` bash
  $ sudo service apparmor stop
  $ sudo service apparmor teardown
  $ sudo update-rc.d -f apparmor remove
  ```
  重新启动，以确保AppArmor完全禁用。

- 从下面列出的选项中选择一项锁定服务。技术上可以使用另一台锁服务器，但插件目前仅适用于ZooKeeper，etcd和consul。
  - ZooKeeper 3.4.10 is included by default.
  - Install etcd v3.0+. If you use etcd, remember to include the etcd command on your path.
  - Install Consul. If you use consul, remember to include the consul command on your path.

- 安装构建和运行Vitess所需的以下其他工具：
  - make
  - automake
  - libtool
  - python-dev
  - python-virtualenv
  - python-mysqldb
  - libssl-dev
  - g++
  - git
  - pkg-config
  - bison
  - curl
  - unzip
这些可以通过以下apt-get命令来安装：
  ``` bash
  $ sudo apt-get install make automake libtool python-dev python-virtualenv python-mysqldb libssl-dev g++ git pkg-config bison curl unzip
  ```
如果您决定在步骤3中使用ZooKeeper，则还需要安装Java Runtime，如OpenJDK。
  ``` bash
  $ sudo apt-get install openjdk-7-jre
  ```
##### OS X
- 安装Homebrew。如果你的/ usr / local目录不是空的，你以前从未使用过Homebrew，那么 运行以下命令将是 强制性的：
  ``` bash
  sudo chown -R $(whoami):admin /usr/local
  ```
- 在OS X上，必须使用MySQL 5.6，MariaDB由于某种原因而不起作用。它应该从Homebrew安装（安装步骤如下）。

- 如果安装了Xcode（使用控制台工具，自7.1版以来应自动捆绑），则在此步骤中应满足所有开发依赖关系。如果不存在Xcode，则需要安装pkg-config。
  ``` bash
  brew install pkg-config
  ```
- ZooKeeper被用作锁定服务。

- 运行以下命令：
  ``` bash
  brew install go automake libtool python git bison curl wget homebrew/versions/mysql56
  pip install --upgrade pip setuptools
  pip install virtualenv
  pip install MySQL-python
  pip install tox
  ```
- 从此URL安装Java运行时：https : //support.apple.com/kb/dl1572? locale =zh_CN Apple仅支持Java 6.如果您需要安装较新版本，此链接可能会有所帮助： http：// osxdaily .COM / 2015/10/17 /如何安装的-java的在-OS-X-EL-匹/

- Vitess引导脚本会对运行时执行一些检查，因此建议在〜/ .profile或〜/ .bashrc或〜/ .zshrc中包含以下命令：
  ``` bash
  export PATH=/usr/local/opt/go/libexec/bin:$PATH
  export GOROOT=/usr/local/opt/go/libexec
  ```
- 使用pip安装enum34 Python包时存在问题，因此必须编辑以下文件：
  ``` bash
  /usr/local/opt/python/Frameworks/Python.framework/Versions/2.7/lib/python2.7/distutils/distutils.cfg
  ```
和这一行：
  ``` bash
  prefix=/usr/local
  ```
必须注释掉：
  ``` bash
  # prefix=/usr/local
  ```
从下一步运行./bootstrap.sh脚本之后，您可以恢复更改。

- 为使Vitess主机名解析功能正常工作，必须将新条目添加到/ etc / hosts文件中，并将当前计算机的LAN IP地址（最好是IPv4）和当前主机名添加到当前主机名中，您可以通过键入'主机名'命令在终端。

在〜/ .profile或〜/ .bashrc或〜/ .zshrc中加入以下命令强制使用Go DNS解析器也是一个好主意：
  ``` bash
  export GODEBUG=netdns=go
  ```
#### Build Vitess  构建Vitess

- 导航到您想要下载Vitess源代码的目录并克隆Vitess Github回购。完成后，导航到该src/vitess.io/vitess目录。
  ``` bash
  cd $WORKSPACE
  git clone https://github.com/vitessio/vitess.git \
      src/vitess.io/vitess
  cd src/vitess.io/vitess
  ```
- 设置MYSQL_FLAVOR环境变量。为您的数据库选择适当的值。该值区分大小写。
  ``` bash
  export MYSQL_FLAVOR=MariaDB
  # or (mandatory for OS X)
  # export MYSQL_FLAVOR=MySQL56
  ```
- 如果您选择的数据库安装在除了以外的位置/usr/bin，请将该VT_MYSQL_ROOT变量设置为MariaDB安装的根目录。例如，如果安装了MariaDB /usr/local/mysql，请运行以下命令。
  ``` bash
  export VT_MYSQL_ROOT=/usr/local/mysql

  # on OS X, this is the correct value:
  # export VT_MYSQL_ROOT=/usr/local/opt/mysql56
  ```
  请注意，该命令表示mysql应该在位置找到可执行文件/usr/local/mysql/bin/mysql。

- 运行mysqld --version并确认您正在运行MariaDB或MySQL的正确版本。MariaDB和MySQL的值应该是10或更高。

  使用下面的命令构建Vitess。请注意，该 bootstrap.sh脚本需要下载一些依赖项。如果你的机器需要代理服务器访问Internet，您将需要设置常用的环境变量（例如http_proxy， https_proxy，no_proxy）。

  运行boostrap.sh脚本：
  ``` bash
  ./bootstrap.sh
  ### example output:
  # skipping zookeeper build
  # go install golang.org/x/tools/cmd/cover ...
  # Found MariaDB installation in ...
  # creating git pre-commit hooks
  #
  # source dev.env in your shell before building
  # Remaining commands to build Vitess
  . ./dev.env
  make build
  ```
#### Run Tests 运行测试

注意：如果您使用的是etcd，请设置以下环境变量：
  ``` bash
  export VT_TEST_FLAGS='--topo-server-flavor=etcd2'
  ```
注意：如果您使用consul，请设置以下环境变量：
  ``` bash
  export VT_TEST_FLAGS='--topo-server-flavor=consul'
  ```

运行时的默认目标make test包含一整套旨在帮助Vitess开发人员验证代码更改的测试。这些测试通过在本地计算机上启动许多服务器来模拟小型Vitess集群。为此，他们需要大量资源; 建议至少使用8GB RAM和SSD来运行测试。

一些测试需要额外的包。例如，在Ubuntu上：
  ``` bash
  $ sudo apt-get install chromium-browser mvn xvfb
  ```
如果您只想检查Vitess是否在您的环境中工作，则可以运行一组较轻的测试：
  ``` bash
  make site_test
  ```
- 常见测试问题

尝试make test在动力不足的机器上运行完整的开发人员测试套件（）通常会导致失败。如果您在运行较轻的测试集时仍然看到相同的失败（make site_test），请在vitess@googlegroups.com 论坛上告诉开发团队 。

  - Node already exists, port in use, etc.

  > 失败的测试可能会导致孤立的进程。如果您使用默认设置，则可以使用以下命令来识别并终止这些进程：
  ``` bash
  pgrep -f -l '(vtdataroot|VTDATAROOT)' # list Vitess processes
  pkill -f '(vtdataroot|VTDATAROOT)' # kill Vitess processes
  ```

  - Too many connections to MySQL, or other timeouts
  > 此错误通常意味着您的磁盘太慢。如果您无法访问SSD，则可以尝试使用虚拟硬盘进行测试。

  - Connection refused to tablet, MySQL socket not found, etc.
  > 这些错误可能表明机器内存耗尽，并且尝试分配更多RAM时服务器崩溃。一些较重的测试需要高达8GB的RAM。

  - Connection refused in zkctl test
  > 此错误可能表示机器没有安装Java Runtime，如果您将ZooKeeper用作锁定服务器，则这是一项要求。

  - Running out of disk space
  > 一些较大的测试在磁盘上使用高达4GB的临时空间。

#### Start a Vitess cluster  启动Vitess集群

在完成上面构建Vitess的指示后，可以使用Github repo中的示例脚本在本地机器上启动Vitess集群。这些脚本使用ZooKeeper作为锁定服务。Vitess发行版中包含ZooKeeper。

- 检查系统设置

> 一些Linux发行版的默认文件描述符限制对数据库服务器来说太低。这个问题可能会在数据库崩溃时显示消息“打开的文件过多”。
检查系统范围的file-max设置以及用户特定的 ulimit值。我们建议将它们设置在100K以上以确保安全。确切的程序 可能因您的Linux发行版而异。

- 配置环境变量

> 如果您仍然在用于运行构建命令的终端窗口中，则可以跳到下一步，因为环境变量已经设置。
如果您将此示例适用于您自己的部署，则运行脚本之前所需的唯一环境变量是VTROOT和VTDATAROOT。

设置VTROOT为Vitess源代码树的父级。例如，如果你跑make build进去$HOME/vt/src/vitess.io/vitess，那么你应该设置：
  ``` bash
  export VTROOT=$HOME/vt
  ```
设置VTDATAROOT到您想要存储数据文件和日志的目录。例如：
  ``` bash
  export VTDATAROOT=$HOME/vtdataroot
  ```
- 启动ZooKeeper或Etcd

Vitess集群中的服务器通过查找存储在分布式锁定服务中的动态配置数据来相互找到对方。以下脚本创建一个小型ZooKeeper集群：
  ``` bash
  $ cd $VTROOT/src/vitess.io/vitess/examples/local
  vitess/examples/local$ ./zk-up.sh
  ### example output:
  # Starting zk servers...
  # Waiting for zk servers to be ready...
  ```
在ZooKeeper集群运行之后，我们只需告诉每个Vitess进程如何连接到ZooKeeper。然后，每个进程都可以通过ZooKeeper进行协调来找到所有其他的Vitess进程。

我们的每个脚本自动使用TOPOLOGY_FLAGS环境变量指向全局ZooKeeper实例。全局实例依次被配置为指向本地实例。在我们的示例脚本中，它们都托管在相同的ZooKeeper服务中。

如果您想将Etcd用作分布式锁定服务，则以下脚本将创建一个Etcd实例：
  ``` bash
  $ cd $VTROOT/src/vitess.io/vitess/examples/local
  vitess/examples/local$ source ./topo-etcd2.sh
  vitess/examples/local$ ./etcd-up.sh
  ### example output:
  # enter etcd2 env
  # etcdmain: etcd Version: 3.X.X
  # ...
  # etcd start done...
  ```
- 启动vtctld

该vtctld服务器提供了显示所有存储在ZooKeeper的协调信息的Web界面。
  ``` bash
  vitess/examples/local$ ./vtctld-up.sh
  # Starting vtctld
  # Access vtctld web UI at http://localhost:15000
  # Send commands with: vtctlclient -server localhost:15999 ...
  ```
打开http://localhost:15000以验证 vtctld正在运行。目前还没有任何信息，但菜单应该出现，这表明 vtctld正在运行。

所述vtctld服务器还接受来自命令vtctlclient工具，其用于管理群集。请注意，RPC的端口（在本例中15999）与Web UI端口（15000）不同。这些端口可以使用命令行标志进行配置，如演示vtctld-up.sh。

为了方便起见，我们将lvtctl.sh在示例命令中使用脚本，以避免每次都输入vtctld地址。
  ``` bash
  # List available commands
  vitess/examples/local$ ./lvtctl.sh help
  ```
- 启动vttablets

该vttablet-up.sh脚本会引出三个vttablets，并根据脚本文件顶部设置的变量将它们分配给一个keyspace和shard。
  ``` bash
  vitess/examples/local$ ./vttablet-up.sh
  # Output from vttablet-up.sh is below
  # Starting MySQL for tablet test-0000000100...
  # Starting vttablet for test-0000000100...
  # Access tablet test-0000000100 at http://localhost:15100/debug/status
  # Starting MySQL for tablet test-0000000101...
  # Starting vttablet for test-0000000101...
  # Access tablet test-0000000101 at http://localhost:15101/debug/status
  # Starting MySQL for tablet test-0000000102...
  # Starting vttablet for test-0000000102...
  # Access tablet test-0000000102 at http://localhost:15102/debug/status
  ```
此命令完成后，刷新vtctld Web UI，您应该看到一个名为test_keyspace单个分片的密钥空间0。这是一个未硬化的密钥空间。

如果您点击分片框，您会看到该分片中的平板电脑列表。请注意，此时平板电脑不健康是正常现象，因为您尚未初始化它们。

您也可以点击每台平板电脑上的状态链接进入其状态页面，显示其操作的更多细节。每个Vitess服务器都/debug/status在其Web端口上提供状态页面。

- 初始化MySQL数据库

接下来，指定其中一个平板电脑作为初始主人。Vitess会自动连接其他从属的mysqld实例，以便它们从主设备的mysqld开始复制。这也是在创建默认数据库时。由于我们的密钥空间是命名的test_keyspace，MySQL数据库将被命名vt_test_keyspace。
``` bash
vitess/examples/local$ ./lvtctl.sh InitShardMaster -force test_keyspace/0 test-100
### example output:
# master-elect tablet test-0000000100 is not the shard master, proceeding anyway as -force was used
# master-elect tablet test-0000000100 is not a master in the shard, proceeding anyway as -force was used
```
注意：由于这是碎片第一次启动，平板电脑尚未进行任何复制，并且没有现有的主设备。InitShardMaster上面的命令使用该-force标志绕过通常的适用性检查，如果这不是全新的碎片，则适用。

运行此命令后，返回到vtctld Web界面中的Shard Status页面。当你刷新页面时，你应该看到一个vttablet是主，两个是副本，另外两个是rdonly。

你也可以在命令行看到这个：
``` bash
vitess/examples/local$ ./lvtctl.sh ListAllTablets test
### example output:
# test-0000000100 test_keyspace 0 master localhost:15100 localhost:17100 []
# test-0000000101 test_keyspace 0 replica localhost:15101 localhost:17101 []
# test-0000000102 test_keyspace 0 replica localhost:15102 localhost:17102 []
# test-0000000103 test_keyspace 0 rdonly localhost:15103 localhost:17103 []
# test-0000000104 test_keyspace 0 rdonly localhost:15104 localhost:17104 []
```
- 创建一个表

该vtctlclient工具可用于在键盘空间中的所有平板电脑上应用数据库架构。以下命令创建create_test_table.sql文件中定义的表格：
``` bash
# Make sure to run this from the examples/local dir, so it finds the file.
vitess/examples/local$ ./lvtctl.sh ApplySchema -sql "$(cat create_test_table.sql)" test_keyspace
下面显示了创建表的SQL：

CREATE TABLE messages (
  page BIGINT(20) UNSIGNED,
  time_created_ns BIGINT(20) UNSIGNED,
  message VARCHAR(10000),
  PRIMARY KEY (page, time_created_ns)
) ENGINE=InnoDB
```
- 采取备份

现在应用了初始模式，现在是进行第一次备份的好时机 。此备份将用于自动恢复您运行的任何其他副本，然后将它们连接到主服务器并赶上复制。如果现有的平板电脑出现故障并在没有数据的情况下进行备份，它也会自动从最新的备份中恢复，然后恢复复制。
``` bash
vitess/examples/local$ ./lvtctl.sh Backup test-0000000102
```
备份完成后，您可以列出碎片的可用备份：
``` bash
vitess/examples/local$ ./lvtctl.sh ListBackups test_keyspace/0
### example output:
# 2016-05-06.072724.test-0000000102
```
注意：在此单服务器示例设置中，备份存储在 $VTDATAROOT/backups。在多服务器部署中，您通常会在那里挂载一个NFS目录。您还可以通过-file_backup_storage_root在vtctld和vttablet上设置标志来更改位置 ，如vtctld-up.sh和中所示vttablet-up.sh。

- 初始化Vitess路由架构

在这些例子中，我们只是使用一个没有特定配置的数据库。所以我们只需要使这个（空的）配置可见即可使用。这是通过运行以下命令完成的：

vitess/examples/local$ ./lvtctl.sh RebuildVSchemaGraph
（当它工作时，这个命令不会显示任何输出。）

- 启动vtgate

Vitess使用vtgate将每个客户端查询路由到正确的vttablet。这个本地示例运行单个vtgate实例，但真正的部署可能会运行多个vtgate实例来共享负载。
``` bash
vitess/examples/local$ ./vtgate-up.sh
```
##### Run a Client Application  运行客户端应用横向

该client.py文件是一个简单的示例应用程序，它连接到vtgate并执行一些查询。要运行它，您需要：

将Vitess Python包添加到您的PYTHONPATH。

要么

使用client.sh包装脚本，它临时设置环境然后运行client.py。
``` bash
vitess/examples/local$ ./client.sh
### example output:
# Inserting into master...
# Reading from master...
# (5L, 1462510331910124032L, 'V is for speed')
# (15L, 1462519383758071808L, 'V is for speed')
# (42L, 1462510369213753088L, 'V is for speed')
# ...
```
在Java，PHP和Go的同一目录中也有示例客户端。请参阅每个示例文件顶部的注释以获取使用说明。
##### Try Vitess resharding 尝试Vitess重新粉碎

现在您已经完成了一个完整的Vitess堆栈，您可能想要继续使用 Horizo​​ntal Sharding工作流指南 或Horizo​​ntal Sharding codelab （如果您希望通过命令手动运行每个步骤）来尝试 动态重新分片。

如果是这样，你可以跳过拆除指南，因为拆分指南在这里提取。如果不是，继续下面的清理步骤。

##### Tear down the cluster 清理集群

每个-up.sh脚本都有相应的-down.sh脚本来停止服务器。
``` bash
vitess/examples/local$ ./vtgate-down.sh
vitess/examples/local$ ./vttablet-down.sh
vitess/examples/local$ ./vtctld-down.sh
vitess/examples/local$ ./zk-down.sh  # If you use Etcd, run ./etcd-down.sh
```
请注意，这些-down.sh脚本将留下任何创建的数据文件。如果您已完成此示例数据，则可以清除以下内容VTDATAROOT：
``` bash
$ cd $VTDATAROOT
/path/to/vtdataroot$ rm -rf *
```

### Troubleshooting 故障排除

如果出现任何问题，请检查$VTDATAROOT/tmp目录中的日志以获取错误消息。还有一些平板特定的日志，以及各种$VTDATAROOT/vt_*目录中的MySQL日志。

如果您需要帮助诊断问题，请将邮件发送到我们的 邮件列表。除了在命令行中看到的任何错误之外，还可以帮助将VTDATAROOT目录的存档上载到文件共享服务并提供指向它的链接。
