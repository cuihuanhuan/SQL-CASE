CREATE OR REPLACE PACKAGE PACK_ZOO IS
        /* 不带参数的存储过程 */
        PROCEDURE WATCH_MONKEY;
        /* 带参数的存储过程 */
        PROCEDURE FEED_MONKEY(p_food IN VARCHAR2, p_amount IN NUMBER);
END PACK_ZOO;
/
CREATE OR REPLACE PACKAGE BODY PACK_ZOO IS
      /*
        * 不带参数的存储过程
        */
      PROCEDURE WATCH_MONKEY IS
          /* 参数声明 */
          name VARCHAR2(12);
          BEGIN
          /* 处理体 */
             name:='xx';
          /* 异常处理 */
          EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                      DBMS_OUTPUT.PUT_LINE('NO RECORD');
                 WHEN OTHERS THEN
                      DBMS_OUTPUT.PUT_LINE('CODE:' + sqlcode);  --sqlcode代表异常代码
                      DBMS_OUTPUT.PUT_LINE('MSG:' + sqlerrm);  --sqlerrm代表异常信息

        END WATCH_MONKEY;
/*
        *带参数的存储过程
        */
       PROCEDURE FEED_MONKEY(p_food IN VARCHAR2, p_amount IN NUMBER) IS
          /* 参数声明 */
          name VARCHAR2(12);
       BEGIN
          /* 处理体 */
          name := 'Hello Oracle';
          /* 异常处理 */
          EXCEPTION
             WHEN NO_DATA_FOUND THEN
                  DBMS_OUTPUT.put_line('CATCH EXCEPTIOIN');
             WHEN OTHERS THEN
                  DBMS_OUTPUT.PUT_LINE('CODE:' + sqlcode);  --sqlcode代表异常代码
                  DBMS_OUTPUT.PUT_LINE('MSG:' + sqlerrm);  --sqlerrm代表异常信息

       END FEED_MONKEY;
END PACK_ZOO;
/




CREATE OR REPLACE PACKAGE pk_a
IS
procedure p_test(i_name in varchar2,o_result out varchar2);
end pk_a;
/
--body功能实现部分:
CREATE OR REPLACE PACKAGE body pk_a
IS
procedure p_test(i_name in varchar2,o_result out varchar2)
is
begin
dbms_output.put_line('输入参数为：'||i_name);
o_result := i_name;
end;
end pk_a;
--调用新添加
/