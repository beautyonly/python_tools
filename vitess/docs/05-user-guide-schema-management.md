## Schema Management 模式管理
原文地址：https://vitess.io/user-guide/schema-management/

### Contents 内容
使用Vitess要求您使用两种不同类型的schemas：
- The MySQL database schema，这是各个MySQL实例的模式
- VSchema，它表述了所有keyspaces，以及how they're sharded

The workflow for the VSchema is as follows：
- 使用该ApplyVschema命令为每个keyspace应用VSchema 。这将VSchemas保存在the global topo server中。
- 执行RebuildVSchemaGraph针对每个cell（或all cells）。该命令将组合的VSchema的非规范化版本传播到所有指定的cells。这种传播的主要目的是最小化每个cell与全局拓扑的依赖关系。只将变化推送到特定cell的功能可以让您在变更之前确保变化良好，然后将其部署到任意位置。

本文档介绍vtctl 可用于在Vitess中review or update 模式的命令。

请注意，对于长时间运行的模式更改，不建议使用此功能。在这种情况下，我们建议改为进行schema swap。

### Reviewing your schema 检查您的schema
本节介绍vtctl命令，让你查看架构并验证器在tablet或shards上的一致性
- GetSchema
- ValidateSchemaShard
- ValidateSchemaKeyspace
- GetVSchema
- GetSrvVSchema

#### GetSchema

  该命令显示tablet或tablet的子集的the full schema。当你调用GetSchema，您可以指定唯一标识tablet的the tablet alias。该<tablet alias> 参数值的格式<cell name>-<uid>。

  注意：您可以使用该 vtctl ListAllTablets 命令检索cell中的tablet列表及其唯一ID。

  以下示例将检索具有唯一ID的tablet架构test-000000100：

  > GetSchema test-000000100

实践记录
``` bash
$ ./lvtctl.sh GetSchema -h
Usage: GetSchema [-tables=<table1>,<table2>,...] [-exclude_tables=<table1>,<table2>,...] [-include-views] <tablet alias>

Displays the full schema for a tablet, or just the schema for the specified tables in that tablet.

  -exclude_tables string
        Specifies a comma-separated list of tables to exclude. Each is either an exact match, or a regular expression of the form /regexp/
  -include-views
        Includes views in the output
  -table_names_only
        Only displays table names that match
  -tables string
        Specifies a comma-separated list of tables for which we should gather information. Each is either an exact match, or a regular expression of the form /regexp/
$ ./lvtctl.sh GetSchema test-100
{
  "database_schema": "CREATE DATABASE /*!32312 IF NOT EXISTS*/ {{.DatabaseName}} /*!40100 DEFAULT CHARACTER SET utf8 */",
  "table_definitions": [
    {
      "name": "messages",
      "schema": "CREATE TABLE `messages` (\n  `page` bigint(20) unsigned NOT NULL DEFAULT '0',\n  `time_created_ns` bigint(20) unsigned NOT NULL DEFAULT '0',\n  `message` varchar(10000) DEFAULT NULL,\n  PRIMARY KEY (`page`,`time_created_ns`)\n) ENGINE=InnoDB DEFAULT CHARSET=utf8",
      "columns": [
        "page",
        "time_created_ns",
        "message"
      ],
      "primary_key_columns": [
        "page",
        "time_created_ns"
      ],
      "type": "BASE TABLE",
      "data_length": "16384",
      "row_count": "3"
    }
  ],
  "version": "981dca8a5c3fa245d2da95d735019460"
}       
```
#### ValidateSchemaShard
  该 ValidateSchemaShard 命令确认，对于给定的keyspace，指定shard中的all of the slave tablets与该shard中的the master tablet具有相同的架构。当你调用时ValidateSchemaShard，你指定你正在验证的keyspaces和shard。

  以下命令确认shard中的master和slave tablets 在 shard 0均具有相同的user keyspaces schema：

  > ValidateSchemaShard user/0

