select
    -- dimensions to slice by
    move_order_id,
    move_order_number,
    service_type,
    site_id,
    site_code,
    site_name,
    site_city,
    site_state,
    warehouse_id,
    warehouse_code,
    warehouse_name,
    order_date,
    requested_by,

    -- volume metrics
    count(move_order_line_id)                               as total_line_items,
    sum(requested_quantity)                                 as total_requested_qty,

    -- fulfillment metrics
    sum(case when is_fulfilled = 1 then 1 else 0 end)       as fulfilled_lines,
    sum(case when is_pending   = 1 then 1 else 0 end)       as pending_lines,

    -- fulfillment rate
    round(
        sum(case when is_fulfilled = 1 then 1 else 0 end) * 100.0
        / nullif(count(move_order_line_id), 0)
    , 2)                                                    as fulfillment_rate_pct,

    -- order level status
    max(move_order_status)                                  as move_order_status,

    -- is entire order fulfilled
    case
        when sum(case when is_pending = 1 then 1 else 0 end) = 0 then 1
        else 0
    end                                                     as is_fully_fulfilled

from {{ ref('fct_move_order_lines') }}
group by
    move_order_id,
    move_order_number,
    service_type,
    site_id,
    site_code,
    site_name,
    site_city,
    site_state,
    warehouse_id,
    warehouse_code,
    warehouse_name,
    order_date,
    requested_by,
    move_order_status