select * from apps.mtl_system_items_b where segment1 like 'Q001400353%';

select msib.segment1, mln.status_id, mln.* --mln.status_id, msib.segment1
  from apps.mtl_lot_numbers       mln,
       apps.mtl_system_items_b    msib,
       apps.mtl_onhand_quantities moqd
 where msib.organization_id   = mln.organization_id
   and msib.inventory_item_id = mln.inventory_item_id
   and moqd.organization_id   = mln.organization_id
   and moqd.inventory_item_id = mln.inventory_item_id
   and moqd.lot_number        = mln.lot_number
   and moqd.subinventory_code = msib.process_yield_subinventory
   and mln.status_id <> 1;
  -- and mln.status_id          
  
  
select status_id, status_code from apps.MTL_MATERIAL_STATUSES_VL;  