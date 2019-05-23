create table analytical_funcs_first_tbl(
  LINE_NUM number
  ,NUM1 number
  ,NUM2 number
  ,NUM3 number
  ,CONSTRAINT check_num1
  CHECK (NUM1 BETWEEN 1 and 100)
  ,CONSTRAINT check_num2
  CHECK (NUM1 BETWEEN 1 and 100)
  ,CONSTRAINT check_num3
  CHECK (NUM1 BETWEEN 1 and 100)
  );

create or replace PACKAGE BODY analytical_funcs_first IS

function generate_number(i_num_name varchar2) return number IS
l_num number;
begin
  l_num := trunc(dbms_random.value(1,101));
  --dbms_output.put_line(i_num_name||':='||l_num);
  return l_num;
end;

procedure generate_four_nums(o_num1 OUT number, o_num2 OUT number, o_num3 OUT number) IS
  l_num1 number;
  l_num2 number;
  l_num3 number;
begin
    l_num1 :=  generate_number('l_num1');
    --------------------------------------------------------
    <<generate_num_2>> l_num2 :=  generate_number('l_num2');
    
    if (l_num1 = l_num2) then
    begin 
      --dbms_output.put_line('l_num1:=l_num2');
      goto generate_num_2;  
    end;
    end if;
    --------------------------------------------------------
    <<generate_num_3>> l_num3 :=  generate_number('l_num3');

    if (l_num1 = l_num3) then
    begin 
      --dbms_output.put_line('l_num1:=l_num3');
      goto generate_num_3;  
    end;
    end if;
    
    if (l_num2 = l_num3) then
    begin 
      --dbms_output.put_line('l_num2:=l_num3');
      goto generate_num_3;  
    end;
    end if;

  o_num1 := l_num1;
  o_num2 := l_num2;
  o_num3 := l_num3;
end;
/

procedure fill_table IS
  l_row_count CONSTANT number := trunc(dbms_random.value(1000,2001));
  l_num1 number;
  l_num2 number;
  l_num3 number;
begin
  dbms_output.put_line(l_row_count);
  for l_row_num in 1..l_row_count loop
    --dbms_output.put_line('************************l_row_num:='||l_row_num||'************************');
    generate_four_nums(l_num1, l_num2, l_num3);
    --dbms_output.put_line('l_num1:='||l_num1||' l_num2:='||l_num2||' l_num3:='||l_num3);
    BEGIN
      INSERT INTO analytical_funcs_first_tbl(LINE_NUM, NUM1,NUM2,NUM3) VALUES
        (l_row_num, l_num1,l_num2,l_num3);
      EXCEPTION WHEN others THEN
       dbms_output.put_line(SQLERRM);
    END;
    commit;
  end loop;
end;

end analytical_funcs_first;
/

BEGIN
  ANALYTICAL_FUNCS_FIRST.FILL_TABLE();

END;

select
LINE_NUM
,NUM1
,case  
  when LINE_NUM = 1 then lead(NUM2) OVER(ORDER BY LINE_NUM)
  when LINE_NUM = max_line_num then lag(NUM2) OVER (ORDER BY LINE_NUM)
  when mod(LINE_NUM,2) = 0 then lag(NUM2) OVER (ORDER BY LINE_NUM)
  when mod(LINE_NUM,2) = 1 then lead(NUM2) OVER (ORDER BY LINE_NUM)
  end agr1
,NUM2 -- only for test, you may comment out this line
,case  
  when LINE_NUM = 1 then lead(NUM3) OVER(ORDER BY LINE_NUM)
  when LINE_NUM = max_line_num then lag(NUM3) OVER (ORDER BY LINE_NUM)
  when mod(LINE_NUM,2) = 0 then lead(NUM3) OVER (ORDER BY LINE_NUM)
  when mod(LINE_NUM,2) = 1 then lag(NUM3) OVER (ORDER BY LINE_NUM)
  end agr2
,NUM3 -- only for test, you may comment out this line
FROM (select max(line_num) max_line_num from analytical_funcs_first_tbl) maximum, analytical_funcs_first_tbl;
