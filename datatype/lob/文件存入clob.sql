drop table clobTest purge
/
Create Table clobTest(
 filename varchar2(200),
 filedesc varchar2(200),
 filebody clob
);
drop procedure getClobDocument
create or replace function getClobDocument(filename in varchar2, charset in varchar2 default NULL)

return CLOB deterministic 
is 
 file  bfile := bfilename('MYDIR',filename);    
 charContent     CLOB := ' ';    
 targetFile      bfile;    
 lang_ctx        number := DBMS_LOB.default_lang_ctx;    
 charset_id      number := 0;    
 src_offset      number := 1 ;    
 dst_offset      number := 1 ;    
 warning         number; 
 begin   if charset is not null then       
  charset_id := NLS_CHARSET_ID(charset);   
 end if;   
 targetFile := file;   
  insert into clobTest(filename,filedesc,filebody)
  values ('INS','PDF',EMPTY_CLOB());
 DBMS_LOB.fileopen(targetFile, DBMS_LOB.file_readonly);   
 DBMS_LOB.LOADCLOBFROMFILE(charContent, targetFile, DBMS_LOB.getLength(targetFile), src_offset,dst_offset,charset_id, lang_ctx,warning);  
 update clobTest set filebody=charContent;commit;
 
 DBMS_LOB.fileclose(targetFile);   

return charContent; 
end; 
/
show error
/


set serveroutput on
/
declare
 charContent     CLOB := ' ';   
begin
charContent :=getClobDocument('INS.pdf');
end;
/
select * from clobTest


create table txt_docs(doc_num number,doc_nm varchar2(100),doc_clb clob,ins_ts timestamp);

create sequence doc_seq;

declare
src_clb bfile;
dst_clb clob;
src_doc_nm varchar2(100) :='iawork_2018-09-12.log';
src_offset integer :=1;
dst_offset integer :=1;
lang_ctx integer := dbms_lob.default_lang_ctx;
warning_msg number;
begin
src_clb:=bfilename('MYDIR',src_doc_nm);
insert into txt_docs(doc_num,doc_nm,doc_clb,ins_ts) values(doc_seq.nextval,src_doc_nm,empty_clob(),systimestamp) returning doc_clb into dst_clb;
dbms_lob.open(src_clb,dbms_lob.lob_readonly);
dbms_lob.loadclobfromfile(dest_lob=>dst_clb,src_bfile=>src_clb,amount=>dbms_lob.lobmaxsize,dest_offset=>dst_offset,src_offset=>src_offset,bfile_csid=>dbms_lob.default_csid,lang_context=>lang_ctx,warning=>warning_msg);
dbms_lob.close(src_clb);
commit;
dbms_output.put_line('Wrote clob to table:'||src_doc_nm);
end;
/
show error
/
select * from txt_docs;