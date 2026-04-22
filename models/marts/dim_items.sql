select
    item_id,
    item_code,
    item_name,
    item_category,
    is_returnable,
    created_at
from {{ source('raw', 'items') }}