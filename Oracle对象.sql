--------------------------------------------索引------------------------------------------
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
select index_name,table_name from user_indexes where TABLE_OWNER='F'
------------------------------------------------视图-----------------------------------------
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
------------------------------------------------函数-----------------------------------------
drop function fun_test
			/
            create or replace function fun_test
            return varchar2
            as
            begin
                 return 'hello world';
            end;
            /
------------------------------------------------存储过程-------------------------------------
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
------------------------------------------------包头包体-------------------------------------
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
            begin dds_pack_test.pk_proc; 
            end;
            /
select object_name,object_type,status from user_objects where object_name in('PK_TEST_TAB','DDS_PACK_TEST') order by object_name,object_type
            /
------------------------------------------------同义词---------------------------------------
drop table dds_table_test1 purge
             /
             create table dds_table_test1(
                    a1 number(9,3) not null,
                    a2 varchar2(20),
                    a3 date,a4 int,a5 varchar2(30))
             /
             create synonym dtt1 for dds_table_test1
             /
------------------------------------------------触发器---------------------------------------
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
------------------------------------------------序列-----------------------------------------
drop sequence dds_test_seq
            /
            drop sequence dds_test_seq2
            /
            create sequence dds_test_seq
                   start with 100
                   minvalue -1000
                   maxvalue 500000
                   cache 5
                   noorder cycle
            /
            create sequence dds_test_seq2
            /
 select cycle_flag||','||order_flag||','||cache_size from user_sequences where sequence_name='DDS_TEST_SEQ'
            /
            select cycle_flag||','||order_flag||','||cache_size from user_sequences where sequence_name='DDS_TEST_SEQ2'
            /
------------------------------------------------java-----------------------------------------
select * from dba_directories;
create directory java_dir as '/u01/'
/

create java resource named "Hello" using bfile(java_dir,'Hello.java')
/
create java resource named "People" using bfile(java_dir,'People.java')
/
create java class using BFILE(java_dir,'Hello.class')
/
create java class using BFILE(java_dir,'People.class')
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
------------------------------------------------类型/类型体----------------------------------
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
select object_name,object_type from user_objects where object_type='TYPE BODY'
/
select type_name from user_types where type_name='GROWTH_INDEX'
/
------------------------------------------------物化视图---------------------------------------
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
-------------------------------------------------dblink----------------------------------------
drop database link dblink1
/
create database link dblink1 using 'ORCL'
/
create database link dblink1
   connect to user1 identified by "12345"
   using 'ORCLbk'
/
select owner,object_name from dba_objects where object_type='DATABASE LINK'
/
-------------------------------------------------job-------------------------------------------

DROP TABLE A8 purge
/
drop procedure proc_add_test
/
create table A8
(
  a1 VARCHAR2(500)
)
/

create or replace procedure proc_add_test as
begin
  insert into a8 values (to_char(sysdate, 'yyyy-mm-dd hh:mi'));/*向测试表插入数据*/
  commit;
end;
/

-- oracle 12c
declare
job number;
begin
sys.dbms_job.submit(job,
                    'proc_add_test;', --job要执行的工作（范例为要执行的存储过程）
                      to_date('23-02-2012', 'dd-mm-yyyy'),
                      'TRUNC(SYSDATE+1)'); --执行job的周期（每天凌晨零点）
  dbms_output.put_line(job);
end;
/

select job,what from user_jobs
/


----------------------------------------------sch job---------------------------------------

drop table sam1 purge
/
drop procedure pc_sam
/
create table sam1 (id int,name varchar2(10),time date)
/
create or replace procedure pc_sam as
begin
insert into sam1 values (1,'sam',sysdate);
commit;
end pc_sam;
/

begin
dbms_scheduler.create_job(
job_name => 'sam_job', --job名
job_type => 'STORED_PROCEDURE', --job类型
job_action => 'pc_sam', --存储过程名
start_date => sysdate, --开始执行时间
repeat_interval => 'FREQ=MINUTELY;INTERVAL=1', --下次执行时间，每5分钟执行存储过程pc_sam
comments => '测试存储过程', --注释
auto_drop => false, --job禁用后是否自动删除
enabled => true);
end;
/


select owner, job_name, state from dba_scheduler_jobs where owner='HUAN1'
/

----------------------------------------------权限---------------------------------------
--前提：huan2是同步用户
grant create view to huan2;
--查询当前用户的权限
select * from user_sys_privs;


----------------------------------------------约束-----------------------------------------
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

