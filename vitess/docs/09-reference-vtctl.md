# vtctl
官网地址：https://vitess.io/reference/vtctl/
## Contents
  本文档描述了Vitess API方法，使您的客户端应用程序能够轻松的与您的存储系统对话以查询数据。API方法分为以下几类：

- Cells
- Generic
- Keyspaces
- Queries
- Replication Graph
- Resharding Throttler
- Schema, Version, Permissions
- Serving Graph
- Shards
- Tablets
- Topo
- Workflows

vtctld、vtctl、vtctlclient三者之间的关系
- vtctld
  守护进程
- vtctl
  不需要vtctld守护进程，它需要从topology之间获取信息
- vtctlclient
  vtctlclient 需要vtctld的存在才能进行相应的操作 需要-server 指向vtctld的端口

## Cells
  - AddCellInfo
  - DeleteCellInfo
  - GetCellInfo
  - GetCellInfoNames
  - UpdateCellInfo

``` bash
cd /data0/workspaces/go/src/vitess.io/vitess/examples/local
./lvtctl.sh AddCellInfo cell-loveworld
./lvtctl.sh DeleteCellInfo first
./lvtctl.sh GetCellInfo test
{
  "server_address": "localhost:21811,localhost:21812,localhost:21813",
  "root": "/vitess/test",
  "region": ""
}
./lvtctl.sh GetCellInfoNames
cell-loveworld
test
./lvtctl.sh UpdateCellInfo test
```

## Generic 通用
  - ListAllTablets
  - ListTablets
  - Validate

``` bash
./lvtctl.sh ListAllTablets test
test-0000000100 test_keyspace 0 master 192.168.47.100:15100 192.168.47.100:17100 []
test-0000000101 test_keyspace 0 restore 192.168.47.100:15101 192.168.47.100:17101 []
test-0000000102 test_keyspace 0 restore 192.168.47.100:15102 192.168.47.100:17102 []
test-0000000103 test_keyspace 0 restore 192.168.47.100:15103 192.168.47.100:17103 []
test-0000000104 test_keyspace 0 restore 192.168.47.100:15104 192.168.47.100:17104 []
./lvtctl.sh ListTablets test-100
test-0000000100 test_keyspace 0 master 192.168.47.100:15100 192.168.47.100:17100 []
./lvtctl.sh Validate
```
## Keyspaces
  - CreateKeyspace
  - DeleteKeyspace
  - FindAllShardsInKeyspace
  - GetKeyspace
  - GetKeyspaces
  - MigrateServedFrom
  - MigrateServedTypes
  - RebuildKeyspaceGraph
  - RemoveKeyspaceCell
  - SetKeyspaceServedFrom
  - SetKeyspaceShardingInfo
  - ValidateKeyspace
  - WaitForDrain

``` bash
./lvtctl.sh CreateKeyspace loveworld_keyspace
 ./lvtctl.sh DeleteKeyspace loveworld_keyspace  // 遍历所有的cell
W0504 18:28:40.842436   33900 main.go:58] W0504 10:28:40.841252 keyspace.go:891] Cannot delete KeyspaceReplication in cell cell-loveworld for loveworld_keyspace: no valid address found in
W0504 18:28:46.153529   33900 main.go:58] W0504 10:28:46.151431 keyspace.go:895] Cannot delete SrvKeyspace in cell cell-loveworld for loveworld_keyspace: no valid address found in
W0504 18:28:47.578951   33900 main.go:58] W0504 10:28:47.578291 keyspace.go:891] Cannot delete KeyspaceReplication in cell d for loveworld_keyspace: no valid address found in
W0504 18:28:52.813035   33900 main.go:58] W0504 10:28:52.812128 keyspace.go:895] Cannot delete SrvKeyspace in cell d for loveworld_keyspace: no valid address found in
./lvtctl.sh FindAllShardsInKeyspace test_keyspace
{
  "0": {
    "master_alias": {
      "cell": "test",
      "uid": 100
    },
    "served_types": [
      {
        "tablet_type": 1
      },
      {
        "tablet_type": 2
      },
      {
        "tablet_type": 3
      }
    ],
    "cells": [
      "test"
    ]
  }
}
./lvtctl.sh GetKeyspace loveworld_keyspace
{
  "sharding_column_name": "",
  "sharding_column_type": 0,
  "served_froms": [
  ]
}
./lvtctl.sh GetKeyspaces
test_keyspace
```

## Queries
  - VtGateExecute
  - VtGateExecuteKeyspaceIds
  - VtGateExecuteShards
  - VtGateSplitQuery
  - VtTabletBegin
  - VtTabletCommit
  - VtTabletExecute
  - VtTabletRollback
  - VtTabletStreamHealth
  - VtTabletUpdateStream

``` bash
```
## Replication Graph
- GetShardReplication

``` bash
./lvtctl.sh GetShardReplication test test_keyspace/0
{
  "nodes": [
    {
      "tablet_alias": {
        "cell": "test",
        "uid": 102
      }
    },
    {
      "tablet_alias": {
        "cell": "test",
        "uid": 101
      }
    },
    {
      "tablet_alias": {
        "cell": "test",
        "uid": 100
      }
    },
    {
      "tablet_alias": {
        "cell": "test",
        "uid": 103
      }
    },
    {
      "tablet_alias": {
        "cell": "test",
        "uid": 104
      }
    }
  ]
}
```
## Resharding Throttler
- GetThrottlerConfiguration
- ResetThrottlerConfiguration
- ThrottlerMaxRates
- ThrottlerSetMaxRate
- UpdateThrottlerConfiguration