实践记录
``` bash
$ ./lvtctl.sh ValidateSchemaShard -h
Usage: ValidateSchemaShard [-exclude_tables=''] [-include-views] <keyspace/shard>

Validates that the master schema matches all of the slaves.

  -exclude_tables string
        Specifies a comma-separated list of tables to exclude. Each is either an exact match, or a regular expression of the form /regexp/
  -include-views
        Includes views in the validation
$ ./lvtctl.sh ValidateSchemaShard test_keyspace/0
```
#### ValidateSchemaKeyspace

该ValidateSchemaKeyspace 命令确认给定密钥空间中的所有平板电脑都具有与该密钥空间中分片的主平板电脑相同的模式0 。因此，尽管该ValidateSchemaShard 命令确认给定密钥空间的碎片内的平板电脑上的模式的一致性，但ValidateSchemaKeyspace确认了该密钥空间的所有碎片中的所有平板电脑之间的一致性。

以下命令证实，所有碎片所有片剂具有相同的模式在碎片主平板0的 user密钥空间：

> ValidateSchemaKeyspace user

``` bash
$ ./lvtctl.sh ValidateSchemaKeyspace -h
Usage: ValidateSchemaKeyspace [-exclude_tables=''] [-include-views] <keyspace name>

Validates that the master schema from shard 0 matches the schema on all of the other tablets in the keyspace.

  -exclude_tables string
        Specifies a comma-separated list of tables to exclude. Each is either an exact match, or a regular expression of the form /regexp/
  -include-views
        Includes views in the validation
$ ./lvtctl.sh ValidateSchemaKeyspace test_keyspace
```
#### GetVSchema

该GetVSchema 命令显示指定密钥空间的全局VSchema。

``` bash
$ ./lvtctl.sh GetVSchema -h
Usage: GetVSchema <keyspace>

Displays the VTGate routing schema.
```
#### GetSrvVSchema

  该GetSrvVSchema 命令显示给定cell的组合VSchema。

