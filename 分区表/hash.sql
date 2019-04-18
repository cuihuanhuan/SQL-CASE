--https://www.cnblogs.com/ledemi/p/6321939.html
--对于那些无法有效划分范围的表，可以使用hash分区，这样对于提高性能还是会有一定的帮助。
--hash分区会将表中的数据平均分配到你指定的几个分区中，列所在分区是依据分区列的hash值自动分配，
--因此你并不能控制也不知道哪条记录会被放到哪个分区中，
--hash分区也可以支持多个依赖列。
drop table t_partition_hash purge
/
create table t_partition_hash(id number,name varchar2(20))
partition by hash(id)(
partition t_hash_p1,
partition t_hash_p2,
partition t_hash_p3)
/
drop table t_partition_hash purge
/
create table t_partition_hash(id number,name varchar2(20))
partition by hash(id)
partitions 3 store in(users,users,users)
/
--这里分区数量和可供使用的表空间数量之间没有直接对应关系。 分区数并不一定要等于表 空间数。
drop table t_partition_hash purge
/
create table t_partition_hash(id number,name varchar2(20))
partition by hash(id)
partitions 3 store in(users,users,users,test)
/

create temporary tablespace test_temp tempfile '/u01/app/oracle/oradata/orcl/orclpdb/test_temp01.dbf'
/
select partition_name,high_value,tablespace_name from user_tab_partitions where table_name='T_PARTITION_HASH'
/

create index idx_part_hash_id on t_partition_hash(id) global partition by hash(id) partitions 3 store in(users,users,users)
/

select partition_name,tablespace_name from user_ind_partitions where index_name='IDX_PART_HASH_ID'
/
create index idx_part_hash_id on t_partition_hash(id) local
/
select partition_name,tablespace_name from user_ind_partitions where index_name='IDX_PART_HASH_ID'
/
--hash分区的local索引与range 分区的local索引一样，其local 索引的分区完全继承表的分区的属性。
--对于 global 索引分区而言，在 10g 中只能支持 range 分区和 hash 分区。
--对于 local 索引分区而言，其分区形式完全依赖于索引所在表的分区形式。
--注意，在创建索引时如果不显式指定 global 或 local ，则默认是 global 。
--注意，在创建 global 索引时如果不显式指定分区子句，则默认不分区 。
alter table t_partition_hash add partition t_hash_p4 tablespace users
/
select partition_name,tablespace_name from user_tab_partitions where table_name='T_PARTITION_HASH'
/
--收缩表分区
alter table t_partition_hash coalesce partition
/
select table_name,partition_name,tablespace_name,high_value from user_tab_partitions where table_name='T_PARTITION_HASH' order by partition_name
/