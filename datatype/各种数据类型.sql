--字符类型
drop table dds_char
/
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
begin 
    for i in 10..30000
    loop
insert into dds_char  values
(
i, 
'A', 
'56789',
'GH',
'BN',
'0123456789',
'China' 
);

    end loop; 
commit;    
end;
/

update dds_char set c_nvarchar2='X'
/
commit
/

delete from dds_char where  no>10000
/
commit
/
truncate table dds_char 
/

--数字类型


drop table dds_no
/
create table dds_no (
    no             int primary key,
    c_number       number,
    c_number5      number(5),
    c_number5_2    number(5,2),
    c_int          int,
    c_float        float,
    c_double       double precision,
    c_real         real,
    c_binary_float BINARY_FLOAT,
    c_BINARY_DOUBLE BINARY_DOUBLE
)
/
insert into dds_no values ( 1,100, 400, 123.45, 1, 100.23, 300.45, 500.6789, 100.23, 300.45  )
/
insert into dds_no values ( 2,200, 400, 345.54, 1, 100.23, 300.45, 500.6789, 100.23, 300.45  )
/
insert into dds_no values ( 3,300, 400, 654.54, 1, 100.23, 300.45, 500.6789, 100.23, 300.45  )
/
insert into dds_no values ( 4,400, 400, 789.98, 1, 100.23, 300.45, 500.6789, 100.23, 300.45  )
/
commit
/
begin 
    for i in 10..30000
    loop
insert into dds_no  values
( i,i+10, 400, 123.45, 1, 100.23, 300.45, 500.6789, 100.23, 300.45  );
    end loop; 
commit;    
end;
/
update dds_no set c_number=500 where no>1000
/
commit
/
delete from dds_no where  no<6000
/
commit
/

truncate table dds_no
/


--日期类型
drop table dds_time
/
create table dds_time (
    no                   int primary key,
    c_date               date,
    c_timestamp          timestamp,
    c_timestamp5         timestamp(5),
    c_timestampzone      timestamp with time zone,
    c_timestamp5zone     timestamp(5) with time zone,
    c_ts_lzone           timestamp with local time zone,
    c_ts5_lzone          timestamp(5) with local time zone,
    c_ym                 interval year to month,
    c_ym3                interval year (3) to month,
    c_ds                 interval day to second,
    c_ds_3               interval day (3) to second,
    c_ds_3_4             interval day (3) to second ( 4 )
)
/
insert into dds_time values (1,
    to_date( '08/12/01 12:34:56','YY/MM/DD HH24:MI:SS' ),
    TO_TIMESTAMP ('10-09-04 14:10:10.123000', 'DD-MM-RR HH24:MI:SS.FF'),
    TO_TIMESTAMP ('23-09-04 15:17:32.456000', 'DD-MM-RR HH24:MI:SS.FF'),
    TO_TIMESTAMP_TZ('1999-12-04 11:00:00-08:00','YYYY-MM-DD HH24:MI:SSTZH:TZM'),
    TO_TIMESTAMP_TZ('2000-12-04 12:00:00-09:00','YYYY-MM-DD HH24:MI:SSTZH:TZM'),
    TO_TIMESTAMP_TZ('2001-12-04 13:00:00-10:00','YYYY-MM-DD HH24:MI:SSTZH:TZM'),
    TO_TIMESTAMP_TZ('2008-12-04 14:00:00-11:00','YYYY-MM-DD HH24:MI:SSTZH:TZM'),
    TO_YMINTERVAL('01-02'),
    TO_YMINTERVAL('03-04'),
    TO_DSINTERVAL('001 10:00:00'),
    TO_DSINTERVAL('002 12:34:56'),
    TO_DSINTERVAL('003 10:20:30')
)
/
commit
/


begin 
    for i in 2..30000
    loop
