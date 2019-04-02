研发沟通：
全量index未做过滤处理
增量,create table里面得索引被当作create table操作
-------------------------------表---------------------------------------
--删表
drop table dds_char
/
--建表
create table dds_char (
    no           int primary key,
    c_char       char,
    c_char5      char(5),
    c_charbyte   char( 2 byte ),
    c_charchar   char( 2 char ),
    c_varchar2   varchar2(10),
    c_nvarchar2  nvarchar2(10)
)
/
insert into dds_char values ( 1,'A', '56789','GH','BN', '0123456789', 'INFO' )
/
insert into dds_char values ( 2,'B', '45678','ED','CV', '0123456789', 'INFO' )
/
commit
/
--修改列属性
alter table dds_char modify (c_char varchar2(2)) 
/
--添加列
alter table dds_char add v1 char
/
alter table dds_char add v2 char
/
--删除列
alter table dds_char drop column v2
/
--列重命名
alter table dds_char rename column v1 to v1_11111111
/
--标记不可用列
drop table unu cascade constraints
/
create table unu (a1 int,a2 int,a3 varchar2(10),a4 varchar2(10) not null)
/
alter table unu set unused (a4)
/
alter table unu set unused (a2,a4)
/
--表重命名
alter table dds_char rename to dds_char_11111111;
--清空表
truncate table dds_char_11111111 
/
--列添加comment
drop table comment_cs
/
create table comment_cs(id int,id2 int,id3 int,id4 int)
/
comment on table comment_cs is '~!@#$测试test%^&*()_+'
/
comment on column comment_cs.id1 is '"":{}注释comment?></{}|：“《》？'
/


select table_name||','||column_name||','||data_type||','||data_length from user_tab_columns where table_name = 'DDS_CHAR' order by table_name 
/
-------------------------------分区表----------------------------------
---------------------简单分区表--------------
--添加分区
drop table objects purge
            /
            create table objects ( object_id NUMBER primary key, object_type VARCHAR2(19) )
                   PARTITION BY LIST ( object_type ) (
                       PARTITION type_table VALUES ('TABLE' ) TABLESPACE users,
                       PARTITION type_index VALUES ('INDEX' ) NOLOGGING,
                       PARTITION type_view  VALUES ('VIEW'  ) TABLESPACE system,
                       PARTITION type_other VALUES ('FUNCTION','TRIGGER','PROCEDURE'),
                       PARTITION type_null  VALUES (NULL)
                   )
            /
            ALTER TABLE objects ADD PARTITION type_package VALUES ( 'PACKAGE', 'PACKAGE BODY' ) TABLESPACE system
            /
            INSERT INTO objects VALUES (1,'VIEW')
            /
            INSERT INTO objects VALUES (2,'TABLE')
            /
            INSERT INTO objects VALUES (3,'INDEX')
            /
            commit
            /
--删除分区
drop table objects purge
            /
            create table objects ( object_id NUMBER,
             object_type VARCHAR2(19) )
                   PARTITION BY LIST ( object_type ) (
                       PARTITION type_table VALUES ('TABLE' ) TABLESPACE users,
                       PARTITION type_index VALUES ('INDEX' ) NOLOGGING,
                       PARTITION type_view  VALUES ('VIEW'  ) TABLESPACE system,
                       PARTITION type_other VALUES ('FUNCTION','TRIGGER','PROCEDURE'),
                       PARTITION type_null  VALUES (NULL)
                   )
            /
            alter table objects add constraint PK_L primary key (object_id)
            /
            INSERT INTO objects SELECT object_id, object_type FROM user_objects WHERE object_type IN ( 'TABLE','INDEX' )
            /
            INSERT INTO objects VALUES (1,'VIEW')
            /
            INSERT INTO objects VALUES (2,'TABLE')
            /
            INSERT INTO objects VALUES (3,'INDEX')
            /
            ALTER TABLE objects DROP PARTITION type_table
            /
            alter index PK_L rebuild
            /
            update objects set object_id=object_id+100 where object_type='INDEX'
            /
            COMMIT
            /
