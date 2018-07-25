# CMDB
- 数据库存储-MySQL
- API接口-Go
- 远程管理-Ansible
- 其他Redis、Python

# 公有云管理平台
- CDN管理
- 域名管理
- 云服务器管理
- 费用管理
- 权限管理系统
- 人员系统
## 一期规划
- 1、技术选型后端：go+mysql 前端：bootstrap
- 2、设计表结构、存储数据、go实现API供用户使用

- 命令行库：github.com/spf13/cobra
``` bash
go get -v github.com/spf13/cobra/cobra
cobra.exe init demo 基于$GOPATH路径下开始
```
- 读取各类配置文件：github.com/spf13/viper
- 依赖管理：github.com/kardianos/govendor
``` bash
go get github.com/kardianos/govendor
cd $GOPATH/src/github.com/mds1455975151/cmdb
govendor init
govendor list
govendor.exe fetch github.com/sirupsen/logrus  
```
- 记录log
  - https://github.com/sirupsen/logrus
  - github.com/heirko/go-contrib/logrusHelper

  ``` bash
  go get -u github.com/sirupsen/logrus
  import github.com/sirupsen/logrus
  logo='我是要被记录的log信息'
  logrus.Info(logo)

  govendor.exe fetch github.com/heirko/go-contrib/logrusHelper
  ```
 - Go ORM 
  - https://github.com/jinzhu/gorm
 ``` bash
  govendor.exe fetch github.com/jinzhu/gorm
  连接操作数据库需要两类包：1、ORM 2、数据库驱动
  
mysql 
import _ "github.com/go-sql-driver/mysql"
为了方便记住导入路径，GORM包装了一些驱动。
import _ "github.com/jinzhu/gorm/dialects/mysql"
// import _ "github.com/jinzhu/gorm/dialects/postgres"
// import _ "github.com/jinzhu/gorm/dialects/sqlite"
// import _ "github.com/jinzhu/gorm/dialects/mssql"
 ```
 
go import用法
import "fmt"最常用的一种形式
import "./test"导入同一目录下test包中的内容
import f "fmt"导入fmt，并给他启别名ｆ
import . "fmt"，将fmt启用别名"."，这样就可以直接使用其内容，而不用再添加ｆｍｔ，如fmt.Println可以直接写成Println
import  _ "fmt" 表示不使用该包，而是只是使用该包的init函数，并不显示的使用该包的其他内容。注意：这种形式的import，当import时就执行了fmt包中的init函数，而不能够使用该包的其他函数。
- api文档
  - https://swagger.io/
- 数据库：github.com/go-sql-driver/mysql
- HTTP框架：https://github.com/gin-gonic/gin
  - 案例：https://github.com/gin-gonic/gin/tree/master/examples

# 参考资料
- https://github.com/evcloud/evcloud_server
- https://github.com/linqian123/wisdom-mattress
- https://github.com/ixrjog/opsCloud
- https://github.com/chanyipiaomiao
- https://github.com/YoLoveLife/DevOps
- https://github.com/george518/PPGo_Job
- https://github.com/MiSecurity/x-patrol
- https://github.com/openspug/spug
