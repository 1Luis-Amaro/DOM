SELECT distinct
       oh.ordered_date,
       oh.order_number "Ordem",
--       prl.SOURCE_ORGANIZATION_ID,
--       prl.DESTINATION_ORGANIZATION_ID,
       ol.ORDERED_ITEM,
--     ol.ordered_quantity,
       dd.shipped_quantity,
       decode (dd.RELEASED_STATUS,'B', 'Backordered',
                                  'C', 'Shipped',
                                  'D', 'Cancelled',
                                  'N', 'Not ready for Release',
                                  'R', 'Ready to Release',
                                  'S', 'Released to wharehouse',
                                  'X', 'Not Applicable',
                                  'Y', 'Staged') RELEASED_STATUS,
       dd.LATEST_PICKUP_DATE,
       ol.line_number "Lin",
       nd.name "Delivery",
       rc.trx_number "Dcto",
       rl.line_number "Linha",
       prh.segment1 "Req",
       prl.line_num "R.Line",
--       prl.requisition_line_id,
       prl.Unit_Price "Unit Price",
       cst.vl_std,
--       OL.UNIT_SELLING_PRICE,
--       OL.UNIT_LIST_PRICE,
--       RL.UNIT_SELLING_PRICE,
--       RL.UNIT_STANDARD_PRICE,
       nd.confirm_date,
       GCC.SEGMENT1||'.'||GCC.SEGMENT2||'.'||GCC.SEGMENT3||'.'||GCC.SEGMENT4||'.'||GCC.SEGMENT5||'.'||GCC.SEGMENT6 CONTA_CONTABIL
       ,dd.item_description    
--       ,rl.*
  FROM apps.ra_customer_trx_all        rc,
       apps.ra_customer_trx_lines_all  rl,
       apps.wsh_new_deliveries         nd,
       apps.wsh_delivery_assignments   da,
       apps.wsh_delivery_details       dd,
       apps.oe_order_headers_all       oh,
       apps.oe_order_lines_all         ol,
       apps.po_requisition_lines_all   prl,
       apps.po_requisition_headers_all prh,
       apps.po_req_distributions_all   prd,
       apps.gl_code_combinations_v     gcc,
       apps.gmf_period_statuses        gps,
      (SELECT SUM(cst.CMPNT_COST) vl_std,
              cst.inventory_item_id,
              cst.organization_id,
              cst.period_id
         FROM apps.CM_CMPT_DTL cst
        WHERE cst.delete_mark        = '0'
          AND cst.organization_id    = 92
          AND cst.cost_type_id       = 1005
        GROUP BY cst.inventory_item_id,cst.organization_id,cst.period_id) cst
 WHERE rc.customer_trx_id (+)                    = rl.customer_trx_id
   AND rl.line_type (+)                          = 'LINE'
   AND to_char(rl.interface_line_attribute6 (+)) = to_char(ol.line_id)
   AND nd.delivery_id (+)                        = da.delivery_id
   AND da.delivery_detail_id (+)                 = dd.delivery_detail_id
   AND dd.source_line_id (+)                     = ol.line_id
   AND ol.header_id (+)                          = oh.header_id
   AND prl.requisition_line_id                   = prd.requisition_line_id
   AND ol.source_document_line_id                = prl.requisition_line_id(+)
   AND prd.code_combination_id                   = gcc.code_combination_id(+)   
   AND oh.orig_sys_document_ref                  = prh.segment1
   and oh.org_id                                IN(select operating_unit
                                                     from apps.org_organization_definitions
                                                    where organization_id = prl.source_organization_id) 
   --AND prl.destination_organization_id          <> prl.source_organization_id
   AND ol.header_id(+)                           = oh.header_id
   AND prl.destination_organization_id           = prl.SOURCE_ORGANIZATION_ID
   AND PRH.TYPE_LOOKUP_CODE                      = 'INTERNAL' 
 --  AND ol.ordered_quantity                       > 0 --APENAS QUANTIDADES ATENDIDAS
   AND NVL(nd.name,'')                         <> ' '
   AND gps.start_date                           <= nvl(nd.confirm_date,dd.date_requested) --dd.latest_pickup_date
   AND gps.end_date                             >= nvl(nd.confirm_date,dd.date_requested) --dd.latest_pickup_date
   AND gps.cost_type_id                          = 1005 -- STD;
   AND cst.organization_id                       = 92
   --AND cst.cost_analysis_code = 'MT'
   AND cst.period_id                             = gps.period_id
   AND cst.inventory_item_id                     = dd.inventory_item_id
--   and dd.subinventory = 'MROS'
--   and nd.confirm_date >= to_date('01-sep-2017')
  -- AND prh.segment1 = 82186
   --and prh.segment1                              = '151'
   --and prh.org_id in(171)
    --and oh.org_id not in(83,84)
    --AND prh.segment1 IN('77')
    ;
    
---- dd.RELEASED_STATUS,    
--B - 'Backordered'
--C - 'Shipped'
--D - 'Cancelled'
--N - 'Not ready for Release'
--R - 'Ready to Release'
--S - 'Released to wharehouse'
--X - 'Not Applicable'
--Y - 'Staged'
    
select * from apps.wsh_delivery_details       dd;    
select * from apps.wsh_delivery_assignments   da;
select * from apps.wsh_new_deliveries         nd;


 
 
 
 SELECT * --start_date, end_date INTO l_dt_ini, l_dt_fim
   FROM apps.gmf_period_statuses gps
  WHERE start_date <= SYSDATE AND
        end_date   >= SYSDATE AND
        cost_type_id = 1005;
       WHERE gps.calendar_code = p_calendar_code AND
             gps.period_id     = p_period_id     AND
             gps.cost_type_id  = p_cost_type_id;