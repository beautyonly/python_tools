> Go语言常量

常量的定义格式:

> const identifier [type] = value

- 显式类型定义： const b string = "abc"
- 隐式类型定义： const b = "abc"

案例
``` bash
package main

import "fmt"

func main() {
   const LENGTH int = 10
   const WIDTH int = 5   
   var area int
   const a, b, c = 1, false, "str" //多重赋值

   area = LENGTH * WIDTH
   fmt.Printf("面积为 : %d", area)
   println()
   println(a, b, c)   
}
```

# iota
特殊常量，可以被编译器修改的常量
