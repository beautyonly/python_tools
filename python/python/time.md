# 前言
工作中经常会使用到各种时间的表示方式, 比如时间戳, 时间字符串等等, python标准库中有两个常用的相关模块, time和datetime, 为了以后的快速开发, 而不用每次使用到的时候临时搜索, 所以在这里总结了时间, 日期的常见的处理方法!

# 总结
* 获取当前的时间戳

```
>>> time.time()
1508901761.147111
>>> int(time.time())
1508901769
```

* 获取当前的时间字符串

```
>>> datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
'2017-10-25 11:31:30'
```

* 分别获取当前的时间数字

```
>>> datetime.datetime.now()
datetime.datetime(2017, 10, 25, 11, 40, 24, 515960)
>>> datetime.datetime.now().year
2017
>>> datetime.datetime.now().month
10
>>> datetime.datetime.now().day
25
>>> datetime.datetime.now().hour
11
>>> datetime.datetime.now().minute
40
>>> datetime.datetime.now().second
58
```

* 获取当天0点的时间戳

```
>>> datetime.date.today()
datetime.date(2017, 10, 25)
datetime.date对象只表示日期, 默认时间都是0, 所以可以使用这个来转化
>>>int(time.mktime(datetime.date.today().timetuple()))
1508860800
```

* 获取今天是周几, 是今年的第几天

```
>>> datetime.date.today().timetuple()
time.struct_time(tm_year=2017, tm_mon=10, tm_mday=25, tm_hour=0, tm_min=0, tm_sec=0, tm_wday=2, tm_yday=298, tm_isdst=-1)

tm_wday 表示今天是周几, [0, 6] 0表示周一
tm_yday 表示今天是今天的第几天, [1, 366]
```

* 获取N天前/后的日期

```
>>> datetime.datetime.now() + datetime.timedelta(days=1)
datetime.datetime(2017, 10, 26, 12, 9, 31, 690823)
具体日期处理方式跟上面的类似
```




![](https://user-images.githubusercontent.com/7486508/31890268-178dbb5a-b835-11e7-9b5d-ffb8e0168807.png)
