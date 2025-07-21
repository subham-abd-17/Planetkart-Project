{{ config(materialized='view') }}

SELECT 
    product_id,
    product_name,
    category,
    sku,
    cost,
    -- Since there's no price column, we'll need to get it from order_items or set a default markup
    ROUND(cost * 1.5, 2) as price,  -- Assuming 50% markup as default
    ROUND((cost * 1.5) - cost, 2) as profit_margin
FROM {{ source('raw', 'products') }}