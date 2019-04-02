DROP TABLE t1;
DROP SEQUENCE t1_seq;
 
CREATE TABLE t1 (
    ID NUMBER(10),
    DESCRIPTION VARCHAR2(50),
    CONSTRAINT t1_pk PRIMARY KEY (id));
 
CREATE SEQUENCE t1_seq;
 
INSERT INTO t1 VALUES (t1_seq.nextval, 'ONE');
INSERT INTO t1 VALUES (t1_seq.nextval, 'TWO');
INSERT INTO t1 VALUES (t1_seq.nextval, 'THREE');
INSERT INTO t1 VALUES (t1_seq.nextval, 'FOUR');
COMMIT;

SET SERVEROUTPUT ON
DECLARE
    v_id t1.id%TYPE;
BEGIN
    INSERT INTO t1
    VALUES (t1_seq.nextval, 'FOUR')
    RETURNING id INTO v_id;
    COMMIT;
    DBMS_OUTPUT.put_line('ID=' || v_id);
END;
/


SET SERVEROUTPUT ON
DECLARE
    v_id t1.id%TYPE;
BEGIN
    UPDATE t1
    SET description = description
    WHERE description = 'FOUR'
    RETURNING id INTO v_id;
    DBMS_OUTPUT.put_line('UPDATE ID=' || v_id);
 
    DELETE FROM t1
    WHERE description = 'FOUR'
    RETURNING id INTO v_id;
    DBMS_OUTPUT.put_line('DELETE ID=' || v_id);
    COMMIT;
END;
/

SET SERVEROUTPUT ON
DECLARE
    TYPE t_tab IS TABLE OF t1.id%TYPE;
    v_tab t_tab;
BEGIN
    UPDATE t1
    SET description = description
    RETURNING id BULK COLLECT INTO v_tab;
 
    FOR i IN v_tab.first .. v_tab.last LOOP
    DBMS_OUTPUT.put_line('UPDATE ID=' || v_tab(i));
    END LOOP;
 
COMMIT;
END;
/

