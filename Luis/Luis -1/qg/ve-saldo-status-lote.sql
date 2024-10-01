select mts.status_code,
       msi.segment1,
       lot.lot_number,
       lot.creation_date,
       ohq.subinventory_code,
       ohq.transaction_quantity
  from apps.mtl_onhand_quantities    ohq,
       apps.mtl_lot_numbers          lot,
       apps.MTL_MATERIAL_STATUSES_VL mts,
       apps.mtl_system_items_b       msi
 where mts.status_id         = lot.status_id         and
       mts.status_code    like 'Pendente%'           and
       ohq.organization_id   = 92                    and
       ohq.inventory_item_id = lot.inventory_item_id and
       ohq.lot_number        = lot.lot_number        and
       lot.organization_id   = ohq.organization_id   and
       msi.organization_id   = ohq.organization_id   and
       msi.inventory_item_id = ohq.inventory_item_id;
       
select * from apps.mtl_lot_numbers          lot;       