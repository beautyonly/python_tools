> Go语言函数

函数是基本的代码块，用于执行一个任务.

Go语言最少有一个main()函数.

通过函数划分不同功能，逻辑上每个函数执行的是指定的任务

函数声明告诉编辑器函数的名称，返回类型和参数

Go语言提供了内置函数，例如len()
# 函数定义
```
func function_name( [parameter list] ) [return_types] {
   函数体
}
```
函数定义解析：
- func：函数由 func 开始声明
- function_name：函数名称，函数名和参数列表一起构成了函数签名。
- parameter list：参数列表，参数就像一个占位符，当函数被调用时，你可以将值传递给参数，这个值被称为实际参数。参数列表指定的是参数类型、顺序、及参数个数。参数是可选的，也就是说函数也可以不包含参数。
- return_types：返回类型，函数返回一列值。return_types 是该列值的数据类型。有些功能不需要返回值，这种情况下 return_types 不是必须的。
函数体：函数定义的代码集合。

**实例**

以下实例为 max() 函数的代码，该函数传入两个整型参数 num1 和 num2，并返回这两个参数的最大值：
```
/* 函数返回两个数的最大值 */
func max(num1, num2 int) int {
   /* 声明局部变量 */
   var result int

   if (num1 > num2) {
      result = num1
   } else {
      result = num2
   }
   return result
}
```
# 函数调用
# 函数返回多个值
Go 函数可以返回多个值，例如：
```
package main

import "fmt"

func swap(x, y string) (string, string) {
   return y, x
}

func main() {
   a, b := swap("Mahesh", "Kumar")
   fmt.Println(a, b)
}
```
以上实例执行结果为：

Kumar Mahesh

# 函数参数
函数如果使用参数，该变量可以称为函数的形参

形参就像定义在函数体内的局部变量

调用函数，可以通过两种方式来传递参数：
- 值传递
- 引用传递

# 函数用法
- 函数作为值
- 闭包
- 方法
