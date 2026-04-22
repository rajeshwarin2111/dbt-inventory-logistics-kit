SELECT 
    --RMO details
    rev.return_order_id AS RMO_ID,
    rev.return_order_number AS RMO_NUMBER,
    l.return_line_id AS RMO_LINE_NUMBER,
    rev.move_order_id AS MO_ID,
    r.request_number AS REQ_NUMBER,
    r.service_type AS SERVICE_TYPE,

    -- site details(from location)
    s.site_id AS SITE_ID,
    s.site_code AS SITE_CODE,
    s.site_name AS SITE_NAME,
    s.city         as SITE_CITY,
    s.state        as SITE_STATE,

    -- warehouse details(to location)
    wh.warehouse_code AS WH_CODE,
    wh.warehouse_name AS WH_NAME,
    wh.warehouse_id AS WH_ID,
    rev.created_at AS RMO_CREATED_DATE,

    --item details
    l.item_id AS ITEM_ID,
    i.item_name AS ITEM_NAME,
    i.item_category,
    i.is_returnable,

    --quantity details
    coalesce(l.dispatched_quantity,0) AS DISPATCH_QUANTITY,
    coalesce(l.received_quantity,0) AS REC_QUANTITY,
    coalesce(l.damaged_quantity,0) AS DAMAGED_QUANTITY,
    SUM(l.dispatched_quantity) OVER(PARTITION BY rev.return_order_id) AS TOTAL_RMO_DISPATCH_QUANTITY,
    (l.dispatched_quantity - coalesce(l.received_quantity, 0)) as QUANTITY_VARIANCE,
    case
        when (l.dispatched_quantity - coalesce(l.received_quantity, 0)) = 0 then 1
        else 0
    end as IS_FULLY_REC,

    --status
    rev.return_reason AS RMO_REASON,
    rev.status AS MAIN_STATUS,
    l.status AS LINE_STATUS,
    l.condition AS ITEM_CONDITION,
    case 
        when UPPER(l.status) = 'RECEIVED' then 1
        else 0
    end as IS_RECEIVED,
    case 
        when UPPER(l.status) in ('PENDING') then 1
        else 0
    end as IS_PENDING,

    
    r.requestor_name AS REQ_BY,
    l.created_at AS CREATED_AT,
    l.last_updated_at AS UPDATED_AT

FROM  {{ source('raw', 'return_orders') }}  rev 
LEFT JOIN {{ source('raw', 'return_order_lines') }}  l 
ON rev.return_order_id = l.return_order_id
LEFT JOIN {{ source('raw', 'requests') }} r
ON rev.request_id = r.request_id
LEFT JOIN {{ source('raw', 'sites') }} s 
ON rev.site_id = s.site_id
LEFT JOIN {{ source('raw', 'warehouses') }} wh
ON rev.warehouse_id = wh.warehouse_id
LEFT JOIN {{ source('raw', 'items') }} i 
ON l.item_id = i.item_id
    
