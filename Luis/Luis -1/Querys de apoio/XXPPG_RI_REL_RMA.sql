select distinct orig_oeh.order_number "Original Order",oeh.order_number "RMA Order",cfi.invoice_num "RI Invoice Number",cfi.invoice_amount "RI Invoice Amount",cffe.document_number,
cfi.operation_id "RI Number",ood.organization_code
,rct.trx_number "Invoice RMA ORD",rct.trx_date "RMA Invoice date",--rct.customer_trx_id "RMA Invoice cust TRX id",
(select sum(rctl.extended_amount) from apps.ra_customer_trx_lines_all rctl where rctl.customer_trx_id = rct.customer_trx_id) "RMA invoice amount" 
,orig_rct.trx_number "Invoice Orignal Order",orig_rct.trx_date "Original Invoice Date"
from apps.oe_order_headers_all oeh
     ,apps.oe_order_lines_all oel
     ,apps.oe_order_headers_all orig_oeh
     ,apps.cll_f189_invoice_lines cfil
     ,apps.cll_f189_invoices cfi
     ,apps.ra_customer_trx_all rct
     ,apps.ra_customer_trx_all orig_rct
     ,apps.cll_f189_fiscal_entities_all cffe
     ,apps.org_organization_definitions ood
where oeh.header_id = oel.header_id
  and oel.line_id = cfil.rma_interface_id
  and cfil.invoice_id = cfi.invoice_id
 and cfi.entity_id = cffe.entity_id
  and cfi.organization_id = ood.organization_id
  and oeh.source_document_id = orig_oeh.header_id
  and to_char(orig_oeh.order_number) = orig_rct.interface_header_attribute1
  and to_char (oeh.order_number) = rct.interface_header_attribute1 
  and rct.PREVIOUS_CUSTOMER_TRX_ID = orig_rct.customer_trx_id