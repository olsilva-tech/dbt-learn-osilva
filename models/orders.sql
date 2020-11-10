{{
  config(
    materialized='view'
  )
}}

with 

payments as (
    select
        orderid as order_id,
        sum(amount) as total_amount,
        total_amount / 100 as total_amount_dollars

    from {{ ref('stg_payments') }}
    where status = 'success'
    group by order_id
),

orders as (
    select * from {{ ref('stg_orders') }}
),

final as (
    select
        orders.order_id,
        orders.customer_id,
        orders.order_date,
        orders.status,
        payments.total_amount_dollars as amount

    from orders
    left join payments using (order_id)
)


select * from final