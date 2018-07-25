# Replica Set Members 副本集成员
A replica set in MongoDB is a group of mongod processes that provide redundancy and high availability. The members of a replica set are:

Primary.
> The primary receives all write operations.

Secondaries.
> Secondaries replicate operations from the primary to maintain an identical data set. Secondaries may have additional configurations for special usage profiles. For example, secondaries may be non-voting or priority 0.

您还可以将仲裁器作为副本集的一部分进行维护。仲裁员不保留数据的副本。然而，仲裁员在选举主要人选的选举中发挥作用，如果当前的主要人选不可用。

推荐配置的最小配置是三个副本集，其中包含三个数据承载成员：一个主要成员和两个次要成员。您也可以部署带有两个数据承载成员的三个成员副本集：主数据承载成员，辅助数据承载成员 和仲裁器，但具有至少三个数据承载成员的副本集合可提供更好的冗余。

版本3.0.0更改：副本集可以有多达50个成员，但只有7个有投票权的成员。 [1]在以前的版本中，副本集最多可以有12个成员。
# Primary

# Secondaries

# Arbiter
