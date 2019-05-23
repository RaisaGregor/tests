select pseudo_random_value from (select trunc(floor(level/3))+1 pseudo_random_value from dual
CONNECT BY LEVEL <= 2999
order by dbms_random.VALUE(1, 1000))
where rownum <= 1000

--test
select pseudo_random_value from (select pseudo_random_value from (select trunc(floor(level/3))+1 pseudo_random_value from dual
CONNECT BY LEVEL <= 2999
order by dbms_random.VALUE(1, 1000))
where rownum <= 1000) group by pseudo_random_value having count(1) > 3
