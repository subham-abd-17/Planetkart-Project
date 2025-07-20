{{ config(materialized='view') }}

SELECT 
    order_id,
    customer_id,
    order_date,
    status,
    CASE 
        WHEN status = 'Completed' THEN 1
        ELSE 0 
    END as is_completed
FROM {{ source('raw', 'orders') }}