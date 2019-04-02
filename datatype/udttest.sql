
--simple clob
create or replace type lobtype2 as object(
f1 number,
f2 varchar2(30),
f3 clob
);
/
drop table udtlob1 purge;
create table udtlob1(f1 number primary key, f2 lobtype2);

begin 
for i in 1..4000
loop
insert into udtlob1 values (i, lobtype2(i, 'aaa', 'bbbbb'));
end loop;
commit;
end;
/

update udtlob1 set f2=lobtype1(2,'cccc','dddd');
commit;
delete from udtlob1 where rownum < 1000;
commit;

--complex udt

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
);
/
drop table udtcom1 purge;
create table udtcom1(f1 number primary key, f2 comtype1);



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



update udtcom1 set f2 = comtype1(
1,
'dasda',
sysdate,
lpad('a',4000,'a'),
lpad('b',1800,'b'),
'wo cao shi zhendasdasdase ba ,en wo lianxile yige bishouzei',
 hextoraw('ff'),
 sysdate,
empty_blob(),
lpad('c',4000,'c'),
lpad('d',3000,'d'),
0,
0,
3,
4.4,
5);
commit;

delete from udtcom1 where rownum < 10;
commit;



drop table udtcom2 purge;
create table udtcom2(f1 number primary key, f2 comtype1, f3 comtype1);

begin 
for i in 1..40
loop
insert into udtcom2 values
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
5),
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



update udtcom2 set f2 = comtype1(
1,
'dasda',
sysdate,
lpad('a',4000,'a'),
lpad('b',1800,'b'),
'wo cao shi zhendasdasdase ba ,en wo lianxile yige bishouzei',
 hextoraw('ff'),
 sysdate,
empty_blob(),
lpad('c',4000,'c'),
lpad('d',3000,'d'),
0,
0,
3,
4.4,
5)
, f3 = comtype1(
1,
'dasda',
sysdate,
lpad('a',4000,'a'),
lpad('b',1800,'b'),
'wo cao shi zhendasdasdase ba ,en wo lianxile yige bishouzei',
 hextoraw('ff'),
 sysdate,
empty_blob(),
lpad('c',4000,'c'),
lpad('d',3000,'d'),
0,
0,
3,
4.4,
5);
commit;



delete from udtcom2 where rownum < 10;
commit;


--XMLTYPE udt

create or replace type xmltype1 as object(
f1 number,
f3 clob,
f2 varchar2(30),
f4 xmltype
);
/

--store as clob

create table xmltable1 (f1 number primary key, f2 xmltype1) XMLType COLUMN f2.f4
  STORE AS CLOB (
    TABLESPACE USERS
    STORAGE(INITIAL 4K NEXT 8K)
    CHUNK 4096 NOCACHE LOGGING
  );

