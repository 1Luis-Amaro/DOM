select * from apps.XXPPG_ROMANEIO_DHL_HDR where status = 0 and total_qty_kg <> 0 order by 2;

select * from apps.XXPPG_ROMANEIO_DHL_ln where inventory_item_id = 1007 and qty = 96;


select * from apps.fnd_user where user_id = 2000;

select rowid, rh.* from apps.XXPPG_ROMANEIO_DHL_HDR rh where status = 0 and total_qty_kg <> 0 order by 2;

select rowid, rh.* from apps.XXPPG_ROMANEIO_DHL_HDR rh where rh.romaneio_id in (850,
900,
908,
909,
912
);

select * from apps.XXPPG_ROMANEIO_DHL_LN  rl where romaneio_id = 49;

select rh.romaneio_id,
       msi.segment1,
       rl.lot_number,
       rl.qty,
       mln.expiration_date,
       msi.PROCESS_yield_SUBINVENTORY,
       rh.*
  from apps.XXPPG_ROMANEIO_DHL_HDR rh,
       apps.XXPPG_ROMANEIO_DHL_LN  rl,
       apps.mtl_system_items_b     msi,
       apps.mtl_lot_numbers        mln
 where rh.romaneio_id = rl.romaneio_id and
       mln.inventory_item_id(+) = msi.inventory_item_id and
       mln.lot_number(+) = upper(rl.lot_number) and
       mln.organization_id = msi.organization_id and
       msi.inventory_item_id = rl.inventory_item_id and
       msi.organization_id = 92 and
       rh.romaneio_id in (6999, 7008
) and
       msi.organization_id = 92 order by 1; and
       rh.romaneio_id in (13,14,19) order by 1;

select * from APPS.XXPPG_ROMANEIO_DHL_LN;

select * from apps.mtl_lot_numbers mln; 

select * from apps.mtl_onhand_quantities moq;
select * from apps.mtl_onhand_quantities;
select moq.TRANSACTION_QUANTITY
  from apps.XXPPG_ROMANEIO_DHL_LN  rl,
       apps.mtl_onhand_quantities  moq,
       apps.mtl_system_items_b     msi
 where moq.inventory_item_id = rl.inventory_item_id and
       moq.lot_number        = rl.lot_number        and
       msi.inventory_item_id = rl.inventory_item_id and
       msi.organization_id   = 92                   and
       moq.organization_id   = 92                   and
       moq.subinventory_code = msi.PROCESS_YIELD_SUBINVENTORY;
              
select * from apps.fnd_user;      