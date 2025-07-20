{{ config(materialized='table') }}

SELECT 
    {{ dbt_utils.generate_surrogate_key(['region_id']) }} as region_key,
    region_id,
    planet,
    zone,
    CASE 
        WHEN planet = 'Earth' THEN 'Home Base'
        WHEN planet = 'Mars' THEN 'Red Planet'
        WHEN planet = 'Venus' THEN 'Cloud World'
        ELSE 'Unknown'
    END as planet_nickname
FROM {{ ref('stage_regions') }}