{# Ticket 138822 repro: lateral split_to_table variant #}
{{ config(materialized='table') }}

select
    t.id,
    s.value as v
from (select 1 as id, 'a,b' as csv) t,
    lateral split_to_table(t.csv, ',') s
