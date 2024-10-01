SELECT distinct
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


------------------- Requisição via Move Order ---------------
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
       
SELECT mp.organization_code     "Org",
       'Move Oder'              "Tipo Docto",
       trunc(mtrl.status_date)  "Data Consumo",
       mtr.request_number       "Requisicao",
       mtr.request_number       "Ordem",
       mtrl.line_number         "Linha",
       msi.segment1             "Item",
       msi.description          "Descricao",
       mtrl.quantity_delivered  "Quantidade",
       (select sum(CMPNT_COST) 
          from apps.cm_cmpt_dtl ccd
         where inventory_item_id = mtrl.inventory_item_id
           AND organization_id   = mtrl.organization_id
           AND cost_type_id      = '1005'
         --  AND COST_ANALYSIS_CODE = 'MT'
           AND period_id         = (SELECT MAX(cstt.period_id)
                                      FROM apps.CM_CMPT_DTL cstt, apps.gmf_period_statuses gps
                                     WHERE gps.cost_type_id       = cstt.cost_type_id
                                       AND cstt.period_id         = gps.period_id
                                       AND gps.period_status     IN ('C','F')
                                       AND cstt.delete_mark       = '0'
                                       AND cstt.organization_id   = mtrl.organization_id
                                       AND cstt.inventory_item_id = mtrl.inventory_item_id
                                       AND cstt.cost_type_id      = '1005'
                                       AND cmpnt_cost       <> 0)) CUSTO_STD,
       mtrl.quantity_delivered * (select sum(CMPNT_COST) 
                                    from apps.cm_cmpt_dtl ccd
                                   where inventory_item_id = mtrl.inventory_item_id
                                     AND organization_id   = mtrl.organization_id
                                     AND cost_type_id      = '1005'
                                   --  AND COST_ANALYSIS_CODE = 'MT'
                                     AND period_id         = (SELECT MAX(cstt.period_id)
                                                                FROM apps.CM_CMPT_DTL cstt, apps.gmf_period_statuses gps
                                                               WHERE gps.cost_type_id       = cstt.cost_type_id
                                                                 AND cstt.period_id         = gps.period_id
                                                                 AND gps.period_status     IN ('C','F')
                                                                 AND cstt.delete_mark       = '0'
                                                                 AND cstt.organization_id   = mtrl.organization_id
                                                                 AND cstt.inventory_item_id = mtrl.inventory_item_id
                                                                 AND cstt.cost_type_id      = '1005'
                                                                 AND cmpnt_cost       <> 0)) "Valor STD",
       decode(mtrl.line_status,1, 'Incompleto',
                               2, 'Aprovacao Pendente',
                               3, 'Aprovado',
                               4, 'Não Aprovado',
                               5, 'Fechado',
                               6, 'Cancelado',
                               7, 'Pre-Aprovado',
                               8, 'Parcialmente Aprovado',
                               9, 'Cancelado pela Origem') Status,
       mtrl.status_date,
       mtrl.line_number,
       '' "Delivery",
       mtr.request_number "Dcto",
       mtrl.line_number "Linha",
       '' "Req",
       '' "R.Line",
       '' "Unit Price",
      (select sum(CMPNT_COST) 
         from apps.cm_cmpt_dtl ccd
        where inventory_item_id = mtrl.inventory_item_id
          AND organization_id   = mtrl.organization_id
          AND cost_type_id      = '1005'
        --  AND COST_ANALYSIS_CODE = 'MT'
          AND period_id         = (SELECT MAX(cstt.period_id)
                                     FROM apps.CM_CMPT_DTL cstt, apps.gmf_period_statuses gps
                                    WHERE gps.cost_type_id       = cstt.cost_type_id
                                      AND cstt.period_id         = gps.period_id
                                      AND gps.period_status     IN ('C','F')
                                      AND cstt.delete_mark       = '0'
                                      AND cstt.organization_id   = mtrl.organization_id
                                      AND cstt.inventory_item_id = mtrl.inventory_item_id
                                      AND cstt.cost_type_id      = '1005'
                                      AND cmpnt_cost       <> 0)) CUSTO_STD,  
       mtrl.status_date,
       GCC.SEGMENT1||'.'||GCC.SEGMENT2||'.'||GCC.SEGMENT3||'.'||GCC.SEGMENT4||'.'||GCC.SEGMENT5||'.'||GCC.SEGMENT6 CONTA_CONTABIL
  FROM mtl_txn_request_headers_v   mtr,
       mtl_txn_request_lines       mtrl,
       mtl_transaction_reasons     mt,
       apps.gl_code_combinations_v gcc,
       apps.mtl_system_items_b     msi,
       apps.mtl_parameters         mp
 WHERE mtr.transaction_type_name  = 'Move Order Issue'     AND
       mtr.move_order_type_name   = 'Requisition'          AND
       mtr.organization_id        = 92                     AND
       msi.organization_id        = mtr.organization_id    AND
       msi.inventory_item_id      = mtrl.inventory_item_id AND
       mp.organization_id         = msi.organization_id    AND
       mtrl.header_id             = mtr.header_id          AND
       mtrl.status_date          >= to_date('01/sep/2020') AND
       mtrl.status_date          <= sysdate                AND
       mt.reason_id               = mtrl.reason_id         AND
       gcc.code_combination_id(+) = mtrl.TO_ACCOUNT_ID     AND
       mtrl.line_status          <> 6 /*Desconsidera Documento Cancelado*/;



