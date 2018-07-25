> Go语言切片(Slice)

Go 语言切片是对数组的抽象。

Go 数组的长度不可改变，在特定场景中这样的集合就不太适用，Go中提供了一种灵活，功能强悍的内置类型切片("动态数组"),与数组相比切片的长度是不固定的，可以追加元素，在追加时可能使切片的容量增大。

# 定义切片
你可以声明一个未指定大小的数组来定义切片：
> var identifier []type

切片不需要说明长度。

或使用make()函数来创建切片:
> var slice1 []type = make([]type, len)

也可以简写为
> slice1 := make([]type, len)

也可以指定容量，其中capacity为可选参数。
> make([]T, length, capacity)

这里 len 是数组的长度并且也是切片的初始长度。

## 切片初始化
## len()和cap()函数
切片是可索引的，并且可以由 len() 方法获取长度。

切片提供了计算容量的方法 cap() 可以测量切片最长可以达到多少。

以下为具体实例：
```
package main

import "fmt"

func main() {
   var numbers = make([]int,3,5)

   printSlice(numbers)
}

func printSlice(x []int){
   fmt.Printf("len=%d cap=%d slice=%v\n",len(x),cap(x),x)
}
```
以上实例运行输出结果为:
> len=3 cap=5 slice=[0 0 0]

# 空切片
一个切片在未初始化之前默认为 nil，长度为 0，实例如下：
```
package main

import "fmt"

func main() {
   var numbers []int

   printSlice(numbers)

   if(numbers == nil){
      fmt.Printf("切片是空的")
   }
}

func printSlice(x []int){
   fmt.Printf("len=%d cap=%d slice=%v\n",len(x),cap(x),x)
}
```
以上实例运行输出结果为:
> len=0 cap=0 slice=[]
>
> 切片是空的

# 切片截断
# append() 和 copy() 函数
如果想增加切片的容量，我们必须创建一个新的更大的切片并把原分片的内容都拷贝过来。

下面的代码描述了从拷贝切片的 copy 方法和向切片追加新元素的 append 方法。
```
package main

import "fmt"

func main() {
   var numbers []int
   printSlice(numbers)

   /* 允许追加空切片 */
   numbers = append(numbers, 0)
   printSlice(numbers)

   /* 向切片添加一个元素 */
   numbers = append(numbers, 1)
   printSlice(numbers)

   /* 同时添加多个元素 */
   numbers = append(numbers, 2,3,4)
   printSlice(numbers)

   /* 创建切片 numbers1 是之前切片的两倍容量*/
   numbers1 := make([]int, len(numbers), (cap(numbers))*2)

   /* 拷贝 numbers 的内容到 numbers1 */
   copy(numbers1,numbers)
   printSlice(numbers1)   
}

func printSlice(x []int){
   fmt.Printf("len=%d cap=%d slice=%v\n",len(x),cap(x),x)
}
```
以上代码执行输出结果为：

> len=0 cap=0 slice=[]
>
> len=1 cap=1 slice=[0]
>
> len=2 cap=2 slice=[0 1]
>
> len=5 cap=6 slice=[0 1 2 3 4]
>
> len=5 cap=12 slice=[0 1 2 3 4]
