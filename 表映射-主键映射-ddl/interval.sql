drop table sub purge
/
create table sub 
( a1 number primary key,
year number
)
partition by range (a1) interval (100)
subpartition by range (year)
subpartition template (
subpartition sp_2016 values less than (2017),
subpartition sp_2017 values less than (2018),
subpartition sp_2018 values less than (2019)
)
(
partition b1 values less than (2),
partition b2 values less than (4)
)
/
insert into sub values (1,2015)
/
insert into sub values (2,2016)
/
insert into sub values (3,2017)
/
insert into sub values (203,2018)
/
insert into sub values (205,2014)
/
commit
/
delete from sub where a1=1
/

update sub set year=2015 where a1=205
/
commit
/
begin 
	for i in 20000..30000
		loop
			insert into sub  values (i, 2017);
		end loop; 
		commit;    
	end;
/
--交换分区
create table swap_t
( a1 number primary key,
year number
)
partition by range (year) (
partition sp_16 values less than (2017),
partition sp_17 values less than (2018),
partition sp_18 values less than (2019)
)
/
insert into swap_t values (4,2015)
/
insert into swap_t values (5,2016)
/
commit
/
alter table sub exchange partition b1 with table swap_t
/