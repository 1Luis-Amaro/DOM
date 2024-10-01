
SELECT itm.segment1, inv.transaction_quantity, inv.lot_number, inv.subinventory_code from apps.mtl_onhand_quantities inv, apps.mtl_system_items_b itm
where inv.subinventory_code like 'D%'                    AND
      inv.subinventory_code not in ('DCQ','DHF','DFV','DQI','DNE','DAN') AND
      itm.inventory_item_id = inv.inventory_item_id      AND
      itm.organization_id = inv.organization_id;