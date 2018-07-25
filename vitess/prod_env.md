# 生产环境考虑要点
## 资源评估
### 服务器硬件配置
- vtgate
- vttablet
- Topology(zookeeper)

### 服务安装部署及配置
- MySQL环境安装，但是不用启动
- env.sh

    - 修改hostname参数为公有云内网IP地址
  
- vtctld-up.sh

    - cell变量，线上环境根据需要进行调整
  
- vttablet-up.sh

    - tablet_hostname 变量修改为公有云内网IP地址
  
    - vtctld_addr变量修改为公有云内网IP地址
  
    > 点击实例的status，进入详情页面显示为内网IP地址，无法正常查看参数需要解决
    
``` bash
su - vitess   # 使用普通用户操作
mkdir -p $GOPATH/vtdataroot
cd $VTROOT/src/vitess.io/vitess/examples/local
./zk-up.sh                      # 启动过忽略
./cell_create.sh loveworld      # 创建项目用cell
./vtctld-up.sh                  # 启动过忽略 排查错误日志目录：/data0/workspaces/go/vtdataroot
./vttablet-loveworld-up.sh loveworld loveworld_develop 0 200
./lvtctl.sh InitShardMaster -force loveworld_develop/0 loveworld-200  # 修改keyspace name及 cell-xxx
./lvtctl.sh ListAllTablets loveworld                                  # test为cell名称，根据需要修改该变量
./lvtctl.sh ApplySchema -sql "$(cat database_loveworld.sql)" loveworld_develop    # sql文件里面不能包含注释性信息
./lvtctl.sh Backup loveworld-0000000202
./lvtctl.sh ListBackups loveworld_develop/0
./lvtctl.sh RebuildVSchemaGraph
./vtgate-loveworld-up.sh loveworld 15002 15992 15307
./client.sh

for i in `seq 0 4`;do mysql -uvt_dba -S /data0/workspaces/go/vtdataroot/vt_000000020${i}/mysql.sock -e "show databases;" ;done
mysql -uvt_dba -S /data0/workspaces/go/vtdataroot/vt_0000000200/mysql.sock -e "show slave hosts;"

./vttablet-loveworld-up.sh test loveworld_develop 0 200
./lvtctl.sh InitShardMaster -force loveworld_develop/0 test-200
./lvtctl.sh ListAllTablets test  
./lvtctl.sh ApplySchema -sql "$(cat database_loveworld.sql)" loveworld_develop
./lvtctl.sh Backup test-0000000202
./lvtctl.sh ListBackups loveworld_develop/0
./lvtctl.sh RebuildVSchemaGraph(有问题)
./vtgate-loveworld-up.sh test 15002 15992 15307
./client.sh

./vtgate-down.sh
./vttablet-down.sh
./vttablet-loveworld-down.sh test 200
./vtgate-loveworld-down.sh 15307
./vtctld-down.sh
./zk-down.sh
cd $VTDATAROOT
rm -rf *
```

### 日常管理
- Vitess + RDS
- ~~创建cell~~

    - xxx_develop
    
    - xxx_master
    
    - xxx_publish
    
- 创建vttablet loveworld
- client.sh脚本，通用修改
- vtctld web ui(Dashboard-loveworld-显示1 Not serving如何解决？)

### 故障转移/恢复
### 备份/恢复
### 架构管理/架构交换
### 重新分片/水平重新分片教程
### 升级
### 监控报警
## 参考资料
