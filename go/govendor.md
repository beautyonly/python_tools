# Go依赖管理利器-govendor
## govendor概述
长期以来，Golang对外部依赖都没有很好的管理方式，只能从$GOPATH下查找依赖。这就造成不同用户在安装同一个项目适合可能从外部获取到不同的依赖库版本，同时当无法联网时，无法编译依赖缺失的项目。

自 1.5 版本开始引入 govendor 工具，该工具将项目依赖的外部包放到项目下的 vendor 目录下（对比 nodejs 的 node_modules 目录），并通过 vendor.json 文件来记录依赖包的版本，方便用户使用相对稳定的依赖。

GitHub地址：https://github.com/kardianos/govendor
## govendor详细介绍
对于 govendor 来说，主要存在三种位置的包：
- 项目自身的包组织为本地（local）包
- 传统的存放在$GOPATH下的依赖包为外部（external）依赖包
- 被govendor管理的放在vendor目录下的依赖包则为vendor包。

具体来看，这些包可能的类型如下：

| 状态      | 缩写状态 | 含义                                               |
| --------- | -------- | -------------------------------------------------- |
| +local    | l        | 本地包，即项目自身的包组织                         |
| +external | e        | 外部包，即被 $GOPATH 管理，但不在 vendor 目录下    |
| +vendor   | v        | 已被 govendor 管理，即在 vendor 目录下             |
| +std      | s        | 标准库中的包                                       |
| +unused   | u        | 未使用的包，即包在 vendor 目录下，但项目并没有用到 |
| +unused   | u        | 未使用的包，即包在 vendor 目录下，但项目并没有用到 |
| +missing  | m        | 代码引用了依赖包，但该包并没有找到                 |
| +program  | p        | 主程序包，意味着可以编译为执行文件                 |
| +outside  |          | 外部包和缺失的包                                  |
| +all      |          | 所有的包                                          |


常见的命令如下，格式为 govendor COMMAND。
通过指定包类型，可以过滤仅对指定包进行操作。

| 命令      | 功能 |
| --------- | -------- |
| init			|初始化 vendor 目录                                             |
| list			|列出所有的依赖包                                               |
| add			|添加包到 vendor 目录，如 govendor add +external 添加所有外部包 |
| add PKG_PATH	|添加指定的依赖包到 vendor 目录                                 |
| update			|从 $GOPATH 更新依赖包到 vendor 目录                            |
| remove			|从 vendor 管理中删除依赖                                       |
| status			|列出所有缺失、过期和修改过的包                                 |
| fetch			|添加或更新包到本地 vendor 目录                                 |
| sync			|本地存在 vendor.json 时候拉去依赖包，匹配所记录的版本          |
| get			|类似 go get 目录，拉取依赖包到 vendor 目录                     |

## 其他Go依赖管理工具
- Glide
## 参考资料
