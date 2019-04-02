Create Directory  MYDIR As '/opt/oracle/oradata';


Create Table blobTest(
 filename varchar2(200),
 filedesc varchar2(200),
 filebody blob
);

Create Or Replace Procedure Proc_loadBlob(p_filename varchar2,p_filedesc varchar2)
Is
 src_file bfile;
 dst_file BLOB;
 lgh_file binary_integer;
Begin
 --src_file := bfilename('BlobFile',p_filename);
 src_file := bfilename('MYDIR',p_filename);
 
 insert into blobTest(filename,filedesc,filebody)
  values (p_filename,p_filedesc,EMPTY_BLOB())
   returning filebody into dst_file;
 
 dbms_lob.fileopen(src_file,dbms_lob.file_readonly);
 lgh_file := dbms_lob.getlength(src_file);
 dbms_lob.loadfromfile(dst_file,src_file,lgh_file);
 
 update blobTest
 set filebody = dst_file
 where filename = p_filename;
 
 dbms_lob.fileclose(src_file);
End Proc_loadBlob;
/
Show Err;

exec Proc_loadBlob('IMG_0210.JPG','scenery');
select * from blobTest;