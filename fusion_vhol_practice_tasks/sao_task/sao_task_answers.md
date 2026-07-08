# Answer Key — SAO Behavior

## First SAO Rerun

### `dim_customers` → Reused

**Why:**

* It did **not** meet its `build_after: 3 hours` threshold.
* Even if upstream data changed, not enough time had passed since the last build.

✅ Check the job logs — they should indicate the model was **reused due to freshness timing**.

---

### `stg_jaffle_shop__orders` → Rebuilt

**Why:**

* Changes were detected upstream.
* Its `build_after: 2 minutes` threshold was satisfied.
* Data was only updated once during the workshop, so the model qualified for rebuild.

---

### `stg_jaffle_shop__stores` → Rebuilt

**Why:**

* Changes were detected.
* `updates_on: all` did **not** prevent a rebuild because the required upstream conditions were met.
* All direct upstream sources had qualifying changes.

---

## Second SAO Rerun

### `dim_customers` → Reused

### `stg_jaffle_shop__orders` → Reused

### `stg_jaffle_shop__stores` → Reused

**Why:**

* No additional upstream changes were detected.
* No models qualified for rebuild under their freshness or update rules.
* SAO correctly reused prior results.