``` bash
./lvtctl.sh GetSrvVSchema -h
Usage: GetSrvVSchema <cell>

Outputs a JSON structure that contains information about the SrvVSchema.
$ ./lvtctl.sh GetSrvVSchema test
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
### Changing your schema  改变您的模式
本节介绍以下命令：

- ApplySchema
- ApplyVSchema
- RebuildVSchemaGraph

#### ApplySchema
  Vitess架构修改功能的设计考虑了以下几个目标：
  - 启动传播到整个服务器的简单更新
  - 最少的人际交往
  - 通过针对临时数据库测试更改来最大限度的减少错误
  - 对于大多数模式更新，确保非常少的停机时间(或无停机时间)
  - 不要在拓扑服务器中存储永久架构数据。

请注意：目前，Vitess仅支持create, modify, or delete database tables的数据定义语句。例如，ApplySchema不影响stored procedures or grants(存储过程和授权)

该ApplySchema 命令将架构更改应用于every master tablet上指定的keyspace，并行运行在所有shard上。然后通过复制将更改传播到从服务器。命令格式是： ApplySchema {-sql=<sql> || -sql_file=<filename>} <keyspace>

当该ApplySchema操作实际将模式更改应用于指定的密钥空间时，它将执行以下步骤：
- 1、它发现属于keyspace的shard，包括如果发生重新划分事件时新添加的碎片 。
- 2、它验证SQL语法并确定模式更改的影响。如果变化的范围太大，Vitess会拒绝它。有关更多详细信息，请参阅允许的模式更改部分
- 3、它使用飞行前检查来确保在更改实际应用于实时数据库之前模式更新会成功。在这个阶段，Vitess将当前模式复制到临时数据库中，在那里应用更改以验证它，并检索生成的模式。通过这样做，Vitess可以验证更改是否成功，而无需实际接触实时数据库表。
- 4、它在每个分片中的主平板电脑上应用SQL命令。

以下示例命令将user_table.sql 文件中的SQL应用于用户keyspace：

> ApplySchema -sql_file=user_table.sql user

**Permitted schema changes** 允许的模式更改

该ApplySchema命令支持一组有限的DDL语句。此外，Vitess拒绝某些模式更改，因为较大的更改会减慢复制速度，并可能降低整个系统的可用性。

以下列表标识了Vitess支持的DDL语句的类型：

- CREATE TABLE
- CREATE INDEX
- CREATE VIEW
- ALTER TABLE
- ALTER VIEW
- RENAME TABLE
- DROP TABLE
- DROP INDEX
- DROP VIEW

此外，Vitess在评估潜在变化的影响时应用以下规则：
- DROP 无论表的大小如何，总是允许使用语句。
- ALTER 只有在分片主平板电脑上的表格具有100,000行或更少的行时才允许使用语句。
- 对于所有其他声明，碎片主平板电脑上的表格必须有200万行或更少。

如果模式更改因为影响太多的行而被拒绝，您可以指定标志来告诉跳过此检查。但是，我们不建议这样做。相反，您应该遵循模式交换流程应用大型模式更改。-allow_long_unavailabilityApplySchema

#### ApplyVSchema

  该ApplyVSchema 命令将指定的VSchema应用于密钥空间。VSchema可以被指定为字符串或文件。

#### RebuildVSchemaGraph

  该RebuildVSchemaGraph 命令将全局VSchema传播到特定单元格或指定单元格的列表。

### VSchema Guide    VSchema 用户指南
#### Contents
VSchema代表Vitess Schema。与包含有关表的元数据的传统数据库模式相比，VSchema包含有关如何在密钥空间和分片中组织表的方式的元数据。简而言之，它包含使Vitess看起来像单个数据库服务器所需的信息。

例如，VSchema将包含关于分片表的分片键的信息。当应用程序使用引用密钥的WHERE子句发出查询时，将使用VSchema信息将查询路由到适当的分片。

#### Sharding Model 分片模型
在Vitess中，a keyspace被keyspace ID范围分割。每行都被分配一个密钥空间ID，这个密钥空间ID就像街道地址一样，它决定了该行所在的分片。在某些方面，可以说这keyspace ID相当于NoSQL分片密钥。但是，有一些差异：

- 这keyspace ID是Vitess内部的一个概念。该应用程序不需要知道任何有关它。
- 没有存储实际的物理列keyspace ID。该值根据需要进行计算。

这种差异足够重要，我们不把密钥空间ID称为分片密钥。我们稍后将介绍主要Vindex的概念，它更紧密地重新排列NoSQL分片密钥。

映射到keyspace ID碎片，然后映射到碎片，使我们能够灵活地重新保存数据，同时keyspace ID保持最小的中断，因为每行的数据在整个过程中保持不变。
#### Vindex
- The Primary Vindex
- Secondary Vindexes
- Unique and NonUnique Vindex
- Functional and Lookup Vindex
- Shared Vindexes
- Orthogonality
- How vindexes are used
- Predefined Vindexes
#### Sequences
#### VSchema
- Unsharded Table
- Sharded Table With Simple Primary Vindex
- Specifying A Sequence
- Specifying A Secondary Vindex
- Advanced usage
#### Roadmap

### Schema Swap (Tutorial)  架构交互（教程）
#### Contents 内容
本节描述如何在不中断正在进行的操作的情况下，在Vitess / MySQL中应用长时间运行的模式更改。大型数据库长时间运行更改ALTER TABLE的示例（例如添加列）OPTIMIZE TABLE或大规模数据更改（例如填充列或清除值）。

如果模式更改不是长时间运行的，请改用更简单的vtctl ApplySchema。
#### Overview 概述

#### Prerequisites 先决条件
#### Schema Swap Steps
