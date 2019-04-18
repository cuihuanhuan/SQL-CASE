--根据交易记录的序号分区建表：
create table dinya_test  
(  
       transaction_id number primary key,  
       item_id number(8) not null,  
       item_description varchar2(300),  
       transaction_date date not null  
)  
partition by range (transaction_id)  
(  
       partition part_01 values less than(2) tablespace users,-----2条以下的交易在此分区上：part_01  
       partition part_02 values less than(3) tablespace users,-----等于+大于2而小于3的交易在此分区：part_02  
       partition part_03 values less than(maxvalue) tablespace system----大于3的交易在此分区：part_03  
)
/
--根据交易日期分区建表
create table dinya_test  
(  
       transaction_id number primary key,  
       item_id number(8) not null,  
       item_description varchar2(300),  
       transaction_date date not null    
 )  
partition by range (transaction_date)  
(  
       partition part_01 values less than(to_date('2006-01-01','yyyy-mm-dd')) tablespace dinya_space01,  
       partition part_02 values less than(to_date('2010-01-01','yyyy-mm-dd')) tablespace dinya_space02,  
       partition part_03 values less than(maxvalue) tablespace dinya_space03  
 )
/
--多列组合分区
drop table mul_col_range purge;
create table mul_col_range(
city_id number(2),
month_number number(2),
createdate date)
partition by range (city_id,month_number,createdate)(
partition p1 values less than (11, 9,to_date('20151001','yyyymmdd')),
partition p2 values less than (12,10,to_date('20151101','yyyymmdd')),
partition p3 values less than (13,11,to_date('20151201','yyyymmdd'))
)
/
insert into mul_col_range values (10,9,to_date('20150901','yyyymmdd'));
insert into mul_col_range values (10,9,to_date('20151001','yyyymmdd'));
insert into mul_col_range values (10,9,to_date('20151101','yyyymmdd'));
insert into mul_col_range values (10,10,to_date('20150901','yyyymmdd'));
insert into mul_col_range values (10,10,to_date('20151001','yyyymmdd'));
insert into mul_col_range values (10,10,to_date('20151101','yyyymmdd'));
commit;
--三列组合分区只要第一个列的值小与分区的界限时候，无论后面两个分区列的值是什么，这条记录都会落到p1中。
insert into mul_col_range values (11,8,to_date('20150901','yyyymmdd'));
insert into mul_col_range values (11,8,to_date('20151001','yyyymmdd'));
insert into mul_col_range values (11,8,to_date('20151101','yyyymmdd'));
insert into mul_col_range values (11,9,to_date('20150901','yyyymmdd'));
insert into mul_col_range values (11,9,to_date('20151001','yyyymmdd'));
insert into mul_col_range values (11,10,to_date('20150901','yyyymmdd'));
insert into mul_col_range values (11,10,to_date('20151101','yyyymmdd'));
commit;
--如果三列组合分区第一个列的值等于分区的界限时候，那么数据库会判断分区的第二列的值。
--如果第二列值小于分区界限则直接忽略第三列，将记录放到p1分区。
--如果第二列值大于分区界限则忽略第三列，则记录直接放到p2分区。
--如果第二列值等于分区界限值，则判断第三列，如果第三列值小于分区界限值则放到p1，如果第三列大于等于分区界限值则记录放到p2


insert into mul_col_range values (12,9,to_date('20151001','yyyymmdd'));
insert into mul_col_range values (12,12,to_date('20151001','yyyymmdd'));
commit;
--如果三列组合分区第一个列city_id的值大于分区的界限时候，则比较第一列city_id的值与下一个分区界限p2分区的分区界限比较，

--如果小于p2分区第一列的分区界限，则直接落入p2分区，如果等于p2分区第一列city_id分区界限，则判断第二列month_number的值与分区界限的比较，

--如果第二列month_number值小于分区界限，则落入p2，如果等于则判断第三列createdate

--总结
--对于多列组合的分区关键词的分区方式，首先判断第一个分区关键词，如果第一个分区关键词的值小于分区界限值，则直接落入当前分区，

--如果恰巧等于分区界限值，则判断第二个分区关键词，如果第二个分区关键词小于分区界限值，则落入当前分区，如果也恰巧等于分区关键词则继续判断第三个分区关键词，

--以此类推，直到最后一个分区关键词，如果最后一个分区关键词不是小于分区界限则直接落入下一个分区中。

CREATE TABLE mul_col_range2
   (    "REGION" NUMBER(5,0) NOT NULL ENABLE,
        "RECDATE" DATE
   ) 
  PARTITION BY RANGE ("REGION","RECDATE")(
 PARTITION "P_536_201604"  VALUES LESS THAN (530, TO_DATE(' 2016-05-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')),
 PARTITION "P_536_201605"  VALUES LESS THAN (530, TO_DATE(' 2016-06-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')),
 PARTITION "P_536_201606"  VALUES LESS THAN (530, TO_DATE(' 2016-07-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))
)
/
CREATE TABLE sales_demo (
   year          NUMBER, 
   month         NUMBER,
   day           NUMBER,
   amount_sold   NUMBER) 
PARTITION BY RANGE (year,month) (
   PARTITION before2001 VALUES LESS THAN (2001,1),
   PARTITION q1_2001    VALUES LESS THAN (2001,4),
   PARTITION q2_2001    VALUES LESS THAN (2001,7),
   PARTITION q3_2001    VALUES LESS THAN (2001,10),
   PARTITION q4_2001    VALUES LESS THAN (2002,1),
   PARTITION future     VALUES LESS THAN (MAXVALUE,0)
)
/
INSERT INTO  sales_demo values(null,10,10,10);
INSERT INTO  sales_demo values(null,3,10,10);
INSERT INTO  sales_demo values(2001,null,10,10);
INSERT INTO sales_demo VALUES(2000,12,12, 1000);   
INSERT INTO sales_demo VALUES(2001,3,17, 2000);    
INSERT INTO sales_demo VALUES(2001,11,1, 5000);    
INSERT INTO sales_demo VALUES(2002,1,1, 4000);    
commit;
CREATE TABLE supplier_parts (
   supplier_id      NUMBER, 
   partnum          NUMBER,
   price            NUMBER)
PARTITION BY RANGE (supplier_id, partnum)
  (PARTITION p1 VALUES LESS THAN  (10,100),
   PARTITION p2 VALUES LESS THAN (10,200),
   PARTITION p3 VALUES LESS THAN (MAXVALUE,MAXVALUE))
/


INSERT INTO supplier_parts VALUES (5,5, 1000);
INSERT INTO supplier_parts VALUES (5,150, 1000);
INSERT INTO supplier_parts VALUES (10,100, 1000);
commit;