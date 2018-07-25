## Sharding 拆分
### Horizontal Sharding (Tutorial, automated) 水平分片（教程、自动化）
#### Contents 内容
  本节向您展示如果使用水平重用工作流程在现有未分散Vitess密钥空间中应用基于范围的分片过程的示例。在这个案例中，我们将从1个shard重新生成2个shard  -80和 80-.

#### Overview 概述
水平重新划分过程主要包含以下步骤（每个步骤是工作流中的一个阶段）：

1、将模式从原始分片复制到目标分片。（阶段：CopySchemaShard）

2、使用称为vtworker （阶段：SplitClone）的批处理过程复制数据。 更多细节

3、检查过滤的复制（阶段：WaitForFilteredReplication）。 更多细节

4、在模式下使用vtworker批处理过程检查复制的数据完整性，以比较源数据和目标数据。（阶段：SplitDiff）

5、迁移原始碎片中的所有服务rdonly平板电脑。（阶段：MigrateServedTypeRdonly）

6、迁移原始分片中的所有服务副本平板电脑。（阶段：MigrateServedTypeReplica）

7、迁移原始分片中的所有服务主平板电脑。（阶段：MigrateServedTypeMaster） 更多细节

#### Prerequisites 先决条件
您应该完成入门教程(请在尝试Vitess重新划分之前完成所有步骤)，并且已经离开集群运行。然后在运行重新分片过程之前按照如下步骤操作：
- 1、配置分片信息
  > vitess/examples/local$ ./lvtctl.sh ApplyVSchema -vschema "$(cat vschema.json)" test_keyspace

- 2、为2个附加shard启动tablet：test_keyspace/-80和test_keyspace/80-
  > vitess/examples/local$ ./sharded-vttablet-up.sh

  通过选择每个新分片的第一个主分区来初始化复制
  > vitess/examples/local$ ./lvtctl.sh InitShardMaster -force test_keyspace/-80 test-200
    vitess/examples/local$ ./lvtctl.sh InitShardMaster -force test_keyspace/80- test-300

  设置完成后，您应该在vtctld UI（http：// localhost：15000）的仪表板页面上看到分片。应该有一个名为“0”的服务分片和两个名为“-80”和“80-”的非服务分片。点击分片节点，您可以检查其所有平板电脑信息。
- 3、弹出一个vtworker过程中，可通过端口15033.连接（数量vtworker应该是相同的原始碎片，我们在这里开始一个vtworker的过程，因为我们只有一个在这个例子中原来的碎片。）
  > vitess/examples/local$ ./vtworker-up.sh

  您可以验证通过http://192.168.47.100:15032/Debugging设置的vtworker进程。它应该成功。在ping完vtworker之后，请点击“重置作业”。否则，vtworker没有准备好执行其他任务。

#### Horizontal resharding workflow 水平重新划分工作流程

