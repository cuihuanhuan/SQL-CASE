--没有模板的创建方式
create table MobileMessage  
(  
 ACCT_MONTH VARCHAR2(6), -- 帐期 格式：年月 YYYYMM  
 AREA_NO VARCHAR2(10), -- 地域号码   
 DAY_ID VARCHAR2(2), -- 本月中的第几天 格式 DD  
 SUBSCRBID VARCHAR2(20), -- 用户标识   
 SVCNUM VARCHAR2(30) -- 手机号码  
)  
partition by range(ACCT_MONTH,AREA_NO) subpartition by list(DAY_ID)  
(  
  partition p1 values less than('200705','012')  
  (  
    subpartition shangxun1 values('01','02','03','04','05','06','07','08','09','10'),  
    subpartition zhongxun1 values('11','12','13','14','15','16','17','18','19','20'),  
    subpartition xiaxun1 values('21','22','23','24','25','26','27','28','29','30','31')  
  ),  
  partition p2 values less than('200709','014')  
  (  
    subpartition shangxun2 values('01','02','03','04','05','06','07','08','09','10'),  
    subpartition zhongxun2 values('11','12','13','14','15','16','17','18','19','20'),  
    subpartition xiaxun2 values('21','22','23','24','25','26','27','28','29','30','31')  
  ),  
  partition p3 values less than('200801','016')  
  (  
    subpartition shangxun3 values('01','02','03','04','05','06','07','08','09','10'),  
    subpartition zhongxun3 values('11','12','13','14','15','16','17','18','19','20'),  
    subpartition xiaxun3 values('21','22','23','24','25','26','27','28','29','30','31')  
  )  
)
/
insert into MobileMessage values('200701','010','04','ghk001','13800000000');  
insert into MobileMessage values('200702','015','12','myx001','13633330000');  
insert into MobileMessage values('200703','015','24','hjd001','13300000000');  
insert into MobileMessage values('200704','010','04','ghk001','13800000000');  
insert into MobileMessage values('200705','010','04','ghk001','13800000000');  
insert into MobileMessage values('200705','011','18','sxl001','13222000000');  
insert into MobileMessage values('200706','011','21','sxl001','13222000000');  
insert into MobileMessage values('200706','012','11','tgg001','13800044400');  
insert into MobileMessage values('200707','010','04','ghk001','13800000000');  
insert into MobileMessage values('200708','012','24','tgg001','13800044400');  
insert into MobileMessage values('200709','014','29','zjj001','13100000000');  
insert into MobileMessage values('200710','014','29','zjj001','13100000000');  
insert into MobileMessage values('200711','014','29','zjj001','13100000000');  
insert into MobileMessage values('200711','013','30','wgc001','13444000000');  
insert into MobileMessage values('200712','013','30','wgc001','13444000000');  
insert into MobileMessage values('200712','010','30','ghk001','13800000000');  
insert into MobileMessage values('200801','015','22','myx001','13633330000');  
commit;
select * from MobileMessage;  

