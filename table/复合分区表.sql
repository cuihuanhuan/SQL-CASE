---------interval分区表-------
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
			begin 
				for i in 1..5000
				loop
			insert into sub values (i,2015);

				end loop; 
			--commit;    
			end;
			/
			begin 
				for i in 6000..8000
				loop
			insert into sub values (i,2016);

				end loop; 
			--commit;    
			end;
			/
			delete from sub where a1>5000
			/
			begin 
				for i in 1..5000
				loop
			update sub set  year=2016 where a1=i;

				end loop; 
			--commit;    
			end;
			/
			commit
			/
			truncate table sub
			/

-----LIST-HASH分区表----
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
SUBPARTITION BY HASH (customer_id) SUBPARTITIONS 8
( PARTITION p_northwest VALUES ('OR', 'WA')
, PARTITION p_southwest VALUES ('AZ', 'UT', 'NM')
, PARTITION p_northeast VALUES ('NY', 'VM', 'NJ')
, PARTITION p_southeast VALUES ('FL', 'GA')
, PARTITION p_northcentral VALUES ('SD', 'WI')
, PARTITION p_southcentral VALUES ('OK', 'TX')
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
			
			------------------------------------
			
			
			begin 
				for i in 36000..40000
				loop
					insert into accounts values(i,12,106,1002,10002,'UT','B');

				end loop; 
			--commit;    
			end;
			/
			
					update accounts set id=id+20000;--延迟约束装载：是,主键冲突，插入失败

			begin 
				for i in 20001..30000
				loop
			insert into accounts values(i,12,105,1002,10002,'UT','B');

				end loop; 
			--commit;    
			end;
			/
			begin 
				for i in 1..5000
				loop
			insert into accounts values(i,12,101,1002,10002,'UT','B');

				end loop; 
			--commit;    
			end;
			/
			delete from accounts where id<6000
			/
			begin 
				for i in 5001..10000
				loop
			insert into accounts values(i,12,102,1002,10002,'UT','B');

				end loop; 
			--commit;    
			end;
			/
			------------------------------------
update accounts set branch_id=201708 where id > 3
/
commit
/
truncate table accounts
/
-----LIST-LIST分区表----
 drop table accounts2 purge
 /
 CREATE TABLE accounts2
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
insert into accounts2 values(1,11,101,1001,10001,'OR','B')
/
insert into accounts2 values(2,12,102,1002,10002,'UT','B')
/
insert into accounts2 values(3,13,103,1003,10003,'NY','A')
/
insert into accounts2 values(4,14,104,1004,10004,'FL','A')
/
insert into accounts2 values(5,15,105,1005,10005,'SD','G')
/
insert into accounts2 values(6,16,106,1006,10006,'OK','G')
/
commit
/
			begin 
				for i in 1..10
				loop
			insert into accounts2 values(i,12,106,1002,10002,'UT','B');

				end loop; 
			--commit;    
			end;
			/
			
			update accounts2 set ACCOUNT_NUMBER=1000 where id<100;

			
			begin 
				for i in 6001..10000
				loop
			insert into accounts2 values(i,12,102,1002,10002,'UT','B');

				end loop; 
			--commit;    
			end;
			/
			
			begin 
				for i in 10001..12000
				loop
			insert into accounts2 values(i,14,104,1004,10004,'FL','A');

				end loop; 
			--commit;    
			end;
			/
			
			update accounts2 set account_number=account_number+100;

			begin 
				for i in 12001..13000
				loop
			insert into accounts2 values(i,15,105,1005,10005,'SD','G');

				end loop; 
			--commit;    
			end;
			/
			
			update accounts2 set id=id+5;--延迟约束装载,备端err

			
			

			begin 
				for i in 13001..15000
				loop
			insert into accounts2 values(i,16,106,1006,10006,'OK','G');

				end loop; 
			--commit;    
			end;
			/
			delete from accounts2 where id <5000
			/
			
			
			commit
			/
update accounts2 set customer_id=201708 where id > 3
/
commit
/
truncate table accounts2
/
-----LIST-RANGE分区表----
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
insert into object_type values (6,4,'SEQUENCE','4')
/
commit
/
			begin 
				for i in 1..6000
				loop
			insert into object_type values (i,2,'TABLE','2');
				end loop; 
			--commit;    
			end;
			/
			begin 
				for i in 1..6000
				loop
			update object_type set objn=objn+1000 where obid=i;
				end loop; 
			--commit;    
			end;
			/
			begin 
				for i in 7000..9000
				loop
			insert into object_type values (i,2,'INDEX','2');
				end loop; 
			--commit;    
			end;
			/
			begin 
				for i in 7000..9000
				loop
			update object_type set objn=objn+1000 where obid=i;
				end loop; 
			--commit;    
			end;
			/
update object_type set objn=objn+100 where obid>2
/
commit
/
truncate table object_type
/
-----RANGE-HASH分区表----
drop table object_type2 purge
          /
          create table object_type2 ( oid NUMBER primary key, otype VARCHAR2(19), created DATE )
           partition by range ( created )
           subpartition by hash (oid)
           subpartition template (
                 subpartition sub_table tablespace system,
                 subpartition sub_index TABLESPACE users,
                 subpartition sub_other TABLESPACE users
           )(
              partition P1 values less than (to_date('2002-12-31','YYYY-MM-DD')),
              partition P2 values less than (to_date('2003-12-31','YYYY-MM-DD')),
              partition P3 values less than (to_date('2004-12-31','YYYY-MM-DD')),
              partition P4 values less than (to_date('2005-12-31','YYYY-MM-DD'))
           )
           /
			begin	
				for i in 1..3000
				loop
					insert into object_type2 values(
					i,
					'info2soft',
					to_date('2002-10-01','YYYY-MM-DD')
					);
				end loop;
				--commit;
			end;
			/
			UPDATE object_type2 set otype='information2'
			/
			delete object_type2 where oid>2800
			/
			begin	
				for i in 4000..5000
				loop
					insert into object_type2 values(
					i,
					'info2soft',
					to_date('2005-10-01','YYYY-MM-DD')
					);
				end loop;
				--commit;
			end;
			/
			commit
			/
			truncate table object_type2
			/
			
----------RANGE-LIST分区表-----
        drop table object_type3 purge
        /
        create table object_type3 ( oid NUMBER primary key, onum number,otype VARCHAR2(19), created DATE )
        partition by range ( created )
        subpartition by list (otype)
        subpartition template (
				subpartition sub_table VALUES ('TABLE' )  tablespace users,
                subpartition sub_index VALUES ('INDEX' )  tablespace system,
                subpartition sub_other VALUES (DEFAULT )  tablespace users
        )(
            partition P1 values less than (to_date('2002-12-31','YYYY-MM-DD')),
            partition P2 values less than (to_date('2003-12-31','YYYY-MM-DD')),
            partition P3 values less than (to_date('2004-12-31','YYYY-MM-DD'))
          )
          /
		begin	
			for i in 1..2000
			loop
				insert into object_type3 values(i,i,'TABLE',to_date('2002-10-01','YYYY-MM-DD'));
			end loop;
			--commit;
		end;
		/
		UPDATE object_type3 set onum=onum+100 where oid<1000
		/
		begin	
			for i in 3000..5000
			loop
				insert into object_type3 values(i,i,'TABLE',to_date('2004-10-01','YYYY-MM-DD'));
			end loop;
			--commit;
		end;
		/
		UPDATE object_type3 set onum=onum+100 where oid>4500
		/
		commit
		/
		truncate table object_type3
		/
---------------range-range分区表-----
drop table OBJECT_TYPE4 purge
/
CREATE TABLE OBJECT_TYPE4
( order_id      NUMBER primary key
, order_date    DATE NOT NULL
, delivery_date DATE NOT NULL
, customer_id   NUMBER NOT NULL
, sales_amount  NUMBER NOT NULL
)
PARTITION BY RANGE (order_date)
SUBPARTITION BY RANGE (delivery_date)
( PARTITION p_2006_jul VALUES LESS THAN (TO_DATE('01-AUG-2006','dd-MON-yyyy'))
  ( SUBPARTITION p06_jul_e VALUES LESS THAN (TO_DATE('15-AUG-2006','dd-MON-yyyy'))
  , SUBPARTITION p06_jul_a VALUES LESS THAN (TO_DATE('01-SEP-2006','dd-MON-yyyy'))
  , SUBPARTITION p06_jul_l VALUES LESS THAN (MAXVALUE)
  )
, PARTITION p_2006_aug VALUES LESS THAN (TO_DATE('01-SEP-2006','dd-MON-yyyy'))
  ( SUBPARTITION p06_aug_e VALUES LESS THAN (TO_DATE('15-SEP-2006','dd-MON-yyyy'))
  , SUBPARTITION p06_aug_a VALUES LESS THAN (TO_DATE('01-OCT-2006','dd-MON-yyyy'))
  , SUBPARTITION p06_aug_l VALUES LESS THAN (MAXVALUE)
  )
, PARTITION p_2006_sep VALUES LESS THAN (TO_DATE('01-OCT-2006','dd-MON-yyyy'))
  ( SUBPARTITION p06_sep_e VALUES LESS THAN (TO_DATE('15-OCT-2006','dd-MON-yyyy'))
  , SUBPARTITION p06_sep_a VALUES LESS THAN (TO_DATE('01-NOV-2006','dd-MON-yyyy'))
  , SUBPARTITION p06_sep_l VALUES LESS THAN (MAXVALUE)
  )
, PARTITION p_2006_oct VALUES LESS THAN (TO_DATE('01-NOV-2006','dd-MON-yyyy'))
  ( SUBPARTITION p06_oct_e VALUES LESS THAN (TO_DATE('15-NOV-2006','dd-MON-yyyy'))
  , SUBPARTITION p06_oct_a VALUES LESS THAN (TO_DATE('01-DEC-2006','dd-MON-yyyy'))
  , SUBPARTITION p06_oct_l VALUES LESS THAN (MAXVALUE)
  )
, PARTITION p_2006_nov VALUES LESS THAN (TO_DATE('01-DEC-2006','dd-MON-yyyy'))
  ( SUBPARTITION p06_nov_e VALUES LESS THAN (TO_DATE('15-DEC-2006','dd-MON-yyyy'))
  , SUBPARTITION p06_nov_a VALUES LESS THAN (TO_DATE('01-JAN-2007','dd-MON-yyyy'))
  , SUBPARTITION p06_nov_l VALUES LESS THAN (MAXVALUE)
  )
, PARTITION p_2006_dec VALUES LESS THAN (TO_DATE('01-JAN-2007','dd-MON-yyyy'))
  ( SUBPARTITION p06_dec_e VALUES LESS THAN (TO_DATE('15-JAN-2007','dd-MON-yyyy'))
  , SUBPARTITION p06_dec_a VALUES LESS THAN (TO_DATE('01-FEB-2007','dd-MON-yyyy'))
  , SUBPARTITION p06_dec_l VALUES LESS THAN (MAXVALUE)
  )
)
/
begin
	for i in 1..1000
	loop
		insert into OBJECT_TYPE4 values(
		i,
		to_date('01-FEB-2006','dd-MON-yyyy'),
		to_date('21-APR-2006','dd-MON-yyyy'),
		233,
		i+233
		);
	end loop;
	--commit;
end;
/

update OBJECT_TYPE4 set  order_id=order_id+1000
/
begin
	for i in 1..1000
	loop
		insert into OBJECT_TYPE4 values(
		i,
		to_date('01-DEC-2006','dd-MON-yyyy'),
		to_date('01-JAN-2007','dd-MON-yyyy'),
		233,
		i+233
		);
	end loop;
	--commit;
end;
/

update OBJECT_TYPE4 set sales_amount=12345
/
commit
/
truncate table object_Type4
/