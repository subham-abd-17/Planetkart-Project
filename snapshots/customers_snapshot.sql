{% snapshot customers_snapshot %}

    {{
        config(
          target_database='a_database',
          target_schema='planetkart_planetkart_stage',
          unique_key='customer_id',
          strategy='timestamp',
          updated_at='updated_at',
        )
    }}

    SELECT 
        customer_id,
        customer_name,
        email,
        signup_date,
        region_id,
        CAST(updated_at AS TIMESTAMP_NTZ) AS updated_at
    FROM {{ ref('stage_customers') }}

{% endsnapshot %}