--分裂分区
drop table objects purge
            /
            create table objects ( object_id NUMBER, object_type VARCHAR2(19) ) PARTITION BY LIST ( object_type ) (
               partition type_tab_idx VALUES ('TABLE', 'INDEX' ) TABLESPACE users,
               partition type_view    VALUES ('VIEW'           ) TABLESPACE system,
               partition type_other   VALUES ('FUNCTION','TRIGGER','PROCEDURE'),
               partition type_null  VALUES (NULL)
            )
            /
            alter table objects add constraint PK_L primary key (object_id)
            /
            insert into objects values ( 1001, 'TABLE' )
            /
            insert into objects values ( 1003, 'TABLE' )
            /
            insert into objects values ( 1009, 'INDEX' )
            /
            ALTER TABLE objects SPLIT PARTITION type_tab_idx VALUES ('TABLE') INTO (
                  PARTITION type_table TABLESPACE users,
                  PARTITION type_index TABLESPACE system  )
            /
            alter index PK_L rebuild
            /
            update objects set object_id=object_id+10000
            /
            commit
            /
--合并分区
drop table objects purge
            /
            create table objects ( object_id NUMBER, object_type VARCHAR2(19) )
                   PARTITION BY LIST ( object_type ) (
                       PARTITION type_table VALUES ('TABLE' ) TABLESPACE users,
                       PARTITION type_index VALUES ('INDEX' ) NOLOGGING,
                       PARTITION type_view  VALUES ('VIEW'  ) TABLESPACE system,
                       PARTITION type_other VALUES ('FUNCTION','TRIGGER','PROCEDURE'),
                       PARTITION type_null  VALUES (NULL)
                   )
            /
            alter table objects add constraint PK_L primary key (object_id)
            /
            INSERT INTO objects SELECT object_id, object_type FROM user_objects WHERE object_type IN ( 'TABLE','INDEX' )
            /
            INSERT INTO objects VALUES (1,'VIEW')
            /
            INSERT INTO objects VALUES (2,'TABLE')
            /
            INSERT INTO objects VALUES (3,'INDEX')
            /
            commit
            /
            ALTER TABLE objects MERGE PARTITIONS type_table, type_index INTO PARTITION type_tab_ind
            /
            alter index PK_L rebuild
            /
            update objects set object_id=object_id+100 where object_type='INDEX'
            /
            commit
            /
--交换分区
drop table objects purge
            /
            create table objects ( object_id NUMBER, object_type VARCHAR2(19) )
                   PARTITION BY LIST ( object_type ) (
                       PARTITION type_table VALUES ('TABLE' ) TABLESPACE users,
                       PARTITION type_index VALUES ('INDEX' ) NOLOGGING,
                       PARTITION type_view  VALUES ('VIEW'  ) TABLESPACE system,
                       PARTITION type_other VALUES ('FUNCTION','TRIGGER','PROCEDURE'),
                       PARTITION type_null  VALUES (NULL)
                   )
            /
            INSERT INTO objects SELECT object_id, object_type FROM user_objects WHERE object_type IN ( 'TABLE','INDEX' )
            /
            INSERT INTO objects VALUES (1,'VIEW')
            /
            INSERT INTO objects VALUES (2,'TABLE')
            /
            INSERT INTO objects VALUES (3,'INDEX')
            /
			commit
			/
            drop table swap_t purge
            /
            CREATE TABLE swap_t AS SELECT object_id-10000 as object_id, object_type FROM objects WHERE object_type='TABLE'
            /
            ALTER TABLE objects EXCHANGE PARTITION type_table WITH TABLE swap_t
            /
            update objects set object_id=object_id+100 where object_type='TABLE'
            /
            commit
            /
--修改分区
drop table object_type purge
/
create table object_type (obid number,objn number, obtp varchar(20),obsp number )
partition by list( obtp )
subpartition by range (obsp)                    
(partition p1 values ('TABLE')(subpartition p1_sub1 values less than ('3') tablespace users ,
                               subpartition p1_sub2 values less than ('5') tablespace users 
                              ) 
,partition p2 values ('INDEX')(subpartition p2_sub1 values less than ('3'),
                               subpartition p2_sub2 values less than ('5')
                              ) 
,partition p3 values ('SEQUENCE','CLUSTER')
,partition p4 values ('FUNCTION','TRIGGER')                             
)
/
alter table object_type add constraint pk_lr primary key (obid)
/
insert into object_type values (1,2,'TABLE','2')
/
insert into object_type values (2,4,'INDEX','2')
/ 
insert into object_type values (22,25,'TABLE','4')
/
insert into object_type values (24,29,'INDEX','4')
/ 
alter table object_type move SUBPARTITION p1_sub1 tablespace users
/
alter table object_type move SUBPARTITION p1_sub2 tablespace users
/
alter table object_type modify default ATTRIBUTES FOR PARTITION p1 tablespace users
/
alter index pk_lr rebuild
/ 
update object_type set obid=obid+100 where obtp = 'INDEX'
/
commit
/
---------------------复合分区表-------------
--添加子分区
drop table accounts purge
 /
 CREATE TABLE accounts
