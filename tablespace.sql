CREATE TABLESPACE TEST DATAFILE '/u01/app/oracle/oradata/orcl/orclpdb/test.dbf' size 100M
/
create table dds_lob1 ( no int, nm varchar2(20), resume clob, photo blob )
/
insert into dds_lob1(no,nm )values(1,'huan')
/
insert into dds_lob1(no,nm )values(2,'huan')
/
commit;

ALTER TABLE DDS_LOB1 MOVE TABLESPACE TEST
/
ALTER TABLE DDS_LOB1 MOVE TABLESPACE TEST--移动表到相同表空间
/
SELECT TABLE_NAME,TABLESPACE_NAME FROM USER_tABLES WHERE TABLE_NAME='DDS_LOB1'
/
drop tablespace test including contents and datafiles
/
drop table ptest purge
/
create table ptest ( id number, year number(4) not null )
partition by range ( year ) (
partition p1 values less than (2001),
partition p2 values less than (2002),
partition p3 values less than (2003),
partition p4 values less than (2004)
)
/
alter table ptest add constraint PK_R primary key (id)
/
insert into ptest values ( 1, 2001 )
/
COMMIT
/
alter table ptest move partition p2
/
select table_name,tablespace_name from USER_TAB_PARTITIONS where table_name='PTEST'
/
alter tablespace test add datafile '/u01/app/oracle/oradata/orcl/orclpdb/test2.dbf' size 5M
/
SELECT FILE_NAME FROM DBA_DATA_FILES WHERE TABLESPACE_NAME='TEST'
/
ALTER DATABASE DATAFILE '/u01/app/oracle/oradata/orcl/orclpdb/test2.dbf' RESIZE 10M
/
create smallfile tablespace "EXAMPLE" datafile '/u01/app/oracle/oradata/orcl/orclpdb/example.dbf' size 100M
/
create temporary tablespace tempts1 tempfile '/u01/app/oracle/oradata/orcl/orclpdb/temp1.dbf' size 2M tablespace group group1
/
--临时表空间组
SELECT TABLESPACE_NAME,FILE_NAME FROM DBA_TEMP_FILES WHERE TABLESPACE_NAME = 'TEMPTS1'
/
select * from dba_tablespace_groups
/