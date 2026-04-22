SELECT 
    m.move_order_id AS MO_ID,
    m.move_order_number AS MO_NUMBER,
    l.line_id AS MO_LINE_NUMBER,
    r.request_number AS REQ_NUMBER,
    r.service_type AS SERVICE_TYPE,
    s.site_id AS SITE_ID,
    s.site_code AS SITE_CODE,
    s.site_name AS SITE_NAME,
    s.city         as site_city,
    s.state        as site_state,
    wh.warehouse_id AS WH_ID,
    wh.warehouse_code AS WH_CODE,
    wh.warehouse_name AS WH_NAME,
    m.order_date AS MO_ORDER_DATE,
    l.item_id AS ITEM_ID,
    i.item_name AS ITEM_NAME,
    i.item_category,
    i.is_returnable,
    l.requested_quantity AS REQ_QUANTITY,
    SUM(l.requested_quantity) OVER(PARTITION BY m.move_order_id) AS TOTAL_MO_QUANTITY,
    m.status AS MAIN_STATUS,
    l.status AS LINE_STATUS,
    case 
        when UPPER(l.status) = 'FULFILLED' then 1
        else 0
    end as IS_FULFILLED,
    case 
        when UPPER(l.status) in ('PENDING', 'PARTIALLY FILFILLED') then 1
        else 0
    end as IS_PENDING,
    r.requestor_name AS REQ_BY,
    l.created_at AS CREATED_AT,
    l.last_updated_at AS UPDATED_AT

FROM  {{ source('raw', 'move_orders') }}  m 
LEFT JOIN {{ source('raw', 'move_order_lines') }}  l 
ON m.move_order_id = l.move_order_id
LEFT JOIN {{ source('raw', 'requests') }} r
ON m.request_id = r.request_id
LEFT JOIN {{ source('raw', 'sites') }} s 
ON m.site_id = s.site_id
LEFT JOIN {{ source('raw', 'warehouses') }} wh
ON m.warehouse_id = wh.warehouse_id
LEFT JOIN {{ source('raw', 'items') }} i 
ON l.item_id = i.item_id
    