( id             NUMBER primary key
, account_number NUMBER
, customer_id    NUMBER
, balance        NUMBER
, branch_id      NUMBER
, region         VARCHAR(2)
, status         VARCHAR2(1)
)
PARTITION BY LIST (region)
SUBPARTITION BY LIST (status)
( PARTITION p_northwest VALUES ('OR', 'WA')
  ( SUBPARTITION p_nw_bad VALUES ('B')
  , SUBPARTITION p_nw_average VALUES ('A')
  , SUBPARTITION p_nw_good VALUES ('G')
  )
, PARTITION p_southwest VALUES ('AZ', 'UT', 'NM')
  ( SUBPARTITION p_sw_bad VALUES ('B')
  , SUBPARTITION p_sw_average VALUES ('A')
  , SUBPARTITION p_sw_good VALUES ('G')
  )
, PARTITION p_northeast VALUES ('NY', 'VM', 'NJ')
  ( SUBPARTITION p_ne_bad VALUES ('B')
  , SUBPARTITION p_ne_average VALUES ('A')
  , SUBPARTITION p_ne_good VALUES ('G')
  )
, PARTITION p_southeast VALUES ('FL', 'GA')
  ( SUBPARTITION p_se_bad VALUES ('B')
  , SUBPARTITION p_se_average VALUES ('A')
  , SUBPARTITION p_se_good VALUES ('G')
  )
, PARTITION p_northcentral VALUES ('SD', 'WI')
  ( SUBPARTITION p_nc_bad VALUES ('B')
  , SUBPARTITION p_nc_average VALUES ('A')
  , SUBPARTITION p_nc_good VALUES ('G')
  )
, PARTITION p_southcentral VALUES ('OK', 'TX')
  ( SUBPARTITION p_sc_bad VALUES ('B')
  , SUBPARTITION p_sc_average VALUES ('A')
  , SUBPARTITION p_sc_good VALUES ('G')
  )
)
/
insert into accounts values(1,11,101,1001,10001,'OR','B')
/
insert into accounts values(2,12,102,1002,10002,'UT','B')
/
insert into accounts values(3,13,103,1003,10003,'NY','A')
/
insert into accounts values(4,14,104,1004,10004,'FL','A')
/
insert into accounts values(5,15,105,1005,10005,'SD','G')
/
insert into accounts values(6,16,106,1006,10006,'OK','G')
/
commit
/
alter table accounts modify partition p_southcentral add subpartition p_sc_add values ('J')
/
insert into accounts values(7,17,107,1007,10007,'OK','J')
/
update accounts set customer_id=201708 where id > 3
/
commit
/
--合并子分区
drop table accounts purge
 /
 CREATE TABLE accounts
( id             NUMBER primary key
, account_number NUMBER
, customer_id    NUMBER
, balance        NUMBER
, branch_id      NUMBER
, region         VARCHAR(2)
, status         VARCHAR2(1)
)
PARTITION BY LIST (region)
SUBPARTITION BY LIST (status)
( PARTITION p_northwest VALUES ('OR', 'WA')
  ( SUBPARTITION p_nw_bad VALUES ('B')
  , SUBPARTITION p_nw_average VALUES ('A')
  , SUBPARTITION p_nw_good VALUES ('G')
  )
, PARTITION p_southwest VALUES ('AZ', 'UT', 'NM')
  ( SUBPARTITION p_sw_bad VALUES ('B')
  , SUBPARTITION p_sw_average VALUES ('A')
  , SUBPARTITION p_sw_good VALUES ('G')
  )
, PARTITION p_northeast VALUES ('NY', 'VM', 'NJ')
  ( SUBPARTITION p_ne_bad VALUES ('B')
  , SUBPARTITION p_ne_average VALUES ('A')
  , SUBPARTITION p_ne_good VALUES ('G')
  )
, PARTITION p_southeast VALUES ('FL', 'GA')
  ( SUBPARTITION p_se_bad VALUES ('B')
  , SUBPARTITION p_se_average VALUES ('A')
  , SUBPARTITION p_se_good VALUES ('G')
  )
, PARTITION p_northcentral VALUES ('SD', 'WI')
  ( SUBPARTITION p_nc_bad VALUES ('B')
  , SUBPARTITION p_nc_average VALUES ('A')
  , SUBPARTITION p_nc_good VALUES ('G')
  )
, PARTITION p_southcentral VALUES ('OK', 'TX')
  ( SUBPARTITION p_sc_bad VALUES ('B')
  , SUBPARTITION p_sc_average VALUES ('A')
  , SUBPARTITION p_sc_good VALUES ('G')
  )
)
/
alter table accounts merge subpartitions p_sc_bad,p_sc_average into subpartition p_notgood
/
insert into accounts values(1,11,101,1001,10001,'OR','B')
/
insert into accounts values(2,12,102,1002,10002,'UT','B')
/
insert into accounts values(3,13,103,1003,10003,'NY','A')
/
insert into accounts values(4,14,104,1004,10004,'FL','A')
/
insert into accounts values(5,15,105,1005,10005,'SD','G')
/
insert into accounts values(6,16,106,1006,10006,'OK','G')
/
insert into accounts values(7,17,107,1007,10007,'TX','B')
/
commit
/
--分裂子分区

