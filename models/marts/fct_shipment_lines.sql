select
    -- keys
    shipment_line_id,
    shipment_id,
    shipment_number,
    move_order_id,
    return_order_id,
    shipment_type,

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

    -- company & engineer
    company_id,
    company_code,
    company_name,
    contact_person,
    engineer_id,
    engineer_code,
    full_name                   as engineer_name,

    -- measures
    dispatched_quantity,
    received_quantity,
    damaged_quantity,
    quantity_variance,
    is_fully_received,

    -- delivery performance
    dispatch_date,
    expected_delivery,
    actual_delivery,
    delivery_delay_days,
    is_on_time,

    -- status
    main_status                 as shipment_status,
    line_status,

    -- audit
    created_at,
    last_updated_at

from {{ ref('int_shipments_enriched') }}