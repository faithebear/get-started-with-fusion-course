# Task 2 Answer Key

## Quick fixes surfaced by live errors

The starter model included several straightforward issues that should be resolved first using Fusion’s real-time feedback:

* Incorrect `ref()` to the staging model (wrong model name)
* Misspelled column names in both the `orders` and `stores` CTEs
* Selecting a column that does not exist in the dataset
* A function call with the wrong number of arguments

These issues prevent the model from compiling or running successfully.

**Fusion feature highlight:** Hover over error messages to see:

* Unresolved node suggestions for incorrect `ref()` calls
* Available column names when a column is misspelled or does not exist
* Function signature hints when arguments are incorrect

Fixing these first allows the model to compile and makes downstream debugging easier.

---

## Grouping and grain

The required grain for this model is:

```
store_id + order_date
```

To correctly produce one row per store per day:

* Every non-aggregated column in the `SELECT` statement must appear in the `GROUP BY`
* Aggregated fields (such as `sum()` and `count()`) should align with the intended grain

In the starter query, some selected columns were not included in the `GROUP BY`, which caused a compilation error. These needed to be added so the grouping matched the selected dimensional attributes.

**Fusion feature highlight:** Fusion surfaces GROUP BY errors immediately with clear messages such as *“column must appear in the GROUP BY clause or be used in an aggregate function.”* Hovering the error highlights exactly which column is missing.

After correction, the model properly aggregates at the store + day level.

---

## Calculation issues to validate with previews

Two calculations required careful validation:

### Average Order Total

The average order total should reflect a reasonable per-order value for that store and day. It should not:

* Be excessively large or small
* Cause a divide-by-zero error on days with no orders

Ensuring safe division logic helps maintain model robustness.

### Days Since Store Open

This field should represent the number of days between the store’s open date and the order date.

A reversed date difference calculation will run successfully but produce negative values for most rows.

The corrected calculation ensures:

* Values are **0 or positive**
* The direction of the date difference reflects “order date minus opened date”

**Fusion feature highlight:** Use CTE previews to sanity-check calculated fields. Even when SQL runs successfully, previewing results helps catch logic errors that do not produce compilation failures.

---

## Final Validation Checklist

You are done when: 

* It runs with zero errors
* The output contains exactly one row per `store_id` per day
* Aggregated totals are consistent and plausible
* `avg_order_total` is reasonable
* `days_since_store_open` is never negative
* Results are sorted by `order_date desc, store_id`