alter table accounts split subpartition p_notgood values ('B') into ( subpartition p_sc_bad , subpartition p_sc_average )
/
update accounts set customer_id=201708 where id > 3
/
commit
/

--交换子分区
drop table accounts purge
/
drop table swap_t purge
/
 CREATE TABLE accounts
( id             NUMBER 
, account_number NUMBER
, customer_id    NUMBER
, balance        NUMBER
, branch_id      NUMBER
, region         VARCHAR(2)
, status         VARCHAR2(1)
)
PARTITION BY LIST (region)
SUBPARTITION BY LIST (status)
( PARTITION p_northwest VALUES ('OR', 'WA')
  ( SUBPARTITION p_nw_bad VALUES ('B')
  , SUBPARTITION p_nw_average VALUES ('A')
  , SUBPARTITION p_nw_good VALUES ('G')
  )
, PARTITION p_southwest VALUES ('AZ', 'UT', 'NM')
  ( SUBPARTITION p_sw_bad VALUES ('B')
  , SUBPARTITION p_sw_average VALUES ('A')
  , SUBPARTITION p_sw_good VALUES ('G')
  )
, PARTITION p_northeast VALUES ('NY', 'VM', 'NJ')
  ( SUBPARTITION p_ne_bad VALUES ('B')
  , SUBPARTITION p_ne_average VALUES ('A')
  , SUBPARTITION p_ne_good VALUES ('G')
  )
, PARTITION p_southeast VALUES ('FL', 'GA')
  ( SUBPARTITION p_se_bad VALUES ('B')
  , SUBPARTITION p_se_average VALUES ('A')
  , SUBPARTITION p_se_good VALUES ('G')
  )
, PARTITION p_northcentral VALUES ('SD', 'WI')
  ( SUBPARTITION p_nc_bad VALUES ('B')
  , SUBPARTITION p_nc_average VALUES ('A')
  , SUBPARTITION p_nc_good VALUES ('G')
  )
, PARTITION p_southcentral VALUES ('OK', 'TX')
  ( SUBPARTITION p_sc_bad VALUES ('B')
  , SUBPARTITION p_sc_average VALUES ('A')
  , SUBPARTITION p_sc_good VALUES ('G')
  )
)
/
alter table accounts add constraint pk_ll primary key (id)
/
 CREATE TABLE swap_t
( id             NUMBER 
, account_number NUMBER
, customer_id    NUMBER
, balance        NUMBER
, branch_id      NUMBER
, region         VARCHAR(2)
, status         VARCHAR2(1)
)
/
alter table swap_t add constraint PK_id_s primary key (id)
/
insert into accounts values(1,11,101,1001,10001,'OR','B')
/
insert into accounts values(2,12,102,1002,10002,'OR','B')
/
insert into accounts values(3,13,103,1003,10003,'OK','G')
/
insert into swap_t values(11,11,101,1001,10001,'OR','B')
/
commit
/
alter table accounts exchange subpartition p_nw_bad with table swap_t
/
alter index pk_ll rebuild
/
alter INDEX PK_id_s rebuild
/
update accounts set customer_id=201708 where region = 'OR'
/
commit
/
--修改子分区模板属性
drop table object_type purge
/
create table object_type (obid number primary key,objn number, obtp varchar(20),obsp number )
partition by list( obtp )
subpartition by range (obsp)
subpartition template (subpartition p_sub1 values less than ('3'),
                       subpartition p_sub2 values less than ('5')
                       )                       
