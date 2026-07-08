# Problem 3: Build `fct_perishable_product_daily`

Your team wants to understand how **perishable supplies** impact product profitability over time.

You’ve been asked to build a new mart model:

**`fct_perishable_product_daily`**

This model should produce **one row per product per day** with daily units sold, revenue, perishable supply cost, and profit.

A colleague started the model, but it currently contains multiple issues and won’t run correctly.

Your job is to debug and complete it using dbt Fusion.

---

## Your Task

1. Locate the starter SQL file in the `task_3` folder.
2. Move that file into your `models/marts` folder.
3. Rename it (if needed) to:

```
fct_perishable_product_daily.sql
```

4. Modify the SQL so the final model produces: 

One row per:

```
product_id + order_date
```

With the following columns:

* `order_date` (day grain)
* `product_id`
* `product_name`
* `product_type`
* `items_sold`
* `product_price`
* `daily_revenue`
* `perishable_supply_cost` (per-unit perishable supply cost for the product)
* `daily_perishable_cost`
* `daily_profit`

---

## Acceptance Criteria

You're done when: 

* It runs with **zero errors**
* The output contains exactly **one row per product per day**
* The results are sorted by `order_date desc, product_id`




