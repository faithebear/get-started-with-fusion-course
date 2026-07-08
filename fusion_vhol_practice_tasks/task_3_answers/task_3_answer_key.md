# Task 3 Answer Key

## Quick fixes surfaced by live errors

The starter model includes several structural and naming issues that prevent compilation. These should be resolved first.

Issues corrected:

* Incorrect `ref()` targets:

  * `stg_jaffle_shop__order_item` → `stg_jaffle_shop__order_items`
  * `stg_jaffle_shop__product` → `stg_jaffle_shop__products`

* Incorrect or non-existent column names:

  * `is_perishable` → `is_perishable_supply`
  * `where is_perishable_supply = true` (column name mismatch fixed in supplies CTE)
  * `group by supply_id` → `group by product_id`
  * `date_trunc(orders.ordered_at)` → `date_trunc('day', orders.ordered_at)`

* Incorrect function usage:

  * `coalesce(perishable_supply_costs.perishable_supply_cost)` → must include a default value (e.g., `coalesce(..., 0)`)

**Fusion feature highlight:**
Hover error messages to:

* See unresolved model references
* View available column names in each CTE
* Confirm required function arguments and signatures

Fixing these enables the model to compile and makes downstream aggregation logic easier to debug.

---

## Grain and grouping corrections

The required grain for this model is:

```
product_id + order_date
```

In the starter query, two grouping issues broke that grain:

1. `daily_product_sales` grouped by both `order_date` and `orders.ordered_at`, which introduces duplicate rows at the timestamp level instead of the day level.
2. `perishable_supply_costs` grouped by `supply_id`, which produces multiple rows per product instead of a single per-product supply cost.

Corrections required:

* In `perishable_supply_costs`, group only by `product_id`.
* In `daily_product_sales`, group only by:

  * `order_date`
  * `order_items.product_id`

After these fixes, each intermediate CTE correctly reflects its intended grain.

**Fusion feature highlight:**
Fusion surfaces GROUP BY errors immediately with clear messages indicating which selected columns are missing from the GROUP BY clause. Hovering the error identifies the exact column that must be added or removed.

Previewing each CTE also confirms row counts align with expected grain.

---

## Date truncation correction

The original query used:

```
date_trunc(orders.ordered_at)
```

`date_trunc` requires two arguments in Snowflake:

```
date_trunc('day', timestamp_column)
```

Correcting this ensures the `order_date` field is computed properly at day grain.

**Fusion feature highlight:**
Hovering the function error shows the required function signature and expected arguments.

---

## Perishable supply cost aggregation

The `perishable_supply_costs` CTE should:

* Filter only perishable supplies
* Aggregate per-product supply costs
* Produce exactly one row per `product_id`

Grouping by `supply_id` instead of `product_id` breaks this logic and causes join fanout downstream.

Correcting the grouping ensures:

* One perishable cost value per product
* Stable join to `daily_product_sales`

---

## Revenue and profit calculations

Final calculations should follow this logic:

* `daily_revenue = items_sold * product_price`
* `daily_perishable_cost = perishable_supply_cost * items_sold`
* `daily_profit = daily_revenue - daily_perishable_cost`

The starter query incorrectly:

* Used `coalesce()` without a default argument

After correction:

* `coalesce(perishable_supply_cost, 0)` prevents null multiplication issues

**Fusion feature highlight:**
Hover to inspect numeric data types and confirm calculations align with expected types.
Use CTE preview to validate that profit scales with units sold and does not explode due to duplicate joins.

---

## Final validation checklist

The model is complete when:

* It runs with zero errors
* Each CTE compiles independently
* The final output contains exactly one row per `product_id` per `order_date`
* Revenue equals `items_sold * product_price`
* Perishable cost scales with units sold
* Profit equals revenue minus perishable cost
* Results are sorted by `order_date desc, product_id`


