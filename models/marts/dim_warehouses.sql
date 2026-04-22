select
    warehouse_id,
    warehouse_code,
    warehouse_name,
    city,
    state,
    pincode,
    created_at
from {{ source('raw', 'warehouses') }}