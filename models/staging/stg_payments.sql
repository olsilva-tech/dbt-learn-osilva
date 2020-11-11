select 
    id,
    amount,
    status,
    orderid as order_id,
    paymentmethod as payment_method, 
    created,
    _batched_at
from {{ source('stripe', 'payment') }}