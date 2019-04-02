drop table admin_iot purge
/
CREATE OR REPLACE TYPE admin_typ AS OBJECT
    (col1 NUMBER, col2 VARCHAR2(6));
CREATE TABLE admin_iot (c1 NUMBER primary key, c2 admin_typ)
    ORGANIZATION INDEX;
   CREATE TABLE admin_iot5(i INT, j INT, k INT, l INT, PRIMARY KEY (i, j, k)) 
    ORGANIZATION INDEX COMPRESS; 
ALTER TABLE admin_iot5 MOVE NOCOMPRESS;
ALTER TABLE admin_docindex MOVE;

ALTER TABLE admin_iot5 MOVE;
ALTER TABLE admin_iot5 MOVE ONLINE;
CREATE TABLE admin_iot5(i INT, j INT, k INT, l INT, PRIMARY KEY (i, j, k)) 
    ORGANIZATION INDEX COMPRESS;
CREATE INDEX admin_iot5_index on admin_iot5(l);