-- test: ST05 (subquery in join) and AL06 (alias too short)
select
    a.id
from tbl as a
inner join (select id from tbl2) as s
    on a.id = s.id

-- test: ST05 (subquery in join) and AL06 (alias too short) run 2. this
