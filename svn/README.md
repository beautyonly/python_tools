# SVN相关问题
## SVN web管理工具
- [submin](https://supermind.nl/submin/)

## SVN权限设置
- 特殊账号($authenticated 代表所有用户)

- 特殊权限(* = 代表其他所有用户无任何权限)

## SVN权限管理
- qa_junior
- qa_senior
- qa_advanced

## FQA
- 1、父级目录dir1 二级子目录dir-1 dir-2 ... dir-n,user1只能访问dir-1，如何进行授权？
``` text
svn设计是子目录继承父级目录权限，所有没有很好的办法解决该问题，解决办法有两种，根据情况自行选择：
方法1：父级目录不授权，只授权dir-1,用户单独每个目录进行checkout
方法2：父级目录授权，dir-1授权给user1,然后其他目录再去掉user1权限
方法1用户体验不好，方法2二级目录太多管理员不好管理，根据情况自行选择。
```
- 2、Linux环境下查看svn目录结构
``` bash
# cat svn_list_dir.sh
#!/bin/env bash
tag_level1_dir=`svn list file:///home/svn-root/proj4/`
for i in $tag_level1_dir
do
    tag_level2_dir=`svn list file:///home/svn-root/proj4/$i`
    echo $i
    for j in $tag_level2_dir
    do
        echo "------/$i$j"
    done
done
```
## SVN目录结构调整
目录结构调整，在不checkout所有代码的情况下如何快速调整
``` bash
svn move -m "Move a dir" svn://xxx/dongsheng/test1/test_dir svn://xxx/dongsheng/test2/test_dir
svn move -m "Move a dir" file:///home/svn-root/dongsheng/test2/test_dir file:///home/svn-root/dongsheng/test1/test_dir
svn mkdir -m 'make a new dir' file:///home/svn-root/dongsheng/script
svn list file:///home/svn-root/dongsheng/script
```

##
```
--force # 强制覆盖
/usr/bin/svn --username user --password passwd co  $Code  ${SvnPath}src/                 # 检出整个项目
/usr/bin/svn --username user --password passwd up  $Code  ${SvnPath}src/                 # 更新项目
/usr/bin/svn --username user --password passwd export  $Code$File ${SvnPath}src/$File    # 导出个别文件
/usr/bin/svn --username user --password passwd export -r 版本号 svn路径 本地路径 --force   # 导出指定版本
```
