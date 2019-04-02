drop table temp purge
/
create table TEMP
(
  name      VARCHAR2(200),
  age       NUMBER,
  temp_clob CLOB
)
tablespace users
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 160K
    next 1M
    minextents 1
    maxextents unlimited
  );
  
  
  
  
  
create table t
(
dt date,
x int,
y varchar2(30),
z clob
)
partition by range(dt)
interval(numtoyminterval(1,'MONTH')) store in (users)
(partition T20130512 values less than (to_date('2013-05-12 14:45:13','YYYY-MM-DD HH24:MI:SS'))TABLESPACE users
lob(z) store as (tablespace users )
);

declare

     l_data long := rpad('*',32000,'*');
    begin
            for i in 1 .. 10
            loop
                    insert into t (dt,x,y,z) values (add_months( to_date('2013-06-12 16:51:50','YYYY-MM-DD HH24:MI:SS'),i), i, i, l_data );
           end loop;
           commit;
    end;
    /
    
    select * from t;
    
    drop table t purge
    /
    CREATE TABLE t (
     ID           INTEGER NOT NULL,
    LOB_Column   CLOB,
    created_date DATE
  )
  PARTITION BY RANGE (created_date)
  (
     PARTITION p_1 VALUES LESS THAN (TO_DATE('2012-11-01', 'yyyy-mm-dd'))
        TABLESPACE users
        LOB(LOB_Column) STORE AS (TABLESPACE users ENABLE STORAGE IN ROW),
        PARTITION p_2 VALUES LESS THAN (TO_DATE('2012-12-01', 'yyyy-mm-dd'))
        TABLESPACE users
        LOB(LOB_Column) STORE AS (TABLESPACE users ENABLE STORAGE IN ROW)
  );
INSERT INTO t VALUES (1, 'abc', TO_DATE('2012-10-01', 'yyyy-mm-dd'));
INSERT INTO t VALUES (2, 'def', TO_DATE('2012-11-01', 'yyyy-mm-dd'));
commit;
/

DECLARE
   l_data LONG := RPAD('*', 32000, '*');
 BEGIN
    INSERT INTO t VALUES (3, l_data, TO_DATE('2012-10-01', 'yyyy-mm-dd'));
    INSERT INTO t VALUES (4, l_data, TO_DATE('2012-11-01', 'yyyy-mm-dd'));
    commit;
  END;
  /
  select segment_name, segment_type, tablespace_name
   from dba_segments
  where owner = user 
  