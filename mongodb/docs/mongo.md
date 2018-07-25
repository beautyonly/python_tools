# the-mongo-shell

# Introduction 介绍
该mongo shell是一个连到MongoDB的交互式JavaScript界面​​。您可以使用mongo shell来查询和更新数据以及执行管理操作。

所述mongo shell是的一个组件的MongoDB分布。一旦你已经安装，并已开始MongoDB中，将连接mongo shell到正在运行的MongoDB实例。

MongoDB手册中的大多数示例都使用 mongo shell; 然而，许多驱动程序提供与MongoDB类似的接口。

# Start the mongo Shell 启动
``` bash
./bin/mongo
```
- .mongorc.js

# Working with the mongo Shell 工作
``` bash
db                                          # 查看当前db
use <database>                              # 切换db
db.myCollection.insertOne( { x: 1 } );      # 插入
db.myCollection.find().pretty();            # 输出
```

# Tab Completion and Other Keyboard Shortcuts tab补全与快捷键
- .dbshell

# Exit the Shell 退出
To exit the shell, type quit() or use the <Ctrl-C> shortcut.
