select
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
    warehouse_id,
    warehouse_code,
    warehouse_name,
    service_type,
    return_reason,
    item_condition,

    -- volume
    count(distinct return_order_id)                         as total_return_orders,
    count(RMO_LINE_NUMBER)                                   as total_return_lines,
    sum(dispatched_quantity)                                as total_returned_qty,
    sum(coalesce(received_quantity, 0))                     as total_received_back_qty,
    sum(coalesce(damaged_quantity, 0))                      as total_damaged_qty,

    -- return reason breakdown
    sum(case when return_reason = 'Excess'         then 1 else 0 end) as excess_returns,
    sum(case when return_reason = 'Faulty'         then 1 else 0 end) as faulty_returns,
    sum(case when return_reason = 'Uninstallation' then 1 else 0 end) as uninstallation_returns,

    -- condition breakdown
    sum(case when item_condition = 'Good'    then 1 else 0 end)       as good_condition,
    sum(case when item_condition = 'Faulty'  then 1 else 0 end)       as faulty_condition,
    sum(case when item_condition = 'Damaged' then 1 else 0 end)       as damaged_condition,

    -- receipt rate on returns
    round(
        sum(coalesce(received_quantity, 0)) * 100.0
        / nullif(sum(dispatched_quantity), 0)
    , 2)                                                    as return_receipt_rate_pct

from {{ ref('fct_return_lines') }}
group by
    item_id,
    item_name,
    item_category,
    is_returnable,
    site_id,
    site_code,
    site_name,
    site_city,
    site_state,
    warehouse_id,
    warehouse_code,
    warehouse_name,
    service_type,
    return_reason,
    item_condition