``` bash

```
### Schema, Version, Permissions 架构，版本，权限
- ApplySchema
  将模式更改应用于每个master节点上的指定keyspaces，并行运行在所有shard上。然后这些更改通过复制传播到slave。
- ApplyVSchema
- CopySchemaShard
- GetPermissions
  显示tablet的权限
- GetSchema
- GetVSchema
  显示Vtgate路由模式
- RebuildVSchemaGraph
- ReloadSchema
- ReloadSchemaKeyspace
- ReloadSchemaShard
- ValidatePermissionsKeyspace
- ValidatePermissionsShard
- ValidateSchemaKeyspace
- ValidateSchemaShard
- ValidateVersionKeyspace
- ValidateVersionShard
``` bash
```
## Serving Graph 服务视图
- GetSrvKeyspace
  输出包含有关srvkeyspace信息的json数据结构
- GetSrvKeyspaceNames
  输出keyspace名称列表
- GetSrvVSchema
``` bash
 ./lvtctl.sh GetSrvKeyspace test test_keyspace
{
  "partitions": [
    {
      "served_type": 1,
      "shard_references": [
        {
          "name": "0",
          "key_range": null
        }
      ]
    },
    {
      "served_type": 2,
      "shard_references": [
        {
          "name": "0",
          "key_range": null
        }
      ]
    },
    {
      "served_type": 3,
      "shard_references": [
        {
          "name": "0",
          "key_range": null
        }
      ]
    }
  ],
  "sharding_column_name": "",
  "sharding_column_type": 0,
  "served_from": [
  ]
}
./lvtctl.sh GetSrvKeyspaceNames test
test_keyspace
./lvtctl.sh GetSrvVSchema test
{
  "keyspaces": {
    "test_keyspace": {
      "sharded": false,
      "vindexes": {
      },
      "tables": {
      }
    }
  }
}
```

# Shards 分片
- CreateShard
  创建指定的shard
- DeleteShard
  删除指定的shard,在递归模式下，它也会删除属于shard下的所有tablets。否则，shard必须没有剩余下tablets.

- EmergencyReparentShard
  把the shard给新的master,假定old master已经死了，没有回应。

- GetShard
  输出包含关于shard的信息的json结构
``` bash
 ./lvtctl.sh GetShard test_keyspace/0
{
  "master_alias": {
    "cell": "test",
    "uid": 100
  },
  "key_range": null,
  "served_types": [
    {
      "tablet_type": 1,
      "cells": [
      ]
    },
    {
      "tablet_type": 2,
      "cells": [
      ]
    },
    {
      "tablet_type": 3,
      "cells": [
      ]
    }
  ],
  "source_shards": [
  ],
  "cells": [
    "test"
  ],
  "tablet_controls": [
  ]
}
```
- InitShardMaster
  设置shard的初始化主数据。将提供的master设备的shard从设备中的所有其他tablets。警告：这可能会导致已经复制的分片上的数据丢失。应该使用PlannedReparentShard或EmergencyReparentShard。

- ListBackups
  列出shard的所有备份
``` bash
./lvtctl.sh ListBackups test_keyspace/0
2018-05-04.084656.test-0000000102
```
- ListShardTablets
  列出指定shard中的所有tablets
``` bash
 ./lvtctl.sh ListShardTablets test_keyspace/0
test-0000000100 test_keyspace 0 master 192.168.47.100:15100 192.168.47.100:17100 []
test-0000000101 test_keyspace 0 restore 192.168.47.100:15101 192.168.47.100:17101 []
test-0000000102 test_keyspace 0 restore 192.168.47.100:15102 192.168.47.100:17102 []
test-0000000103 test_keyspace 0 restore 192.168.47.100:15103 192.168.47.100:17103 []
test-0000000104 test_keyspace 0 restore 192.168.47.100:15104 192.168.47.100:17104 []
```
- PlannedReparentShard
  把shard交给new master,或者远离 old master，old and new master都需要启动并运行
- RemoveBackup
  删除BackupStorage的备份
``` bash
 ./lvtctl.sh ListBackups test_keyspace/0
2018-05-04.084656.test-0000000102
./lvtctl.sh RemoveBackup test_keyspace/0 2018-05-04.084656.test-0000000102
./lvtctl.sh ListBackups test_keyspace/0
```
- RemoveShardCell
从shard的cell中删除
``` bash
```
- SetShardServedTypes
- SetShardTabletControl
- ShardReplicationFix
- ShardReplicationPositions
- SourceShardAdd
- SourceShardDelete
- TabletExternallyReparented
- ValidateShard
- WaitForFilteredReplication
``` bash
```
# Tablets
Backup
ChangeSlaveType
DeleteTablet
ExecuteFetchAsDba
ExecuteHook
GetTablet
IgnoreHealthError
InitTablet
Ping
RefreshState
RefreshStateByShard
ReparentTablet
RestoreFromBackup
RunHealthCheck
SetReadOnly
SetReadWrite
Sleep
StartSlave
StopSlave
UpdateTabletAddrs

## Topo
- TopoCat

## Workflows
- WorkflowAction
- WorkflowCreate
- WorkflowDelete
- WorkflowStart
- WorkflowStop
- WorkflowTree
- WorkflowWait
