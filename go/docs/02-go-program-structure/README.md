> Go语言结构

# Go Hello World实例
GO语言的基础组成有以下几个部分：
- 包声明
- 引入包
- 函数
- 变量
- 语句 & 表达式
- 注释

``` bash
 package main

 import "fmt"

 func main() {

   /* 这是我的第一个简单的程序 */
   fmt.Println("Hello, World!")
}
```

分析下以上程序的各个部分：
## 包的概念
包是结构化代码的一种方式：每个程序都由包的概念组成，可以使用自身的包或者从其他包中导入内容。

如同其他编程语言的类库或命名空间的概念，每个go文件都属于且属于一个包。一个包可以由许多以.go为扩展名的源文件组成，因此文件名和包名一般来说都是不相同的。

你必须在源文件中非注释的第一行指明这个文件属于哪个包，如package main。package main表示一个可独立执行的程序，每个go应用程序都包含一个名为main的包。

所有包名都应该使用小写字母。
## 标准库
如果对一个包进行更改或重新编译，所有引用了这个包的客户端程序都必须全部重新编译。

每一段代码只会被编译一次

导入包方法
```
import "fmt"
import "os"
```
or
```
import "fmt",import "os"
```
更短更优雅
```
import (
    "fmt"
    "os"
)
```
当你导入多个包时，最好按照字母顺序排列包名，这样做更加清晰易读。

如果包名不是以 . 或 / 开头，如 "fmt" 或者 "container/list"，则 Go 会在全局文件进行查找；如果包名以 ./ 开头，则 Go 会在相对目录中查找；如果包名以 / 开头（在 Windows 下也可以这样使用），则会在系统的绝对路径中查找。

导入包即等同于包含了这个包的所有的代码对象。

除了符号 \_，包中所有代码对象的标识符必须是唯一的，以避免名称冲突。但是相同的标识符可以在不同的包中使用，因为可以使用包名来区分它们。
## 可见性规则

# 执行Go程序
``` text
$ go run hello.go
Hello, World!
```

# iota枚举
``` go
package main

import (
	"fmt"
)

func main(){
	const (
		x = iota
		y = iota
		z = iota
	)

	const v  = iota

	const (
		e,f,g = iota,iota,iota
	)
	fmt.Printf("x,y,z,v= %v,%v,%v,%v", x,y,z,v)
	fmt.Printf("\n")
	fmt.Printf("e,f,g = %v,%v,%v", e,f,g)
}

// iota 默认开始值为0，没调用一次加1
// 每遇到一个const关键字，iota就会重置变为0
```

# 数据 arrary
``` go
package main

import "fmt"

func main() {
	var arr [10]int			// 声明一个int类型的数组
	arr[0] = 10				// 赋值操作
	a := [3]int{1,2,3}		// 声明长度为3的数组，其中前三个元素初始化为1,2,3，其他默认为0
	c := [10]int{1,2,3}		// 声明一个长度为10的int
	b := [...]int{4,5,6}	// 可以省略长度采用...代表，go会自动根据元素个数计算长度
	fmt.Printf("arr:%v\n", arr)
	fmt.Printf("a:%v\n", a)
	fmt.Printf("b:%v\n", b)
	fmt.Printf("c:%v\n", c)
}
D:\go\src\test-01>go run 03.go
arr:[10 0 0 0 0 0 0 0 0 0]
a:[1 2 3]
b:[4 5 6]
c:[1 2 3 0 0 0 0 0 0 0]
```
# 注意
- 1、包名和包所在的文件夹名可以是不同的，此处的<pkgName>即为通过package <pkgName>声明的包名，而非文件夹名。
- 2、_（下划线）是个特殊的变量名，任何赋予它的值都会被丢弃

# 常见报错
- 1、go run: cannot run non-main package
原因：package 命名必须为main
- 2、syntax error: non-declaration statement outside function body
原因：在函数为定义了变量