(partition p1 values ('TABLE')
,partition p2 values ('INDEX')
,partition p3 values ('SEQUENCE','CLUSTER')
,partition p4 values ('FUNCTION','TRIGGER')                               
)
/
insert into object_type values (1,2,'TABLE','2')
/
insert into object_type values (2,4,'TABLE','4')
/
insert into object_type values (3,2,'INDEX','2')
/
insert into object_type values (4,4,'INDEX','4')
/
insert into object_type values (5,2,'SEQUENCE','2')
/
commit
/
alter table object_type set subpartition template(
                                                    subpartition p_sub1 values less than ('2'),
                                                    subpartition p_sub2 values less than ('4'),
                                                    subpartition p_sub3 values less than ('6')
                                                  )                                                       
/
alter table object_type add partition P5 values ('PROCEDURE')
/
insert into object_type values (6,4,'PROCEDURE','4')
/
update object_type set objn=objn+100 where obid>2
/
commit
/
-------------------------------索引------------------------------------
drop table dds_table_test
            /
            create table dds_table_test (a1 number(9,3) not null,a2 varchar2(20),a3 date,a4 int,a5 varchar2(30))
                pctfree 10 initrans 8 maxtrans 255
                storage ( initial 10M minextents 1 maxextents unlimited )
            /
            create index test_a1_idx on dds_table_test(a1)
            tablespace users
            pctfree 10
            initrans 10
            maxtrans 255
            storage
            (
              initial 10M
              minextents 1
              maxextents unlimited
            )
            /
			
select index_name||pct_free||ini_trans||max_trans||initial_extent||min_extents||max_extents from user_indexes where index_name='TEST_A1_IDX'   
            /
-------------------------------自定义类型-------------------------------
create or replace type lobtype2 as object(
f1 number,
f2 varchar2(30),
f3 clob
)
/
drop table udtlob1 purge
/
create table udtlob1(f1 number primary key, f2 lobtype2)
/

begin 
for i in 1..4000
loop
insert into udtlob1 values (i, lobtype2(i, 'aaa', 'bbbbb'));
end loop;
commit;
end;
/

update udtlob1 set f2=lobtype1(2,'cccc','dddd')
/
commit
/

delete from udtlob1 where rownum < 1000
/
commit
/
------------------------------视图-----------------------------------------------------------------
drop view dds_view_test
            /
            drop table dds_t1 purge
            /
            create table dds_t1 (
            a1 number(9,3) not null,
            a2 varchar2(20),
            a3 date,
            a4 int,
            a5 varchar2(30)
            )
            /
            insert into dds_t1 values (
            '1','qwer','','123','asdf'
            )
            /
			commit
			/
            create view dds_view_test 
            as 
            SELECT * from dds_t1
            /
------------------------------同义词---------------------------------------------------------------
drop table dds_table_test1 purge
             /
             create table dds_table_test1(
                    a1 number(9,3) not null,
                    a2 varchar2(20),
                    a3 date,a4 int,a5 varchar2(30))
             /
             create synonym dtt1 for dds_table_test1
             /
------------------------------约束------------------------------------------------------------------
drop table emp01 purge;
CREATE TABLE emp01(
eno INT NOT NULL,
name VARCHAR2(10) CONSTRAINT nn_name2 NOT NULL,
salary NUMBER(6,2)
)
/

alter table emp01 add constraint uniq unique(eno,name)
/
alter table emp01 drop constraint uniq
/
select constraint_name,table_name from user_constraints where owner='HUAN1'
/

------------------------------角色------------------------------------------------------------------
--role
create role test;
grant create view to test;
grant create table to test;
grant create procedure to test;
grant create sequence to test;

drop role test;
alter role test identified by 12345;

select * from dba_roles

--user
create user huan5 identified by 12345;
grant session to huan2;

------------------------------授权------------------------------------------------------------------
--前提：huan2是同步用户
grant create view to huan2;
--查询当前用户的权限
select * from user_sys_privs;


------------------------------物化视图--------------------------------------------------------------
drop table mv_t_test1
/

drop materialized view mv_v_test1
/

create table mv_t_test1 (no int primary key,name varchar2(10))
/
insert into mv_t_test1 values ('1','info2soft')
/
commit
/

CREATE MATERIALIZED VIEW LOG ON  mv_t_test1
WITH PRIMARY KEY
INCLUDING NEW VALUES
/

