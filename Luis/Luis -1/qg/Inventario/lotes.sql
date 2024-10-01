select msi.segment1,
       mln.lot_number
  from apps.mtl_lot_numbers mln,
       apps.mtl_system_items_b msi
 where mln.organization_id = 181 and
       msi.organization_id = mln.organization_id and
       msi.inventory_item_id = mln.inventory_item_id;