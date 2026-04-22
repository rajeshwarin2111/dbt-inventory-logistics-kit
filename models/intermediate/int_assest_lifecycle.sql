select
    -- move order context
    mo.mo_id,
    mo.mo_number,
    mo.req_number,
    mo.service_type,
    mo.item_id,
    mo.item_name,
    mo.item_category,
    mo.is_returnable,
    mo.REQ_QUANTITY,
    mo.site_id,
    mo.site_code,
    mo.site_name,
    mo.site_city,
    mo.site_state,
    mo.wh_id,
    mo.wh_code,
    mo.wh_name,
    mo.mo_order_date,
    mo.req_by,

    -- forward shipment context
    sh.shipment_id,
    sh.shipment_number,
    sh.dispatched_quantity,
    sh.received_quantity,
    sh.damaged_quantity,
    sh.quantity_variance,
    sh.is_fully_received,
    sh.dispatch_date,
    sh.expected_delivery,
    sh.actual_delivery,
    sh.delivery_delay_days,
    sh.is_on_time,
    sh.main_status      as shipment_status,

    -- return context
    rv.rmo_id           as return_order_id,
    rv.rmo_number       as return_order_number,
    rv.rmo_reason       as return_reason,
    rv.dispatch_quantity as return_dispatched_qty,
    rv.rec_quantity     as return_received_qty,
    rv.item_condition,
    rv.main_status      as return_status,

    -- lifecycle flags
    case when sh.shipment_id  is not null then 1 else 0 end as is_dispatched,
    case when sh.actual_delivery is not null then 1 else 0 end as is_delivered,
    case when rv.rmo_id is not null then 1 else 0 end as is_returned,
    case
        when rv.rmo_id is not null
         and rv.rec_quantity < sh.received_quantity then 1
        else 0
    end as is_partially_returned,

    -- lifecycle stage
    case
        when rv.rmo_id is not null                              then 'Returned'
        when sh.actual_delivery is not null and rv.rmo_id is null then 'Installed'
        when sh.shipment_id is not null and sh.actual_delivery is null then 'In Transit'
        when sh.shipment_id is null                             then 'Pending Dispatch'
    end as lifecycle_stage

from {{ ref('int_move_orders_enriched') }} mo

-- forward shipment — join on move_order_id + item_id to stay at correct grain
left join {{ ref('int_shipments_enriched') }} sh
    on  mo.mo_id   = sh.move_order_id
    and mo.item_id = sh.item_id
    and sh.shipment_type = 'FORWARD'

-- return — join on move_order_id + item_id
left join {{ ref('int_rev_orders_enriched') }} rv
    on  mo.mo_id   = rv.mo_id
    and mo.item_id = rv.item_id