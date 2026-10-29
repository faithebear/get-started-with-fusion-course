{# Ticket 138822 repro: split_to_table in FROM under strict static analysis with --generate-info-schema #}
{{ config(materialized='table') }}

select value as v
from table(split_to_table('a,b', ','))
