# jmeter总结(运维相关)
## 新建jxm文件
### 流程总结

 - 1、File-->New 添加测试项，修改项目名称，修改备注，添加变量
   
 - 2、Edit-->Add-->Threads(Users)-->Thread Group 设置线程组
   
 - 3、Edit-->Add-->Config Element-->HTTP Request Defaults 添加http默认请求值（协议、IP、Port、路径、编码等等）
   
 - 4、右击2中新建的Thread Group线程组选择Add-->Sampler-->HTTP Request 添加HTTP请求
   
 - 5、右击2中新建的Thread Group线程组，添加监听器用于存放测试结果Add-->Listener-->Summary Report
   
 - 6、运行测试，并查看结果
   
截图展示：
![image](https://github.com/mds1455975151/tools/blob/master/jmeter/tutorial/images/01.png)
![image](https://github.com/mds1455975151/tools/blob/master/jmeter/tutorial/images/02.png)
![image](https://github.com/mds1455975151/tools/blob/master/jmeter/tutorial/images/03.png)
![image](https://github.com/mds1455975151/tools/blob/master/jmeter/tutorial/images/04.png)
![image](https://github.com/mds1455975151/tools/blob/master/jmeter/tutorial/images/05.png)
![image](https://github.com/mds1455975151/tools/blob/master/jmeter/tutorial/images/06.png)

### jtl文件分析

## FQA
- 1、界面语句修改

   > Options-->Choose Language--> Chinese


## 参考资料
- [JMeter数据库压力测试工具学习资料](https://github.com/langpf1/jmeter)
- [性能测试、资料培训、jmeter+ant+jenkins测试平台搭建](https://github.com/renyixiang/Jmeter)
