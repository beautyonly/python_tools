###
### Go概述
- [GoLang官网](https://golang.org/)
- [GoLang中国](https://www.golangtc.com/)

### Go Web框架
- https://github.com/gin-gonic/gin
### Go环境安装
``` bash
wget https://raw.githubusercontent.com/mds1455975151/tools/master/go/go_install.sh
sh go_install.sh
```
### Go Get问题
- [代理方案](https://blog.csdn.net/wdy_yx/article/details/53045084)
- https://github.com/golang/

``` bash
https://github.com/MXi4oyu/golang.org
源：go get golang.org/x/tools/cmd/goimports
新：go get github.com/MXi4oyu/golang.org/x/toos/cmd/goimports
```

### 模块
- gofmt: 源代码格式化
- os：命令行
- https://github.com/golang/lint
- https://github.com/mozillazg/request
- 日志
  - https://github.com/mozillazg/logrus
- 包管理
  - http://glide.sh/
- golint
https://github.com/golang/lint
- goimporter
go vet是一个用于检查Go语言源码中静态错误的简单工具
### FQA
- go项目搜索：https://gowalker.org/

### 参考资料
- [Go语言圣经](https://books.studygolang.com/gopl-zh/index.html)
  - [示例代码](github.com/adonovan/gopl.io/)
- 资料汇总
  - https://github.com/jobbole/awesome-go-cn
  - https://github.com/Unknwon/the-way-to-go_ZH_CN
  - https://github.com/EDDYCJY/blog
### Go开发环境的基本要求
- 语法高亮
- 自动保存代码
- 可以显示代码所在的行数
- 拥有较好的项目文件浏览和导航能力，可以同时编辑多个源文件并设置书签，能够匹配括号，能够跳转到某个函数或类型的定义部分。
- 查找和替换功能，替换之前预览
- 注释和取消一行或多行代码
- 有编译错误时，双击错误提示可以跳转到发生错误的位置
- 跨平台，在linux、mac os和window下，可以专注于一个开发环境
- 免费
- 开源
- 能够通过插件架构来轻易扩展和替换某个功能
- 操作方便
- 通过代码模板简化编码过程从而提升编译速度
- 构建系统概念
- 断点、检查变量、单步执行、逐过程执行标识库中代码的能力
- 方便的存取最近使用过的文件或项目
- 对包、类型、变量、函数和方法的智能补全功能
- 对项目或包代码建立抽象语法树视图（AST-view）
- 内置go相关工具
- 方便完整查阅go文档
- 方便在不同go环境之间切换
- 导出不同格式的代码文件，例如PDF,HTML或格式化都的代码
- 针对特定的项目有模板，如：web应用，app Engine项目，从而能够更快的开始开发工作
- 具备代码重构的能力
- 集成git等版本控制工具
- 集成google app engine开发及调试的功能

