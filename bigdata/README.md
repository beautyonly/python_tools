hdfs{
    hdfs --help                  # 所有参数

    hdfs dfs -help               # 运行文件系统命令在Hadoop文件系统
    hdfs dfs -ls /logs           # 查看
    hdfs dfs -ls /user/          # 查看用户
    hdfs dfs -cat
    hdfs dfs -df
    hdfs dfs -du
    hdfs dfs -rm
    hdfs dfs -tail
    hdfs dfs –put localSrc dest  # 上传文件

    hdfs dfsadmin -help          # hdfs集群节点管理
    hdfs dfsadmin -report        # 基本的文件系统统计信息
}
