> Go语言基础语法

# Go 标记
# 行分隔符
# 注释
``` text
// 单行注释
/*
 Author by 菜鸟教程
 我是多行注释
*/
```

# 标识符
# 关键字
# Go 语言的空格


- 通过 const 关键字来进行常量的定义。
- 通过在函数体外部使用 var 关键字来进行全局变量的声明和赋值。
- 通过 type 关键字来进行结构(struct)和接口(interface)的声明。
- 通过 func 关键字来进行函数的声明。
- 可见性规则
```
  Go语言中，使用大小写来决定该常量、变量、类型、接口、结构或函数是否可以被外部包所调用。
  函数名首字母小写即为 private :
  func getId() {}
  函数名首字母大写即为 public :
  func Printf() {}
```

``` bash
// 一般类型声明
type newType int

// 结构的声明
type gopher struct{}

// 接口的声明
type golang interface{}
```
