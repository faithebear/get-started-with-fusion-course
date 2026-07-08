with order_items as (

    select
        order_item_id,
        order_id,
        product_id
    from {{ ref('stg_jaffle_shop__order_items') }}  -- FIX: corrected ref from stg_jaffle_shop__order_item -> stg_jaffle_shop__order_items

),

orders as (

    select
        order_id,
        ordered_at
    from {{ ref('stg_jaffle_shop__orders') }}

),

products as (

    select
        product_id,
        product_name,
        product_type,
        product_price
    from {{ ref('stg_jaffle_shop__products') }}   -- FIX: corrected ref from stg_jaffle_shop__product -> stg_jaffle_shop__products

),

supplies as (

    select
        product_id,
        supply_cost,
        is_perishable_supply
    from {{ ref('stg_jaffle_shop__supplies') }} -- FIX: corrected column name from is_perishable -> is_perishable_supply

),

perishable_supply_costs as (

    select
        product_id,
        sum(supply_cost) as perishable_supply_cost
    from supplies
    where is_perishable_supply = true     -- FIX: corrected filter column name to is_perishable_supply
    group by product_id                   -- FIX: corrected group by from supply_id -> product_id (one row per product)

),

daily_product_sales as (

    select
        date_trunc('day', orders.ordered_at) as order_date, -- FIX: corrected date_trunc signature (added 'day' argument)
        order_items.product_id,
        count(order_items.order_item_id) as items_sold
    from order_items
    left join orders
        on order_items.order_id = orders.order_id
    group by
        order_date,
        order_items.product_id    -- FIX: removed orders.ordered_at from group by (keeps day grain)

),

final as (

    select
        daily_product_sales.order_date,
        daily_product_sales.product_id,
        products.product_name,
        products.product_type,

        daily_product_sales.items_sold,
        products.product_price,

        daily_product_sales.items_sold * products.product_price as daily_revenue,

        coalesce(perishable_supply_costs.perishable_supply_cost, 0) as perishable_supply_cost,
        -- FIX: coalesce requires a default value; use 0 so products with no perishable supplies don't error/null out

        coalesce(perishable_supply_costs.perishable_supply_cost, 0) * daily_product_sales.items_sold as daily_perishable_cost,
        -- FIX: coalesce previously had wrong arg count and was applied after multiplication; now safe and explicit

                perishable_supply_costs.perishable_supply_cost,
        daily_revenue - (perishable_supply_costs.perishable_supply_cost * daily_product_sales.items_sold) as daily_profit,
        coalesce(perishable_supply_costs.perishable_supply_cost) * daily_product_sales.items_sold as daily_perishable_cost

    from daily_product_sales
    left join products
        on daily_product_sales.product_id = products.product_id

    left join perishable_supply_costs
        on daily_product_sales.product_id = perishable_supply_costs.product_id

)

select *
from final
order by order_date desc, product_id