select * from  mtl_txn_request_headers_v   mtr where request_number =  '3768602'

select  rowid, mtrl.* from mtl_txn_request_lines       mtrl where header_id = 3768602

------------------------------------------------------------- 



 
 
 SELECT * --start_date, end_date INTO l_dt_ini, l_dt_fim
   FROM apps.gmf_period_statuses gps
  WHERE start_date <= SYSDATE AND
        end_date   >= SYSDATE AND
        cost_type_id = 1005;
       WHERE gps.calendar_code = p_calendar_code AND
             gps.period_id     = p_period_id     AND
             gps.cost_type_id  = p_cost_type_id;
------------------------------- original -------------------------------------------



--------------- Requisição via Internal Requisition -------------
SELECT distinct
       mp.organization_code         "Org",
       'Requisition'                "Tipo Docto",
       TRUNC(nd.confirm_date)       "Data Consumo",
       prh.segment1                 "Requisicao",
       TO_CHAR(oh.order_number)     "Ordem",
       ol.line_number               "Linha",
       ol.ORDERED_ITEM              "Item",
       msi.description              "Descricao",
       dd.shipped_quantity          "Quantidade",
       (select sum(CMPNT_COST) 
          from apps.cm_cmpt_dtl ccd
         where inventory_item_id = msi.inventory_item_id
           AND organization_id   = msi.organization_id
           AND cost_type_id      = '1005'
           AND period_id         = (SELECT MAX(cstt.period_id)
                                      FROM apps.CM_CMPT_DTL cstt, apps.gmf_period_statuses gps
                                     WHERE gps.cost_type_id       = cstt.cost_type_id
                                       AND cstt.period_id         = gps.period_id
                                       AND gps.period_status     IN ('C','F')
                                       AND cstt.delete_mark       = '0'
                                       AND cstt.organization_id   = msi.organization_id
                                       AND cstt.inventory_item_id = msi.inventory_item_id
                                       AND cstt.cost_type_id      = '1005'
                                       AND cmpnt_cost       <> 0)) CUSTO_STD,
       dd.shipped_quantity * (select sum(CMPNT_COST) 
                                from apps.cm_cmpt_dtl ccd
                               where inventory_item_id = msi.inventory_item_id
                                 AND organization_id   = msi.organization_id
                                 AND cost_type_id      = '1005'
                                 AND period_id         = (SELECT MAX(cstt.period_id)
                                                            FROM apps.CM_CMPT_DTL cstt, apps.gmf_period_statuses gps
                                                           WHERE gps.cost_type_id       = cstt.cost_type_id
                                                             AND cstt.period_id         = gps.period_id
                                                             AND gps.period_status     IN ('C','F')
                                                             AND cstt.delete_mark       = '0'
                                                             AND cstt.organization_id   = msi.organization_id
                                                             AND cstt.inventory_item_id = msi.inventory_item_id
                                                             AND cstt.cost_type_id      = '1005'
                                                             AND cmpnt_cost       <> 0)) "Valor STD",
       GCC.SEGMENT1||'.'||GCC.SEGMENT2||'.'||GCC.SEGMENT3||'.'||GCC.SEGMENT4||'.'||GCC.SEGMENT5||'.'||GCC.SEGMENT6 "CONTA CONTABIL",
       (select description from apps.fnd_user where user_id = prh.created_by) "Usuario",  
       prh.description "Observacao",
       ' ' "Motivo"
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
       apps.mtl_system_items_b         msi,
       apps.mtl_parameters             mp
 WHERE rc.customer_trx_id (+)                    = rl.customer_trx_id         AND
       rl.line_type (+)                          = 'LINE'                     AND
       to_char(rl.interface_line_attribute6 (+)) = to_char(ol.line_id)        AND
       nd.delivery_id (+)                        = da.delivery_id             AND
       nd.status_code                            = 'CL'                       AND
       da.delivery_detail_id (+)                 = dd.delivery_detail_id      AND
       dd.source_line_id (+)                     = ol.line_id                 AND
       ol.header_id (+)                          = oh.header_id               AND
       prl.requisition_line_id                   = prd.requisition_line_id    AND
       ol.source_document_line_id                = prl.requisition_line_id(+) AND
       prd.code_combination_id                   = gcc.code_combination_id(+) AND
       oh.orig_sys_document_ref                  = prh.segment1               AND
       oh.org_id      IN(select operating_unit
                           from apps.org_organization_definitions
                          where organization_id = prl.source_organization_id) AND 
       ol.header_id(+)                           = oh.header_id               AND
       prl.destination_organization_id           = prl.SOURCE_ORGANIZATION_ID AND
       PRH.TYPE_LOOKUP_CODE                      = 'INTERNAL'                 AND
       ol.ordered_quantity                       > 0                          AND
       nd.confirm_date                          >= to_date('01/may/2021')     AND -- Selecao
       nd.confirm_date                          <= to_date('31/may/2021')     AND -- Selecao
       NVL(nd.name,'')                         <> ' '                         AND
       msi.inventory_item_id                     = dd.inventory_item_id       AND
       msi.organization_id                       = oh.SHIP_FROM_ORG_ID        AND
       mp.organization_id                        = msi.organization_id        AND
       mp.organization_id                        = 92                             -- Selecao
