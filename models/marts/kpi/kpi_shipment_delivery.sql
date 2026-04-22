select
    -- dimensions
    company_id,
    company_code,
    company_name,
    warehouse_id,
    warehouse_code,
    warehouse_name,
    site_id,
    site_code,
    site_name,
    shipment_type,

    -- volume
    count(distinct shipment_id)                             as total_shipments,
    count(shipment_line_id)                                 as total_lines,
    sum(dispatched_quantity)                                as total_dispatched_qty,
    sum(coalesce(received_quantity, 0))                     as total_received_qty,
    sum(coalesce(damaged_quantity, 0))                      as total_damaged_qty,

    -- delivery performance
    count(
        case when is_on_time = 1 then 1 end
    )                                                       as on_time_deliveries,
    count(
        case when is_on_time = 0 then 1 end
    )                                                       as delayed_deliveries,
    round(
        count(case when is_on_time = 1 then 1 end) * 100.0
        / nullif(count(case when actual_delivery is not null then 1 end), 0)
    , 2)                                                    as on_time_rate_pct,
    round(avg(
        case when delivery_delay_days is not null
        then delivery_delay_days end
    ), 1)                                                   as avg_delay_days,

    -- damage rate
    round(
        sum(coalesce(damaged_quantity, 0)) * 100.0
        / nullif(sum(dispatched_quantity), 0)
    , 2)                                                    as damage_rate_pct,

    -- receipt rate
    round(
        sum(coalesce(received_quantity, 0)) * 100.0
        / nullif(sum(dispatched_quantity), 0)
    , 2)                                                    as receipt_rate_pct

from {{ ref('fct_shipment_lines') }}
group by
    company_id,
    company_code,
    company_name,
    warehouse_id,
    warehouse_code,
    warehouse_name,
    site_id,
    site_code,
    site_name,
    shipment_type