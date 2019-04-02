 case 1 "IOT：建立" 0
  src_sql:
      drop table T1
      /
      CREATE TABLE T1
   		(a NUMBER(18,0) PRIMARY KEY,
  		 b int NOT NULL ,
  		 c varchar2(18)
		) ORGANIZATION INDEX
    /
  tgt_sql:
    select COLUMN_NAME,DATA_TYPE from user_tab_cols where table_name='T1' 
    /    

 case 2 "IOT：INSERT" 0
    src_sql:
    drop table T2
    /
    CREATE TABLE T2
   		(a NUMBER(18,0) PRIMARY KEY,
       b int NOT NULL, 
       c varchar2(18)
		) ORGANIZATION INDEX
    /
    INSERT INTO "T2"("A", "B", "C") VALUES ('11', '11', '一a')
    /
    INSERT INTO "T2"("A", "B", "C") VALUES ('22', '22', '二b')
    /
    commit
    /
    tgt_sql:
    select * from T2  order by A
    /

 case 3 "IOT(主键字段在一般字段后面)：建立" 0
	src_sql:
    drop table T3
    /
    CREATE TABLE T3(
   		a NUMBER(18,0),
  		b int PRIMARY KEY, 
  		c varchar2(18)
		) ORGANIZATION INDEX
    /
    tgt_sql:
    select COLUMN_NAME,DATA_TYPE from user_tab_cols where table_name='T3' 
    /


 case 4 "IOT(主键字段在一般字段后面)：INSERT" 0
    src_sql:
      drop table T4
      /
      CREATE TABLE T4
   		(a NUMBER(18,0),
  		 b int PRIMARY KEY, 
  		 c varchar2(18)
		) ORGANIZATION INDEX
    /
    INSERT INTO "T4"("A", "B", "C") VALUES ('11', '11', '一a')
    /
    INSERT INTO "T4"("A", "B", "C") VALUES ('22', '22', '二b')
    /
   
    commit
    /
    tgt_sql:
    select * from T4  order by A
    /

 case 5 "IOT(分区表)：建立" 0
 src_sql:
    drop table T5
    /
    CREATE TABLE T5
    ( A          number(20),
      B          int,
      C          varchar2(20),
    constraint IoT4 primary key (A, B)
    )
    organization index
    PARTITION BY RANGE (B)
    ( 
    PARTITION part_1 VALUES LESS THAN (1),
    PARTITION part_2 VALUES LESS THAN (2),
    PARTITION part_3 VALUES LESS THAN (3)
    )
    /
  tgt_sql:
    select COLUMN_NAME,DATA_TYPE from user_tab_cols where table_name='T5' 
    /

 case 6 "IOT(分区表)：INSERT" 0
  src_sql:
      drop table T6
      /
      CREATE TABLE T6
    (  A          number(20),
      B          int,
      C          varchar2(20),
    constraint IoT6 primary key (A, B)
    )
    organization index
    PARTITION BY RANGE (B)
    ( 
    PARTITION part_1 VALUES LESS THAN (1),
    PARTITION part_2 VALUES LESS THAN (2),
    PARTITION part_3 VALUES LESS THAN (3)
    )
    /
  INSERT INTO "T6"("A", "B", "C") VALUES ('1', '1', '一')
  /
  INSERT INTO "T6"("A", "B", "C") VALUES ('2', '2', '二')
  /
  commit
  /
  tgt_sql:
    select * from T6  order by A
    /


 case 7 "IOT(众多字段)：建立" 0
	src_sql:
    drop table T7
    /
    CREATE TABLE T7 
   		(a NUMBER(18,0), 
  		 b int, 
  		 c varchar2(18),
  		 d NUMBER(18,0), 
  		 e int,
  		 f varchar2(18), 
  		 g NUMBER(18,0),
  		 h int,
       i varchar2(18) PRIMARY KEY
   		) ORGANIZATION INDEX
    /
   tgt_sql:
   select COLUMN_NAME,DATA_TYPE from user_tab_cols where table_name='T7' 
    /   

 case 8 "IOT(众多字段)：INSERT" 0
 	src_sql:
    drop table T8
    /
    CREATE TABLE T8 
      (a NUMBER(18,0), 
       b int, 
       c varchar2(18),
       d NUMBER(18,0), 
       e int,
       f varchar2(18), 
       g NUMBER(18,0),
       h int,
       i varchar2(18) PRIMARY KEY
   		) ORGANIZATION INDEX
    /
    INSERT INTO "T8"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES ('11', '11', '一a','11', '11', '一a','11', '11', '一a')
    /
    INSERT INTO "T8"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES ('22', '22', '二b','22', '22', '二b','22', '22', '二b')
    /
    INSERT INTO "T8"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES ('33', '33', '三c','33', '33', '三c','33', '33', '三c')
    /
    commit
    /
   tgt_sql:
    select * from T8  order by A
    /
   
     
 case 9 "IOT(众多字段)：DELETE" 0
    src_sql:
    drop table T9
    /
    CREATE TABLE T9 
   		(a NUMBER(18,0), 
       b int, 
       c varchar2(18),
       d NUMBER(18,0), 
       e int,
       f varchar2(18), 
       g NUMBER(18,0),
       h int,
       i varchar2(18) PRIMARY KEY
   		) ORGANIZATION INDEX
    /
    INSERT INTO "T9"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES ('11', '11', '一a','11', '11', '一a','11', '11', '一a')
    /
    INSERT INTO "T9"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES ('22', '22', '二b','22', '22', '二b','22', '22', '二b')
    /
    INSERT INTO "T9"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES ('33', '33', '三c','33', '33', '三c','33', '33', '三c')
    /
    delete from T9 where A="11"
    /
    delete from T9 where A="11"
    /
    delete from T9 where A="11"
    /
    commit
    /
   tgt_sql:
    select * from T9  order by A
    /


 case 10 "IOT(众多字段)：UPDATE" 0
   src_sql:
    drop table T10
    /
    CREATE TABLE T10 
   		(a NUMBER(18,0), 
       b int, 
       c varchar2(18),
       d NUMBER(18,0), 
       e int,
       f varchar2(18), 
       g NUMBER(18,0),
       h int,
       i varchar2(18) PRIMARY KEY
   		) ORGANIZATION INDEX
    /
    INSERT INTO "T10"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES ('11', '11', '一a','11', '11', '一a','11', '11', '一a')
    /
    INSERT INTO "T10"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES ('22', '22', '二b','22', '22', '二b','22', '22', '二b')
    /
    INSERT INTO "T10"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES ('33', '33', '三c','33', '33', '三c','33', '33', '三c')
    /
    UPDATE "T10" SET "A"="1" WHERE "A" = '11' 
    /
    UPDATE "T10" SET "C"="2b二" WHERE "A" = '22' 
    /
    UPDATE "T10" SET "b"="3" WHERE "A" = '33' 
    /
    commit
    /
   tgt_sql:
    select * from T10  order by A
    /

 case 11 "IOT(众多字段)：UPDATE(2)" 0
    src_sql:
    drop table T11
    /
    CREATE TABLE T11 
   		(a NUMBER(18,0), 
       b int, 
       c varchar2(18),
       d NUMBER(18,0), 
       e int,
       f varchar2(18), 
       g NUMBER(18,0),
       h int,
       i varchar2(18) PRIMARY KEY
   		) ORGANIZATION INDEX
    /
    INSERT INTO "T11"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES ('11', '11', '一a','11', '11', '一a','11', '11', '一a')
    /
    INSERT INTO "T11"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES ('22', '22', '二b','22', '22', '二b','22', '22', '二b')
    /
    INSERT INTO "T11"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES ('33', '33', '三c','33', '33', '三c','33', '33', '三c')
    /
    UPDATE "T11" SET "A"='1', "B"='1' WHERE "A" = '11' ;
    /
    UPDATE "T11" SET "A"='2', "B"='2' WHERE "A" = '22' ;
    /
    UPDATE "T11" SET "A"='3', "B"='3' WHERE "A" = '33' ;
    /
    commit
    /
   tgt_sql:
    select * from T11  order by A
    /


 case 12 "IOT(众多字段)：UPDATE(3)" 0
   src_sql:
    drop table T12
    /
    CREATE TABLE T12 
   		(a NUMBER(18,0), 
       b int, 
       c varchar2(18),
       d NUMBER(18,0), 
       e int,
       f varchar2(18), 
       g NUMBER(18,0),
       h int,
       i varchar2(18) PRIMARY KEY
   		) ORGANIZATION INDEX
    /
   INSERT INTO "T12"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES ('11', '11', '一a','11', '11', '一a','11', '11', '一a')
   /
   INSERT INTO "T12"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES ('22', '22', '二b','22', '22', '二b','22', '22', '二b')
   /
   INSERT INTO "T12"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES ('33', '33', '三c','33', '33', '三c','33', '33', '三c')
   /
   UPDATE "T12" SET "A"='1', "B"='1' , "C"='1' WHERE "A" = '11' 
   /
   UPDATE "T12" SET "A"='2', "B"='2' , "C"='2' WHERE "A" = '22' 
   /
   UPDATE "T12" SET "A"='3', "B"='3' , "C"='3' WHERE "A" = '33' 
   /
   commit
    /
   tgt_sql:
   select * from T12  order by A
   /
  
      
 case 13 "IOT(众多字段)：UPDATE(4)" 0
 src_sql:
    drop table T13
    /
    CREATE TABLE T13 
   		(a NUMBER(18,0), 
       b int, 
       c varchar2(18),
       d NUMBER(18,0), 
       e int,
       f varchar2(18), 
       g NUMBER(18,0),
       h int,
       i varchar2(18) PRIMARY KEY
   		) ORGANIZATION INDEX
   /
   INSERT INTO "T13"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES ('11', '11', '一a','11', '11', '一a','11', '11', '一a')
   /
   INSERT INTO "T13"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES ('22', '22', '二b','22', '22', '二b','22', '22', '二b')
   /
   INSERT INTO "T13"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES ('33', '33', '三c','33', '33', '三c','33', '33', '三c')
   /
   UPDATE "T13" SET "A"='1', "B"='1' , "C"='1', "D"='1' WHERE "A" = '11' 
   /
   UPDATE "T13" SET "A"='2', "B"='2' , "C"='2', "D"='2' WHERE "A" = '22' 
   /
   UPDATE "T13" SET "A"='3', "B"='3' , "C"='3', "D"='3' WHERE "A" = '33' 
   /
   commit
   /
   tgt_sql:
   select * from T13  order by A
   /
 
      
 case 14 "IOT(众多字段)：UPDATE(5) - 主键不变，其他值也不变" 0
 	src_sql:
    drop table T14
    /
    CREATE TABLE T14
   		(a NUMBER(18,0), 
       b int, 
       c varchar2(18),
       d NUMBER(18,0), 
       e int,
       f varchar2(18), 
       g NUMBER(18,0),
       h int,
       i varchar2(18) PRIMARY KEY
   		) ORGANIZATION INDEX
   /
   INSERT INTO "T14"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES ('11', '11', '一a','11', '11', '一a','11', '11', '一a')
   /
   INSERT INTO "T14"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES ('22', '22', '二b','22', '22', '二b','22', '22', '二b')
   /
   INSERT INTO "T14"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES ('33', '33', '三c','33', '33', '三c','33', '33', '三c')
   /
   UPDATE "T14" SET "A"='11', "B"='11' , "C"='11', "D"='11' WHERE "A" = '11' 
   /
   UPDATE "T14" SET "A"='22', "B"='22' , "C"='22', "D"='22' WHERE "A" = '22' 
   /
   UPDATE "T14" SET "A"='33', "B"='33' , "C"='33', "D"='33' WHERE "A" = '33' 
   /
   commit
    /
   tgt_sql:
   select * from T14  order by A
   /
  
 case 15 "IOT：UPDATE - 值更改为空" 0
    src_sql:
    drop table T15
    /
    CREATE TABLE T15
   		(a NUMBER(18,0), 
       b int, 
       c varchar2(18),
       d NUMBER(18,0), 
       e int,
       f varchar2(18), 
       g NUMBER(18,0),
       h int,
       i varchar2(18) PRIMARY KEY
   		) ORGANIZATION INDEX
   /
   INSERT INTO "T15"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES ('11', '11', '一a','11', '11', '一a','11', '11', '一a')
   /
   INSERT INTO "T15"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES ('22', '22', '二b','22', '22', '二b','22', '22', '二b')
   /
   INSERT INTO "T15"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES ('33', '33', '三c','33', '33', '三c','33', '33', '三c')
   /
   UPDATE "T15" SET "A"=NULL, "B"='11' , "C"='11', "D"='11' WHERE "A" = '11' 
   /
   UPDATE "T15" SET "A"=NULL, "B"='22' , "C"='22', "D"='22' WHERE "A" = '22' 
   /
   UPDATE "T15" SET "A"=NULL, "B"='33' , "C"='33', "D"='33' WHERE "A" = '33' 
   /
   commit
   /
   tgt_sql:
   select * from T15  order by A
   /
 

 case 16 "IOT：UPDATE - 空值操作" 0
   src_sql:
    drop table T16
    /
    CREATE TABLE T16
   		(a NUMBER(18,0), 
       b int, 
       c varchar2(18),
       d NUMBER(18,0), 
       e int,
       f varchar2(18), 
       g NUMBER(18,0),
       h int,
       i varchar2(18) PRIMARY KEY
   		) ORGANIZATION INDEX
  /
   INSERT INTO "T16"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES (NULL, '11', '11','11', '11', '11','11', '11', '11')
   /
   INSERT INTO "T16"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES (NULL, '22', '22','22', '22', '22','22', '22', '22')
   /
   INSERT INTO "T16"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES (NULL, '33', '33','33', '33', '33','33', '33', '33')
   /
   UPDATE "T16" SET "A"='11' WHERE "B" = '11' 
   /
   UPDATE "T16" SET "A"='22' WHERE "B" = '22' 
   /
   UPDATE "T16" SET "A"='33' WHERE "B" = '33' 
   /
   commit
   /
   tgt_sql:  
   select * from T16  order by A
   /


 case 17 "IOT：TRUNCATE" 0
       src_sql:
    drop table T17
    /
    CREATE TABLE T17
   		(a NUMBER(18,0), 
       b int, 
       c varchar2(18),
       d NUMBER(18,0), 
       e int,
       f varchar2(18), 
       g NUMBER(18,0),
       h int,
       i varchar2(18) PRIMARY KEY
   		) ORGANIZATION INDEX
   /
   INSERT INTO "T17"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES (NULL, '11', '11','11', '11', '11','11', '11', '11')
   /
   INSERT INTO "T17"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES (NULL, '22', '22','22', '22', '22','22', '22', '22')
   /
   INSERT INTO "T17"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES (NULL, '33', '33','33', '33', '33','33', '33', '33')
   /
   commit
   /
   trancate T17
   /
   tgt_sql:
   select * from T17  order by A
   /


 case 18 "IOT：大批量INSERT" 0
        src_sql:
    drop table T18
    /
    CREATE TABLE T18
      (a NUMBER(18,0), 
       b int, 
       c varchar2(18),
       d NUMBER(18,0), 
       e int,
       f varchar2(18), 
       g NUMBER(18,0),
       h int,
       i varchar2(18) PRIMARY KEY
      ) ORGANIZATION INDEX
   /
   INSERT INTO "T18"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES (NULL, '11', '11','11', '11', '11','11', '11', '11')
   /
   INSERT INTO "T18"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES (NULL, '22', '22','22', '22', '22','22', '22', '22')
   /
   INSERT INTO "T18"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES (NULL, '33', '33','33', '33', '33','33', '33', '33')
   /
   INSERT INTO "T18"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES (NULL, '111', '111','111', '111', '111','111', '111', '111')
   /
   INSERT INTO "T18"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES (NULL, '222', '222','222', '222', '222','222', '222', '222')
   /
   INSERT INTO "T18"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES (NULL, '333', '333','333', '333', '333','333', '333', '333')
   /
   INSERT INTO "T18"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES (NULL, '1111', '1111','1111', '1111', '1111','1111', '1111', '1111')
   /
   INSERT INTO "T18"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES (NULL, '2222', '2222','2222', '2222', '2222','2222', '2222', '2222')
   /
   INSERT INTO "T18"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES (NULL, '3333', '3333','3333', '3333', '3333','3333', '3333', '3333')
   /
   INSERT INTO "T18"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES (NULL, '11111', '1111','11111', '11111', '11111','11111', '11111', '11111')
   /
   INSERT INTO "T18"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES (NULL, '22222', '22222','22222', '22222', '22222','22222', '22222', '22222')
   /
   INSERT INTO "T18"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES (NULL, '33333', '33333','33333', '33333', '33333','33333', '33333', '33333')
   /
   commit
  /
   tgt_sql:
   select * from T18  order by A
   /


 case 19 "IOT：大批量UPDATE" 0
    src_sql:
    drop table T19
    /
    CREATE TABLE T19
      (a NUMBER(18,0), 
       b int, 
       c varchar2(18),
       d NUMBER(18,0), 
       e int,
       f varchar2(18), 
       g NUMBER(18,0),
       h int,
       i varchar2(18) PRIMARY KEY
      ) ORGANIZATION INDEX
   /
   INSERT INTO "T19"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES (NULL, '11', '11','11', '11', '11','11', '11', '11')
   /
   INSERT INTO "T19"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES (NULL, '22', '22','22', '22', '22','22', '22', '22')
   /
   INSERT INTO "T19"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES (NULL, '33', '33','33', '33', '33','33', '33', '33')
   /
   INSERT INTO "T19"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES (NULL, '111', '111','111', '111', '111','111', '111', '111')
   /
   INSERT INTO "T19"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES (NULL, '222', '222','222', '222', '222','222', '222', '222')
   /
   INSERT INTO "T19"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES (NULL, '333', '333','333', '333', '333','333', '333', '333')
   /
   INSERT INTO "T19"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES (NULL, '1111', '1111','1111', '1111', '1111','1111', '1111', '1111')
   /
   INSERT INTO "T19"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES (NULL, '2222', '2222','2222', '2222', '2222','2222', '2222', '2222')
   /
   INSERT INTO "T19"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES (NULL, '3333', '3333','3333', '3333', '3333','3333', '3333', '3333')
   /
   INSERT INTO "T19"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES (NULL, '11111', '1111','11111', '11111', '11111','11111', '11111', '11111')
   /
   INSERT INTO "T19"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES (NULL, '22222', '22222','22222', '22222', '22222','22222', '22222', '22222')
   /
   INSERT INTO "T19"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES (NULL, '33333', '33333','33333', '33333', '33333','33333', '33333', '33333')
   /
   UPDATE "T19" SET "A"='11' WHERE "B" = '11' 
   /
   UPDATE "T19" SET "A"='22' WHERE "B" = '22' 
   /
   UPDATE "T19" SET "A"='33' WHERE "B" = '33' 
   /
   UPDATE "T19" SET "A"='11' WHERE "B" = '111' 
   /
   UPDATE "T19" SET "A"='22' WHERE "B" = '222' 
   /
   UPDATE "T19" SET "A"='33' WHERE "B" = '333' 
   /
   UPDATE "T19" SET "A"='11' WHERE "B" = '1111' 
   /
   UPDATE "T19" SET "A"='22' WHERE "B" = '2222' 
   /
   UPDATE "T19" SET "A"='33' WHERE "B" = '333' 
   /
   UPDATE "T19" SET "A"='11' WHERE "B" = '11111' 
   /
   UPDATE "T19" SET "A"='22' WHERE "B" = '22222' 
   /
   UPDATE "T19" SET "A"='33' WHERE "B" = '33333' 
   /
   commit
  /
   tgt_sql:
   select * from T19  order by A
   /



 case 20 "IOT：增加字段" 0
    src_sql:
    drop table T20
    /
    CREATE TABLE T20 
      (a NUMBER(18,0), 
       b int, 
       c varchar2(18),
       d NUMBER(18,0), 
       e int,
       f varchar2(18), 
       g NUMBER(18,0),
       h int,
       i varchar2(18) PRIMARY KEY
      ) ORGANIZATION INDEX
   /
   alter table T20 add (j varchar2(30) default '11' not null);
   /
   tgt_sql:
   select * from T20  order by A
   /
   


 case 21 "IOT：大批量UPDATE: 修改增加字段后原来最后一个字段" 0
     src_sql:
    drop table T21
    /
    CREATE TABLE T21
      (a NUMBER(18,0), 
       b int, 
       c varchar2(18),
       d NUMBER(18,0), 
       e int,
       f varchar2(18), 
       g NUMBER(18,0),
       h int,
       i varchar2(18) PRIMARY KEY
      ) ORGANIZATION INDEX
   /
   INSERT INTO "T21"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES (NULL, '11', '11','11', '11', '11','11', '11', '1vcbncfg1')
   /
   INSERT INTO "T21"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES (NULL, '22', '22','22', '22', '22','22', '22', '2fdg2')
   /
   INSERT INTO "T21"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES (NULL, '33', '33','33', '33', '33','33', '33', '345433')
   /
   INSERT INTO "T21"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES (NULL, '111', '111','111', '111', '111','111', '111', '1ew3411')
   /
   INSERT INTO "T21"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES (NULL, '222', '222','222', '222', '222','222', '222', '22fdgh2')
   /
   INSERT INTO "T21"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES (NULL, '333', '333','333', '333', '333','333', '333', '33;lgh3')
   /
   INSERT INTO "T21"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES (NULL, '1111', '1111','1111', '1111', '1111','1111', '1111', '1gh111')
   /
   INSERT INTO "T21"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES (NULL, '2222', '2222','2222', '2222', '2222','2222', '2222', '22gfdhn22')
   /
   INSERT INTO "T21"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES (NULL, '3333', '3333','3333', '3333', '3333','3333', '3333', '33asdf33')
   /
   INSERT INTO "T21"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES (NULL, '11111', '1111','11111', '11111', '11111','11111', '11111', '11sadf111')
   /
   INSERT INTO "T21"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES (NULL, '22222', '22222','22222', '22222', '22222','22222', '22222', '2adsf2222')
   /
   INSERT INTO "T21"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES (NULL, '33333', '33333','33333', '33333', '33333','33333', '33333', '333dfas33')
   /
   alter table T21 add (j varchar2(30) default '11' not null);
   /
   UPDATE "T21" SET "I"='a11' WHERE "B" = '11' 
   /
   UPDATE "T21" SET "I"='b22' WHERE "B" = '22' 
   /
   UPDATE "T21" SET "I"='c33' WHERE "B" = '33' 
   /
   UPDATE "T21" SET "I"='d11' WHERE "B" = '111' 
   /
   UPDATE "T21" SET "I"='e22' WHERE "B" = '222' 
   /
   UPDATE "T21" SET "I"='f33' WHERE "B" = '333' 
   /
   UPDATE "T21" SET "I"='g11' WHERE "B" = '1111' 
   /
   UPDATE "T21" SET "I"='h22' WHERE "B" = '2222' 
   /
   UPDATE "T21" SET "I"='i33' WHERE "B" = '3333' 
   /
   UPDATE "T21" SET "I"='j11' WHERE "B" = '11111' 
   /
   UPDATE "T21" SET "I"='k22' WHERE "B" = '22222' 
   /
   UPDATE "T21" SET "I"='l33' WHERE "B" = '33333' 
   /
   commit
    /
   tgt_sql:
   
   select * from T21  order by A
   /


 case 22 "IOT：大批量UPDATE: 修改增加的字段" 0
 src_sql:
    drop table T22
    /
    CREATE TABLE T22
      (a NUMBER(18,0), 
       b int, 
       c varchar2(18),
       d NUMBER(18,0), 
       e int,
       f varchar2(18), 
       g NUMBER(18,0),
       h int,
       i varchar2(18) PRIMARY KEY
      ) ORGANIZATION INDEX
   /
   INSERT INTO "T22"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES (NULL, '11', '11','11', '11', '11','11', '11', '11')
   /
   INSERT INTO "T22"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES (NULL, '22', '22','22', '22', '22','22', '22', '22')
   /
   INSERT INTO "T22"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES (NULL, '33', '33','33', '33', '33','33', '33', '33')
   /
   INSERT INTO "T22"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES (NULL, '111', '111','111', '111', '111','111', '111', '111')
   /
   INSERT INTO "T22"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES (NULL, '222', '222','222', '222', '222','222', '222', '222')
   /
   INSERT INTO "T22"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES (NULL, '333', '333','333', '333', '333','333', '333', '333')
   /
   INSERT INTO "T22"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES (NULL, '1111', '1111','1111', '1111', '1111','1111', '1111', '1111')
   /
   INSERT INTO "T22"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES (NULL, '2222', '2222','2222', '2222', '2222','2222', '2222', '2222')
   /
   INSERT INTO "T22"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES (NULL, '3333', '3333','3333', '3333', '3333','3333', '3333', '3333')
   /
   INSERT INTO "T22"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES (NULL, '11111', '1111','11111', '11111', '11111','11111', '11111', '11111')
   /
   INSERT INTO "T22"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES (NULL, '22222', '22222','22222', '22222', '22222','22222', '22222', '22222')
   /
   INSERT INTO "T22"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES (NULL, '33333', '33333','33333', '33333', '33333','33333', '33333', '33333')
   /
   alter table T22 add (j varchar2(30) default '11' not null)
   /
   UPDATE "T22" SET "J"='11' WHERE "B" = '11' 
   /
   UPDATE "T22" SET "J"='22' WHERE "B" = '22' 
   /
   UPDATE "T22" SET "J"='33' WHERE "B" = '33' 
   /
   UPDATE "T22" SET "J"='11' WHERE "B" = '111' 
   /
   UPDATE "T22" SET "J"='22' WHERE "B" = '222' 
   /
   UPDATE "T22" SET "J"='33' WHERE "B" = '333' 
   /
   UPDATE "T22" SET "J"='11' WHERE "B" = '1111' 
   /
   UPDATE "T22" SET "J"='22' WHERE "B" = '2222' 
   /
   UPDATE "T22" SET "J"='33' WHERE "B" = '3333' 
   /
   UPDATE "T22" SET "J"='11' WHERE "B" = '11111' 
   /
   UPDATE "T22" SET "J"='22' WHERE "B" = '22222' 
   /
   UPDATE "T22" SET "J"='33' WHERE "B" = '33333' 
   /
   commit
    /
   tgt_sql:
   select * from T22 order by A
   /
  


 case 23 "IOT：大批量UPDATE: 修改增加的字段和其他字段" 0
     src_sql:
    drop table T23
    /
    CREATE TABLE T23
      (a NUMBER(18,0), 
       b int, 
       c varchar2(18),
       d NUMBER(18,0), 
       e int,
       f varchar2(18), 
       g NUMBER(18,0),
       h int,
       i varchar2(18) PRIMARY KEY
      ) ORGANIZATION INDEX
   /
   INSERT INTO "T23"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES (NULL, '11', '11','11', '11', '11','11', '11', '1dfsgs1')
   /
   INSERT INTO "T23"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES (NULL, '22', '22','22', '22', '22','22', '22', '2dfsfg2')
   /
   INSERT INTO "T23"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES (NULL, '33', '33','33', '33', '33','33', '33', '3fsdh3')
   /
   INSERT INTO "T23"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES (NULL, '111', '111','111', '111', '111','111', '111', '1ewrfeqw11')
   /
   INSERT INTO "T23"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES (NULL, '222', '222','222', '222', '222','222', '222', '22sdzfq2')
   /
   INSERT INTO "T23"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES (NULL, '333', '333','333', '333', '333','333', '333', '3ewrq33')
   /
   INSERT INTO "T23"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES (NULL, '1111', '1111','1111', '1111', '1111','1111', '1111', '11jhgf11')
   /
   INSERT INTO "T23"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES (NULL, '2222', '2222','2222', '2222', '2222','2222', '2222', '22qwer22')
   /
   INSERT INTO "T23"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES (NULL, '3333', '3333','3333', '3333', '3333','3333', '3333', '333qwer3')
   /
   INSERT INTO "T23"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES (NULL, '11111', '1111','11111', '11111', '11111','11111', '11111', '111qewr11')
   /
   INSERT INTO "T23"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES (NULL, '22222', '22222','22222', '22222', '22222','22222', '22222', '22ewrq222')
   /
   INSERT INTO "T23"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES (NULL, '33333', '33333','33333', '33333', '33333','33333', '33333', '333dsaf33')
   /
   alter table T23 add (j varchar2(30) default '11' not null)
   /
   UPDATE "T23" SET "J"='11' WHERE "B" = '11' 
   /
   UPDATE "T23" SET "J"='22' WHERE "B" = '22' 
   /
   UPDATE "T23" SET "J"='33' WHERE "B" = '33' 
   /
   UPDATE "T23" SET "J"='11' WHERE "B" = '111' 
   /
   UPDATE "T23" SET "J"='22' WHERE "B" = '222' 
   /
   UPDATE "T23" SET "J"='33' WHERE "B" = '333' 
   /
   UPDATE "T23" SET "J"='11' WHERE "B" = '1111' 
   /
   UPDATE "T23" SET "J"='22' WHERE "B" = '2222' 
   /
   UPDATE "T23" SET "J"='33' WHERE "B" = '3333' 
   /
   UPDATE "T23" SET "J"='11' WHERE "B" = '11111' 
   /
   UPDATE "T23" SET "J"='22' WHERE "B" = '22222' 
   /
   UPDATE "T23" SET "J"='33' WHERE "B" = '33333' 
   /
   commit
    /
   tgt_sql:
   select * from T23 order by A
   /
 
          

 case 24 "IOT：INSERT，极少字段有值" 0
     
    src_sql:
    drop table T24
    /
    CREATE TABLE T24
      (a NUMBER(18,0), 
       b int, 
       c varchar2(18),
       d NUMBER(18,0), 
       e int,
       f varchar2(18), 
       g NUMBER(18,0),
       h int,
       i varchar2(18) PRIMARY KEY
      ) ORGANIZATION INDEX
   /
   INSERT INTO "T24"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES (NULL, NULL, NULL,NULL, NULL, NULL,NULL, NULL, '11')
   /
   INSERT INTO "T24"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES (NULL, NULL, NULL,NULL, NULL, NULL,NULL, NULL, '22')
   /
   INSERT INTO "T24"("A", "B", "C","D", "E", "F","G", "H", "I") VALUES (NULL, NULL, NULL,NULL, NULL, NULL,NULL, NULL,'33')
   /
   commit
    /
   tgt_sql:
   select * from T24  order by A
   /



     


      