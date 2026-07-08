---

# Task 2: Build `fct_store_daily`

Your team wants a daily performance mart to analyze how each store is performing over time.

You’ve been asked to build a new model:

**`fct_store_daily`**

This model should produce **one row per store per day**, with aggregated order and revenue metrics.

A colleague started the model, but it’s currently not working correctly.

Your job is to debug and complete it using dbt Fusion.

---

## Your Task

1. Locate the starter SQL file in the `task_2` folder.
2. Move that file into your `models/marts` folder.
3. Rename it (if needed) to:

```
fct_store_daily.sql
```

4. Modify the SQL so the final model produces a clean, daily store-level mart with:

One row per:

```
store_id + order_date
```

With the following columns:

* `store_id`
* `store_location`
* `tax_rate`
* `order_date` (day grain)
* `orders_count`
* `daily_subtotal`
* `daily_tax_paid`
* `daily_order_total`
* `avg_order_total`
* `days_since_store_open`

---

## Acceptance Criteria

When the model is complete:

* It runs with **zero errors**
* The output contains exactly **one row per store per day**
* `avg_order_total` looks reasonable relative to daily totals
* `daily_order_total` is consistent with subtotal + tax
* `days_since_store_open` is **0 or positive** for all rows
* The results are sorted by `order_date desc, store_id`

