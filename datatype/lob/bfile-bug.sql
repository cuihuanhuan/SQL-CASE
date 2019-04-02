drop Directory MYDIR
/
Create Directory  MYDIR As '/opt/oracle/oradata'
/
drop table Lob_table purge
/
CREATE TABLE Lob_table (
   Key_value NUMBER NOT NULL,
   F_lob BFILE)
/
INSERT INTO Lob_table VALUES(21,  BFILENAME('MYDIR', 'IMG_0210.JPG'))
/
commit
/
SELECT F_LOB FROM LOB_TABLE
/

UPDATE Lob_table SET f_lob = BFILENAME('MYDIR', 'IMG_0211.JPG') WHERE Key_value = 21;
commit;
