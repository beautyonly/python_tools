> Go语言变量

# 变量声明
``` bash
package main
var a = "菜鸟教程"
var b string = "runoob.com"
var c bool

func main(){
    println(a, b, c)
}
```
# 多变量声明

# 值类型和引用类型

# 如何判断变量的类型
- 方法1

```
package main

import (
 "fmt"
)

func main() {

        v1 := "123456"
        v2 := 12

        fmt.Printf("v1 type:%T\n", v1)
        fmt.Printf("v2 type:%T\n", v2)
}
```
output:
> v1 type:string
v2 type:int

- 方法2

```
package main

import (
 "fmt"
 "reflect"
)

func main() {
        v1 := "123456"
        v2 := 12

        // reflect
        fmt.Println("v1 type:", reflect.TypeOf(v1))
        fmt.Println("v2 type:", reflect.TypeOf(v2))
}
```
output
> v1 type:string
v2 type:int

# 语言类型转换

类型转换用于将一种数据类型的变量转换为另外一种类型的变量。Go 语言类型转换基本格式如下：
```
type_name(expression)
type_name 为类型，expression 为表达式。
```
**实例**

以下实例中将整型转化为浮点型，并计算结果，将结果赋值给浮点型变量：
```
package main

import "fmt"

func main() {
   var sum int = 17
   var count int = 5
   var mean float32

   mean = float32(sum)/float32(count)
   fmt.Printf("mean 的值为: %f\n",mean)
}
```
以上实例执行输出结果为：
```
mean 的值为: 3.400000
```
