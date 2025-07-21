{{ config(materialized='table') }}

WITH customer_metrics AS (
    SELECT 
        c.customer_id,
        COUNT(DISTINCT o.order_id) as total_orders,
        SUM(CASE WHEN o.status = 'Completed' THEN 1 ELSE 0 END) as completed_orders,
        MIN(o.order_date) as first_order_date,
        MAX(o.order_date) as last_order_date
    FROM {{ ref('stage_customers') }} c
    LEFT JOIN {{ ref('stage_orders') }} o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id
)

SELECT
    {{ generate_surrogate_key(['c.customer_id']) }} as customer_key,
    c.customer_id,
    c.customer_name,
    c.email,
    c.signup_date,
    COALESCE(cm.total_orders, 0) as total_orders,
    COALESCE(cm.completed_orders, 0) as completed_orders,
    cm.first_order_date,
    cm.last_order_date,
    CASE 
        WHEN cm.total_orders >= 5 THEN 'VIP'
        WHEN cm.total_orders >= 2 THEN 'Regular'
        ELSE 'New'
    END as customer_segment
FROM {{ ref('stage_customers') }} c
LEFT JOIN customer_metrics cm ON c.customer_id = cm.customer_id
