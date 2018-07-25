> Go语言数据类型

# Go 语言数据类型
## 布尔型
  布尔类型的值只可以是常量true或者false
## 数字类型
- int
- float32
- float64

## 字符串类型
## 派生类型
- 指针类型
- 数组类型
- 结构体类型 struct
- channel类型
- 函数类型
- 切片类型
- 接口类型 interface
- Map类型

``` bash
$ cat data-type.go
package main

import "fmt"

func main(){
    var a = 10.1
    var b = 1
    fmt.Println(a,b)
}
```
