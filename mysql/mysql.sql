-- 新项目模板只需替换root和dba账号密码即可

-- 更新root密码 默认123456
update mysql.user set password='*6BB4837EB74329105EE4568DDA7DC67ED2CA2AD9' where user='root' and host='127.0.0.1';
update mysql.user set password='*6BB4837EB74329105EE4568DDA7DC67ED2CA2AD9' where user='root' and host='localhost';

-- 更新dba密码 默认123456
GRANT ALL PRIVILEGES ON *.* TO 'dba'@'%' IDENTIFIED BY PASSWORD '*6BB4837EB74329105EE4568DDA7DC67ED2CA2AD9' WITH GRANT OPTION;

-- 添加默认账号 获取密文方式 mysql> SELECT PASSWORD('123456');  
GRANT ALL PRIVILEGES ON *.* TO 'dba_agent'@'%' IDENTIFIED BY PASSWORD '*6BB4837EB74329105EE4568DDA7DC67ED2CA2AD9' WITH GRANT OPTION;
GRANT SELECT, RELOAD, FILE, LOCK TABLES, REPLICATION CLIENT ON *.* TO 'dump'@'localhost' IDENTIFIED BY PASSWORD '*6BB4837EB74329105EE4568DDA7DC67ED2CA2AD9';
GRANT SELECT, RELOAD, SHUTDOWN, PROCESS, FILE, LOCK TABLES, REPLICATION CLIENT ON *.* TO 'readonly'@'%' IDENTIFIED BY PASSWORD '*6BB4837EB74329105EE4568DDA7DC67ED2CA2AD9';
GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%' IDENTIFIED BY PASSWORD '*6BB4837EB74329105EE4568DDA7DC67ED2CA2AD9';

-- 数据库分库分表
grant SELECT on dbproxy.* to 'dbproxy'@'%' identified by password '*6BB4837EB74329105EE4568DDA7DC67ED2CA2AD9';
grant SELECT on dbproxymgr.* to 'dbproxy'@'%' identified by password '*6BB4837EB74329105EE4568DDA7DC67ED2CA2AD9';

-- 应用授权
-- GRANT SELECT, UPDATE, INSERT, DELETE ON loveworld.* TO 'loveworld'@'%' IDENTIFIED BY PASSWORD '*6BB4837EB74329105EE4568DDA7DC67ED2CA2AD9';

delete from mysql.user where user = '';
delete from mysql.user where password = '';
flush privileges;

-- 应用授权案例
-- grant all privileges on app_db.* to 'xxx'@'10.0.%' identified by password '*6BB4837EB74329105EE4568DDA7DC67ED2CA2AD9';
-- flush privileges;

-- 删除非root用户但是保留空用户
-- delete from mysql.user where user<>'root' and char_length(user)>0;  
