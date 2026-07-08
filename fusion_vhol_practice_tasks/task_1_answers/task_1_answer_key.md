# Task 1 Answer Key: `fct_orders`

# Walkthrough & Explanation

This exercise intentionally included a mix of:

* Compile-time errors
* Incorrect column references
* Incorrect aggregation logic
* Grain-breaking grouping
* A subtle but important join bug

---

## 1️⃣ Incorrect `ref()` to staging model

**Bug in starter:**

```sql
from {{ ref('stg_jaffle_shop__order') }}
```

**Correct version:**

```sql
from {{ ref('stg_jaffle_shop__orders') }}
```

**Fusion feature highlight:**

* Hover over insights on error shows unresolved node

---

## 2️⃣ Incorrect column name in stores CTE

**Bug in starter:**

```sql
taxrate
```

**Correct version:**

```sql
tax_rate
```


**Fusion feature highlight:**

* Hover over error message to see available column names


---

## 3️⃣ Incorrect distinct product calculation

**Bug in starter:**

```sql
count(product_id) as distinct_products_count
```

**Problem:**
This counts total line items, not unique products.

**Correct version:**

```sql
count(distinct product_id) as distinct_products_count
```

**Why this matters:**
If an order contains multiple quantities of the same product, we should count that product once.

**Fusion feature highlight:**

* Preview CTE on `item_rollup` allows comparing `items_count` vs `distinct_products_count`

---

## 4️⃣ GROUP BY breaks order grain

**Bug in starter:**

```sql
group by order_id, product_id
```

**Problem:**
This produces one row per product per order — not one row per order.

**Correct version:**

```sql
group by order_id
```

**Why this matters:**
`fct_orders` must be strictly at the order grain. Any duplication here cascades into the final join.

**Fusion feature highlight:**

* Preview CTE on `item_rollup` allows confirmation of one row per `order_id`
---

## 5️⃣ Incorrect join key in final CTE ( Bug on Line 73)

**Bug in starter:**

```sql
left join item_rollup
    on order_items.order_id = item_rollup.order_id
```

**Problem:**
The `joined` CTE’s FROM clause is `from orders`. Referencing `order_items` in the join condition is incorrect and causes either:

* A compilation error (unresolved reference), or
* Incorrect grain behavior depending on engine resolution

**Correct version:**

```sql
left join item_rollup
    on orders.order_id = item_rollup.order_id
```

**Why this matters:**
We want a clean 1:1 join between `orders` and `item_rollup`.

**Fusion feature highlight:**

* Real-time error detection flags unresolved CTE references
* CTE preview shows duplicated rows if join grain is wrong

--

# Final Validation Checklist

You are done when:

* Model compiles successfully
* Output contains exactly one row per `order_id`
* `items_count` ≥ `distinct_products_count`
* `tax_rate` is populated
* `expected_tax` calculates correctly
* `tax_delta` looks reasonable
* Results are sorted by `order_date desc, order_id`

---


