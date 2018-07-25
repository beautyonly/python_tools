下载地址：https://golang.org/dl/

# Go安装
## windows:
### Install the Go tools
[安装及配置方法](https://golang.org/doc/install?download=go1.10.windows-amd64.msi)
## Test your installation
``` bash
$ cat test.go
package main

import "fmt"

func main(){
  fmt.Println("Hello,world!")
}

$ go run test.go
Hello,world!

```

## Linux
待补充
## Mac OS X
``` bash
brew install go
brew info go
```

# Go 命令说明
- go build
- go run:编译并运行Go程序
- go install
- go clean
- go fmt
- go get:动态获取远程代码包
- go test
- go doc
- go version
- go env
- go list


# GoGetTools
https://github.com/golang/go/wiki/GoGetTools

# IDE推荐
- JetBrains GoLand(依赖JDK)
https://www.jetbrains.com/go/?fromMenu
- LiteIDE
- Eclipse
- Sublime Text
- Vim
- Emacs
# 格式化代码
- gofmt
```
gofmt -w a1.go  # 格式化并重写go源文件
gofmt -w *.go
gofmt dir1      # 格式化并重写dir1目录及其子目录下的所有go源文件
```

参考资料：https://golang.org/cmd/gofmt/

# 生成代码文档
go doc工具会从Go程序和包文件中提前顶级声明的首行注释以及每个对象的相关注释，并生成相关文档。

它也可以作为一个提供在线文件浏览的web服务器，http://golang.org 就是通过这种形式实现的。

**一般用法**
- go doc package获取包的文档注释，例如：go doc fmt会显示使用godoc生成的fmt包的文件注释
- go doc package/subpackage获取子包的文档注释，例如：go doc container/list
- go doc package function 获取某个函数在某个包中的文档注释，例如：go doc fmt Printf会显示有关fmt.Printf()的使用说明

godoc -http=:6060，然后使用浏览器打开http://localhost:6060 后可以在本地文档浏览服务器提供的页面。(**本地重要手册方便快捷**)

参考资料：http://golang.org/cmd/godoc/

# 其他工具
- go install
- go fix
- go test:轻量级的单元测试框架

# 与其它语言进行交互
## C语言
- http://golang.org/cmd/cgo
## C++

