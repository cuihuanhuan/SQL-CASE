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
SUBPARTITION BY HASH (customer_id)
( PARTITION p_northwest VALUES ('OR', 'WA')
, PARTITION p_southwest VALUES ('AZ', 'UT', 'NM')
, PARTITION p_northeast VALUES ('NY', 'VM', 'NJ')
, PARTITION p_southeast VALUES ('FL', 'GA')
, PARTITION p_northcentral VALUES ('SD', 'WI')
, PARTITION p_southcentral VALUES ('OK', 'TX')
)
/
alter table accounts add partition p_add values ('KK', 'TT')
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

update accounts set branch_id=201708 where id > 3
/
commit
/

update accounts set branch_id=201708 where id > 3
/
commit
/

alter table accounts rename partition p_southcentral to p_sc
/

alter table accounts rename subpartition  pp_southcentral_sub to p_sc_sub
/
alter table accounts merge partitions p_northcentral,p_southcentral into partition p_central
/
ALTER TABLE accounts SPLIT PARTITION p_southcentral VALUES ('OK') INTO (
                  PARTITION p_southcentral_1 TABLESPACE users,
                  PARTITION p_southcentral_2 TABLESPACE system  )
/
DROP TABLE SWAP_T PURGE
/
CREATE TABLE swap_t
( id             NUMBER primary key
, account_number NUMBER
, customer_id    NUMBER
, balance        NUMBER
, branch_id      NUMBER
, region         VARCHAR(2)
, status         VARCHAR2(1)
) PARTITION BY HASH (customer_id)
/

insert into swap_t values(11111,11,101,1001,10001,'SD','B')
/
insert into swap_t values(11112,12,102,1002,10002,'SD','B')
/
insert into swap_t values(11113,13,103,1003,10003,'SD','A')
/
insert into swap_t values(11114,14,104,1004,10004,'SD','A')
/
insert into swap_t values(11115,15,105,1005,10005,'SD','G')
/
insert into swap_t values(11116,16,106,1006,10006,'SD','G')
/
commit
/
ALTER TABLE accounts EXCHANGE PARTITION p_northcentral WITH TABLE swap_t
/ 
alter table accounts drop partition p_southcentral
/
alter table accounts modify partition p_southcentral add subpartition pp_southcentral_sub values (105)
/