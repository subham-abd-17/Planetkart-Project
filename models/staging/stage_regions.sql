{{ config(materialized='view') }}

SELECT 
    region_id,
    planet,
    zone
FROM {{ source('raw', 'regions') }}