--------------- Requisição via Internal Requisition -------------       
    UNION ALL
------------------- Requisição via Move Order -------------------
SELECT mp.organization_code         "Org",
       'Move Oder'                  "Tipo Docto",
       trunc(mtrl.status_date)      "Data Consumo",
       mtr.request_number           "Requisicao",
       TO_CHAR(mtr.request_number)  "Ordem",
       mtrl.line_number             "Linha",
       msi.segment1                 "Item",
       msi.description              "Descricao",
       mtrl.quantity_delivered      "Quantidade",
       (select sum(CMPNT_COST) 
          from apps.cm_cmpt_dtl ccd
         where inventory_item_id = mtrl.inventory_item_id
           AND organization_id   = mtrl.organization_id
           AND cost_type_id      = '1005'
         --  AND COST_ANALYSIS_CODE = 'MT'
           AND period_id         = (SELECT MAX(cstt.period_id)
                                      FROM apps.CM_CMPT_DTL cstt, apps.gmf_period_statuses gps
                                     WHERE gps.cost_type_id       = cstt.cost_type_id
                                       AND cstt.period_id         = gps.period_id
                                       AND gps.period_status     IN ('C','F')
                                       AND cstt.delete_mark       = '0'
                                       AND cstt.organization_id   = mtrl.organization_id
                                       AND cstt.inventory_item_id = mtrl.inventory_item_id
                                       AND cstt.cost_type_id      = '1005'
                                       AND cmpnt_cost       <> 0)) CUSTO_STD,
       mtrl.quantity_delivered * (select sum(CMPNT_COST) 
                                    from apps.cm_cmpt_dtl ccd
                                   where inventory_item_id = mtrl.inventory_item_id
                                     AND organization_id   = mtrl.organization_id
                                     AND cost_type_id      = '1005'
                                   --  AND COST_ANALYSIS_CODE = 'MT'
                                     AND period_id         = (SELECT MAX(cstt.period_id)
                                                                FROM apps.CM_CMPT_DTL cstt, apps.gmf_period_statuses gps
                                                               WHERE gps.cost_type_id       = cstt.cost_type_id
                                                                 AND cstt.period_id         = gps.period_id
                                                                 AND gps.period_status     IN ('C','F')
                                                                 AND cstt.delete_mark       = '0'
                                                                 AND cstt.organization_id   = mtrl.organization_id
                                                                 AND cstt.inventory_item_id = mtrl.inventory_item_id
                                                                 AND cstt.cost_type_id      = '1005'
                                                                 AND cmpnt_cost       <> 0)) "Valor STD",
       GCC.SEGMENT1||'.'||GCC.SEGMENT2||'.'||GCC.SEGMENT3||'.'||GCC.SEGMENT4||'.'||GCC.SEGMENT5||'.'||GCC.SEGMENT6 CONTA_CONTABIL,
       (select description from apps.fnd_user where user_id = mtr.created_by) "Usuario",
       mtr.description "Comentario",
       mt.reason_name  "Motivo"
  FROM apps.mtl_txn_request_headers_v mtr,
       apps.mtl_txn_request_lines     mtrl,
       apps.mtl_transaction_reasons   mt,
       apps.gl_code_combinations_v    gcc,
       apps.mtl_system_items_b        msi,
       apps.mtl_parameters            mp
 WHERE --mtr.transaction_type_name  = 'Move Order Issue'     AND
       mtr.transaction_type_name  like 'Move Order%'     AND
       mtr.move_order_type_name   = 'Requisition'          AND
       mtr.organization_id        = 92                     AND --Selecao
       msi.organization_id        = mtr.organization_id    AND
       msi.inventory_item_id      = mtrl.inventory_item_id AND
       mp.organization_id         = msi.organization_id    AND
       mtrl.header_id             = mtr.header_id          AND
       mtrl.status_date          >= to_date('01/may/2021') AND -- Selecao
       mtrl.status_date          <= to_date('31/may/2021') AND -- Selecao
       mtrl.quantity_delivered    > 0                      AND
       mt.reason_id               = mtrl.reason_id         AND
       gcc.code_combination_id(+) = mtrl.TO_ACCOUNT_ID     AND
       mtrl.line_status          <> 6 /*Desconsidera Documento Cancelado*/
    order by 3;
