create table t(a integer, b integer);

insert into t(a,b) values (1,1);
insert into t(a,b) values (2,2);
insert into t(a,b) values (2,2);
insert into t(a,b) values (3,3);
insert into t(a,b) values (3,3);
insert into t(a,b) values (3,3);

commit;

delete
from t
where rowid not in (
        select min(rowid)
        from t
        group by a,b
      );

--test
select *
from t
where (a,b) in (
  select a,b
  from t
  having count(*) > 1
  group by a,b
)
order by a;