insert into dds_time  values(i,
    to_date( '08/12/01 12:34:56','YY/MM/DD HH24:MI:SS' ),
    TO_TIMESTAMP ('10-09-04 14:10:10.123000', 'DD-MM-RR HH24:MI:SS.FF'),
    TO_TIMESTAMP ('23-09-04 15:17:32.456000', 'DD-MM-RR HH24:MI:SS.FF'),
    TO_TIMESTAMP_TZ('1999-12-04 11:00:00-08:00','YYYY-MM-DD HH24:MI:SSTZH:TZM'),
    TO_TIMESTAMP_TZ('2000-12-04 12:00:00-09:00','YYYY-MM-DD HH24:MI:SSTZH:TZM'),
    TO_TIMESTAMP_TZ('2001-12-04 13:00:00-10:00','YYYY-MM-DD HH24:MI:SSTZH:TZM'),
    TO_TIMESTAMP_TZ('2008-12-04 14:00:00-11:00','YYYY-MM-DD HH24:MI:SSTZH:TZM'),
    TO_YMINTERVAL('01-02'),
    TO_YMINTERVAL('03-04'),
    TO_DSINTERVAL('001 10:00:00'),
    TO_DSINTERVAL('002 12:34:56'),
    TO_DSINTERVAL('003 10:20:30')
);

    end loop; 
commit;    
end;
/

update dds_time set c_date=to_date( '08/11/01 12:34:56','YY/MM/DD HH24:MI:SS' ) where no>2000
/
commit
/
delete from dds_time where  no<10000
/
commit
/

truncate table dds_time
/

--lob
drop table dds_lob
/
create table dds_lob (
    no                  int primary key,
    c_blob              blob,
    c_clob              clob
)
/
insert into dds_lob values ( 1,rawtohex('aaaaaa'), rawtohex('info2soft') )
/
insert into dds_lob values ( 2,rawtohex('bbbbbb'), rawtohex('info2soft') )
/
insert into dds_lob values ( 3,rawtohex('cccccc'), rawtohex('info2soft') )
/
commit
/
begin 
    for i in 5..30000
    loop
insert into dds_lob values ( i,rawtohex('cccccc'), rawtohex('info2soft') );

    end loop; 
commit;    
end;
/
update dds_lob set c_blob=rawtohex('eeee') where no>1
/
commit
/
update dds_lob set c_clob=rawtohex('huanhuan') where no>1
/
commit
/
delete from dds_lob where  no=8
/
commit
/

	
truncate table dds_lob
/


--raw
drop table dds_raw
/
create table dds_raw (
    no                  int primary key,
    c_int               int,
    c_raw6              raw(6),
    c_lraw              long raw
)
/
insert into dds_raw values ( 1, 10,'ABCDEF','00112233445566778899aabbccddeeff' )
/
insert into dds_raw values ( 2, 20,'ABCDEF','00112233445566778899aabbccddeeff' )
/
insert into dds_raw values ( 3, 30,'ABCDEF','00112233445566778899aabbccddeeff' )
/
commit
/
begin 
    for i in 5..30000
    loop
insert into dds_raw values ( i, 10+i,'ABCDEF','00112233445566778899aabbccddeeff' );
    end loop; 
commit;    
end;
/
update dds_raw set c_lraw='00112233445566778899aabbccddeeee' where no>1000
/
commit
/
delete from dds_raw where  no<1500
/
commit
/

truncate table dds_raw 
/
--rowid
drop table dds_rowid
/
 create table dds_rowid (
    no                  int primary key,
    c_rid               rowid,
    c_urid              urowid
)
/
insert into dds_rowid values ( 4,'AAAQ+UAAEAAADAvAAA', '*BAEANzQCwQICwQL+' )
/
insert into dds_rowid values ( 2,'AAAQ+UAAEAAADAvBBB', '*BAEANzQCwQICwQL+' )
/
insert into dds_rowid values ( 3,'AAAQ+UAAEAAADAvCCC', '*BAEANzQCwQICwQL+' )
/
commit
/
begin 
    for i in 5..30000
    loop
insert into dds_rowid values ( i,'AAAQ+UAAEAAADAvAAA', '*BAEANzQCwQICwQL+' );
    end loop; 
--commit;    
end;
/
update dds_rowid set c_urid='QQQQ+QQQQQQQQQvQQQ' where no>2000
/
delete from dds_rowid where  no<3000
/
commit
/

truncate table dds_rowid
/