------------------- Requisição via Move Order -------------------             
























SELECT mp.organization_code         "Org",
mtr.transaction_type_id,
mtr.transaction_type_name,
       'Move Oder'                  "Tipo Docto",
       trunc(mtrl.status_date)      "Data Consumo",
       mtr.request_number           "Requisicao",
       TO_CHAR(mtr.request_number)  "Ordem",
       mtrl.line_number             "Linha",
       msi.segment1                 "Item",
       msi.description              "Descricao",
       mtrl.quantity_delivered      "Quantidade",
       (select sum(CMPNT_COST) 
          from apps.cm_cmpt_dtl ccd
         where inventory_item_id = mtrl.inventory_item_id
           AND organization_id   = mtrl.organization_id
           AND cost_type_id      = '1005'
         --  AND COST_ANALYSIS_CODE = 'MT'
           AND period_id         = (SELECT MAX(cstt.period_id)
                                      FROM apps.CM_CMPT_DTL cstt, apps.gmf_period_statuses gps
                                     WHERE gps.cost_type_id       = cstt.cost_type_id
                                       AND cstt.period_id         = gps.period_id
                                       AND gps.period_status     IN ('C','F')
                                       AND cstt.delete_mark       = '0'
                                       AND cstt.organization_id   = mtrl.organization_id
                                       AND cstt.inventory_item_id = mtrl.inventory_item_id
                                       AND cstt.cost_type_id      = '1005'
                                       AND cmpnt_cost       <> 0)) CUSTO_STD,
       mtrl.quantity_delivered * (select sum(CMPNT_COST) 
                                    from apps.cm_cmpt_dtl ccd
                                   where inventory_item_id = mtrl.inventory_item_id
                                     AND organization_id   = mtrl.organization_id
                                     AND cost_type_id      = '1005'
                                   --  AND COST_ANALYSIS_CODE = 'MT'
                                     AND period_id         = (SELECT MAX(cstt.period_id)
                                                                FROM apps.CM_CMPT_DTL cstt, apps.gmf_period_statuses gps
                                                               WHERE gps.cost_type_id       = cstt.cost_type_id
                                                                 AND cstt.period_id         = gps.period_id
                                                                 AND gps.period_status     IN ('C','F')
                                                                 AND cstt.delete_mark       = '0'
                                                                 AND cstt.organization_id   = mtrl.organization_id
                                                                 AND cstt.inventory_item_id = mtrl.inventory_item_id
                                                                 AND cstt.cost_type_id      = '1005'
                                                                 AND cmpnt_cost       <> 0)) "Valor STD",
       GCC.SEGMENT1||'.'||GCC.SEGMENT2||'.'||GCC.SEGMENT3||'.'||GCC.SEGMENT4||'.'||GCC.SEGMENT5||'.'||GCC.SEGMENT6 CONTA_CONTABIL,
       (select description from apps.fnd_user where user_id = mtr.created_by) "Usuario",
       mtr.description "Comentario",
       mt.reason_name  "Motivo"
  FROM apps.mtl_txn_request_headers_v mtr,
       apps.mtl_txn_request_lines     mtrl,
       apps.mtl_transaction_reasons   mt,
       apps.gl_code_combinations_v    gcc,
       apps.mtl_system_items_b        msi,
       apps.mtl_parameters            mp
 WHERE --mtr.transaction_type_name  = 'Move Order Issue'     AND
       mtr.transaction_type_name  like 'Move Order%'     AND
       mtr.move_order_type_name   = 'Requisition'          AND
       mtr.organization_id        = 92                     AND --Selecao
       msi.organization_id        = mtr.organization_id    AND
       msi.inventory_item_id      = mtrl.inventory_item_id AND
       mp.organization_id         = msi.organization_id    AND
       mtrl.header_id             = mtr.header_id          AND
      -- mtrl.status_date          >= to_date('01/may/2021') AND -- Selecao
      -- mtrl.status_date          <= to_date('31/may/2021') AND -- Selecao
       mtrl.quantity_delivered    > 0                      AND
       mt.reason_id(+)               = mtrl.reason_id         AND
       gcc.code_combination_id(+) = mtrl.TO_ACCOUNT_ID     AND
       mtr.request_number in ('3067512','3045845') and
       mtrl.line_status          <> 6 /*Desconsidera Documento Cancelado*/
    order by 3;