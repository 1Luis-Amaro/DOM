select organization_id, segment1, inventory_item_id from apps.mtl_system_items_b where segment1 = 'TOSA-00027.48'; inventory_item_id = 1955776;
SELECT distinct
da.*,
       oh.ordered_date,
       oh.order_number "Ordem",
       ol.ORDERED_ITEM,
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
       prl.Unit_Price "Unit Price",
       cst.vl_std,
       nd.confirm_date,
       GCC.SEGMENT1||'.'||GCC.SEGMENT2||'.'||GCC.SEGMENT3||'.'||GCC.SEGMENT4||'.'||GCC.SEGMENT5||'.'||GCC.SEGMENT6 CONTA_CONTABIL
       ,dd.item_description
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
   and oh.order_number = 734913
   and oh.org_id                                IN(select operating_unit
                                                     from apps.org_organization_definitions
                                                    where organization_id = prl.source_organization_id) 
   AND ol.header_id(+)                           = oh.header_id
   AND prl.destination_organization_id           = prl.SOURCE_ORGANIZATION_ID
   AND PRH.TYPE_LOOKUP_CODE                      = 'INTERNAL' 
 --  AND ol.ordered_quantity                       > 0 --APENAS QUANTIDADES ATENDIDAS
   AND NVL(nd.name,'')                         <> ' '
   AND nd.status_code                           = 'CL'
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
    
select organization_id,transaction_type_id, transaction_quantity, mmt.* from apps.mtl_material_transactions mmt where inventory_item_id = 4826 and trunc(transaction_date) >= '01/oct/2020' and trunc(transaction_date) <= '31/oct/2020'    

select * from apps.mtl_material_transactions where LOGICAL_TRANSACTION is not null and TRANSACTION_TYPE_ID <> 10008 and TRANSACTION_TYPE_ID <> 27;

select TRX_SOURCE_DELIVERY_ID, prl.DESTINATION_TYPE_CODE
  from apps.mtl_material_transactions mmt,
       apps.wsh_delivery_assignments   da,
       apps.wsh_delivery_details       dd,
       apps.oe_order_headers_all       oh,
       apps.oe_order_lines_all         ol,
       apps.po_requisition_lines_all   prl,
       apps.po_requisition_headers_all prh 
 where mmt.inventory_item_id = 1955776 and
       trunc(transaction_date) = '22/jul/2020' and
       mmt.TRX_SOURCE_DELIVERY_ID = da.delivery_id and
       transaction_quantity= -5 and
       da.delivery_detail_id (+)                 = dd.delivery_detail_id
       AND dd.source_line_id (+)                     = ol.line_id
       AND ol.header_id (+)                          = oh.header_id
       --AND prl.requisition_line_id                   = prd.requisition_line_id
       AND ol.source_document_line_id                = prl.requisition_line_id(+)
       AND oh.orig_sys_document_ref                  = prh.segment1;    
