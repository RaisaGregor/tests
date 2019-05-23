create table dept(
  DEPTNO NUMBER NOT NULL,
  DNAME VARCHAR2(14),
  LOC VARCHAR2(13) 
  );

CREATE INDEX DEPTNO_INDEX ON dept(DEPTNO);

create or replace package dept_pkg AS

TYPE t_dept_row IS record (
   DEPTNO	NUMBER
  ,DNAME	VARCHAR2(14)
  ,LOC	VARCHAR2(13)
);

TYPE t_dept_tab IS TABLE OF t_dept_row;

procedure fill_dept(i_row_count IN number default 100);

FUNCTION get_dept (i_deptno_min IN NUMBER default 0, i_deptno_max IN NUMBER default 0) RETURN t_dept_tab PIPELINED;

end dept_pkg;
/

create or replace package body dept_pkg AS

procedure fill_dept(i_row_count IN number default 100) IS
l_type_str CONSTANT varchar2(1) :=  'a';
l_dname_len CONSTANT number := 14;
l_loc_len CONSTANT number := 13;
begin
  for i IN 1..i_row_count loop
  begin
    INSERT INTO DEPT(DEPTNO, DNAME, LOC) VALUES (i, DBMS_RANDOM.STRING(l_type_str, l_dname_len), DBMS_RANDOM.STRING(l_type_str, l_loc_len) );
    EXCEPTION when others then dbms_output.put_line(SQLCODE||SQLERRM);
  end;
  end loop;
  commit;
end;

FUNCTION get_dept (i_deptno_min IN NUMBER default 0, i_deptno_max IN NUMBER default 0) RETURN t_dept_tab PIPELINED
AS
BEGIN
  FOR dept_curr IN (SELECT * FROM dept WHERE DEPTNO >= i_deptno_min AND DEPTNO <= i_deptno_max) LOOP
    pipe row (dept_curr);
  END LOOP;
END;

end dept_pkg;
/


--test

DECLARE
  I_ROW_COUNT NUMBER;
BEGIN
  I_ROW_COUNT := 100;

  DEPT_PKG.FILL_DEPT(
    I_ROW_COUNT => I_ROW_COUNT
  );
 
END;

select * from table(dept_pkg.get_dept(4,50));

select * from table(dept_pkg.get_dept);
