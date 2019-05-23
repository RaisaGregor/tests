   CREATE OR REPLACE TYPE TNUM as table of number;
   
CREATE OR REPLACE function return_num_collection return TNUM IS
  result_collection TNUM := TNUM();
  collection_count CONSTANT NUMBER := 1000;
begin
  for collection_element in 1..collection_count
    LOOP
      result_collection.EXTEND;
	  result_collection(collection_element):=collection_element;
    END LOOP;
  return result_collection; 
end;

--TEST
set serveroutput on;

declare
   num_collection TNUM;
   l_row NUMBER;
begin
 num_collection:=return_num_collection;
 FOR l_row in num_collection.FIRST..num_collection.LAST
 LOOP
    DBMS_OUTPUT.PUT_LINE(num_collection(l_row));
 END LOOP;
end;
