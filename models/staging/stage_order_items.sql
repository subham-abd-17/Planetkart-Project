{{ config(materialized='view') }}

SELECT
    order_id,
    product_id,
    quantity,
    unit_price,
    (quantity * unit_price) as line_total
FROM {{ source('raw', 'order_items') }}