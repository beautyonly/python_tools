- mysql 查询出某字段的值不为空的语句
``` sql
-- 不为空
select * from table where id <> "";
select * from table where id != "";

-- 为空
select * from table where id ="";
select * from table where isNull(id);

-- 具体情况具体分析，如果字段是char或者varchar类型的，使用id=""可以的，如果字段是int类型的，使用isNull会好些。
-- 案例
select count(*) from coupons_register20180315 where updated_at <> "";     -- 使用激活码数量
select * from coupons_register20180315 where updated_at <> "";            -- 保存即可
```
