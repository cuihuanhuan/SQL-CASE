--List分区也需要指定列的值，其分区值必须明确指定，该分区列只能有一个，不能像range或者hash分区那样同时指定多个列做为分区依赖列，但它的单个分区对应值可以是多个。
--在分区时必须确定分区列可能存在的值，一旦插入的列值不在分区范围内，则插入/更新就会失败，因此通常建议使用list分区时，要创建一个default分区存储那些不在指定范围内的记录，类似range分区中的maxvalue分区。
--在根据某字段，如城市代码分区时，可以指定default，把非分区规则的数据，全部放到这个default分区。
--Oracle 12.2新特性：多列列表分区和外部表分区
--多列列表分区
CREATE TABLE mul_col_list
(dbalic           NUMBER, 
  username         VARCHAR2(20),
  dbcat            VARCHAR2(4),
  region           VARCHAR2(10)
 )
 PARTITION BY LIST (dbcat, region)
 (
  PARTITION north_part VALUES (('ORCL','BEIJING'), ('ORCL','TIANJIN')),
  PARTITION south_part VALUES (('DB2','SHENZHEN'), ('DB2','GUANGZHOU')),
  PARTITION west_part  VALUES (('SQL','CHENGDU'),('ORCL','CHENGDU'),('DB2','KUNMING')),
  PARTITION east_part  VALUES ('ORCL','SHANGHAI'),
  PARTITION rest VALUES (DEFAULT)
 )
/

insert into  mul_col_list values(1,'EYGLE','ORCL','BEIJING');
insert into  mul_col_list values(2,'KAMUS','ORCL','BEIJING');
insert into  mul_col_list values(3,'LAOXIONG','SQL','CHENGDU');
insert into  mul_col_list values(4,'ORA-600','DB2','GUANGZHOU');
insert into  mul_col_list values(5,'YANGTINGKUN','ALL','BEIJING');
commit;
insert into  mul_col_list values(6,'SECOOLER','ORCL','TIANJIN');
commit;

select * from mul_col_list partition (north_part);
select * from mul_col_list partition (south_part);
select * from mul_col_list partition (west_part);
select * from mul_col_list partition (east_part);
select * from mul_col_list partition (rest);
--为了简化维护操作，12.2 增加了维护过滤特性 - Filtered Partition on Maintenance Operations，
--也就是说，在执行分区的Move、Split和Merge等操作时，可以选择对数据进行过滤，通过一个 INCLUDING ROWS 进行限制。
--当MOVE时指定保留分区中区域为「BEIJING」的数据后，『TIANJIN』的数据则被移除了：
ALTER TABLE mul_col_list MOVE PARTITION north_part INCLUDING ROWS WHERE REGION = 'BEIJING';

--外部表分区
CREATE TABLE sales (loc_id number, prod_id number, cust_id number, amount_sold number, quantity_sold number)

 ORGANIZATION EXTERNAL

 (TYPE oracle_loader

  DEFAULT DIRECTORY load_d1

  ACCESS PARAMETERS

  ( RECORDS DELIMITED BY NEWLINE CHARACTERSET AL32UTF8

    NOBADFILE

    LOGFILE log_dir:'sales.log'

    FIELDS TERMINATED BY ","

   )

 )

  REJECT LIMIT UNLIMITED

 PARTITION BY RANGE (loc_id)

 (PARTITION p1 VALUES LESS THAN (1000) LOCATION ('california.txt'),

  PARTITION p2 VALUES LESS THAN (2000) DEFAULT DIRECTORY load_d2 LOCATION ('washington.txt'),

  PARTITION p3 VALUES LESS THAN (3000))

; 