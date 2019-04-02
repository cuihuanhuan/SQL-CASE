--触发器是一种特殊的存储过程，触发器一般由事件触发并且不能接受参数
--触发器在更新表dds_char之前触发，目的是不允许在周三修改表
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

select to_char(sysdate,'DY') from dual
/

create or replace trigger auth_secure before insert or update or DELETE
on dds_char
begin
  IF(to_char(sysdate,'DY')='WED') THEN
    RAISE_APPLICATION_ERROR(-20600,'can not modify table dds_char on WED');
  END IF;
END;
/

insert into dds_char values ( 1,'A', '56789','GH','BN', '0123456789', 'INFO' )
/
insert into dds_char values ( 2,'B', '45678','ED','CV', '0123456789', 'INFO' )
/
commit
/
--使用触发器实现序号自增
create table tab_user(
  id number(11) primary key,
  username varchar(50),
  password varchar(50)
)
/

create sequence my_seq increment by 1 start with 1 nomaxvalue nocycle cache 20
/

CREATE OR REPLACE TRIGGER MY_TGR
 BEFORE INSERT ON TAB_USER
 FOR EACH ROW--对表的每一行触发器执行一次
DECLARE
 NEXT_ID NUMBER;
BEGIN
 SELECT MY_SEQ.NEXTVAL INTO NEXT_ID FROM DUAL;
 :NEW.ID := NEXT_ID; --:NEW表示新插入的那条记录
END;
/

insert into tab_user(username,password) values('admin','admin')
/
insert into tab_user(username,password) values('fgz','fgz')
/
insert into tab_user(username,password) values('test','test')
/
COMMIT
/
--当用户对test表执行DML语句时，将相关信息记录到日志表

CREATE TABLE test(
  t_id  NUMBER(4),
  t_name VARCHAR2(20),
  t_age NUMBER(2),
  t_sex CHAR
)
/

CREATE TABLE test_log(
  l_user  VARCHAR2(15),
  l_type  VARCHAR2(15),
  l_date  VARCHAR2(30)
)
/

CREATE OR REPLACE TRIGGER TEST_TRIGGER
 AFTER DELETE OR INSERT OR UPDATE ON TEST
DECLARE
 V_TYPE TEST_LOG.L_TYPE%TYPE;
BEGIN
 IF INSERTING THEN
  --INSERT触发
  V_TYPE := 'INSERT';
  DBMS_OUTPUT.PUT_LINE('记录已经成功插入，并已记录到日志');
 ELSIF UPDATING THEN
  --UPDATE触发
  V_TYPE := 'UPDATE';
  DBMS_OUTPUT.PUT_LINE('记录已经成功更新，并已记录到日志');
 ELSIF DELETING THEN
  --DELETE触发
  V_TYPE := 'DELETE';
  DBMS_OUTPUT.PUT_LINE('记录已经成功删除，并已记录到日志');
 END IF;
 INSERT INTO TEST_LOG
 VALUES
  (USER, V_TYPE, TO_CHAR(SYSDATE, 'yyyy-mm-dd hh24:mi:ss')); --USER表示当前用户名
END;
/

INSERT INTO test VALUES(101,'zhao',22,'M')
/
UPDATE test SET t_age = 30 WHERE t_id = 101
/
DELETE test WHERE t_id = 101
/
commit
/

--创建触发器，它将映射emp表中每个部门的总人数和总工资
drop table emp purge
/
CREATE TABLE EMP
   (	"EMPNO" NUMBER(4,0),
	"ENAME" VARCHAR2(10),
	"JOB" VARCHAR2(9),
	"MGR" NUMBER(4,0),
	"HIREDATE" DATE,
	"SAL" NUMBER(7,2),
	"COMM" NUMBER(7,2),
	"DEPTNO" NUMBER(2,0),
	 CONSTRAINT "PK_EMP" PRIMARY KEY ("EMPNO")
)
/
insert into emp values(7369,'SMITH','CLERK',7902,'17-DEC-80',800,null,20)
/
insert into emp values(7499,'ALLEN','SALESMAN',7698,'20-FEB-81',1600,300,30)
/  
insert into emp values(7521,'WARD','SALESMAN',7698,'22-FEB-81',1250,500,30)
/  
insert into emp values(7566,'JONES','MANAGER',7839,'02-APR-81',2975,null,20)
/  
commit
/
drop table dept_sal purge
/
CREATE TABLE dept_sal AS
SELECT deptno, COUNT(empno) total_emp, SUM(sal) total_sal
FROM emp
GROUP BY deptno
/

CREATE OR REPLACE TRIGGER EMP_INFO
 AFTER INSERT OR UPDATE OR DELETE ON EMP
DECLARE
 CURSOR CUR_EMP IS
  SELECT DEPTNO, COUNT(EMPNO) AS TOTAL_EMP, SUM(SAL) AS TOTAL_SAL FROM EMP GROUP BY DEPTNO;
BEGIN
 DELETE DEPT_SAL; --触发时首先删除映射表信息
 FOR V_EMP IN CUR_EMP LOOP
  --DBMS_OUTPUT.PUT_LINE(v_emp.deptno || v_emp.total_emp || v_emp.total_sal);
  --插入数据
  INSERT INTO DEPT_SAL
  VALUES
   (V_EMP.DEPTNO, V_EMP.TOTAL_EMP, V_EMP.TOTAL_SAL);
 END LOOP;
END;
/

INSERT INTO emp(empno,deptno,sal) VALUES('123','10',10000)
/
SELECT * FROM dept_sal
/
DELETE EMP WHERE empno=123
/
SELECT * FROM dept_sal
/
--创建触发器，用来记录表的删除数据
DROP TABLE EMPLOYEE PURGE
/

