select * from apps.mtl_onhand_quantities ohq;


SELECT msi.segment1, ohq.transaction_quantity, subinventory_code
  FROM inv.mtl_lot_numbers        mln,
       apps.mtl_onhand_quantities ohq,
       apps.mtl_material_statuses mms1,
       apps.mtl_system_items_b    msi
 WHERE mln.lot_number        = ohq.lot_number
   AND msi.inventory_item_id = ohq.inventory_item_id
   AND msi.organization_id   = ohq.organization_id
   AND mln.inventory_item_id = ohq.inventory_item_id
   AND mln.organization_id   = ohq.organization_id
   AND mln.status_id         = mms1.status_id 
   AND mms1.status_code      = 'Pendente CQ';