select * from apps.po_headers_all;

SELECT pha.segment1,
       msi.segment1,
      a.transaction_id, 
       b.shipment_line_id,
       c.shipment_header_id,
       c.receipt_num,
       a.transaction_type,
       a.deliver_to_location_id,
       a.parent_transaction_id,
       a.po_header_id,
       a.po_line_id,
       a.po_line_location_id,
       a.po_distribution_id,
       b.item_id,
       c.ship_to_org_id,
       a.destination_type_code,
       a.primary_quantity,
       a.quantity,
       a.primary_unit_of_measure,
       a.uom_code,
       a.primary_unit_of_measure,
       a.transaction_date,
       a.creation_date,
       a.last_update_date,
       --
       a.*
  FROM apps.rcv_transactions a, 
       apps.rcv_shipment_lines b,
       apps.rcv_shipment_headers c,
       apps.po_headers_all pha,
       apps.mtl_system_items_b msi
 WHERE --transaction_id IN (978373
--)--(989633, 989635,978373)
   trunc(TRANSACTION_DATE) >= trunc(to_date('01-nov-2018')) and
   trunc(TRANSACTION_DATE) <= trunc(to_date('30-nov-2018')) 
--
   AND a.SHIPMENT_LINE_ID = b.shipment_line_id
   and a.shipment_header_id = c.shipment_header_id 
   and transaction_type = 'DELIVER'
   AND pha.po_header_id = a.po_header_id
   and msi.organization_id = a.organization_id
   and msi.inventory_item_id = item_id
   AND MSI.SEGMENT1 = 'RP-15-2083'