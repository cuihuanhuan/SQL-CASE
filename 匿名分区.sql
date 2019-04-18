drop table object_type purge
			/
			create table object_type ( oid NUMBER primary key, otype VARCHAR2(19), created DATE )
			partition by range ( created )
			subpartition by hash (oid)
			subpartitions 2 (
			  partition P1 values less than (to_date('2002-12-31','YYYY-MM-DD')),
			  partition P2 values less than (to_date('2003-12-31','YYYY-MM-DD')),
			  partition P3 values less than (to_date('2004-12-31','YYYY-MM-DD')),
			  partition P4 values less than (to_date('2005-12-31','YYYY-MM-DD'))
			)
			/
alter table object_type modify partition p1 add subpartition p1_sub_new
/
select subpartition_name from user_tab_subpartitions where table_name='OBJECT_TYPE' order by subpartition_name;
/
begin	
	for i in 100..3000
		loop
			insert into object_type values(i,'info2soft',to_date('2002-10-01','YYYY-MM-DD'));
		end loop;
		commit;
	end;
/
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

select OBJ#,DATAOBJ#,NAME FROM OBJ$ WHERE NAME='OBJECT_TYPE';
select OBJ#,DATAOBJ#,NAME FROM OBJ$ WHERE DATAOBJ#=257697