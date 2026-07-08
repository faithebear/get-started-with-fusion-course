# State-aware Orchestration Activity: Configuring Model Freshness

## Goal

In this activity, you’ll modify model-level freshness configs and observe how a **State-aware Orchestration (SAO)** job behaves as a result.

You will:

* Add `build_after` to two models
* Configure `updates_on` for one model
* Run the same job twice
* Predict what will happen before each run
* Explain the results using SAO logic

**Reference documentation:**
[https://docs.getdbt.com/reference/resource-configs/freshness](https://docs.getdbt.com/reference/resource-configs/freshness)

---

## Part 1 — Verify the Job Is State-Aware and Runs on a Custom Branch

### Step 1 — Confirm SAO Is Enabled

1. In dbt Platform, navigate to **Orchestration → Jobs**.
2. Open **Prod Job**.
3. Click into the job’s **Settings**.
4. Under **Execution settings**, confirm the **Enable Fusion cost optimization features** checkbox is checked.
5. Click **Save**.

---

### Step 2 — Configure the Job to Run on Your Custom Branch

1. Navigate to **Orchestration → Jobs**.
2. Click into **Production**.
3. Click **Edit**.
4. Under **Environment settings**, check **Only run on a custom branch**.
5. In the text box that appears, enter your branch name.
6. Save your changes.

---

## Part 2 — Update Model Freshness Configs

You will edit two YAML files:

* `dim_customers.yml`
* `stg_jaffle_shop.yml`

---

### Step 1 — Update `dim_customers.yml`

#### Objective

Set `build_after` to **3 hours** for `dim_customers`.

#### Instructions

1. Open:

```bash
models/marts/dim_customers.yml
```

2. Add the following `config:` block directly under the model description:

```yaml
- name: dim_customers
  description: This model....
  config:
    freshness:
      build_after:
        count: 3
        period: hour
  columns:
    - name: customer_id
```

#### What This Means

Even if upstream data changes, this model will only rebuild if **at least 3 hours** have passed since its last build.

3. Save the file and commit your changes.

---

### Step 2 — Update `stg_jaffle_shop.yml`

Open:

```bash
models/staging/jaffle_shop/stg_jaffle_shop.yml
```

You will update **two staging models** in this file.

---

### 2A — Update `stg_jaffle_shop__orders`

#### Objective

Set `build_after` to **2 minutes**.

Find:

```yaml
- name: stg_jaffle_shop__orders
  description: "{{ doc('stg_jaffle_shop__orders') }}"
```

Add this block directly under the description:

```yaml
- name: stg_jaffle_shop__orders
  description: "{{ doc('stg_jaffle_shop__orders') }}"
  config:
    freshness:
      build_after:
        count: 2
        period: minute
  columns:
    - name: order_id
```

#### What This Means

Even if upstream data changes, this model will only rebuild if **at least 2 minutes** have passed since its last build.

Save the file and commit your changes.

---

### 2B — Update `stg_jaffle_shop__stores`

#### Objective

Set `updates_on` to `all`.

Find:

```yaml
- name: stg_jaffle_shop__stores
  description: "{{ doc('stg_jaffle_shop__stores') }}"
```

Add this config block under the description:

```yaml
- name: stg_jaffle_shop__stores
  description: "{{ doc('stg_jaffle_shop__stores') }}"
  config:
    freshness:
      updates_on: all
  columns:
    - name: store_id
```

#### What This Means

By default, `updates_on` is `any`.

Changing it to `all` means:

* This model will rebuild only when **all direct upstream sources** have new data
* Not just when **any one** of them changes

Save the file and commit your changes.

---

## Part 3 — Run the SAO Job (First Rerun)

You are about to run the job.

If you attended the workshop live, your instructor may introduce new data into your sources.

> ⚠️ If you are completing this asynchronously, you will not see new data unless it is introduced manually.

---

### Prediction Exercise — Run #1

Before clicking **Run**, pause.

For each model below, write down:

* Will it build?
* Will it be reused?
* Why?

#### Models to Evaluate

* `dim_customers`
* `stg_jaffle_shop__orders`
* `stg_jaffle_shop__stores`

#### Consider

* Has enough time passed since the last build to satisfy `build_after`?
* Did upstream data change?
* Does the model require **any** upstream changes or **all** upstream changes?

---

### Execute the Job

1. Go to **Orchestration → Jobs**.
2. Click **Run now** on the Prod Job.

As the run executes:

* Watch which models are marked as **built**
* Watch which models are **reused/skipped**

After the run completes, record what actually happened.

---

## Part 4 — Run the SAO Job Again (Second Rerun)

Without changing anything else, run the same job again.

No new data will be introduced this time.

---

### Prediction Exercise — Run #2

Before clicking **Run**, write down:

For each model:

* What will happen?
* Why?

---

### Execute the Job Again

1. Click **Run now**.
2. Observe the results.
3. Compare expected vs actual behavior.


