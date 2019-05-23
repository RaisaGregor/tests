select regexp_substr(str, '[^\,]+', 1, 1 )  C1
      ,regexp_substr(str, '[^\,]+', 1, 2 )  C2
      ,regexp_substr(str, '[^\,]+', 1, 3 )  C3
      ,regexp_substr(str, '[^\,]+', 1, 4 )  C4
from (
select '1,2,3,4' str
from dual)