--包含模板的（比较繁琐，但是更加精确，处理海量存储数据十分必要）
drop table MobileMessage purge;
create table MobileMessage
(  
 ACCT_MONTH VARCHAR2(6), -- 帐期 格式：年月 YYYYMM  
 AREA_NO VARCHAR2(10), -- 地域号码  
 DAY_ID VARCHAR2(2), -- 本月中的第几天 格式 DD  
 SUBSCRBID VARCHAR2(20), -- 用户标识   
 SVCNUM VARCHAR2(30) -- 手机号码  
)  
partition by range(ACCT_MONTH,AREA_NO) subpartition by list(DAY_ID)  
subpartition template  
(  
 subpartition sub1 values('01'),subpartition sub2 values('02'),  
 subpartition sub3 values('03'),subpartition sub4 values('04'),  
 subpartition sub5 values('05'),subpartition sub6 values('06'),  
 subpartition sub7 values('07'),subpartition sub8 values('08'),  
 subpartition sub9 values('09'),subpartition sub10 values('10'),  
 subpartition sub11 values('11'),subpartition sub12 values('12'),  
 subpartition sub13 values('13'),subpartition sub14 values('14'),  
 subpartition sub15 values('15'),subpartition sub16 values('16'),  
 subpartition sub17 values('17'),subpartition sub18 values('18'),  
 subpartition sub19 values('19'),subpartition sub20 values('20'),  
 subpartition sub21 values('21'),subpartition sub22 values('22'),  
 subpartition sub23 values('23'),subpartition sub24 values('24'),  
 subpartition sub25 values('25'),subpartition sub26 values('26'),  
 subpartition sub27 values('27'),subpartition sub28 values('28'),  
 subpartition sub29 values('29'),subpartition sub30 values('30'),  
 subpartition sub31 values('31')  
)  
(  
  partition p_0701_010 values less than('200701','011'),  
  partition p_0701_011 values less than('200701','012'),  
  partition p_0701_012 values less than('200701','013'),  
  partition p_0701_013 values less than('200701','014'),  
  partition p_0701_014 values less than('200701','015'),  
  partition p_0701_015 values less than('200701','016'),  
  partition p_0702_010 values less than('200702','011'),  
  partition p_0702_011 values less than('200702','012'),  
  partition p_0702_012 values less than('200702','013'),  
  partition p_0702_013 values less than('200702','014'),  
  partition p_0702_014 values less than('200702','015'),  
  partition p_0702_015 values less than('200702','016'),  
  partition p_0703_010 values less than('200703','011'),  
  partition p_0703_011 values less than('200703','012'),  
  partition p_0703_012 values less than('200703','013'),  
  partition p_0703_013 values less than('200703','014'),  
  partition p_0703_014 values less than('200703','015'),  
  partition p_0703_015 values less than('200703','016'),    
  partition p_0704_010 values less than('200704','011'),  
  partition p_0704_011 values less than('200704','012'),  
  partition p_0704_012 values less than('200704','013'),  
  partition p_0704_013 values less than('200704','014'),  
  partition p_0704_014 values less than('200704','015'),  
  partition p_0704_015 values less than('200704','016'),    
  partition p_0705_010 values less than('200705','011'),  
  partition p_0705_011 values less than('200705','012'),  
  partition p_0705_012 values less than('200705','013'),  
  partition p_0705_013 values less than('200705','014'),  
  partition p_0705_014 values less than('200705','015'),  
  partition p_0705_015 values less than('200705','016'),    
  partition p_0706_010 values less than('200706','011'),  
  partition p_0706_011 values less than('200706','012'),  
  partition p_0706_012 values less than('200706','013'),  
  partition p_0706_013 values less than('200706','014'),  
  partition p_0706_014 values less than('200706','015'),  
  partition p_0706_015 values less than('200706','016'),    
  partition p_0707_010 values less than('200707','011'),  
  partition p_0707_011 values less than('200707','012'),  
  partition p_0707_012 values less than('200707','013'),  
  partition p_0707_013 values less than('200707','014'),  
  partition p_0707_014 values less than('200707','015'),  
  partition p_0707_015 values less than('200707','016'),    
  partition p_0708_010 values less than('200708','011'),  
  partition p_0708_011 values less than('200708','012'),  
  partition p_0708_012 values less than('200708','013'),  
  partition p_0708_013 values less than('200708','014'),  
  partition p_0708_014 values less than('200708','015'),  
  partition p_0708_015 values less than('200708','016'),    
  partition p_0709_010 values less than('200709','011'),  
  partition p_0709_011 values less than('200709','012'),  
  partition p_0709_012 values less than('200709','013'),  
  partition p_0709_013 values less than('200709','014'),  
  partition p_0709_014 values less than('200709','015'),  
  partition p_0709_015 values less than('200709','016'),    
  partition p_0710_010 values less than('200710','011'),  
  partition p_0710_011 values less than('200710','012'),  
  partition p_0710_012 values less than('200710','013'),  
  partition p_0710_013 values less than('200710','014'),  
  partition p_0710_014 values less than('200710','015'),  
  partition p_0710_015 values less than('200710','016'),    
  partition p_0711_010 values less than('200711','011'),  
  partition p_0711_011 values less than('200711','012'),  
  partition p_0711_012 values less than('200711','013'),  
  partition p_0711_013 values less than('200711','014'),  
  partition p_0711_014 values less than('200711','015'),  
  partition p_0711_015 values less than('200711','016'),    
  partition p_0712_010 values less than('200712','011'),  
  partition p_0712_011 values less than('200712','012'),  
  partition p_0712_012 values less than('200712','013'),  
  partition p_0712_013 values less than('200712','014'),  
  partition p_0712_014 values less than('200712','015'),  
  partition p_0712_015 values less than('200712','016'),    
  partition p_0801_010 values less than('200801','011'),  
  partition p_0801_011 values less than('200801','012'),  
  partition p_0801_012 values less than('200801','013'),  
  partition p_0801_013 values less than('200801','014'),  
  partition p_0801_014 values less than('200801','015'),  
  partition p_0801_015 values less than('200801','016'),    
  partition p_other values less than(maxvalue, maxvalue)  
); 

insert into MobileMessage values('200701','010','04','ghk001','13800000000');  
insert into MobileMessage values('200702','015','12','myx001','13633330000');  
insert into MobileMessage values('200703','015','24','hjd001','13300000000');  
insert into MobileMessage values('200704','010','04','ghk001','13800000000');  
insert into MobileMessage values('200705','010','04','ghk001','13800000000');  
insert into MobileMessage values('200705','011','18','sxl001','13222000000');  
insert into MobileMessage values('200706','011','21','sxl001','13222000000');  
insert into MobileMessage values('200706','012','11','tgg001','13800044400');  
insert into MobileMessage values('200707','010','04','ghk001','13800000000');  
insert into MobileMessage values('200708','012','24','tgg001','13800044400');  
insert into MobileMessage values('200709','014','29','zjj001','13100000000');  
insert into MobileMessage values('200710','014','29','zjj001','13100000000');  
insert into MobileMessage values('200711','014','29','zjj001','13100000000');  
insert into MobileMessage values('200711','013','30','wgc001','13444000000');  
insert into MobileMessage values('200712','013','30','wgc001','13444000000');  
insert into MobileMessage values('200712','010','30','ghk001','13800000000');  
insert into MobileMessage values('200801','015','22','myx001','13633330000');  
commit;
select * from MobileMessage partition(p_0701_010);  
--说明：对待分区的操作同样可以对待子分区，效果一样。删除一个分区会同时删除其下的子分区。合并多个分区也会把他们的子分区自动合并。分裂分区时注意分裂点。
--另外不带模板子分区和带有模板子分区的分区表操作的区别：带有子分区模板的分区表在添加分区时候自动添加子分区，不带模板子分区的分区表没有这个功能；带有子分区模板的分区表在更改分区时只需更改分区，不带模板子分区的分区表在更改分区时一定注意连同子分区一起更改。