select
    -- dimensions
    s.warehouse_id,
    w.warehouse_code,
    w.warehouse_name,
    w.city                                                  as warehouse_city,
    w.state                                                 as warehouse_state,
    s.item_id,
    i.item_code,
    i.item_name,
    i.item_category,
    i.is_returnable,

    -- stock measures
    s.quantity_available,
    s.quantity_reserved,
    s.quantity_damaged,
    (s.quantity_available + s.quantity_reserved)            as total_stock,

    -- utilization
    round(
        s.quantity_reserved * 100.0
        / nullif(s.quantity_available + s.quantity_reserved, 0)
    , 2)                                                    as reservation_rate_pct,

    round(
        s.quantity_damaged * 100.0
        / nullif(s.quantity_available + s.quantity_reserved + s.quantity_damaged, 0)
    , 2)                                                    as damage_rate_pct,

    -- health flag
    case
        when s.quantity_available = 0 and s.quantity_reserved > 0  then 'Fully Reserved'
        when s.quantity_available = 0 and s.quantity_reserved = 0  then 'Out of Stock'
        when s.quantity_available <= 5                              then 'Low Stock'
        else                                                             'Healthy'
    end                                                     as stock_health_status,

    s.last_updated_at

from {{ source('raw', 'stock') }} s
left join {{ ref('dim_warehouses') }} w
    on s.warehouse_id = w.warehouse_id
left join {{ ref('dim_items') }} i
    on s.item_id = i.item_id