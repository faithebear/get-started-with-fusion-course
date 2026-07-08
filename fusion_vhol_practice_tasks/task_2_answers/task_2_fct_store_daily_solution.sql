with orders as (

    select
        order_id,
        store_id,
        ordered_at,       -- FIX: corrected column name from orderedat -> ordered_at
        subtotal,         -- FIX: corrected column name from sub_total -> subtotal
        tax_paid,
        order_total
    from {{ ref('stg_jaffle_shop__orders') }}      -- FIX: corrected ref from stg_jaffle_shop__order -> stg_jaffle_shop__orders

),

stores as (

    select
        store_id,
        store_location,   -- FIX: corrected column name from store_locaton -> store_location
        tax_rate,         -- FIX: corrected column name from taxrate -> tax_rate
        opened_at
        -- FIX: removed is_open (column does not exist in this dataset)
    from {{ ref('stg_jaffle_shop__stores') }}

),

daily_rollup as (

    select
        orders.store_id,
        stores.store_location,
        stores.tax_rate,
        date_trunc('day', orders.ordered_at) as order_date,

        count(orders.order_id) as orders_count,
        sum(coalesce(orders.subtotal, 0)) as daily_subtotal,     
        sum(coalesce(orders.tax_paid, 0)) as daily_tax_paid,      
        sum(coalesce(orders.order_total, 0)) as daily_order_total,

        daily_order_total / nullif(orders_count, 0) as avg_order_total,
        -- FIX: guard against divide-by-zero using nullif

        datediff('day', stores.opened_at, order_date) as days_since_store_open
        -- FIX: corrected argument order so result is non-negative

    from orders
    left join stores
        on orders.store_id = stores.store_id

    group by
        orders.store_id,
        stores.store_location,  -- FIX: included non-aggregated selected columns in group by
        stores.tax_rate,        -- FIX: included non-aggregated selected columns in group by
        order_date

)

select *
from daily_rollup
order by order_date desc, store_id
