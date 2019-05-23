create or replace PACKAGE xml_transformation IS

function xml_constant_col_cnt(i_row_count number default 2, i_col_count number default 4) return xmltype;

function xml_random_col_cnt(i_row_count number default 2) return xmltype;

end xml_transformation;
/

create or replace PACKAGE body xml_transformation IS

function create_col(i_row_num number, i_col_num number) return varchar2 IS
begin
  return '    <col>v'||i_row_num||i_col_num||'</col>';
end;

function create_row(i_col_count number, i_row_num number) return varchar2 IS
l_row varchar2(3000);
begin
  for col_num in 1..i_col_count loop
    if col_num = 1 then
      l_row := create_col(i_row_num, col_num);
    else l_row := l_row||'
'||create_col(i_row_num, col_num);
    end if;
  end loop;  

  return '
  <row>
'||l_row||'
  </row>';
end;

function xml_constant_col_cnt(i_row_count number default 2, i_col_count number default 4) return xmltype IS
  l_xml_in_varchar2 varchar2(3000);--???
begin
  for row_num in 1..i_row_count loop
    l_xml_in_varchar2 := l_xml_in_varchar2||create_row(i_col_count, row_num);
  end loop;

  l_xml_in_varchar2 := '<root>'||l_xml_in_varchar2||'
</root>';
  dbms_output.put_line(l_xml_in_varchar2);
  return xmltype(l_xml_in_varchar2);
end;

function random_col_cnt(i_row_count number default 2) return varchar2 IS
  l_xml_in_varchar2 varchar2(3000);--???
  l_col_cnt_upper_bound constant number := 9;
begin
  for row_num in 1..i_row_count loop
    l_xml_in_varchar2 := l_xml_in_varchar2||create_row(dbms_random.value(1,l_col_cnt_upper_bound), row_num);
  end loop;

  l_xml_in_varchar2 := '<root>'||l_xml_in_varchar2||'
</root>';
  dbms_output.put_line(l_xml_in_varchar2);
  return l_xml_in_varchar2;  
end;

end xml_transformation;
/

with xml_table as (select xml_transformation.xml_constant_col_cnt(i_row_count=>9,i_col_count=>4) xml from dual)
select extractValue(value(row_t), 'row/col[1]') C1,
       extractValue(value(row_t), 'row/col[2]') C2,
       extractValue(value(row_t), 'row/col[3]') C3,
       extractValue(value(row_t), 'row/col[4]') C4
  from xml_table t, table(XMLSequence(t.xml.extract('root/row'))) row_t;


with xml_table as (
  select xmlType(xml_in_varchar2) xml from(
    select xml_transformation.random_col_cnt(i_row_count=>9) xml_in_varchar2 from dual)
  ),
xml_values as (select row_num, row_number() over(PARTITION BY row_num order by row_num) col_num, extractValue(value(col_t),'col') cell_value from
(select rownum row_num, row_t.column_value as cols
  from xml_table t, table(XMLSequence(t.xml.extract('root/row'))) row_t) first_step,
  table(XMLSequence(first_step.cols.extract('row/col'))) col_t),
second_step_t as (select '<data row="'||row_num||'" col="'||col_num||'">'||cell_value||'</data>' second_step_row from xml_values)
select xmlType('<root>'||LISTAGG(second_step_row) WITHIN GROUP (ORDER BY second_step_row)||'</root>') result from second_step_t;
