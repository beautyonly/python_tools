# MySQL知识点
## MySQL概述
## MySQL安装部署
``` bash
wget https://raw.githubusercontent.com/mds1455975151/tools/master/mysql/install_mysql.sh
sh install_mysql.sh

wget https://raw.githubusercontent.com/mds1455975151/tools/master/mysql/uninstall_mysql.sh
sh uninstall_mysql.sh
```
## MySQL备份还原
## 可视化管理工具
- [SQLyog]
- [phpMyAdmin]
- [Navicat]
- [MySQL ODBC Connector]
- [DBeaver]
- [MyDB Studio]
- [SQL Lite Manger]
- [adminer](https://www.adminer.org/)
## MySQL监控及故障处理
## MySQL批量管理
- 如何高效的插入数据库100w条数据(大概300~400M数据具体和存储数据类型相关)
  - 脚本循环+insert
  ``` bash
  #!/bin/env bash

  text=",重复的sql内容"
  sql="INSERT INTO xxx.xxx(xx, xx, xx, xx, xx, xx, xx, xx, xx, xx) VALUES 重复的sql内容"
  end=";"
  sum=$sql
  for i in `seq 1`
  do
      for j in `seq 99`
      do
          sum=$sum$text
      done
      mysql -u xxx -h xxx -p'xxx' -e "$sum$end"
  done
  注意：修改第一个循环调整插入多少次，修改第二个循环调整每次sql拼接内容条数，看情况调整sql进行插入
  ```
  - 存储过程
  - 造数据+load data
## FQA
- mysql -P 指定端口不起作用
``` text
mysql -P 指定端口不起作用，我的MySQL端口实际在3306上，但指定32442端口也能连接上：
[root@centos7 ~] #15> mysql -uroot -hlocalhost -P32442 -p
Enter password:
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 13
Server version: 10.1.30-MariaDB MariaDB Server

Copyright (c) 2000, 2017, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [(none)]>
默认尝试3306端口进行连接，连接上才不去尝试-P指定的端口号了，即：如果使用的是3306端口，则-P参数无效，此处指定的32442没有生效。
```
- ERROR 1067 (42000) at line 621: Invalid default value for 'closeTime'							
``` bash
show variables like 'sql_mode';
SET sql_mode = '';
SET GLOBAL sql_mode = 'ALLOW_INVALID_DATES,NO_ENGINE_SUBSTITUTION';
SET GLOBAL sql_mode = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';

NO_ZERO_IN_DATE,NO_ZERO_DATE


A timestamp. The range is '1970-01-01 00:00:01' UTC to '2038-01-19 03:14:07' UTC.
https://dev.mysql.com/doc/refman/5.7/en/date-and-time-type-overview.html
```
- mysql_errno: 1044, mysql_error: Access denied for user 'root'@'%' to databas
https://blog.csdn.net/aosica321/article/details/53433837
### SQL
### 分库分表
## 参考资料
- https://github.com/Neeky/mysqltools


mysql源码安装{

    groupadd mysql
    useradd mysql -g mysql -M -s /bin/false
    tar zxvf mysql-5.0.22.tar.gz
    cd mysql-5.0.22
    ./configure  --prefix=/usr/local/mysql \
    --with-client-ldflags=-all-static \
    --with-mysqld-ldflags=-all-static \
    --with-mysqld-user=mysql \
    --with-extra-charsets=all \
    --with-unix-socket-path=/var/tmp/mysql.sock
    make  &&   make  install
    # 生成mysql用户数据库和表文件，在安装包中输入
    scripts/mysql_install_db  --user=mysql
    vi ~/.bashrc
    export PATH="$PATH: /usr/local/mysql/bin"
    # 配置文件,有large,medium,small三个，根据机器性能选择
    cp support-files/my-medium.cnf /etc/my.cnf
    cp support-files/mysql.server /etc/init.d/mysqld
    chmod 700 /etc/init.d/mysqld
    cd /usr/local
    chmod 750 mysql -R
    chgrp mysql mysql -R
    chown mysql mysql/var -R
    cp  /usr/local/mysql/libexec/mysqld mysqld.old
    ln -s /usr/local/mysql/bin/mysql /sbin/mysql
    ln -s /usr/local/mysql/bin/mysqladmin /sbin/mysqladmin
    ln -s -f /usr/local/mysql/bin/mysqld_safe /etc/rc.d/rc3.d/S15mysql5
    ln -s -f /usr/local/mysql/bin/mysqld_safe /etc/rc.d/rc0.d/K15mysql5

}

mysql常用命令{

    ./mysql/bin/mysqld_safe --user=mysql &   # 启动mysql服务
    ./mysql/bin/mysqladmin -uroot -p -S ./mysql/data/mysql.sock shutdown    # 停止mysql服务
    mysqlcheck -uroot -p -S mysql.sock --optimize --databases account       # 检查、修复、优化MyISAM表
    mysqlbinlog slave-relay-bin.000001              # 查看二进制日志(报错加绝对路径)
    mysqladmin -h myhost -u root -p create dbname   # 创建数据库

    flush privileges;             # 刷新
    show databases;               # 显示所有数据库
    use dbname;                   # 打开数据库
    show tables;                  # 显示选中数据库中所有的表
    desc tables;                  # 查看表结构
    drop database name;           # 删除数据库
    drop table name;              # 删除表
    create database name;         # 创建数据库
    select 列名称 from 表名称;      # 查询
    show processlist;             # 查看mysql进程
    show full processlist;        # 显示进程全的语句
    select user();                # 查看所有用户
    show slave status\G;          # 查看主从状态
    show variables;               # 查看所有参数变量
    show status;                  # 运行状态
    show table status             # 查看表的引擎状态
    show grants for dbbackup@'localhost';           # 查看用户权限
    drop table if exists user                       # 表存在就删除
    create table if not exists user                 # 表不存在就创建
    select host,user,password from user;            # 查询用户权限 先use mysql
    create table ka(ka_id varchar(6),qianshu int);  # 创建表
    show variables like 'character_set_%';          # 查看系统的字符集和排序方式的设定
    show variables like '%timeout%';                # 查看超时(wait_timeout)
    delete from user where user='';                 # 删除空用户
    delete from user where user='sss' and host='localhost' ;    # 删除用户
    drop user 'sss'@'localhost';                                # 使用此方法删除用户更为靠谱
    ALTER TABLE mytable ENGINE = MyISAM ;                       # 改变现有的表使用的存储引擎
    SHOW TABLE STATUS from  库名  where Name='表名';              # 查询表引擎
    mysql -uroot -p -A -ss -h10.10.10.5 -e "show databases;"    # shell中获取数据不带表格 -ss参数
    CREATE TABLE innodb (id int, title char(20)) ENGINE = INNODB                     # 创建表指定存储引擎的类型(MyISAM或INNODB)
    grant replication slave on *.* to '用户'@'%' identified by '密码';               # 创建主从复制用户
    ALTER TABLE player ADD INDEX weekcredit_faction_index (weekcredit, faction);     # 添加索引
    alter table name add column accountid(列名)  int(11) NOT NULL(字段不为空);          # 插入字段
    update host set monitor_state='Y',hostname='xuesong' where ip='192.168.1.1';     # 更新数据

    自增表{

        create table xuesong  (id INTEGER  PRIMARY KEY AUTO_INCREMENT, name CHAR(30) NOT NULL, age integer , sex CHAR(15) );  # 创建自增表
        insert into xuesong(name,age,sex) values(%s,%s,%s)  # 自增插入数据

    }

    登录mysql的命令{

        # 格式： mysql -h 主机地址 -u 用户名 -p 用户密码
        mysql -h110.110.110.110 -P3306 -uroot -p
        mysql -uroot -p -S /data1/mysql5/data/mysql.sock -A  --default-character-set=GBK

    }

    shell执行mysql命令{

        mysql -u root -p'123' xuesong < file.sql   # 针对指定库执行sql文件中的语句,好处不需要转义特殊符号,一条语句可以换行.不指定库执行时语句中需要先use
        mysql -u$username -p$passwd -h$dbhost -P$dbport -A -e "
        use $dbname;
        delete from data where date=('$date1');
        "    # 执行多条mysql命令
        mysql -uroot -p -S mysql.sock -e "use db;alter table gift add column accountid  int(11) NOT NULL;flush privileges;"    # 不登陆mysql插入字段

    }

    备份数据库{

        mysqldump -h host -u root -p --default-character-set=utf8 dbname >dbname_backup.sql               # 不包括库名，还原需先创建库，在use
        mysqldump -h host -u root -p --database --default-character-set=utf8 dbname >dbname_backup.sql    # 包括库名，还原不需要创建库
        /bin/mysqlhotcopy -u root -p    # mysqlhotcopy只能备份MyISAM引擎
        mysqldump -u root -p -S mysql.sock --default-character-set=utf8 dbname table1 table2  > /data/db.sql    # 备份表
        mysqldump -uroot -p123  -d database > database.sql    # 备份数据库结构

        # 最小权限备份
        grant select on db_name.* to dbbackup@"localhost" Identified by "passwd";
        # --single-transaction  InnoDB有时间戳 只备份开始那一刻的数据,备份过程中的数据不会备份
        mysqldump -hlocalhost -P 3306 -u dbbackup --single-transaction  -p"passwd" --database dbname >dbname.sql

        # xtrabackup备份需单独安装软件 优点: 速度快,压力小,可直接恢复主从复制
        innobackupex --user=root --password="" --defaults-file=/data/mysql5/data/my_3306.cnf --socket=/data/mysql5/data/mysql.sock --slave-info --stream=tar --tmpdir=/data/dbbackup/temp /data/dbbackup/ 2>/data/dbbackup/dbbackup.log | gzip 1>/data/dbbackup/db50.tar.gz

    }

    还原数据库{

        mysql -h host -u root -p dbname < dbname_backup.sql
        source 路径.sql   # 登陆mysql后还原sql文件

    }

    赋权限{

        # 指定IP: $IP  本机: localhost   所有IP地址: %   # 通常指定多条
        grant all on zabbix.* to user@"$IP";             # 对现有账号赋予权限
        grant select on database.* to user@"%" Identified by "passwd";     # 赋予查询权限(没有用户，直接创建)
        grant all privileges on database.* to user@"$IP" identified by 'passwd';         # 赋予指定IP指定用户所有权限(不允许对当前库给其他用户赋权限)
        grant all privileges on database.* to user@"localhost" identified by 'passwd' with grant option;   # 赋予本机指定用户所有权限(允许对当前库给其他用户赋权限)
        grant select, insert, update, delete on database.* to user@'ip'identified by "passwd";   # 开放管理操作指令
        revoke all on *.* from user@localhost;     # 回收权限
        GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER, EXECUTE, CREATE ROUTINE, ALTER ROUTINE ON `storemisc_dev`.* TO 'user'@'192.168.%'

    }

    更改密码{

        update user set password=password('passwd') where user='root'
        mysqladmin -u root password 'xuesong'

    }

    mysql忘记密码后重置{

        cd /data/mysql5
        /data/mysql5/bin/mysqld_safe --user=mysql --skip-grant-tables --skip-networking &
        use mysql;
        update user set password=password('123123') where user='root';

    }

    mysql主从复制失败恢复{

        slave stop;
        reset slave;
        change master to master_host='10.10.10.110',master_port=3306,master_user='repl',master_password='repl',master_log_file='master-bin.000010',master_log_pos=107,master_connect_retry=60;
        slave start;

    }

    sql语句使用变量{

        use xuesong;
        set @a=concat('my',weekday(curdate()));    # 组合时间变量
        set @sql := concat('CREATE TABLE IF NOT EXISTS ',@a,'( id INT(11) NOT NULL )');   # 组合sql语句
        select @sql;                    # 查看语句
        prepare create_tb from @sql;    # 准备
        execute create_tb;              # 执行

    }

    检测mysql主从复制延迟{

        1、在从库定时执行更新主库中的一个timeout数值
        2、同时取出从库中的timeout值对比判断从库与主库的延迟

    }

    mysql慢查询{

        select * from information_schema.processlist where command in ('Query') and time >5\G      # 查询操作大于5S的进程

        开启慢查询日志{

            # 配置文件 /etc/my.conf
            [mysqld]
            log-slow-queries=/var/lib/mysql/slowquery.log         # 指定日志文件存放位置，可以为空，系统会给一个缺省的文件host_name-slow.log
            long_query_time=5                                     # 记录超过的时间，默认为10s
            log-queries-not-using-indexes                         # log下来没有使用索引的query,可以根据情况决定是否开启  可不加
            log-long-format                                       # 如果设置了，所有没有使用索引的查询也将被记录    可不加
            # 直接修改生效
            show variables like "%slow%";                         # 查看慢查询状态
            set global slow_query_log='ON';                       # 开启慢查询日志 变量可能不同，看上句查询出来的变量

        }

        mysqldumpslow慢查询日志查看{

            -s  # 是order的顺序，包括看了代码，主要有 c,t,l,r和ac,at,al,ar，分别是按照query次数，时间，lock的时间和返回的记录数来排序，前面加了a的时倒序
            -t  # 是top n的意思，即为返回前面多少条的数据
            -g  # 后边可以写一个正则匹配模式，大小写不敏感的

            mysqldumpslow -s c -t 20 host-slow.log                # 访问次数最多的20个sql语句
            mysqldumpslow -s r -t 20 host-slow.log                # 返回记录集最多的20个sql
            mysqldumpslow -t 10 -s t -g "left join" host-slow.log # 按照时间返回前10条里面含有左连接的sql语句

            show global status like '%slow%';                     # 查看现在这个session有多少个慢查询
            show variables like '%slow%';                         # 查看慢查询日志是否开启，如果slow_query_log和log_slow_queries显示为on，说明服务器的慢查询日志已经开启
            show variables like '%long%';                         # 查看超时阀值
            desc select * from wei where text='xishizhaohua'\G;   # 扫描整张表 tepe:ALL  没有使用索引 key:NULL
            create index text_index on wei(text);                 # 创建索引

        }

    }

    mysql操作次数查询{

        select * from information_schema.global_status;

        com_select
        com_delete
        com_insert
        com_update

    }

}
