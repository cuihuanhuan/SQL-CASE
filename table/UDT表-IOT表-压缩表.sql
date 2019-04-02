-----UDT表----
drop table udtlob1 purge
/
drop type lobtype2
/
create or replace type lobtype2 as object(
f1 number,
f2 varchar2(30),
f3 clob
)
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
UPDATE UDTLOB1 SET F1=F1+10000
/
UPDATE UDTLOB1 SET F2=lobtype2(10,'SDD','DDDD')
/
begin 
for i in 1..4000
loop
insert into udtlob1 values (i, lobtype2(i, 'aaa', 'bbbbb'));
end loop;
commit;
end;
/
DELETE FROM UDTLOB1 where f1<100
/
COMMIT
/
truncate table udtlob1
/
-----UDT表----
drop table udtcom1 purge
/
drop type comtype1
/
create or replace type comtype1 as object(
id number,
name char(10),
time date,
f1 varchar2(4000),
f2 varchar2(2000),
f3 nchar(100),
f5 raw(1000),
f6 TIMESTAMP(9),
f7 BLOB,
f8 CLOB,
f9 NCLOB,
f11 NUMBER(38,38),
f12 DECIMAL(38,38),
f13 integer,
f14 float,
f15 real
)
/
create table udtcom1(f1 number primary key, f2 comtype1)
/
begin 
for i in 1..40
loop
insert into udtcom1 values
(
i,
comtype1(
1,
'ltwaaa',
sysdate,
lpad('a',40,'a'),
lpad('b',18,'b'),
'wo cao shi zhende ba ,en wo lianxile yige bishouzei',
 hextoraw('ff'),
 sysdate,
hextoraw('aa'),
lpad('c',40,'c'),
lpad('d',30,'d'),
0,
0,
3,
4.4,
5)
);
end loop;
commit;
end;
/
update udtcom1 set f2=comtype1(
8,
'ltwaaa',
sysdate,
lpad('a',40,'a'),
lpad('b',18,'b'),
'wo cao shi zhende ba ,en wo lianxile yige bishouzei',
 hextoraw('ff'),
 sysdate,
hextoraw('aa'),
lpad('c',40,'c'),
lpad('d',30,'d'),
0,
0,
3,
4.4,
5)
/
commit
/
-----IOT表----
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
begin 
    for i in 100..30000
    loop
insert into T2  values
(i, i+100, 'exxxxx');

    end loop; 
--commit;    
end;
/
update t2 set c='xxxx' where a>1000
/
delete from t2 where a<150
/
commit
/
delete from t2
/
commit
/
truncate table t2
/
-----压缩表-----
drop table com6 purge 
/
drop table com purge 
/
create table com (no int,name varchar2(100))
/
insert into com values (1,'info2softcompanyi2activeproduct')
/
insert into com values (2,'info2softcompanyi2activeproduct')
/
insert into com values (3,'info2softcompanyi2activeproduct')
/
insert into com values (4,'info2softcompanyi2activeproduct')
/
insert into com values (5,'info2softcompanyi2activeproduct')
/
insert into com select * from com
/
insert into com select * from com
/
insert into com select * from com
/
insert into com select * from com
/
insert into com select * from com
/
insert into com select * from com
/
insert into com select * from com
/
insert into com select * from com
/
insert into com select * from com
/
insert into com select * from com
/
insert into com select * from com
/
insert into com select * from com
/
insert into com select * from com
/
insert into com select * from com
/
insert into com select * from com
/
commit
/
create table com6 compress as select * from com where 1=2
/

insert into com6 select * from com
/
commit
/ 


insert /*+ append */ into com6 select * from com
/
commit
/