##### Create the workflow 创建工作流程
- 1、打开vtctld UI(http://localhost:15000)左侧菜单中的工作流程部分。点击右上角的+按钮打开Create a new Workflow对话框
- 2、按照以下说明填写创建新工作流对话框（查看实例）
  - 如果您不想在创建后立即启动工作流，请选中“跳过开始”复选框。如果是这样，您需要稍后单击工作流栏中的“开始”按钮以运行工作流程。
  - 打开“Factory Name”菜单并选择“Horizo​​ntal Resharding”。该字段定义您要创建的工作流的类型。
  - 在“Keyspace”插槽中填写test_keyspace。
  - 在“vtworker地址”插槽中填入localhost：15033。
  - 如果您不想手动批准加拿大的任务执行，请取消选中“enable_approvals”复选框。（我们建议您保留默认选择的选项，因为这将启用金丝雀功能）
- 3、点击对话框底部的“创建”按钮。如果创建成功，您将在Workflows页面中看到一个工作流程节点。如果未选择“跳过开始”，工作流程现在开始运行。

启动工作流程的另一种方式是通过vtctlclient命令，在执行命令之后，您还可以在vtctld UI 工作流程部分可视化工作流程：

> vitess/examples/local$ ./lvtctl.sh WorkflowCreate -skip_start=false horizontal_resharding -keyspace=test_keyspace -vtworkers=localhost:15033 -enable_approvals=true

``` bash
[vitess@linux-node01 local]$ ./lvtctl.sh WorkflowCreate -skip_start=false horizontal_resharding -keyspace=test_keyspace -vtworkers=localhost:15033 -enable_approvals=false
uuid: 0b806e3f-51c8-11e8-be68-000c2933cf1a
[vitess@linux-node01 local]$ I0507 15:27:06.529291  102937 instance.go:133] Starting worker...
I0507 15:27:06.530982  102937 logutil.go:31] log: Connected to 127.0.0.1:21813
I0507 15:27:06.535510  102937 logutil.go:31] log: Authenticated: id=244101965884751886, timeout=30000
I0507 15:27:06.535865  102937 zk_conn.go:296] zk conn: session for addr localhost:21811,localhost:21812,localhost:21813 event: {EventSession StateHasSession  <nil> 127.0.0.1:21813}
I0507 15:27:06.544222  102937 split_clone.go:588] Found overlapping shards: &{Left:[master_alias:<cell:"test" uid:200 > key_range:<end:"\200" > cells:"test"  master_alias:<cell:"test" uid:300 > key_range:<start:"\200" > cells:"test" ] Right:[master_alias:<cell:"test" uid:100 > served_types:<tablet_type:MASTER > served_types:<tablet_type:REPLICA > served_types:<tablet_type:RDONLY > cells:"test" ]}
I0507 15:27:06.545895  102937 split_clone.go:748] Finding a MASTER tablet for each destination shard...
I0507 15:27:06.548992  102937 logutil.go:31] log: Connected to 127.0.0.1:21813
I0507 15:27:06.553095  102937 logutil.go:31] log: Authenticated: id=244101965884751887, timeout=30000
I0507 15:27:06.553168  102937 zk_conn.go:296] zk conn: session for addr localhost:21811,localhost:21812,localhost:21813 event: {EventSession StateHasSession  <nil> 127.0.0.1:21813}
I0507 15:27:06.647007  102937 split_clone.go:768] Using tablet test-0000000200 as destination master for test_keyspace/-80
I0507 15:27:06.647164  102937 split_clone.go:768] Using tablet test-0000000300 as destination master for test_keyspace/80-
I0507 15:27:06.647227  102937 split_clone.go:770] NOTE: The used master of a destination shard might change over the course of the copy e.g. due to a reparent. The HealthCheck module will track and log master changes and any error message will always refer the actually used master address.
I0507 15:27:06.647305  102937 split_clone.go:782] Waiting 1m0s for 1 test_keyspace/-80 RDONLY tablet(s)
I0507 15:27:06.647834  102937 split_clone.go:460] Online clone will be run now.
I0507 15:27:06.647905  102937 split_clone.go:782] Waiting 1m0s for 1 test_keyspace/0 RDONLY tablet(s)
I0507 15:27:06.667760  102937 split_clone.go:852] Source tablet 0 has 1 tables to copy
I0507 15:27:06.667956  102937 chunk.go:85] table=messages: Not splitting the table into multiple chunks because it has only 3 rows.
I0507 15:27:06.668060  102937 split_clone.go:782] Waiting 2h0m0s for 1 test_keyspace/0 RDONLY tablet(s)
I0507 15:27:06.672069  102937 split_clone.go:782] Waiting 2h0m0s for 1 test_keyspace/-80 RDONLY tablet(s)
I0507 15:27:06.756537  102937 split_clone.go:476] Online clone finished after 0s.
I0507 15:27:06.756589  102937 split_clone.go:483] Offline clone will be run now.
I0507 15:27:07.530004  102937 command.go:161] Working on: test_keyspace/0
State: cloning the data (online)
Running:
Comparing source and destination using: no online source tablets currently in use
ETA: 2018-05-07 15:27:08.392133114 +0800 CST m=+358.732266926
messages: copy done, processed 3 rows
I0507 15:27:07.758022  102937 topo_utils.go:125] Adding tag[worker]=http://linux-node01:15032/ to tablet test-0000000103
I0507 15:27:07.763709  102937 topo_utils.go:145] Changing tablet test-0000000103 to 'DRAINED'
I0507 15:27:07.795550  102937 healthcheck.go:564] HealthCheckUpdate(Type Change): test-0000000103, tablet: test-103 (192.168.47.100), target test_keyspace/0 (RDONLY) => test_keyspace/0 (DRAINED), reparent time: 0
I0507 15:27:07.799433  102937 split_clone.go:715] Using tablet test-0000000103 as source for test_keyspace/0
I0507 15:27:07.810264  102937 split_clone.go:852] Source tablet 0 has 1 tables to copy
I0507 15:27:07.810420  102937 chunk.go:85] table=messages: Not splitting the table into multiple chunks because it has only 3 rows.
I0507 15:27:07.814138  102937 split_clone.go:782] Waiting 2h0m0s for 1 test_keyspace/-80 RDONLY tablet(s)
I0507 15:27:07.820545  102937 split_clone.go:1087] Making and populating blp_checkpoint table
I0507 15:27:07.820572  102937 split_clone.go:1087] Making and populating blp_checkpoint table
I0507 15:27:07.847506  102937 split_clone.go:1110] Setting SourceShard on shard test_keyspace/-80 (tables: [])
I0507 15:27:07.896458  102937 split_clone.go:1110] Setting SourceShard on shard test_keyspace/80- (tables: [])
I0507 15:27:07.923740  102937 split_clone.go:1135] Refreshing state on tablet test-0000000300
I0507 15:27:07.923797  102937 split_clone.go:1135] Refreshing state on tablet test-0000000200
I0507 15:27:07.933077  102937 split_clone.go:512] Offline clone finished after 0s.
I0507 15:27:07.992355  102937 cleaner.go:98] action StartSlaveAction successful on test-0000000103
I0507 15:27:08.003845  102937 cleaner.go:98] action TabletTagAction successful on test-0000000103
I0507 15:27:08.023109  102937 cleaner.go:98] action TabletTagAction successful on test-0000000103
I0507 15:27:08.061125  102937 healthcheck.go:564] HealthCheckUpdate(Type Change): test-0000000103, tablet: test-103 (192.168.47.100), target test_keyspace/0 (DRAINED) => test_keyspace/0 (RDONLY), reparent time: 0
I0507 15:27:08.102144  102937 cleaner.go:98] action ChangeSlaveTypeAction successful on test-0000000103
I0507 15:27:08.123881  102937 command.go:152] Working on: test_keyspace/0
State: done
Success:

Online Clone Result:
messages: copy done, processed 3 rows

Offline Clone Result:
messages: copy done, processed 3 rows
I0507 15:27:08.171995  102937 instance.go:133] Starting worker...
I0507 15:27:08.275523  102937 topo_utils.go:125] Adding tag[worker]=http://linux-node01:15032/ to tablet test-0000000203
I0507 15:27:08.281134  102937 topo_utils.go:145] Changing tablet test-0000000203 to 'DRAINED'
I0507 15:27:08.401795  102937 topo_utils.go:125] Adding tag[worker]=http://linux-node01:15032/ to tablet test-0000000103
I0507 15:27:08.409698  102937 topo_utils.go:145] Changing tablet test-0000000103 to 'DRAINED'
I0507 15:27:08.432706  102937 split_diff.go:270] Stopping master binlog replication on cell:"test" uid:200
I0507 15:27:08.437994  102937 split_diff.go:297] Stopping slave cell:"test" uid:103  at a minimum of MySQL56/3c21c6dc-51c6-11e8-b2c2-000c2933cf1a:1-10
I0507 15:27:08.446600  102937 split_diff.go:317] Restarting master cell:"test" uid:200  until it catches up to [position:"MySQL56/3c21c6dc-51c6-11e8-b2c2-000c2933cf1a:1-10" ]
I0507 15:27:08.454646  102937 split_diff.go:327] Waiting for destination tablet cell:"test" uid:203  to catch up to MySQL56/92f810d6-51c6-11e8-b2c4-000c2933cf1a:1-12
I0507 15:27:08.464563  102937 split_diff.go:343] Restarting filtered replication on master cell:"test" uid:200
I0507 15:27:08.466995  102937 split_diff.go:365] Gathering schema information...
I0507 15:27:08.472860  102937 split_diff.go:387] Got schema from source cell:"test" uid:103
I0507 15:27:08.475066  102937 split_diff.go:376] Got schema from destination cell:"test" uid:203
I0507 15:27:08.475113  102937 split_diff.go:396] Diffing the schema...
I0507 15:27:08.475230  102937 split_diff.go:402] Schema match, good.
I0507 15:27:08.476126  102937 split_diff.go:432] Running the diffs...
I0507 15:27:08.476271  102937 split_diff.go:458] Starting the diff on table messages
I0507 15:27:08.476476  102937 diff_utils.go:198] SQL query for test-0000000103/messages: SELECT `page`, `time_created_ns`, `message` FROM `messages` ORDER BY `page`, `time_created_ns`
I0507 15:27:08.480787  102937 diff_utils.go:198] SQL query for test-0000000203/messages: SELECT `page`, `time_created_ns`, `message` FROM `messages` ORDER BY `page`, `time_created_ns`
I0507 15:27:08.484983  102937 split_diff.go:513] Table messages checks out (3 rows processed, 71722 qps)
I0507 15:27:08.489795  102937 cleaner.go:98] action StartSlaveAction successful on test-0000000203
I0507 15:27:08.492855  102937 cleaner.go:98] action StartSlaveAction successful on test-0000000103
I0507 15:27:08.495467  102937 cleaner.go:98] action TabletTagAction successful on test-0000000103
I0507 15:27:08.498154  102937 cleaner.go:98] action TabletTagAction successful on test-0000000103
I0507 15:27:08.508936  102937 cleaner.go:98] action ChangeSlaveTypeAction successful on test-0000000103
I0507 15:27:08.512227  102937 cleaner.go:98] action TabletTagAction successful on test-0000000203
I0507 15:27:08.515163  102937 cleaner.go:98] action TabletTagAction successful on test-0000000203
I0507 15:27:08.525888  102937 cleaner.go:98] action ChangeSlaveTypeAction successful on test-0000000203
I0507 15:27:08.525917  102937 command.go:152] Working on: test_keyspace/-80
State: done
Success.
I0507 15:27:08.533867  102937 instance.go:133] Starting worker...
I0507 15:27:08.637604  102937 topo_utils.go:125] Adding tag[worker]=http://linux-node01:15032/ to tablet test-0000000304
I0507 15:27:08.643626  102937 topo_utils.go:145] Changing tablet test-0000000304 to 'DRAINED'
I0507 15:27:08.764138  102937 topo_utils.go:125] Adding tag[worker]=http://linux-node01:15032/ to tablet test-0000000104
I0507 15:27:08.769731  102937 topo_utils.go:145] Changing tablet test-0000000104 to 'DRAINED'
I0507 15:27:08.789657  102937 split_diff.go:270] Stopping master binlog replication on cell:"test" uid:300
I0507 15:27:08.793546  102937 split_diff.go:297] Stopping slave cell:"test" uid:104  at a minimum of MySQL56/3c21c6dc-51c6-11e8-b2c2-000c2933cf1a:1-10
I0507 15:27:08.800327  102937 split_diff.go:317] Restarting master cell:"test" uid:300  until it catches up to [position:"MySQL56/3c21c6dc-51c6-11e8-b2c2-000c2933cf1a:1-10" ]
I0507 15:27:08.805637  102937 split_diff.go:327] Waiting for destination tablet cell:"test" uid:304  to catch up to MySQL56/c6af08b2-51c6-11e8-b2c6-000c2933cf1a:1-12
I0507 15:27:08.815004  102937 split_diff.go:343] Restarting filtered replication on master cell:"test" uid:300
I0507 15:27:08.816854  102937 split_diff.go:365] Gathering schema information...
I0507 15:27:08.824256  102937 split_diff.go:387] Got schema from source cell:"test" uid:104
I0507 15:27:08.825142  102937 split_diff.go:376] Got schema from destination cell:"test" uid:304
I0507 15:27:08.825181  102937 split_diff.go:396] Diffing the schema...
I0507 15:27:08.825206  102937 split_diff.go:402] Schema match, good.
I0507 15:27:08.826479  102937 split_diff.go:432] Running the diffs...
I0507 15:27:08.826561  102937 split_diff.go:458] Starting the diff on table messages
I0507 15:27:08.826602  102937 diff_utils.go:198] SQL query for test-0000000104/messages: SELECT `page`, `time_created_ns`, `message` FROM `messages` ORDER BY `page`, `time_created_ns`
I0507 15:27:08.830894  102937 diff_utils.go:198] SQL query for test-0000000304/messages: SELECT `page`, `time_created_ns`, `message` FROM `messages` ORDER BY `page`, `time_created_ns`
I0507 15:27:08.835993  102937 split_diff.go:513] Table messages checks out (2 rows processed, 54634 qps)
I0507 15:27:08.841668  102937 cleaner.go:98] action StartSlaveAction successful on test-0000000304
I0507 15:27:08.848810  102937 cleaner.go:98] action StartSlaveAction successful on test-0000000104
I0507 15:27:08.853320  102937 cleaner.go:98] action TabletTagAction successful on test-0000000104
I0507 15:27:08.856233  102937 cleaner.go:98] action TabletTagAction successful on test-0000000104
I0507 15:27:08.868803  102937 cleaner.go:98] action ChangeSlaveTypeAction successful on test-0000000104
I0507 15:27:08.871521  102937 cleaner.go:98] action TabletTagAction successful on test-0000000304
I0507 15:27:08.875076  102937 cleaner.go:98] action TabletTagAction successful on test-0000000304
I0507 15:27:08.884144  102937 cleaner.go:98] action ChangeSlaveTypeAction successful on test-0000000304
I0507 15:27:08.884211  102937 command.go:152] Working on: test_keyspace/80-
State: done
Success.
```

创建重新分片工作流程时，程序会自动检测源分片和目标分片，并为重新分片过程创建任务。创建完成后，单击工作流节点，即可看到子节点列表。每个子节点代表工作流中的一个阶段（每个阶段代表概述中提到的一个步骤）。进一步点击一个阶段节点，你可以在这个阶段检查任务。例如，在“CopySchemaShard”阶段，它包括将模式复制到2个目标碎片的任务，因此您可以看到任务节点“碎片-80”和“碎片80-”。你应该看到一个类似这样的页面 。

##### Approvals of Tasks Execution (Canary feature) 任务执行的批准（Canary功能）
一旦工作流程开始运行（如果选择了“跳过开始”并且工作流还未开始，请单击“开始”按钮），如果选择“enable_approvals”，则需要批准每个阶段的任务执行。批准包括2个阶段。第一阶段只批准第一项任务，即运行的第一项任务。第二阶段批准剩下的任务。

重新分片工作流程按顺序进行。阶段开始后，您可以看到阶段节点下所有阶段的审批按钮（如果您没有看到审批按钮，请点击阶段节点，您应该看到类似这样的页面）。当相应的任务准备好运行时，该按钮被启用。点击启用按钮以批准任务执行，然后您可以在点击的按钮上看到批准的消息。阶段完成后，审批按钮将被清除。下一阶段只有在前一阶段成功完成时才会开始。

如果工作流程已从检查点恢复，那么在此许可下有正在运行的任务时，您仍然会看到带有批准消息的审批按钮。但是，您不需要为重新启动的工作流再次批准相同的任务。

##### Retry
如果任务失败，将在任务节点下启用“重试”按钮（如果作业卡住但没有看到“重试”按钮，请单击任务节点）。如果您修复了错误并想重试失败的任务，请单击此按钮。如果任务连续失败，您可以根据需要多次重试。修复后，工作流程可以从故障点继续进行。

例如，您可能会忘记启动一个vtworker进程。需要在SplitClone阶段执行vtworker进程的任务将失败。解决此问题后，单击任务节点上的重试按钮，工作流程将继续运行。

当任务失败时，如果此阶段并行运行任务（应用于“CopySchemaShard”，“SplitClone”，“WaitForFilteredReplication”阶段），则此阶段执行的其他任务不会受到影响。对于按顺序运行任务的阶段，此阶段剩余的未启动任务将不会执行很长时间。之后的阶段将不再执行。

##### Checkpoint and Recovery 检查点和恢复
重新分片工作流跟踪每个任务的状态，并在状态更新时将这些状态检查点转换为拓扑服务器。通过在拓扑中加载检查点来停止并重新启动工作流时，它可以继续运行所有未完成的任务。

#### Verify Results and Clean up  验证结果并清理
在重新分片过程之后，原始分片中的数据被完全复制到新的分片中。数据更新将在新分片中显示，但不会显示在原始分片上。然后，您应该在vtctld UI Dashboard页面中看到分片 0变为非分配，而分片-80和分片80-正在分配分片。自己验证一下：使用以下命令检查数据库内容，然后将消息添加到留言簿页面（您可以使用此处提到的脚本client.sh ）并使用相同的命令进行检查：
``` bash
# See what's on shard test_keyspace/0
# (no updates visible since we migrated away from it):
vitess/examples/local$ ./lvtctl.sh ExecuteFetchAsDba test-100 "SELECT * FROM messages"
# See what's on shard test_keyspace/-80:
vitess/examples/local$ ./lvtctl.sh ExecuteFetchAsDba test-200 "SELECT * FROM messages"
# See what's on shard test_keyspace/80-:
vitess/examples/local$ ./lvtctl.sh ExecuteFetchAsDba test-300 "SELECT * FROM messages"
```
您也可以在vtctl UI上签出拓扑浏览器。它向您显示分片关键字的信息及其服务状态。每个碎片应该看起来像这样
shard 0

shard -80

shard 80-

验证结果后，我们可以删除原始分片，因为所有流量都是从新分片提供的：

> vitess/examples/local$ ./vttablet-down.sh

然后，我们可以删除现在为空的分片：

> vitess/examples/local$ ./lvtctl.sh DeleteShard -recursive test_keyspace/0
然后，您应该在vtctld UI 仪表板页面中看到分片0消失。
#### Tear down and clean up
由于您已经通过运行从原始未展开的示例中清除了平板电脑，因此已将该步骤替换 为清理新的分片平板电脑。./vttablet-down.sh./sharded-vttablet-down.sh
``` bash
vitess/examples/local$ ./vtworker-down.sh
vitess/examples/local$ ./vtgate-down.sh
vitess/examples/local$ ./sharded-vttablet-down.sh
vitess/examples/local$ ./vtctld-down.sh
vitess/examples/local$ ./zk-down.sh
```

#### Reference 参考
- Details in SplitClone phase  SplitClone阶段详细信息l
- Details in WaitForFilteredReplication phase WaitForFilteredReplication阶段详细信息
- Details in MigrateServedTypeMaster phase MigrateServedTypeMaster阶段详细信息

### Horizontal Sharding (Tutorial, manual) 水平分片（教程、手册）
#### Contents 内容
  本节内容指导您分解现有的unsharded Vitess keyspace.

#### Prerequisites 先决条件
  首先假设您已经完成入门指南，并且已经使集群运行起来。

#### Overview 概述
  该文件夹中的示例客户端使用如下模式：example/local
  ``` sql
  CREATE TABLE messages (
  page BIGINT(20) UNSIGNED,
  time_created_ns BIGINT(20) UNSIGNED,
  message VARCHAR(10000),
  PRIMARY KEY (page, time_created_ns)
  ) ENGINE=InnoDB
  ```
这个想法是，每个页面号代表多租户应用程序中的单独留言簿。每个留言页面都包含一个消息列表。

在本指南中，我们将介绍按页码进行分片。这意味着页面将随机分布在各个分片中，但给定页面的所有记录始终保证位于同一个分片上。通过这种方式，我们可以透明地扩展数据库以支持页数的任意增长。
#### Configure sharding information 配置分片信息
第一步是告诉Vitess我们如何分割数据。我们通过提供VSchema定义来完成此操作，如下所示：
``` json
{
  "sharded": true,
  "vindexes": {
    "hash": {
      "type": "hash"
    }
  },
  "tables": {
    "messages": {
      "column_vindexes": [
        {
          "column": "page",
          "name": "hash"
        }
      ]
    }
  }
}
```
这表示我们希望通过page列的散列碎片来分割数据。换句话说，将每个页面的消息保存在一起，但随机地在页面周围扩展页面。

我们可以像这样将这个VSchema加载到Vitess中：

> vitess/examples/local$ ./lvtctl.sh ApplyVSchema -vschema "$(cat vschema.json)" test_keyspace


#### Bring up tablets for new shards 为新的shards应用新的tablets
在unsharded例子，你开始平板电脑名为碎片0在test_keyspace，写成test_keyspace / 0。现在，您将开始为两个额外的碎片启动平板电脑，名为test_keyspace / -80和test_keyspace / 80-：

> vitess/examples/local$ ./sharded-vttablet-up.sh
由于分片键是页码，因此0x80是分片键范围的中点 ，这将导致一半页面到达每个分片。

这些新的分片将在转换过程中与原始分片并行运行，但实际流量只能由原始分片提供，直到我们告诉它切换。

检查vtctld Web用户界面或其输出，以查看平板电脑何时准备就绪。每个碎片应该有5片。lvtctl.sh ListAllTablets test

平板电脑准备好后，通过选择每个新分片的第一个主分区来初始化复制：
``` bash
vitess/examples/local$ ./lvtctl.sh InitShardMaster -force test_keyspace/-80 test-0000000200
vitess/examples/local$ ./lvtctl.sh InitShardMaster -force test_keyspace/80- test-0000000300
```
现在应该总共有15个平板电脑，每个分片有一个主人：
``` bash
vitess/examples/local$ ./lvtctl.sh ListAllTablets test
### example output:
# test-0000000100 test_keyspace 0 master 10.64.3.4:15002 10.64.3.4:3306 []
# ...
# test-0000000200 test_keyspace -80 master 10.64.0.7:15002 10.64.0.7:3306 []
# ...
# test-0000000300 test_keyspace 80- master 10.64.0.9:15002 10.64.0.9:3306 []
# ...
```

#### Copy data from original shard 从原始分片复制数据
新的平板电脑开始是空的，因此我们需要将所有内容从原始分片复制到两个新分片，从模式开始：
``` bash
vitess/examples/local$ ./lvtctl.sh CopySchemaShard test_keyspace/0 test_keyspace/-80
vitess/examples/local$ ./lvtctl.sh CopySchemaShard test_keyspace/0 test_keyspace/80-
```
接下来我们复制数据。由于要复制的数据量可能非常大，因此我们使用称为vtworker的特殊批处理过程将数据从单个源流式传输到多个目标，并根据其keyspace_id路由每行 ：
``` bash
vitess/examples/local$ ./sharded-vtworker.sh SplitClone test_keyspace/0
### example output:
# I0416 02:08:59.952805       9 instance.go:115] Starting worker...
# ...
# State: done
# Success:
# messages: copy done, copied 11 rows
```
请注意，我们只指定了源分片test_keyspace / 0。该SplitClone过程中会自动计算出基于需要被覆盖的键范围的目的地使用的碎片。在这种情况下，分片0覆盖整个范围，因此它将-80和80标识 为目标分片，因为它们结合覆盖相同的范围。

接下来，它将暂停一个rdonly（离线处理）平板电脑上的复制，以充当数据的一致快照。应用程序可以继续运行而无需停机，因为实时流量由不受影响的副本和主平板电脑提供。其他批处理作业也将不受影响，因为它们将仅由剩余的未暂停rdonly平板电脑提供服务。

#### Check filtered replication 检查过滤的复制
一旦从暂停的快照中复制完成，vtworker 将从源分片过滤的复制打开 到每个目标分片。这使得目标分片能够赶上自快照以来持续从应用流入的更新。

当目标分片被追上时，他们将继续复制新的更新。您可以通过查看每个分片的内容来查看此内容，因为您将新消息添加到留言簿应用中的各个页面。碎片0将会看到所有的消息，而新的碎片只会看到生活在该碎片上的页面的消息。
``` bash
# See what's on shard test_keyspace/0:
vitess/examples/local$ ./lvtctl.sh ExecuteFetchAsDba test-0000000100 "SELECT * FROM messages"
# See what's on shard test_keyspace/-80:
vitess/examples/local$ ./lvtctl.sh ExecuteFetchAsDba test-0000000200 "SELECT * FROM messages"
# See what's on shard test_keyspace/80-:
vitess/examples/local$ ./lvtctl.sh ExecuteFetchAsDba test-0000000300 "SELECT * FROM messages"
```
您可以再次运行客户端脚本，在各种页面上添加一些消息，并查看它们如何路由。

#### Check copied data integrity  检查复制的数据的完整性
该vtworker间歇法的另一种模式，将比较源和目标，以确保所有的数据存在且正确的。以下命令将针对每个目标分片运行差异：
``` bash
vitess/examples/local$ ./sharded-vtworker.sh SplitDiff test_keyspace/-80
vitess/examples/local$ ./sharded-vtworker.sh SplitDiff test_keyspace/80-
```
如果发现任何差异，将会打印。如果一切都很好，你应该看到这样的事情：
```
I0416 02:10:56.927313      10 split_diff.go:496] Table messages checks out (4 rows processed, 1072961 qps)
```

#### Switch over to new shards 切换到新的shards
现在我们已经准备好切换到新碎片的服务。该MigrateServedTypes 命令可以让你做这一个 平板电脑类型的时间，甚至一个单元格 在一个时间。这个过程可以在任何时候回滚，直到主机切换。
``` bash
vitess/examples/local$ ./lvtctl.sh MigrateServedTypes test_keyspace/0 rdonly
vitess/examples/local$ ./lvtctl.sh MigrateServedTypes test_keyspace/0 replica
vitess/examples/local$ ./lvtctl.sh MigrateServedTypes test_keyspace/0 master
```
在主移植过程中，原始分片大师将首先停止接受更新。然后，该流程将等待新的分片大师在允许他们开始投放之前完全赶上过滤的复制。由于过滤的复制一直伴随着实时更新，所以主控制器不可用时应该只有几秒钟的时间。

主流量迁移时，已过滤的复制将停止。数据更新将在新分片中显示，但不会显示在原始分片上。亲自查看：向留言簿页面添加一条消息，然后检查数据库内容：
```
# See what's on shard test_keyspace/0
# (no updates visible since we migrated away from it):
vitess/examples/local$ ./lvtctl.sh ExecuteFetchAsDba test-0000000100 "SELECT * FROM messages"
# See what's on shard test_keyspace/-80:
vitess/examples/local$ ./lvtctl.sh ExecuteFetchAsDba test-0000000200 "SELECT * FROM messages"
# See what's on shard test_keyspace/80-:
vitess/examples/local$ ./lvtctl.sh ExecuteFetchAsDba test-0000000300 "SELECT * FROM messages"
```

#### Remove original shard  删除原来的shard
现在所有的流量都是由新的分片服务的，我们可以删除原来的分片。为此，我们使用unsharded示例中的脚本：vttablet-down.sh

> vitess/examples/local$ ./vttablet-down.sh
然后，我们可以删除现在为空的分片：

> vitess/examples/local$ ./lvtctl.sh DeleteShard -recursive test_keyspace/0
然后，您应该在vtctld 拓扑页面或输出中 看到碎片0的平板电脑已经消失。lvtctl.sh ListAllTablets test


#### Tear down and clean up 关闭并清理
由于您已经通过运行从原始未展开的示例中清除了平板电脑，因此已将该步骤替换 为清理新的分片平板电脑。./vttablet-down.sh./sharded-vttablet-down.sh
``` bash
vitess/examples/local$ ./vtgate-down.sh
vitess/examples/local$ ./sharded-vttablet-down.sh
vitess/examples/local$ ./vtctld-down.sh
vitess/examples/local$ ./zk-down.sh
```

### Sharding in Kubernetes (Tutorial, automated) Kubernetes中分片（教程、自动化）
### Sharding in Kubernetes (Tutorial, manual) Kubernetes中分片（教程、手册）
## Topology Service 拓扑服务
### Contents 内容
本节介绍拓扑服务，这是Vitess体系结构的关键部分。该服务暴露给所有Vitess进程，并用于存储有关Vitess集群的小部分配置数据，并提供集群范围的锁。他还支持守护和主选举。

具体而言，拓扑服务功能由锁定服务器实现，在本文档的其余部分中称为拓扑服务器。我们使用插件实现，并且我们支持多个锁服务(Zookeeper,etcd,Consul,...)作为服务的后端。
### Requirements and usage 要求和用法
拓扑服务用于存储有关Keyspaces, the Shards, the Tablets, the Replication Graph, and the Serving Graph。我们存储每个对象的小数据结构（几百字节）。

拓扑服务器的主要合同是高度可用和一致的。据了解，它会产生更高的延迟成本和非常低的吞吐量。

我们从不使用拓扑服务器作为RPC机制，也不将其用作日志的存储系统。我们永远不会依赖于拓扑服务器能够快速响应并快速为每个查询提供服务。

拓扑服务器还必须支持Watch界面，以在节点上发生某些情况时发出信号。这用于例如知道键空间拓扑结构何时改变（例如用于重新分解）。

#### Global vs local 全局 vs 本地
我们区分拓扑服务器的两个实例：全局实例和每个单元本地实例：

- Global实例用于存储关于不经常更改的拓扑的全局数据，例如关于Keyspaces和Shards的信息。数据独立于单个实例和单元，并且需要在单元完全停顿的情况下存活。
- 每个单元有一个Local实例，它包含特定于单元的信息，并且还汇总了来自global + local单元的数据，以便客户更容易地找到数据。Vitess本地进程不应该使用全局拓扑实例，而应该尽可能使用本地拓扑服务器中的汇总数据。

全局实例可能会停止一段时间，并且不会影响本地单元（这是一个例外，如果需要处理重新启动，则可能不起作用）。如果本地实例发生故障，则仅影响本地平板电脑（然后该单元通常状态不佳，不应使用）。

此外，Vitess进程不会使用全局或本地拓扑服务器来为单个查询服务。他们只使用拓扑服务器在启动时和后台获取拓扑信息，但不能直接提供查询。

#### Recovery 恢复
如果本地拓扑服务器死亡并且无法恢复，则可能会被清除。然后需要重新启动该单元中的所有平板电脑，以便重新初始化其拓扑记录（但不会丢失任何MySQL数据）。

如果全局拓扑服务器死亡并且无法恢复，则这是更大的问题。所有的Keyspace / Shard对象都必须重新创建。然后细胞应该恢复。

### Global data 全局数据
#### Keyspace
Keyspace对象包含各种信息，主要是关于分片：Keyspace如何分片，分片密钥列的名称是什么，此Keyspace是否提供数据，如何分割传入的查询，...

整个Keyspace都可以锁定。例如，当我们改变哪个碎片服务于Keyspace内部时，我们在重新利用时使用这个。这样我们保证只有一个操作会同时更改密钥空间数据。

#### Shard 分片
shard包含Keyspace数据的一个子集。全局拓扑中的碎片记录包含：

- 该碎片的主平板别名（具有MySQL主设备）。
- Keyspace中这个碎片覆盖的分片键范围。
- 如果需要，平板电脑会为每个单元格提供这个碎片服务器（主服务器，副本服务器，批处理...）。
- 如果在过滤的复制过程中，源碎片正在从此复制。
- 在此碎片中包含平板电脑的单元格列表。
- 碎片全球平板电脑控制，如黑名单表中没有平板电脑应该在这个碎片服务。

碎片可以被锁定。我们在影响Shard记录或Shard内多个平板电脑（如重新设置）的操作中使用此操作，因此多个作业不会同时更改数据。

#### VSchema data VSchema数据
VSchema数据包含VTGate V3 API的分片和路由信息。

### Local data  本地数据
本节介绍存储在拓扑服务器的本地实例（每个单元）中的数据结构。

#### Tablets
平板电脑记录有关于平板电脑内运行的单个vttablet进程的许多信息（以及MySQL进程）：

- 唯一标识Tablet的Tablet Alias（单元+唯一ID）。
- 平板电脑的主机名，IP地址和端口映射。
- 当前的平板电脑类型（主，副本，批处理，备用...）。
- 这款平板电脑是Keyspace / Shard的一部分。
- 该平板电脑提供的分片键范围。
- 用户指定的标签映射（例如按照安装数据进行存储）。

平板电脑可以在运行之前创建平板电脑记录（通过或将参数传递给vttablet进程）。平板电脑记录更新的唯一方法是以下之一：vtctl InitTabletinit_*

- vttablet进程本身在运行时拥有该记录，并且可以更改它。
- 在初始阶段，在平板电脑启动之前。
- 关机后，当平板电脑被删除。
- 如果平板电脑无响应，则可能会在重新启动时被迫空闲以使其不健康。

#### Replication graph 复制视图
复制图表允许我们在给定的Cell / Keyspace /碎片中查找平板电脑。它用于包含有关哪个平板电脑从其他平板电脑复制的信息，但这太复杂了，无法维护。现在它只是一个平板电脑列表。

#### Serving graph 服务视图
服务图是客户用来查找Keyspace的每个单元格拓扑的。它是全球数据的汇总（Keyspace + Shard）。vtgates仅打开少量这些对象并快速获得所需的所有对象。

- SrvKeyspace

  这是一个Keyspace的当地代表。它包含有关用于获取数据的碎片的信息（但不包括关于每个碎片的信息）：

  - 分区映射由平板电脑类型（主设备，副本设备，批处理...）键入，值为用于服务的分片列表。
  - 它还包含全局Keyspace字段，复制用于快速访问。

它可以通过运行来重建。平板电脑在单元中启动时会自动重建，并且该单元/键空间的SrvKeyspace尚不存在。在水平和垂直分割期间它也将被改变。vtctl RebuildKeyspaceGraph

- SrvVSchema

这是VSchema的本地汇总。它包含单个对象中所有键空间的VSchema。

它可以通过运行来重建。它在使用时自动重建（除非被标志阻止）。vtctl RebuildVSchemaGraphvtctl ApplyVSchema

### Workflows involving the Topology Server 涉及拓扑服务器的工作流程
The Topology Server涉及许多Vitess工作流程。

tablet初始化后，我们创建tablet记录，并将tablet添加到复制图。如果它是Shard的主人，我们也会更新全局Shard记录。

管理工具需要为给定的Keyspace/shard查找tablet：首先，我们得到Shard的Tablets单元列表（全局拓扑碎片记录包含这些），然后我们使用Cell / Keyspace / Shard的复制图表来查找所有的tablet，然后我们可以读取每个tablet的记录

当一个shard被重新设定时，我们需要用新的主别名来更新全局shard记录。

查找tablet以提供数据分两个阶段完成：vtgate维护与所有可能的tablet的健康状况检查连接，并报告它们所服务的键空间/分片/平板电脑类型。vtgate也读取SrvKeyspace对象，以找出碎片映射。有了这两条信息，vtgate可以将查询路由到正确的vttablet。

在重新划分事件期间，我们也改变了拓扑结构。水平分割将更改全局碎片记录和本地SrvKeyspace记录。垂直分割将改变全局Keyspace记录和本地SrvKeyspace记录。

### Exploring the data in a Topology Server 浏览拓扑服务器中的数据
我们存储每个对象的proto3二进制数据。

在所有实现中，我们使用以下路径作为数据：

Global Cell：
- CellInfo path： cells/<cell name>/CellInfo
- Keyspace: keyspaces/<keyspace>/Keyspace
- Shard: keyspaces/<keyspace>/shards/<shard>/Shard
- VSchema: keyspaces/<keyspace>/VSchema

Local Cell：
- Tablet： tablets/<cell>-<uid>/Tablet
- Replication Graph： keyspaces/<keyspace>/shards/<shard>/ShardReplication
- SrvKeyspace： keyspaces/<keyspace>/SrvKeyspace
- SrvVSchema： SvrVSchema

该实用程序可以在使用该选项时解码这些文件 ：vtctl TopoCat-decode_proto

``` bash
TOPOLOGY="-topo_implementation zk2 -topo_global_server_address global_server1,global_server2 -topo_global_root /vitess/global"

$ vtctl $TOPOLOGY TopoCat -decode_proto -long /keyspaces/*/Keyspace
path=/keyspaces/ks1/Keyspace version=53
sharding_column_name: "col1"
path=/keyspaces/ks2/Keyspace version=55
sharding_column_name: "col2"
```
该vtctld网络工具还包含一个拓扑浏览器（使用Topology 左侧选项卡）。它将显示解码后的各种原始文件。

### Implementations 实现
#### Zookeeper zk2 implementation
#### etcd etcd2 implementation (new version of etcd)
#### Consul consul implementation
### Running in only one cell  只在一个cell中运行
拓扑服务旨在分布在多个单元中，并且能够承受单个单元中断。但是，通常的用法是在一个单元/区域中运行Vitess集群。本部分介绍如何执行此操作，以及稍后升级到多个单元/区域。

如果在单个单元中运行，则同一拓扑服务可用于全局数据和本地数据。本地单元记录仍需要创建，只需使用相同的服务器地址，非常重要的是，使用不同的根节点路径。

在这种情况下，只需运行3台服务器进行拓扑服务仲裁就足够了。例如，3个etcd服务器。并且将他们的地址用于本地小区。让我们使用一个简短的单元名称，就像local在那个拓扑服务器中的本地数据稍后将被移动到另一个拓扑服务那样，它将具有真实的单元名称。

#### Extending to more cells 扩展到更多的细胞
为了在多个单元中运行，需要将当前拓扑服务分成全局实例和每个单元一个本地实例。而初始设置有3个拓扑服务器（用于全局和本地数据），我们推荐在所有单元（用于全局拓扑数据）和每个单元3个本地服务器（用于每单元拓扑数据）上运行5个全局服务器。

要迁移到这样的设置，首先在第二个单元中添加3个本地服务器，并像第一个单元那样运行。现在可以在第二个单元格中启动平板电脑和vtgates，并且可以正常使用。vtctl AddCellinfo

然后，可以使用命令行参数为vtgate配置一组单元格以查看平板电脑。然后它可以使用所有单元格中的所有平板电脑来路由流量。注意这是访问另一个单元中的主设备所必需的。-cells_to_watch

在扩展到两个单元后，原始拓扑服务包含全局拓扑数据和第一个单元拓扑数据。我们之后的对称配置将是将原始服务分为两个：全局数据只包含全局数据（分布在两个单元中），而本地数据则包含原始单元。为了实现这一分割：

- 在该原始单元中启动一个新的本地拓扑服务（该单元中有3个本地服务器）。
- 选择与该单元不同的名称local。
- 使用配置它。vtctl AddCellInfo
- 确保所有vtgates都可以看到新的本地单元格（再次使用 ）。-cells_to_watch
- 重新启动所有vttablets在该新的单元格中，而不是local之前使用的单元名称。
- 使用删除所有提到的所有keyspaces细胞。vtctl RemoveKeyspaceCelllocal
- 使用删除全局配置为 电池。vtctl RemoveCellInfolocal
- 删除旧的本地服务器根目录中全局拓扑服务中的所有剩余数据。

分割完成后，配置完全对称：

- 全球拓扑服务，所有单元中都有服务器。仅包含有关Keyspaces，Shards和VSchema的全局拓扑数据。通常它在所有单元中有5个服务器。
- 一个到每个单元的本地拓扑服务，服务器只在该单元中。只包含有关平板电脑的本地拓扑数据，并且为了有效访问而汇总全局数据。通常，它在每个单元中有3个服务器。

### Migration between implementations 实现之间的迁移
我们提供topo2topo二进制文件以在一个实现与另一个拓扑服务之间迁移。

这种情况下的流程是：

从一个稳定的拓扑开始，不要重新分解或重新进行。
配置新拓扑服务，使其至少具有源拓扑服务的所有单元。确保它正在运行。
topo2topo用正确的标志运行程序。， ，描述源（旧）拓扑服务。，，描述目标（新）拓扑服务。-from_implementation-from_root-from_server-to_implementation-to_root-to_server
使用新的拓扑服务标志运行每个密钥空间。vtctl RebuildKeyspaceGraph
运行使用新的拓扑服务标志。vtctl RebuildVSchemaGraph
vtgate使用新的拓扑服务标志重新启动全部。随着拓扑被复制，它们将像以前一样看到相同的密钥空间/碎片/平板电脑/ vschema。
vttablet使用新的拓扑服务标志重新启动全部。他们可能会使用相同的端口，但他们会在启动时更新新拓扑，并且可以从vtgate中看到。
vtctld使用新拓扑服务标志重新启动所有进程。因此UI也显示新数据。
从不推荐使用zookeeper到zk2 拓扑的示例命令是：
``` bash
# Let's assume the zookeeper client config file is already
# exported in $ZK_CLIENT_CONFIG, and it contains a global record
# pointing to: global_server1,global_server2
# an a local cell cell1 pointing to cell1_server1,cell1_server2
#
# The existing directories created by Vitess are:
# /zk/global/vt/...
# /zk/cell1/vt/...
#
# The new zk2 implementation can use any root, so we will use:
# /vitess/global in the global topology service, and:
# /vitess/cell1 in the local topology service.

# Create the new topology service roots in global and local cell.
zk -server global_server1,global_server2 touch -p /vitess/global
zk -server cell1_server1,cell1_server2 touch -p /vitess/cell1

# Store the flags in a shell variable to simplify the example below.
TOPOLOGY="-topo_implementation zk2 -topo_global_server_address global_server1,global_server2 -topo_global_root /vitess/global"

# Reference cell1 in the global topology service:
vtctl $TOPOLOGY AddCellInfo \
  -server_address cell1_server1,cell1_server2 \
  -root /vitess/cell1 \
  cell1

# Now copy the topology. Note the old zookeeper implementation doesn't need
# any server or root parameter, as it reads ZK_CLIENT_CONFIG.
topo2topo \
  -from_implementation zookeeper \
  -to_implementation zk2 \
  -to_server global_server1,global_server2 \
  -to_root /vitess/global \

# Rebuild SvrKeyspace objects in new service, for each keyspace.
vtctl $TOPOLOGY RebuildKeyspaceGraph keyspace1
vtctl $TOPOLOGY RebuildKeyspaceGraph keyspace2

# Rebuild SrvVSchema objects in new service.
vtctl $TOPOLOGY RebuildVSchemaGraph

# Now restart all vtgate, vttablet, vtctld processes replacing:
# -topo_implementation zookeeper
# With:
# -topo_implementation zk2
# -topo_global_server_address global_server1,global_server2
# -topo_global_root /vitess/global
#
# After this, the ZK_CLIENT_CONF file and environment variables are not needed
# any more.
```

#### Migration using the Tee implementation

## Transport Security Model 传输安全模型
### Contents 内容
Vitess公开了一些RPC服务，并在内部也使用RPC。这些RPC可能使用安全传输选型。本文档介绍了如何使用这些功能。

### Overview 概述
图略

有两个主要类别：
 - 内部RPC：它们用于连接Vitess组件
 - 外部可见的RPC：它们被应用程序用于与Vitess交谈。

Vitess生态系统中的一些功能取决于身份验证，如被叫ID和表ACL。我们将首先探索来电显示功能。

使用的加密和认证方案取决于使用的传输。使用gRPC（Vitess的默认设置），可以使用TLS来保护内部和外部RPC。我们将详细介绍选项。
### Caller ID
Caller ID is a feature provided by the Vitess stack to identify the source of queries. There are two different Caller IDs:(确定查询的来源)

- Immediate Caller ID: It represents the secure client identity when it enters the Vitess side:
  - It is a single string, represents the user connecting to Vitess (vtgate).
  - It is authenticated by the transport layer used.
  - It is used by the Vitess TableACL feature.

- Effective Caller ID: It provides detailed information on who the individual caller process is:
  - It contains more information about the caller: principal, component, sub-component.
  - It is provided by the application layer.
  - It is not authenticated.
  - It is exposed in query logs to be able to debug the source of a slow query, for instance.

### gRPC Transport gRPC传输
#### gRPC Encrypted Transport
#### Certificates and Caller ID
#### Caller ID Override
#### Example