begin 
for i in 1..40
loop
insert into xmltable1 values(
i,
xmltype1(
i,
lpad('c',40,'c'),
'aaa',
sys.XMLType.createXML(
'<?xml version="1.0"?>
<PO pono="1">
   <PNAME>Po_1</PNAME>
   <CUSTNAME>John</CUSTNAME>
   <SHIPADDR>
      <STREET>1033, Main Street</STREET>
      <CITY>Sunnyvalue</CITY>
      <STATE>CA</STATE>
   </SHIPADDR>
</PO>')
)
);
end loop;
commit;
end;
/

update xmltable1 set f2=
xmltype1(
1,
lpad('d',4000,'d'),
'dddd',
sys.XMLType.createXML(
'<?xml version="2.0"?>
<PO pono="1">
   <PNAME>Po_1</PNAME>
   <CUSTNAME>John</CUSTNAME>
   <SHIPADDR>
      <STREET>1066, Main Street</STREET>
      <CITY>Sunnyvalue</CITY>
      <STATE>CA</STATE>
   </SHIPADDR>
</PO>'))
;
commit;


delete from xmltable1 where rownum < 10;
commit;

-----not store as clob

drop table xmltable2 purge;
create table xmltable2 (f1 number primary key, f2 xmltype1);

begin 
for i in 1..40
loop
insert into xmltable2 values(
i,
xmltype1(
i,
lpad('c',40,'c'),
'aaa',
sys.XMLType.createXML(
'<?xml version="1.0"?>
<PO pono="1">
   <PNAME>Po_1</PNAME>
   <CUSTNAME>John</CUSTNAME>
   <SHIPADDR>
      <STREET>1033, Main Street</STREET>
      <CITY>Sunnyvalue</CITY>
      <STATE>CA</STATE>
   </SHIPADDR>
</PO>')
)
);
end loop;
commit;
end;
/

update xmltable2 set f2=
xmltype1(
1,
lpad('d',4000,'d'),
'dddd',
sys.XMLType.createXML(
'<?xml version="2.0"?>
<PO pono="1">
   <PNAME>Po_1</PNAME>
   <CUSTNAME>John</CUSTNAME>
   <SHIPADDR>
      <STREET>1066, Main Street</STREET>
      <CITY>Sunnyvalue</CITY>
      <STATE>CA</STATE>
   </SHIPADDR>
</PO>'))
;
commit;


delete from xmltable2 where rownum < 10;
commit;



--------simple varray

create or replace type reftype1 as object(
f1 number,
f2 ref xmltype1,
f3 ref lobtype1,
f4 ref comtype1,
f5 anydata
);
/

create or replace type object_type3 as object (
col1    char(20),
col2    date
);
/
create or replace type varray_type2  as varray(5) of object_type3;
/


drop table varraytable1 purge;
create table varraytable1(f1 number primary key, f2 varray_type2);
begin 
for i in 1..400
loop
insert into varraytable1 values (i, 
varray_type2(object_type3('aa',sysdate),object_type3('bb',sysdate),
object_type3('cc',sysdate),object_type3('dd',sysdate),object_type3('ee',sysdate))
);
end loop;
commit;
end;
/

update  varraytable1 set  f2 = varray_type2(object_type3('aa',sysdate),object_type3('bb',sysdate),
object_type3('cc',sysdate),object_type3('dd',sysdate),object_type3('ee',sysdate));
commit;
/

delete from varraytable1 where rownum<100;
commit;
/

create or replace type varray_type3 as object (
f1 number,
f2 varray_type2
);
/

drop table varraytable2;
create table varraytable2(f1 number primary key, f2 varray_type3);
begin 
for i in 1..400
loop
insert into varraytable2 values(i, varray_type3(i , varray_type2(object_type3('aa',sysdate),object_type3('bb',sysdate),
object_type3('cc',sysdate),object_type3('dd',sysdate),object_type3('ee',sysdate))));
end loop;
commit;
end;
/


update  varraytable2 set f2 = varray_type3(999, varray_type2(object_type3('aa',sysdate),object_type3('bb',sysdate),
object_type3('cc',sysdate),object_type3('dd',sysdate),object_type3('ee',sysdate)));
commit;
/

delete from varraytable2 where rownum<100;
commit;
/

--------complex varray

create or replace type comtype2 as object(
f1 number,
f2 char(10),
f3 date,
f4 varchar2(4000),
f5 varchar2(2000),
f6 nchar(100),
f7 raw(1000),
f8 TIMESTAMP(9),
f9 NUMBER(38,38),
f10 DECIMAL(38,38),
f11 integer,
f12 float,
f13 real
);
/

create or replace type varray_type4  as varray(5) of comtype2;
/

create or replace type varray_type5 as object (
f1 number,
f2 varray_type4
);
/


drop table varraytable3;
create table varraytable3(f1 number primary key, f2 varray_type5);

begin 
for i in 1..40
loop
insert into varraytable3 values(i, varray_type5(i , varray_type4(
comtype2(
i,
'aa',
sysdate,
lpad('a',20,'a'),
lpad('b',20,'b'),
lpad('c',20,'c'),
hextoraw('ff'),
sysdate,
0,
0,
11,
12.1,
13),
comtype2(
i,
'aa',
sysdate,
lpad('a',20,'a'),
lpad('b',20,'b'),
lpad('c',20,'c'),
hextoraw('ff'),
sysdate,
0,
0,
11,
12.1,
13)
)));
end loop;
commit;
end;
/


update  varraytable3 set f2 = varray_type5(223, varray_type4(
comtype2(
1111,
'aa',
sysdate,
lpad('a',4000,'a'),
lpad('b',2000,'b'),
lpad('c',20,'c'),
hextoraw('ff'),
sysdate,
0,
0,
11,
12.1,
13),
comtype2(
111111,
'aa',
sysdate,
lpad('a',4000,'a'),
lpad('b',2000,'b'),
lpad('c',20,'c'),
hextoraw('ff'),
sysdate,
0,
0,
11,
12.1,
13)
));

delete from varraytable3 where rownum<20;
commit;
/

-----anydata----
create type person_type as object (
ssn     number ,
name    varchar2(20),
job     char(10) ,
salary  number(10,4)
);
/

create type phone_list as varray(100) of number ;
/
create type date_list as table of date;
/

create table anydata_tab(f1 number primary key, f2 anydata);

insert into anydata_tab values (10,Sys.AnyData.ConvertNumber(100.101)) ;
insert into anydata_tab values (20,Sys.AnyData.ConvertDate('01-JAN-1901'));
insert into anydata_tab values (30,Sys.AnyData.ConvertChar('thirty')) ;
insert into anydata_tab values (40,Sys.AnyData.ConvertVarchar('forty')) ;
insert into anydata_tab values (50,Sys.AnyData.ConvertVarchar2('fifty'));
insert into anydata_tab values (60,Sys.AnyData.ConvertRaw(utl_raw.cast_to_raw('0908FFGGA')) );

--Cannot insert an AnyData of lob type into a table .
--insert into anydata_tab values (70,Sys.AnyData.ConvertBlob(to_blob('AABB98076'))) ;
--insert into anydata_tab values (80,Sys.AnyData.ConvertClob('eighty') ) ;


insert into anydata_tab values (90,Sys.AnyData.ConvertBfile(BFILENAME('GPFSD1', 'gpfdf1.dat')));
insert into anydata_tab values (100,
        Sys.AnyData.ConvertObject(Person_Type(123456767,'Harry','Manager',1500.0909)));

insert into anydata_tab values (110,
        Sys.AnyData.ConvertCollection(phone_list(9774567878,4075689000,1238761020)));

insert into anydata_tab values (120,
        Sys.AnyData.ConvertCollection(date_list('01-JAN-1910','02-FEB-1920','03-MAR-1930')) );
insert into anydata_tab values (130,
        Sys.AnyData.ConvertObject(comtype2(1111,
'aa',
sysdate,
lpad('a',40,'a'),
lpad('b',20,'b'),
lpad('c',20,'c'),
hextoraw('ff'),
sysdate,
0,
0,
11,
12.1,
13)));

insert into anydata_tab values (140,Sys.AnyData.CONVERTTIMESTAMP(sysdate));
insert into anydata_tab values (150,Sys.AnyData.CONVERTTIMESTAMPTZ(sysdate));
insert into anydata_tab values (160,Sys.AnyData.CONVERTTIMESTAMPLTZ(sysdate));
insert into anydata_tab values (170,Sys.AnyData.CONVERTNCHAR('aaaaaaaaa'));
insert into anydata_tab values (180,Sys.AnyData.CONVERTNVARCHAR2('bbbbbbbb'));

commit ;




update anydata_tab set f2=Sys.AnyData.ConvertNumber(100.101);

update anydata_tab set f2=Sys.AnyData.ConvertDate('01-JAN-1901');
update anydata_tab set f2=Sys.AnyData.ConvertChar('thirty');
update anydata_tab set f2=Sys.AnyData.ConvertVarchar('forty') ;
update anydata_tab set f2=Sys.AnyData.ConvertVarchar2('fifty');
update anydata_tab set f2=Sys.AnyData.ConvertRaw(utl_raw.cast_to_raw('0908FFGGA'));

--Cannot insert an AnyData of lob type into a table .
--update anydata_tab set f2 = Sys.AnyData.ConvertBlob(to_blob('AABB98076')) ;
--insert into anydata_tab values (80,Sys.AnyData.ConvertClob('eighty') ) ;


update anydata_tab set f2=Sys.AnyData.ConvertBfile(BFILENAME('GPFSD1', 'gpfdf1.dat'));
update anydata_tab set f2=Sys.AnyData.ConvertObject(Person_Type(123456767,'Harry','Manager',1500.0909));

update anydata_tab set f2=Sys.AnyData.ConvertCollection(phone_list(9774567878,4075689000,1238761020));

update anydata_tab set f2=Sys.AnyData.ConvertCollection(date_list('01-JAN-1910','02-FEB-1920','03-MAR-1930'));
update anydata_tab set f2=Sys.AnyData.ConvertObject(comtype2(1111,
'aa',
sysdate,
lpad('a',4000,'a'),
lpad('b',2000,'b'),
lpad('c',20,'c'),
hextoraw('ff'),
sysdate,
0,
0,
11,
12.1,
13));

update anydata_tab set f2=Sys.AnyData.CONVERTTIMESTAMP(sysdate)));
update anydata_tab set f2=Sys.AnyData.CONVERTTIMESTAMPTZ(sysdate)));
update anydata_tab set f2=Sys.AnyData.CONVERTTIMESTAMPLTZ(sysdate)));
update anydata_tab set f2=Sys.AnyData.CONVERTNCHAR('aaaaaaaaa')));
update anydata_tab set f2=Sys.AnyData.CONVERTNVARCHAR2('bbbbbbbb')));

commit ;
/

delete from anydata_tab where rownum < 5;
commit;
/