CREATE TABLE employee(
  id  VARCHAR2(4) NOT NULL,
  name VARCHAR2(15) NOT NULL,
  age NUMBER(2)  NOT NULL,
  sex CHAR NOT NULL
)
/

INSERT INTO employee VALUES('e101','zhao',23,'M')
/
INSERT INTO employee VALUES('e102','jian',21,'F')
/
DROP TABLE old_employee PURGE
/
CREATE TABLE old_employee AS SELECT * FROM employee
/

CREATE OR REPLACE TRIGGER TIG_OLD_EMP
 AFTER DELETE ON EMPLOYEE
 FOR EACH ROW --语句级触发，即每一行触发一次
BEGIN
 INSERT INTO OLD_EMPLOYEE VALUES (:OLD.ID, :OLD.NAME, :OLD.AGE, :OLD.SEX); --:old代表旧值
END;
/

DELETE employee
/
SELECT * FROM old_employee
/

--创建触发器，利用视图插入数据
DROP TABLE TAB1 PURGE
/
CREATE TABLE tab1 (tid NUMBER(4) PRIMARY KEY,tname VARCHAR2(20),tage NUMBER(2))
/
DROP TABLE TAB2 PURGE
/
CREATE TABLE tab2 (tid NUMBER(4),ttel VARCHAR2(15),tadr VARCHAR2(30))
/

INSERT INTO tab1 VALUES(101,'zhao',22)
/
INSERT INTO tab1 VALUES(102,'yang',20)
/
INSERT INTO tab2 VALUES(101,'13761512841','AnHuiSuZhou')
/
INSERT INTO tab2 VALUES(102,'13563258514','AnHuiSuZhou')
/

CREATE OR REPLACE VIEW tab_view AS SELECT tab1.tid,tname,ttel,tadr FROM tab1,tab2 WHERE tab1.tid = tab2.tid
/

CREATE OR REPLACE TRIGGER TAB_TRIGGER
 INSTEAD OF INSERT ON TAB_VIEW
BEGIN
 INSERT INTO TAB1 (TID, TNAME) VALUES (:NEW.TID, :NEW.TNAME);
 INSERT INTO TAB2 (TTEL, TADR) VALUES (:NEW.TTEL, :NEW.TADR);
END;
/

INSERT INTO tab_view VALUES(106,'ljq','13886681288','beijing')
/

SELECT * FROM tab_view
/
SELECT * FROM tab1
/
SELECT * FROM tab2
/
--创建触发器，比较emp表中更新的工资
drop table emp purge
/
CREATE TABLE EMP2
   (	"EMPNO" NUMBER(4,0),
	"ENAME" VARCHAR2(10),
	"JOB" VARCHAR2(9),
	"MGR" NUMBER(4,0),
	"HIREDATE" DATE,
	"SAL" NUMBER(7,2),
	"COMM" NUMBER(7,2),
	"DEPTNO" NUMBER(2,0),
	 CONSTRAINT "PK_EMP" PRIMARY KEY ("EMPNO")
)
/
insert into EMP2 values(7369,'SMITH','CLERK',7902,'17-DEC-80',800,null,20)
/
insert into EMP2 values(7499,'ALLEN','SALESMAN',7698,'20-FEB-81',1600,300,30)
/  
insert into EMP2 values(7521,'WARD','SALESMAN',7698,'22-FEB-81',1250,500,30)
/  
insert into EMP2 values(7566,'JONES','MANAGER',7839,'02-APR-81',2975,null,20)
/  
commit
/
set serveroutput on;

CREATE OR REPLACE TRIGGER SAL_EMP
 BEFORE UPDATE ON EMP2
 FOR EACH ROW
BEGIN
 IF :OLD.SAL > :NEW.SAL THEN
  DBMS_OUTPUT.PUT_LINE('sal decrease');
 ELSIF :OLD.SAL < :NEW.SAL THEN
  DBMS_OUTPUT.PUT_LINE('sal increase');
 ELSE
  DBMS_OUTPUT.PUT_LINE('sal change none');
 END IF;
 DBMS_OUTPUT.PUT_LINE('before update :' || :OLD.SAL);
 DBMS_OUTPUT.PUT_LINE('after update :' || :NEW.SAL);
END;
/

UPDATE emp SET sal = 2000 WHERE empno = '7369'
/


--创建触发器，将操作CREATE、DROP存储在log_info表

CREATE TABLE log_info(
  manager_user VARCHAR2(15),
  manager_date VARCHAR2(15),
  manager_type VARCHAR2(15),
  obj_name   VARCHAR2(15),
  obj_type   VARCHAR2(15)
)
/

set serveroutput on;

CREATE OR REPLACE TRIGGER TRIG_LOG_INFO
 AFTER CREATE OR DROP ON SCHEMA
BEGIN
 INSERT INTO LOG_INFO
 VALUES
  (USER,
   SYSDATE,
   SYS.DICTIONARY_OBJ_NAME,
   SYS.DICTIONARY_OBJ_OWNER,
   SYS.DICTIONARY_OBJ_TYPE);
END;
/

CREATE TABLE a(id NUMBER)
/
CREATE TYPE aa AS OBJECT(id NUMBER)
/
DROP TABLE a
/
DROP TYPE aa
/

SELECT * FROM log_info;


--禁用触发器
ALTER TRIGGER TRIG_LOG_INFO DISABLE
/



--相关数据字典
SELECT * FROM USER_TRIGGERS;
--必须以DBA身份登陆才能使用此数据字典
SELECT * FROM ALL_TRIGGERS;SELECT * FROM DBA_TRIGGERS;

--启用和禁用
ALTER TRIGGER trigger_name DISABLE;
ALTER TRIGGER trigger_name ENABLE;