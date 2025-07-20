{{ config(materialized='table') }}

WITH product_sales_metrics AS (
    SELECT 
        p.product_id,
        COUNT(DISTINCT oi.order_id) as orders_count,
        SUM(oi.quantity) as total_quantity_sold,
        SUM(oi.line_total) as total_revenue,
        AVG(oi.unit_price) as avg_selling_price,
        MAX(oi.unit_price) as max_selling_price,
        MIN(oi.unit_price) as min_selling_price
    FROM {{ ref('stage_products') }} p
    LEFT JOIN {{ ref('stage_order_items') }} oi ON p.product_id = oi.product_id
    GROUP BY p.product_id
)

SELECT 
    {{ dbt_utils.generate_surrogate_key(['p.product_id']) }} as product_key,
    p.product_id,
    p.product_name,
    p.category,
    p.sku,
    p.cost,
    -- Use actual selling price from order_items if available, otherwise use calculated price
    COALESCE(psm.avg_selling_price, p.price) as avg_price,
    COALESCE(psm.max_selling_price, p.price) as max_price,
    COALESCE(psm.min_selling_price, p.price) as min_price,
    ROUND(COALESCE(psm.avg_selling_price, p.price) - p.cost, 2) as profit_margin,
    ROUND(((COALESCE(psm.avg_selling_price, p.price) - p.cost) / COALESCE(psm.avg_selling_price, p.price)) * 100, 2) as profit_margin_pct,
    COALESCE(psm.orders_count, 0) as orders_count,
    COALESCE(psm.total_quantity_sold, 0) as total_quantity_sold,
    COALESCE(psm.total_revenue, 0) as total_revenue,
    
    -- Category classifications
    CASE 
        WHEN p.category = 'Kitchen' THEN 'Home & Kitchen'
        WHEN p.category = 'Fitness' THEN 'Health & Fitness'  
        WHEN p.category = 'Outdoor' THEN 'Sports & Outdoors'
        WHEN p.category = 'Gadgets' THEN 'Electronics'
        ELSE 'Other'
    END as category_group,
    
    -- Price tier classification
    CASE 
        WHEN p.cost >= 200 THEN 'Premium'
        WHEN p.cost >= 100 THEN 'Mid-Range'
        WHEN p.cost >= 50 THEN 'Budget'
        ELSE 'Economy'
    END as price_tier,
    
    -- Margin category classification
    CASE 
        WHEN ROUND(((COALESCE(psm.avg_selling_price, p.price) - p.cost) / COALESCE(psm.avg_selling_price, p.price)) * 100, 2) > 40 THEN 'High Margin'
        WHEN ROUND(((COALESCE(psm.avg_selling_price, p.price) - p.cost) / COALESCE(psm.avg_selling_price, p.price)) * 100, 2) > 20 THEN 'Medium Margin'
        ELSE 'Low Margin'
    END as margin_category,
    
    -- Product performance classification
    CASE 
        WHEN COALESCE(psm.total_quantity_sold, 0) = 0 THEN 'No Sales'
        WHEN COALESCE(psm.total_quantity_sold, 0) >= 10 THEN 'Best Seller'
        WHEN COALESCE(psm.total_quantity_sold, 0) >= 5 THEN 'Good Performer'
        ELSE 'Low Performer'
    END as performance_category,
    
    -- Brand extraction from product name (first word)
    SPLIT_PART(p.product_name, ' ', 1) as brand_name,
    
    -- Planet-themed product classification
    CASE 
        WHEN UPPER(p.product_name) LIKE '%MARS%' OR UPPER(p.product_name) LIKE '%MARTIAN%' THEN 'Mars Edition'
        WHEN UPPER(p.product_name) LIKE '%VENUS%' OR UPPER(p.product_name) LIKE '%VENUSIAN%' THEN 'Venus Edition'
        WHEN UPPER(p.product_name) LIKE '%GALAXY%' OR UPPER(p.product_name) LIKE '%GALACTIC%' THEN 'Galaxy Series'
        WHEN UPPER(p.product_name) LIKE '%STELLAR%' OR UPPER(p.product_name) LIKE '%ASTRO%' THEN 'Stellar Collection'
        WHEN UPPER(p.product_name) LIKE '%QUANTUM%' OR UPPER(p.product_name) LIKE '%PLASMA%' THEN 'Quantum Tech'
        WHEN UPPER(p.product_name) LIKE '%ZERO-G%' OR UPPER(p.product_name) LIKE '%GRAVITY%' THEN 'Zero Gravity'
        ELSE 'Standard'
    END as product_line,
    
    -- Activity type for fitness/outdoor products
    CASE 
        WHEN p.category = 'Fitness' AND UPPER(p.product_name) LIKE '%YOGA%' THEN 'Yoga'
        WHEN p.category = 'Fitness' AND (UPPER(p.product_name) LIKE '%DUMBBELL%' OR UPPER(p.product_name) LIKE '%WEIGHT%') THEN 'Strength Training'
        WHEN p.category = 'Fitness' AND UPPER(p.product_name) LIKE '%TREADMILL%' THEN 'Cardio'
        WHEN p.category = 'Outdoor' AND UPPER(p.product_name) LIKE '%KAYAK%' THEN 'Water Sports'
        WHEN p.category = 'Outdoor' AND (UPPER(p.product_name) LIKE '%TENT%' OR UPPER(p.product_name) LIKE '%HELMET%') THEN 'Camping'
        WHEN p.category = 'Outdoor' AND UPPER(p.product_name) LIKE '%SKATE%' THEN 'Skating'
        ELSE NULL
    END as activity_type,
    
    CURRENT_TIMESTAMP as created_at,
    CURRENT_TIMESTAMP as updated_at
    
FROM {{ ref('stage_products') }} p
LEFT JOIN product_sales_metrics psm ON p.product_id = psm.product_id