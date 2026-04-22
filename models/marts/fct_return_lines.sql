select
    -- keys
    RMO_LINE_NUMBER,
    rmo_id                      as return_order_id,
    rmo_number                  as return_order_number,
    mo_id                       as move_order_id,
    req_number                  as request_number,

    -- dimensions
    item_id,
    item_name,
    item_category,
    is_returnable,
    site_id,
    site_code,
    site_name,
    site_city,
    site_state,
    wh_id                       as warehouse_id,
    wh_code                     as warehouse_code,
    wh_name                     as warehouse_name,

    -- context
    service_type,
    req_by                      as requested_by,
    rmo_reason                  as return_reason,
    item_condition,

    -- measures
    dispatch_quantity           as dispatched_quantity,
    rec_quantity                as received_quantity,
    damaged_quantity,
    quantity_variance,
    IS_FULLY_REC                as is_fully_received,
    TOTAL_RMO_DISPATCH_QUANTITY as total_rmo_dispatched_quantity,

    -- flags
    is_received,
    is_pending,

    -- status
    main_status                 as return_order_status,
    line_status,

    -- audit
    created_at,
    updated_at

from {{ ref('int_rev_orders_enriched') }}