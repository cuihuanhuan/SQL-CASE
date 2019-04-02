--/opt/oracle/oradata/test.xml
--<?xml version="1.0" encoding="UTF-8" ?>
-- <collection xmlns="">
--  <record>
--    <leader>-----nam0-22-----^^^450-</leader>
--    <datafield tag="200" ind1="1" ind2=" ">
--      <subfield code="a">抗震救灾</subfield>
--        <subfield code="f">奥运会</subfield>
--    </datafield>
--    <datafield tag="209" ind1=" " ind2=" ">
--      <subfield code="a">经济学</subfield>
--        <subfield code="b">计算机</subfield>
--        <subfield code="c">10001</subfield>
--        <subfield code="d">2005-07-09</subfield>
--    </datafield>
--    <datafield tag="610" ind1="0" ind2=" ">
--        <subfield code="a">计算机</subfield>
--        <subfield code="a">笔记本</subfield>
--    </datafield>
--  </record>
-- </collection>
create table xmlexample(
 ID varchar2(10),
 name varchar2(20),
 data xmltype
 )
/

create or replace directory xml_dir as '/opt/oracle/oradata/'
/
--目录名用引号引起来,要大写
 insert into xmlexample(id,name,data)
 values(1,'my document',
        xmltype
        (
          bfilename('XML_DIR','test.xml'),
          nls_charset_id('AL32UTF8')
        )
 )
 /
 --extractvalue()函数的使用,Oracle提供对XML文件的检索功能（extractvalue），extractvalue只能返回一个节点的一个值
 select id,name,extractvalue(x.data,'/collection/record/leader') as A from xmlexample x;
 --extract()函数的使用,如果想查询所有subfield的值就要用到extract()，它可以返回一个节点下的所有值
 select id,name,extract(x.data,'/collection/record/datafield/subfield') as A from xmlexample x;
 --table和XMLSequence
 select extractValue(value(i),'/subfield') xx from xmlexample x,table(XMLSequence(extract(x.data,'/collection/record/datafield/subfield'))) i;
 --检索出特定的节点的特定值
 select id,name,extractvalue(x.data,'/collection/record/datafield[@tag="209"]/subfield[@code="a"]') as A from xmlexample x;
-- Oracle对与XMLType的操作有很多种，还要靠大家自己去发现。
-- 数据库对XML的检索就是吧XML的节点当作一个列来检索，而不同的是表里装的是二维的数据，而XML中可以装N维。
-- 还有就是，表中列不存在就会提示无效标识符，如果节点不存在，则检索出NULL，不会报错。
-- 所以，对与XML文件的操作通常是通过视图来完成。
 
 create table t1 (id number,xml_data sys.xmltype);
 insert into t1 values(1,'abc');
 insert into t1 values(1,'<abc>1</abc>');
 select * from t1;