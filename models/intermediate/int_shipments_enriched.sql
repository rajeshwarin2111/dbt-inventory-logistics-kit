SELECT
    --order details
    s.shipment_id,
    s.shipment_number,
    sl.shipment_line_id,
    s.shipment_type,
    s.move_order_id,
    s.return_order_id,

    --item details
    sl.item_id,
    i.item_name,                      
    i.item_category,                  
    i.is_returnable,  

    --quantity
    sl.dispatched_quantity,
    sl.received_quantity,
    sl.damaged_quantity,
    (sl.dispatched_quantity - coalesce(sl.received_quantity,0)) AS quantity_variance,
    CASE 
        WHEN (sl.dispatched_quantity - coalesce(sl.received_quantity, 0)) = 0 THEN 1
        ELSE 0 
    END AS is_fully_received,

    --shipment company details
    s.company_id,
    com.company_code,
    com.company_name,
    com.contact_person,

    -- eng details
    s.engineer_id,
    er.engineer_code,
    er.full_name,

    -- delivery dates
    s.dispatch_date,
    s.expected_delivery,
    s.actual_delivery,
    CASE 
        WHEN s.actual_delivery IS NULL THEN NULL
        ELSE DATEDIFF(s.actual_delivery,s.expected_delivery) 
    END AS delivery_delay_days,
    CASE
        WHEN s.actual_delivery IS NULL THEN NULL 
        WHEN s.actual_delivery <= s.expected_delivery THEN 1
        ELSE 0
    END AS is_on_time,

    --location details
    coalesce(mo_enr.WH_NAME,rmo_enr.WH_NAME) AS WH_NAME,
    coalesce(mo_enr.WH_CODE,rmo_enr.WH_CODE) AS WH_CODE,
    coalesce(mo_enr.WH_ID,rmo_enr.WH_ID) AS WH_ID,
    coalesce(mo_enr.site_id,rmo_enr.site_id) AS SITE_ID,
    coalesce(mo_enr.site_code,rmo_enr.site_code) AS SITE_CODE,
    coalesce(mo_enr.site_name,rmo_enr.site_name) AS SITE_NAME,
    coalesce(mo_enr.site_city,rmo_enr.site_city) AS SITE_CITY,
    coalesce(mo_enr.site_state,rmo_enr.site_state) AS SITE_STATE,

    --status
    sl.status AS LINE_STATUS,
    s.status AS MAIN_STATUS,

    sl.created_at AS CREATED_AT,
    sl.last_updated_at AS LAST_UPDATED_AT

FROM {{ source('raw', 'shipments') }} s 
LEFT JOIN {{ source('raw', 'shipment_lines') }} sl 
ON s.shipment_id = sl.shipment_id 
LEFT JOIN {{ source('raw', 'shipment_companies') }} com 
ON s.company_id = com.company_id
LEFT JOIN {{ source('raw', 'engineers') }} er 
ON s.engineer_id = er.engineer_id
LEFT JOIN {{ source('raw', 'items') }} i 
ON sl.item_id = i.item_id
left join (
    select distinct
        mo_id,
        WH_NAME,
        WH_CODE,
        WH_ID,
        SITE_ID,
        SITE_CODE,
        SITE_NAME,
        SITE_CITY,
        SITE_STATE
    from {{ ref('int_move_orders_enriched') }}
)  mo_enr
    on s.move_order_id = mo_enr.mo_id
LEFT JOIN (
    select distinct
        RMO_ID,
        WH_NAME,
        WH_CODE,
        WH_ID,
        SITE_ID,
        SITE_CODE,
        SITE_NAME,
        SITE_CITY,
        SITE_STATE
    from {{ ref('int_rev_orders_enriched') }}
)  rmo_enr
ON rmo_enr.rmo_id = s.return_order_id
