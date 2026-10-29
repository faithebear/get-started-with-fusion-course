with order_items as (

select

order_item_id,

order_id,

product_id,

product_name,

date_trunc('day', order_date) as order_date,

product_price,

is_food_item,

is_drink_item,

supply_cost

from {{ ref('order_items') }}

),

daily_rollup as (

select

order_date,

product_id,

sum(product_price) as daily_revenue,

count(order_item_id) as items_sold

from order_items

group by order_date, product_id

),



leaderboard as (

select

order_date,

product_id,

daily_revenue,

items_sold,

row_number() over (

partition by order_date

order by daily_revenue asc

) as daily_rank

from daily_rollup

)

select *

from leaderboard

order by order_date, daily_rank