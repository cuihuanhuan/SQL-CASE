Create Table MyLob
(
     no number(8) primary key,
     fname varchar2(30),
     myfile blob
);
--先插入普通数据，遇到大对象列使用empty_blob()构造空的指针。
Insert Into MyLob Values(1,'IMG_0210.JPG',empty_blob());
commit;
--创建逻辑目录MYDIR
Create Directory  MYDIR As '/opt/oracle/oradata';


Declare 
    varB blob;
    varF Bfile;
Begin
    --声明一个BLOB类型变量，使用select into 语句让其指向到empty_blob()构造空的指针所指向的存储空间
    select myfile into varB from MyLob where no = 1 for update;
    --声明一个BFile类型变量，关联逻辑目录和物理目录文件，使用 BFileName() 将其指向到待存储的文件。
    varF := bfileName('MYDIR','IMG_0210.JPG');
    --使用DBMS_LOB.open()方法将BFile类型变量所指向的文件打开
    DBMS_LOB.open(varF);
    --使用DBMS_LOB.loadfromfile()方法将BFile类型变量所指向的文件读入到BLOB类型变量所指向的存储空间
    DBMS_LOB.loadfromfile(varB,varF,DBMS_LOB.getlength(varF));
    --使用DBMS_LOB.close()方法将bfile的变量所指向的文件关闭
    DBMS_LOB.close(varF);
    
End;
savepoint p2;
commit;


 Create Or Replace Procedure setBLOB(vFileName varchar2)
  As
     varF bfile;
     varB blob;
     vno number(8);
  Begin
     varF := BFilename('MYDIR',vFileName);
     DBMS_LOB.Open(varF);
     select max(no) into vno from myLob;
     if vno is null then
       vno := 1;
     else
       vno := vno + 1;
     end if;
     insert into myLob values(vno,vFileName,empty_blob());
     select myFile into varB from myLob where no = vno for update;
     DBMS_LOB.loadfromfile(varB,varF,DBMS_LOB.getlength(varF));
     DBMS_LOB.close(varF);
     commit;
  End;
  
EXEC setBLOB('IMG_0210.JPG');

select DBMS_LOB.getlength(myfile) from mylob;

set serveroutput on;

Declare 
    varB blob;
Begin
    select myfile into varB from myLob where no = 2;
    DBMS_OUTPUT.PUT_LINE('长度为: '||DBMS_LOB.getlength(varB));
End;

select dbms_lob.substr(myfile,2000) from myLob;

  