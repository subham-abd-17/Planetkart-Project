# 🚀 PlanetKart Data Modeling Project

## 📚 Overview

This repository contains a complete **dbt** project that transforms and models the **PlanetKart e-commerce** dataset for analytics purposes. The project includes staging and fact/dimension models along with snapshots and tests to ensure data quality and historical tracking.

---

## 🧠 Design Decisions

### 📐 Project Structure

- **Staging Layer (`stg_`)**: Cleanses raw data and applies column naming conventions.
- **Intermediate Layer (`int_`)** *(optional)*: Used for logic reuse when needed.
- **Fact & Dimension Models**:
  - `dim_customers`: Customer-level dimension table.
  - `fact_orders`: Aggregated order-level fact table.
- **Snapshots**:
  - `customers_snapshot`: Tracks changes to customer data over time using `updated_at` strategy.

### 📦 Naming Conventions
- Table names follow `dim_` / `fact_` / `stg_` prefixes.
- Surrogate keys are generated using `dbt_utils.generate_surrogate_key`.

### 🧪 Testing & Data Quality
- All models are tested for:
  - Not null
  - Uniqueness
  - Freshness (custom tests via `dbt-utils`)
- Snapshotting is configured using `TIMESTAMP_LTZ` fields for auditability.

---

## 🗺️ Schema Diagram

You can view the data model relationships using either of the following:
- **[Draw.io Diagram](link_to_your_diagram)** – Manually drawn schema
- **dbt DAG View**: Automatically generated in dbt Cloud or by running `dbt docs generate && dbt docs serve`

![Schema Diagram](images/schema-diagram.png) <!-- Replace with your actual diagram path -->

---

## ▶️ How to Run the Project

### 📥 Prerequisites
- dbt (v1.0+)
- Python 3.7+
- Snowflake credentials configured via `profiles.yml`

### 🔧 Setup Instructions

1. Clone the repo:
    ```bash
    git clone https://github.com/your-username/planetkart-dbt.git
    cd planetkart-dbt
    ```

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

5. Generate and view documentation:
    ```bash
    dbt docs generate
    dbt docs serve
    ```

---

## 📸 Screenshots

### ✅ Hevo Pipeline Setup
![Hevo Pipeline](images/hevo-pipeline.png) <!-- Replace with actual screenshot -->

### ✅ Data Loaded in Snowflake
![Snowflake Data](images/snowflake-tables.png) <!-- Replace with actual screenshot -->

---

## 🧪 Testing Summary

- All tests passing ✅
- Includes custom expression-based tests for data freshness
- Snapshot-based SCD2 implemented for customers

---

## 📂 Folder Structure

