select 
  ril.BATCH_SOURCE_NAME"Origem Aviso_IFACE", 
  ril.INTERFACE_LINE_ATTRIBUTE1"Nro_RMA_IFACE", 
  ril.INTERFACE_LINE_ATTRIBUTE2"Tipo Pedido OM", 
  ril.AMOUNT"Valor_IFACE",
  ril.line_number"Nro_Linha_IFACE",
  RIL.REFERENCE_LINE_ID"Referencia ID Linha NF", 
  rbs.name"Origem NF",
  rct.trx_number"NRO NF",
  rcl.LINE_NUMBER"Nro Linha NF", 
  (select  sum (aps.AMOUNT_DUE_REMAINING) from ar_payment_schedules_all aps
    where aps.customer_trx_id = rct.customer_trx_id)"Saldo_NF",
  HP.PARTY_NAME"Nome Cliente", 
  HCA.ACCOUNT_NUMBER"Nro Cliente",
  ril.interface_line_id"ID Interface",
  RTT.NAME"Tipo Transacao AR_IFACE",
  ril.SALES_ORDER_DATE"Data_RMA_IFACE",
  ril.UNIT_SELLING_PRICE"Preco Unitario_IFACE",  
  ril.QUANTITY"Quantidade_IFACE", 
  msi.segment1"Cod Item",
  ril.DESCRIPTION"Desc Item",  
  rct.trx_date"Data_NF",
  rcl.UNIT_SELLING_PRICE"Preco Unit NF", 
  rcl.QUANTITY_INVOICED"Quant NF", 
  rcl.EXTENDED_AMOUNT"Valor Linha NF",
  msi.inventory_item_id"ID Item",
  rct.customer_trx_id"ID NF",
  rcl.customer_trx_line_id"ID Linha NF",
  rcl.warehouse_id"ID Org INV",
  hao.name"Organizacao Inv."
from 
   ra_interface_lines_all ril,
   hz_parties hp,
   hz_cust_accounts hca,
   ra_cust_trx_types_all rtt,
   hr_all_organization_units hao,
   mtl_system_items_b msi,
   ra_customer_trx_all rct,
   ra_customer_trx_lines_all rcl,
   ra_batch_sources_all rbs
where
   ril.orig_system_bill_customer_id = hca.cust_account_id
   and hp.party_id = hca.party_id
   and ril.cust_trx_type_id = rtt.cust_trx_type_id  
   and ril.warehouse_id = hao.organization_id
   and ril.inventory_item_id = msi.inventory_item_id
   and ril.warehouse_id = msi.organization_id
   and ril.reference_line_id = rcl.customer_trx_line_id  
   and rcl.customer_trx_id   = rct.customer_trx_id
   and rct.batch_source_id = rbs.batch_source_id
   and rcl.line_type = 'LINE'
   and ril.amount < 0
   and ril.line_type = 'LINE'
   and ril.interface_line_context = 'ORDER ENTRY'
   and ril.INTERFACE_STATUS is null
   -- and (select  sum (aps.AMOUNT_DUE_REMAINING) from ar_payment_schedules_all aps   where aps.customer_trx_id = rct.customer_trx_id ) <>  ril.AMOUNT 
group by 
  ril.interface_line_id,
  RIL.REFERENCE_LINE_ID, 
  ril.SALES_ORDER_DATE,
  ril.LINE_NUMBER,
  ril.AMOUNT,
  HP.PARTY_NAME, 
  HCA.ACCOUNT_NUMBER,
  ril.INTERFACE_LINE_ATTRIBUTE1, 
  ril.INTERFACE_LINE_ATTRIBUTE2, 
  RTT.NAME,
  hao.name,
  ril.BATCH_SOURCE_NAME, 
  ril.UNIT_SELLING_PRICE,  
  ril.QUANTITY, 
  ril.AMOUNT,
  msi.segment1,
  ril.DESCRIPTION, 
  rct.customer_trx_id,
  rcl.customer_trx_line_id,
  rbs.name,
  rct.trx_number,
  rct.trx_date,
  rcl.LINE_NUMBER, 
  rcl.UNIT_SELLING_PRICE, 
  rcl.QUANTITY_INVOICED, 
  rcl.EXTENDED_AMOUNT,
  msi.inventory_item_id,
  rcl.warehouse_id
order by  hao.name, ril.INTERFACE_LINE_ATTRIBUTE1, rcl.line_number
