CREATE TABLE analytical_funcs_for_dates_tbl
(
conversation_start date,
conversation_end date
);

CREATE INDEX START_TIME_INDEX ON ANALYTICAL_FUNCS_FOR_DATES_TBL (CONVERSATION_START);

create or replace PACKAGE analytical_funcs_for_dates IS

procedure fill_table;

function get_conv_cnt_by_moment(i_hour number, i_minutes number, i_seconds number) return number;

function get_conv_cnt(i_date date) return number;

end;
/

create or replace PACKAGE BODY analytical_funcs_for_dates IS

function generate_day return date IS
begin
  return TO_DATE(
           TRUNC(
                   DBMS_RANDOM.VALUE(TO_CHAR(DATE '2018-01-01','J')
                                    ,TO_CHAR(DATE '2019-01-01','J')
                                    )
                    ),'J');
end;

function generate_hour24 return number IS
begin
  return trunc(DBMS_RANDOM.VALUE(0,24));
end;

function generate_min_or_sec return number IS
begin
  return trunc(DBMS_RANDOM.VALUE(0,60));
end;

function generate_min return number IS
begin
  return generate_min_or_sec;
end;

function generate_sec return number IS
begin
  return generate_min_or_sec;
end;

function generate_conversation_length return number is
begin
  return trunc(DBMS_RANDOM.VALUE(1,201));
end;

procedure generate_time (i_day IN date, o_start_date OUT date, o_end_date OUT date) IS
l_start_hour number;
l_start_minutes  number;
l_start_seconds  number;
l_start_char varchar2(30);
l_start_date date;
l_end_date date;
l_conversation_length number;
c_sec_in_min CONSTANT number := 60;
c_min_in_hour CONSTANT number := 60;
c_hour_in_day CONSTANT number := 24;
begin
  l_start_hour := generate_hour24;
  l_start_minutes := generate_min;
  l_start_seconds := generate_sec;
  
  l_start_char := to_char(i_day,'YYYY-MM-DD')||' '||l_start_hour||':'||l_start_minutes||':'||l_start_seconds;
  
  o_start_date := to_date(l_start_char,'YYYY-MM-DD HH24:MI:SS');
  
  l_conversation_length := generate_conversation_length;
  
  --dbms_output.put_line('conversation : '||l_conversation_length ||' sec');
  
  o_end_date := o_start_date + l_conversation_length * 1/c_hour_in_day/c_min_in_hour/c_sec_in_min;
  
end;

procedure generate_conversation(i_day date) IS
l_start_date date;
l_end_date date;
begin
  <<generate_time_lbl>>
  generate_time(
     i_day=>i_day
    ,o_start_date=>l_start_date
    ,o_end_date=>l_end_date
  );
  
  --dbms_output.put_line('begin :'||to_char(l_start_date,'YYYY-MM-DD HH24:MI:SS')|| 
  --' end : '||to_char(l_end_date,'YYYY-MM-DD HH24:MI:SS'));

  if to_char(l_end_date, 'YYYY-MM-DD') <> to_char(i_day,'YYYY-MM-DD') then
    dbms_output.put_line(to_char(l_end_date, 'YYYY-MM-DD')||' <> '||to_char(i_day,'YYYY-MM-DD'));
    goto generate_time_lbl;
  end if;

  begin
    INSERT INTO ANALYTICAL_FUNCS_FOR_DATES_TBL(CONVERSATION_START, CONVERSATION_END) VALUES (l_start_date, l_end_date);
  EXCEPTION WHEN others THEN
       dbms_output.put_line(SQLCODE||SQLERRM);
  end;

end;

procedure fill_table IS
l_day date;
l_conv_count CONSTANT number :=  trunc(dbms_random.value(1000,2001));
begin
  l_day := generate_day;

  dbms_output.put_line(to_char(l_conv_count));
  --dbms_output.put_line(to_char(l_day,'YYYY-MM-DD'));

  for i in 1 .. l_conv_count loop
    generate_conversation(l_day);
  end loop;
  commit;
end;

--потому, что по условиям задачи в таблице данные только за один день, я беру первую строку (начало разговора) и выбираю первую попавшуюся строку
function get_day return varchar2 is
l_date date;
begin
  begin
    select CONVERSATION_START into l_date from ANALYTICAL_FUNCS_FOR_DATES_TBL where rownum = 1;
    EXCEPTION WHEN others THEN
       dbms_output.put_line(SQLERRM);
  end; 
  
  return to_char(l_date,'YYYY-MM-DD');
end;

function is_time_correct(i_hour number, i_minutes number, i_seconds number) return boolean is
begin
  if ((not i_seconds between 0 and 59) or (i_seconds is NULL)) then return false;
  end if;
  
  if ((not i_minutes between 0 and 59) or (i_minutes is NULL)) then return false;
  end if;
  
  if ((not i_hour between 0 and 23) or (i_hour is NULL)) then return false;
  end if;
  
  return true;
end;

function get_conv_cnt(i_date date) return number IS
  l_conv_cnt number;
begin
  dbms_output.put_line(to_char(i_date, 'YYYY-MM-DD HH24:MI:SS'));
  select count(*) into l_conv_cnt from ANALYTICAL_FUNCS_FOR_DATES_TBL t where i_date between t.CONVERSATION_START and CONVERSATION_END;  
  return l_conv_cnt;
end;

--если время задано некорректно возвращаем  -1, иначе - количество разговоров в заданное время
function get_conv_cnt_by_moment(i_hour number, i_minutes number, i_seconds number) return number IS
l_day varchar2(30);
time_is_not_correct constant number := -1;
l_is_time_correct boolean;
begin
  l_day := get_day;
  dbms_output.put_line(l_day);
  l_is_time_correct := is_time_correct(i_hour, i_minutes, i_seconds); 
  if (not l_is_time_correct) then return time_is_not_correct;
  end if;
  
  return get_conv_cnt(to_date(l_day||' '||i_hour||':'||i_minutes||':'||i_seconds,'YYYY-MM-DD HH24:MI:SS'));

end;

end analytical_funcs_for_dates;
/

BEGIN
  ANALYTICAL_FUNCS_FOR_DATES.FILL_TABLE();
END;

select max(analytical_funcs_for_dates.get_conv_cnt(t.CONVERSATION_START)) max_conv_cnt
    from ANALYTICAL_FUNCS_FOR_DATES_TBL t;
