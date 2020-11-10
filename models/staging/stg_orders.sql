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
    select * from raw.jaffle_shop.orders
),



final as (
    select
        orders.id as order_id,
        orders.user_id as customer_id,
        orders.order_date as order_date,
        orders.status as status,
        payments.total_amount_dollars as amount

    from orders
    left join payments on (payments.order_id = order_id)
)


select * from final