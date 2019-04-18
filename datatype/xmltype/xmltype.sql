--https://docs.oracle.com/cd/B10500_01/appdev.920/a96620/xdb04cre.htm
drop table po_xtab purge
/
CREATE TABLE po_xtab of XMLType
/
INSERT INTO po_xtab  VALUES 
(XMLType('<Warehouse whNo="100"> 
               <Building>Owned</Building>
</Warehouse>'))
/
commit
/
create table t2 ( f1 int, f2 sys.xmltype, f3 int, f4 int, f5 int )
/
delete from t2
/
insert into t2 values ( 1, '<xml1>Hello</xml1>', 3,4,5 )
/
insert into t2 values ( 2, '<xml1>Hello</xml1>', 3,4,5 )
/
commit
/