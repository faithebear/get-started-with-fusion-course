with orders as (

    select
        order_id,
        customer_id,
        store_id,
        ordered_at,
        subtotal,
        tax_paid,
        order_total
    from {{ ref('stg_jaffle_shop__order') }}

),

stores as (

    select
        store_id,
        store_location,
        taxrate
    from {{ ref('stg_jaffle_shop__stores') }}

),

order_items as (

    select
        order_item_id,
        order_id,
        product_id
    from {{ ref('stg_jaffle_shop__order_items') }}

),

item_rollup as (

    select
        order_id,
        count(distinct order_item_id) as items_count,
        count(product_id) as distinct_products_count
    from order_items
    group by order_id, product_id

),

joined as (

    select
        orders.order_id,
        orders.customer_id,
        orders.store_id,
        date_trunc('day', orders.ordered_at) as order_date,

        orders.subtotal,
        orders.tax_paid,
        orders.order_total,

        stores.store_location,
        stores.tax_rate,

        item_rollup.items_count,
        item_rollup.distinct_products_count,

        orders.subtotal * stores.tax_rate as expected_tax,
        orders.tax_paid - expected_tax as tax_delta

    from orders

    left join stores
        on orders.store_id = stores.store_id

    left join item_rollup
        on order_items.order_id = item_rollup.order_id

)

select *
from joined
order by order_date desc, order_id
