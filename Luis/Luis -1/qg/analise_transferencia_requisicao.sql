/* Formatted on 14/09/2015 15:34:22 (QP5 v5.227.12220.39724) */
SELECT DISTINCT
       oh.ordered_date,
       oh.order_number "Ordem",
       prl.SOURCE_ORGANIZATION_ID,
       prl.DESTINATION_ORGANIZATION_ID,
       ol.ORDERED_ITEM,
       ol.ordered_quantity,
       ol.line_number "Lin_OM",
       nd.name "Delivery",
       rc.trx_number "Dcto",
       rc.status_trx,
       rl.line_number "Linha_NF",
       rl.quantity_invoiced,
       prh.segment1 "Req",
       prl.line_num "R.Line_Req",
       prl.requisition_line_id,
       (SELECT DISTINCT A.INVOICE_NUM RI
          FROM apps.cll_f189_invoices A,
               apps.cll_f189_invoice_lines B,
               apps.cll_f189_entry_operations C,
               APPS.cll_f189_invoice_types D
         WHERE     1 = 1
               AND C.organization_id = A.organization_id
               AND C.operation_id = A.operation_id
               AND A.INVOICE_ID = B.INVOICE_ID
               AND A.ORGANIZATION_ID = B.ORGANIZATION_ID
               AND A.organization_id = D.organization_id
               AND A.invoice_type_id = D.invoice_type_id
               AND B.REQUISITION_LINE_ID IN (prl.requisition_line_id)
               AND ROWNUM = 1)
          NF_RI,
       (SELECT DISTINCT A.OPERATION_ID NUM_RI
          FROM apps.cll_f189_invoices A,
               apps.cll_f189_invoice_lines B,
               apps.cll_f189_entry_operations C,
               APPS.cll_f189_invoice_types D
         WHERE     1 = 1
               AND C.organization_id = A.organization_id
               AND C.operation_id = A.operation_id
               AND A.INVOICE_ID = B.INVOICE_ID
               AND A.ORGANIZATION_ID = B.ORGANIZATION_ID
               AND A.organization_id = D.organization_id
               AND A.invoice_type_id = D.invoice_type_id
               AND B.REQUISITION_LINE_ID IN (prl.requisition_line_id)
               AND ROWNUM = 1)
          NUM_RI,
       rl.*
  FROM apps.ra_customer_trx_all rc,
       apps.ra_customer_trx_lines_all rl,
       apps.wsh_new_deliveries nd,
       apps.wsh_delivery_assignments da,
       apps.wsh_delivery_details dd,
       apps.oe_order_headers_all oh,
       apps.oe_order_lines_all ol,
       apps.po_requisition_lines_all prl,
       apps.po_requisition_headers_all prh
 WHERE     rc.customer_trx_id(+) = rl.customer_trx_id
       AND rl.line_type(+) = 'LINE'
       AND TO_CHAR (rl.interface_line_attribute6(+)) = TO_CHAR (ol.line_id)
       AND nd.delivery_id(+) = da.delivery_id
       AND da.delivery_detail_id(+) = dd.delivery_detail_id
       AND dd.source_line_id(+) = ol.line_id
       AND ol.header_id(+) = oh.header_id
       AND ol.source_document_line_id = prl.requisition_line_id(+)
       AND oh.orig_sys_document_ref = prh.segment1
       AND oh.org_id IN (SELECT operating_unit
                           FROM apps.org_organization_definitions
                          WHERE organization_id = prl.source_organization_id)
       AND prl.destination_organization_id <> prl.source_organization_id
       --AND prh.segment1 = '14482'
       AND RC.CUSTOMER_TRX_ID = 4016905;
       AND ol.header_id(+) = oh.header_id
       AND prh.org_id IN (82);
       
select * 
  from apps.ra_customer_trx_all rc
 where TRX_NUMBER = '314843'; and
       organization_id = 92      
       
       
------ Ver nota sem Requisição Interna -----       
SELECT DISTINCT
       oh.ordered_date,
       oh.order_number "Ordem",
       prl.SOURCE_ORGANIZATION_ID,
       prl.DESTINATION_ORGANIZATION_ID,
       ol.ORDERED_ITEM,
       ol.ordered_quantity,
       ol.line_number "Lin_OM",
       nd.name "Delivery",
       rc.trx_number "Dcto",
       rc.status_trx,
       rl.line_number "Linha_NF",
       rl.quantity_invoiced,
       prh.segment1 "Req",
       prl.line_num "R.Line_Req",
       prl.requisition_line_id,
       (SELECT DISTINCT A.INVOICE_NUM RI
          FROM apps.cll_f189_invoices A,
               apps.cll_f189_invoice_lines B,
               apps.cll_f189_entry_operations C,
               APPS.cll_f189_invoice_types D
         WHERE     1 = 1
               AND C.organization_id = A.organization_id
               AND C.operation_id = A.operation_id
               AND A.INVOICE_ID = B.INVOICE_ID
               AND A.ORGANIZATION_ID = B.ORGANIZATION_ID
               AND A.organization_id = D.organization_id
               AND A.invoice_type_id = D.invoice_type_id
               AND B.REQUISITION_LINE_ID IN (prl.requisition_line_id)
               AND ROWNUM = 1)
          NF_RI,
       (SELECT DISTINCT A.OPERATION_ID NUM_RI
          FROM apps.cll_f189_invoices A,
               apps.cll_f189_invoice_lines B,
               apps.cll_f189_entry_operations C,
               APPS.cll_f189_invoice_types D
         WHERE     1 = 1
               AND C.organization_id = A.organization_id
               AND C.operation_id = A.operation_id
               AND A.INVOICE_ID = B.INVOICE_ID
               AND A.ORGANIZATION_ID = B.ORGANIZATION_ID
               AND A.organization_id = D.organization_id
               AND A.invoice_type_id = D.invoice_type_id
               AND B.REQUISITION_LINE_ID IN (prl.requisition_line_id)
               AND ROWNUM = 1)
          NUM_RI,
       rl.*
  FROM apps.ra_customer_trx_all rc,
       apps.ra_customer_trx_lines_all rl,
       apps.wsh_new_deliveries nd,
       apps.wsh_delivery_assignments da,
       apps.wsh_delivery_details dd,
       apps.oe_order_headers_all oh,
       apps.oe_order_lines_all ol,
       apps.po_requisition_lines_all prl,
       apps.po_requisition_headers_all prh
 WHERE     rc.customer_trx_id(+) = rl.customer_trx_id
       AND rl.line_type(+) = 'LINE'
       AND TO_CHAR (rl.interface_line_attribute6(+)) = TO_CHAR (ol.line_id)
       AND nd.delivery_id(+) = da.delivery_id
       AND da.delivery_detail_id(+) = dd.delivery_detail_id
       AND dd.source_line_id(+) = ol.line_id
       AND ol.header_id(+) = oh.header_id
       AND ol.source_document_line_id = prl.requisition_line_id(+)
       AND oh.orig_sys_document_ref = prh.segment1
       AND oh.org_id IN (SELECT operating_unit
                           FROM apps.org_organization_definitions
                          WHERE organization_id = prl.source_organization_id)
       AND prl.destination_organization_id <> prl.source_organization_id
       --AND prh.segment1 = '14482'
       AND RC.CUSTOMER_TRX_ID = 4016905;
       AND ol.header_id(+) = oh.header_id
       AND prh.org_id IN (82);
              