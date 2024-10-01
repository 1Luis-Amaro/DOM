SELECT inv.organization_id, inv.subinventory_code, itm.segment1, inv.lot_number, sum(inv.transaction_quantity) qtd
   from apps.mtl_onhand_quantities inv, apps.mtl_system_items_b itm 
where INV.SUBINVENTORY_CODE like 'D%' and
      inv.subinventory_code <> 'DIV'  and
      itm.inventory_item_id = inv.inventory_item_id and
      itm.organization_id = inv.organization_id
      group by inv.organization_id, inv.subinventory_code, itm.segment1, inv.lot_number
      