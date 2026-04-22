select
    -- keys
    MO_LINE_NUMBER          as move_order_line_id,
    mo_id                   as move_order_id,
    mo_number               as move_order_number,
    req_number              as request_number,

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
    wh_id                   as warehouse_id,
    wh_code                 as warehouse_code,
    wh_name                 as warehouse_name,

    -- measures
    REQ_QUANTITY            as requested_quantity,
    total_mo_quantity,

    -- context
    service_type,
    req_by                  as requested_by,
    mo_order_date           as order_date,

    -- flags
    is_fulfilled,
    is_pending,

    -- status
    main_status             as move_order_status,
    line_status,

    -- audit
    created_at,
    updated_at

from {{ ref('int_move_orders_enriched') }}