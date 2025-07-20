{{ config(materialized='table') }}

WITH order_aggregates AS (
    SELECT 
        oi.order_id,
        SUM(oi.quantity) AS total_quantity,
        SUM(oi.line_total) AS total_amount,
        COUNT(*) AS item_count
    FROM {{ ref('stage_order_items') }} oi
    GROUP BY oi.order_id
)

SELECT 
    {{ dbt_utils.generate_surrogate_key(['o.order_id']) }} AS order_key,
    {{ dbt_utils.generate_surrogate_key(['o.customer_id']) }} AS customer_key,
    o.order_id,
    o.customer_id,
    o.order_date,
    o.status,
    o.is_completed,
    COALESCE(oa.total_quantity, 0) AS total_quantity,
    COALESCE(oa.total_amount, 0) AS total_amount,
    COALESCE(oa.item_count, 0) AS item_count,
    EXTRACT(YEAR FROM TO_DATE(o.order_date)) AS order_year,
    EXTRACT(MONTH FROM TO_DATE(o.order_date)) AS order_month,
    EXTRACT(DOW FROM TO_DATE(o.order_date)) AS order_day_of_week
FROM {{ ref('stage_orders') }} o
LEFT JOIN order_aggregates oa ON o.order_id = oa.order_id