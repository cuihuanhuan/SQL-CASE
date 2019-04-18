--列表分区不支持多列，但是范围分区和哈希分区支持多列。
create table graderecord  
(  
  sno varchar2(10),  
  sname varchar2(20),  
  dormitory varchar2(3),  
  grade int  
)  
partition by range(grade)  
subpartition by hash(sno,sname)  
(partition p1 values less than(75)  
(subpartition sp1,subpartition sp2),  
partition p2 values less than(maxvalue)  
(subpartition sp3,subpartition sp4)  
); 
insert into graderecord values('511601','魁','229',92);  
insert into graderecord values('511602','凯','229',62);  
insert into graderecord values('511603','东','229',26);  
insert into graderecord values('511604','亮','228',77);  
insert into graderecord values('511605','敬','228',47);  
insert into graderecord(sno,sname,dormitory) values('511606','峰','228');  
insert into graderecord values('511607','明','240',90);  
insert into graderecord values('511608','楠','240',100);  
insert into graderecord values('511609','涛','240',67);  
insert into graderecord values('511610','博','240',75);  
insert into graderecord values('511611','铮','240',60);  
insert into graderecord values('511612','狸','244',72);  
insert into graderecord values('511613','杰','244',88);  
insert into graderecord values('511614','萎','244',19);  
insert into graderecord values('511615','猥','244',65);  
insert into graderecord values('511616','丹','244',59);  
insert into graderecord values('511617','靳','244',95);  
commit;
select * from graderecord partition(p1);  
select * from graderecord partition(p2);  
select * from graderecord subpartition(sp1);  
select * from graderecord subpartition(sp2);  
select * from graderecord subpartition(sp3);  
select * from graderecord subpartition(sp4);  