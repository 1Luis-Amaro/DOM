select * 
  from apps.cll_f189_invoice_lines ril
 where ril.item_id = 12344 AND
       ril.organization_id = 86; and
       ril.quantity = 2017.73;
   
select inventory_item_id from apps.mtl_system_items_b where segment1 = 'SRC-75';   

select * from apps.cll_f189_invoices ri where organization_id = 86 and invoice_id = 176631;
722211;

--Transações de NFD - 15 e 36

select * from apps.mtl_material_transactions mmt where inventory_item_id = 12344 and organization_id = 86 and transaction_type_id = 36;transaction_id = 125395087;
inventory_item_id = 12509 and trunc(creation_date) between to_date('01/10/2016','dd/mm;rrrr') and to_date('30/10/2016','dd/mm;rrrr'); and transaction_quantity = 31096;

----- Verificar RI através do movimento de estoque -----
 

select * -- receipt_num --rt.shipment_header_id
  from apps.mtl_material_transactions mmt, apps.rcv_transactions rt, apps.rcv_shipment_headers rsh 
 where mmt.transaction_id     = 176559753              and --transação apresentada no consulta de transações do estoque no INV
       rt.transaction_id      = mmt.rcv_transaction_id and
       rt.organization_id     = mmt.organization_id    and
       rsh.shipment_header_id = rt.shipment_header_id;  and
       rsh.organization_id    = rt.organization_id

select * from apps.rcv_shipment_headers where organization_id = 86 and shipment_header_id = 350010;

select * from apps.rcv_transactions rt 
   where rt.transaction_id = 722211;