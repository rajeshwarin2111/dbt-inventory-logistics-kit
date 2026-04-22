select
    site_id,
    site_code,
    site_name,
    city,
    state,
    pincode,
    site_type,
    created_at,
    last_updated_at
from {{ source('raw', 'sites') }}