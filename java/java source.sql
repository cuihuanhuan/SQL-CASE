--http://www.php.cn/mysql-tutorials-126223.html
drop  java source sayhi
 /
 create or replace and compile java source named sayhi
AS
public class sayhello
{
 public static void msg(String[] args)
 {
  System.out.println("old,");
 }
}
/
--用例一
--创建Java Source
 drop  java source sayhi
 /
 create or replace and compile java source named sayhi
AS
public class sayhello
{
 public static void msg(String[] args)
 {
  System.out.println("cuihuanhuan-new,");
 }
}
/
--创建存储过程 ，调用Java Source
set serveroutput on;

create or replace procedure testjava
as
language java
name 'sayhello.msg(java.lang.String [])';
/
--调用存储过程
begin

  dbms_java.set_output(2000); ---设置Java输出缓冲区大小，否则无法输出数据

  testjava;             ---调用存储过程

end;
/

--用例二

CREATE OR REPLACE AND COMPILE JAVA SOURCE NAMED OracleJavaProc

AS

public class OracleJavaProc

{

  public static void main(String[] args) 

    {

        System.out.println("Hello World!");

    }

}
/
CREATE OR REPLACE PROCEDURE testoraclejava

AS

LANGUAGE JAVA

NAME 'OracleJavaProc.main(java.lang.String [])';
/
begin

  dbms_java.set_output(2000); ---设置Java输出缓冲区大小，否则无法输出数据

  testoraclejava;             ---调用存储过程

end;
/