CREATE MATERIALIZED VIEW mv_v_test1 
BUILD IMMEDIATE  
REFRESH FAST WITH PRIMARY KEY  
ON DEMAND  
ENABLE QUERY REWRITE  
AS  
SELECT no,name FROM  mv_t_test1
/
select owner||','||mview_name||','||rewrite_enabled||','||refresh_mode||','||refresh_method||','||build_mode  from user_mviews
/
------------------------------JAVA-------------------------------------------------------------------
select * from dba_directories;
create directory java_dir as '/opt/'
/

create java resource named "Hello" using bfile(java_dir,'Hello.java')
/

create java class using BFILE(java_dir,'Hello.class')
/

CREATE JAVA SOURCE NAMED "Welcome" AS
   public class Welcome {
      public static String welcome() {
         return "Welcome World";   } }
/
 drop  java source sayhi
 /
 create or replace and compile java source named sayhi
AS
public class sayhello
{
 public static void msg(String name)
 {
  System.out.println("hello,"+name);
 }
}
/
select object_name,status from user_objects where object_type='JAVA SOURCE'
/
select object_name,status from user_objects where object_type='JAVA CLASS'
/
select object_name,status from user_objects where object_type='JAVA RESOURCE'
/
------------------------------profile----------------------------------------------------------------
create profile p1 limit FAILED_LOGIN_ATTEMPTS 2;
drop profile p1;
alter profile p1 limit FAILED_LOGIN_ATTEMPTS 10;
------------------------------存储过程----------------------
--function
drop function fun_test
			/
            create or replace function fun_test
            return varchar2
            as
            begin
                 return 'hello world';
            end;
            /
			
--package
drop table pk_test_tab purge
            /
			drop package dds_pack_test
			/
            create table pk_test_tab (
                   a1 number(9,3) not null,
                   a2 varchar2(20),
                   a3 date,
                   a4 int,
                   a5 varchar2(30) )
            /
            create package dds_pack_test
            as
            procedure pk_proc;
            end dds_pack_test;
            /
            create package body dds_pack_test
            as
              procedure pk_proc
              as
              begin
                    insert into pk_test_tab values(100,'an',sysdate,11,'ann');
					commit;
              end pk_proc;
            end dds_pack_test;
            /
--trigger
drop trigger trigger_user1
		  /
		  drop table usertr purge
          /
          create table usertr ( id int, name varchar2(20) )
          /
          create trigger trigger_user1 before insert  on usertr
          begin 
               if user not in ('sys') then 
               Raise_application_error(-20001,'You can not access to modify this table.'); 
               end if; 
          end;
          /
--procedure
drop table proc_tab purge
            /
			drop procedure dds_proc_test
			/
            create table proc_tab (a1 number(9,3) not null,a2 varchar2(20),a3 date,a4 int,a5 varchar2(30))
            /
            create or replace procedure dds_proc_test
            is
            begin
                 insert into proc_tab values(100,'an',sysdate,11,'ann');
                 commit;
            end dds_proc_test;
            /
--type

CREATE TYPE growth_index AS OBJECT (
        age		int,
        height_cm	number,
        weight_kg	number,
        MEMBER FUNCTION
        ratio(i int)	RETURN NUMBER)
    /
CREATE OR REPLACE TYPE BODY growth_index AS
        MEMBER FUNCTION ratio(i int) return number is
          begin
             IF i<12 THEN
            return height_cm/weight_kg - age;
             ELSE
            return (height_cm-105)/weight_kg;
             END IF;
          end;
        END;
    /
-------------------------------dblink--------------------------------------
drop database link dblink1
/
create database link dblink1 using 'ORCL'
/
select owner,object_name from dba_objects where object_type='DATABASE LINK'
/
-------------------------------队列----------------------------------------
CREATE OR REPLACE Type mt_struc As Object
( id number(5) ,
? name varchar2(30),
? age varchar2(30)
) ;
begin
? ?sys.dbms_aqadm.create_queue_table(queue_table=>'sms_mt_tab', queue_payload_type=>'mt_struc');
end ;
--删除queue table

begin
   sys.dbms_aqadm.drop_queue_table(queue_table=>'sms_mt_tab');
end ;

-------------------------------表空间--------------------------------------
create tablespace cuihhh datafile '/opt/oracle/oradata/orcl/cuihhh.dbf' size 10m;

set line 1000

SELECT tablespace_name, 
file_id, 
file_name, 
round(bytes / (1024 * 1024), 0) total_space 
FROM dba_data_files 
ORDER BY tablespace_name; 