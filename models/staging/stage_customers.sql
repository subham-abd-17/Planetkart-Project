{{
  config(
    materialized='view'
  )
}}

WITH base_table AS (
  SELECT * FROM {{ source('raw', 'customers') }}
)

SELECT
    customer_id::VARCHAR(20) AS customer_id,
    first_name || ' ' || last_name AS customer_name,
    email::VARCHAR(100) AS email,
    TO_DATE(signup_date, 'YYYY-MM-DD') AS signup_date,
    region_id::VARCHAR(50) AS region_id,
    CURRENT_TIMESTAMP as updated_at

FROM base_table