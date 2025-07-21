# 🚀 PlanetKart Data Modeling Project

## 📚 Overview

This repository contains a complete **dbt** project that transforms and models the **PlanetKart e-commerce** dataset for analytics purposes. The project includes staging and fact/dimension models along with snapshots and tests to ensure data quality and historical tracking.

---

## 🧠 Design Decisions

### 📐 Project Structure

- **Staging Layer (`stage_`)**: Cleanses raw data and applies column naming conventions.
- **Fact & Dimension Models**:
  - `dim_customers`: Customer-level dimension table.
  - `dim_products`: Product-level dimension table.
  - `dim_regions`: Region-level dimension table.
  - `fact_orders`: Aggregated order-level fact table.
- **Snapshots**:
  - `customers_snapshot`: Tracks changes to customer data over time using `updated_at` strategy.

### 📦 Naming Conventions
- Table names follow `dim_` / `fact_` / `stage_` prefixes.
- Surrogate keys are generated using `dbt_utils.generate_surrogate_key`.

### 🧪 Testing & Data Quality
- All models are tested for:
  - Not null
  - Uniqueness
- Dry up logic is used to generate surrogate key in all the tables.
- Snapshotting is configured using `TIMESTAMP_LTZ` fields for auditability.

---

## 🗺️ Schema Diagram

You can view the data model relationships using either of the following:
- Manually drawn schema -
  <img width="3840" height="1115" alt="image" src="https://github.com/user-attachments/assets/1e246b6b-8b77-429e-954c-222cbdd8a3f6" />

  <img width="3116" height="3840" alt="image" src="https://github.com/user-attachments/assets/ae1601fc-62f1-46b2-b9d9-667e2c195062" />

- **dbt DAG View**: Automatically generated in dbt Cloud or by running `dbt docs generate && dbt docs serve`

<img width="1426" height="768" alt="image" src="https://github.com/user-attachments/assets/ae3cd9d9-a26d-489c-a67c-1e8ed5eee668" />


---

## ▶️ How to Run the Project

### 📥 Prerequisites
- dbt (v1.0+)
- Python 3.7+
- Snowflake credentials configured via `profiles.yml`

### 🔧 Setup Instructions

1. Clone the repo

2. Install dependencies:
    ```bash
    dbt deps
    ```

3. Run models:
    ```bash
    dbt run
    ```

4. Run tests:
    ```bash
    dbt test
    ```

5. Run Snapshot:
    ```bash
    dbt snapshot
    ```

6. Run whole pipeline:
    ```
    dbt build
    ```

7. Generate and view documentation:
    ```bash
    dbt docs generate
    dbt docs serve
    ```

---

## 📸 Screenshots

### ✅ Airbyte Pipeline Setup

<img width="644" height="384" alt="image" src="https://github.com/user-attachments/assets/696f70b3-5c09-475e-9723-118e20745c5a" />

<img width="645" height="391" alt="image" src="https://github.com/user-attachments/assets/ea763127-6be6-4e30-b9fc-9ad95a6f52a7" />


### ✅ Data Loaded in Snowflake
<img width="656" height="372" alt="image" src="https://github.com/user-attachments/assets/7af2b7f8-2578-45d6-8856-d3c015a1dfd0" />

---

## 🧪 Testing Summary

- All tests passing ✅
- Snapshot-based SCD2 implemented for customers

---

## 📂 Folder Structure

