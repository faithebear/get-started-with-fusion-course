with order_items as (

    select
        order_item_id,
        order_id,
        product_id
    from {{ ref('stg_jaffle_shop__order_item') }}

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
    from {{ ref('stg_jaffle_shop__product') }}

),

supplies as (

    select
        product_id,
        supply_cost,
        is_perishable
    from {{ ref('stg_jaffle_shop__supplies') }}

),

perishable_supply_costs as (

    select
        product_id,
        sum(supply_cost) as perishable_supply_cost
    from supplies
    where is_perishable_supply = true
    group by supply_id

),

daily_product_sales as (

    select
        date_trunc(orders.ordered_at) as order_date,
        order_items.product_id,
        count(order_items.order_item_id) as items_sold
    from order_items
    left join orders
        on order_items.order_id = orders.order_id
    group by
        order_date,
        order_items.product_id,
        orders.ordered_at

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

        perishable_supply_costs.perishable_supply_cost,
        daily_revenue - (perishable_supply_costs.perishable_supply_cost * daily_product_sales.items_sold) as daily_profit,
        coalesce(perishable_supply_costs.perishable_supply_cost) * daily_product_sales.items_sold as daily_perishable_cost

    from daily_product_sales
    left join products
        on daily_product_sales.product_id = products.product_id

    left join perishable_supply_costs
        on daily_product_sales.product_id = perishable_supply_costs.product_id

    group by
        daily_product_sales.order_date,
        daily_product_sales.product_id,
        products.product_name,
        products.product_type,
        daily_product_sales.items_sold,
        products.product_price

)

select *
from final
order by order_date desc, product_id