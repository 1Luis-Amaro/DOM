select lot.attribute3 from apps.mtl_system_items_b msi, apps.mtl_lot_numbers lot
 where msi.segment1        = :xxppg_printer_operation.result_03
   and msi.organization_id =  :xxppg_printer_operation.organization_id
   and lot.inventory_item_id = msi.inventory_item_id
   and lot.lot_number        = :xxppg_printer_operation.result_04


select lot.attribute3 from apps.mtl_system_items_b msi, apps.mtl_lot_numbers lot 
  where msi.segment1          = '1490001L.20'         and
        lot.inventory_item_id = msi.inventory_item_id and
        lot.lot_number        = 'SUM000044'                           
        
select lot.attribute3 from apps.mtl_system_items_b msi, apps.mtl_lot_numbers lot
 where msi.segment1        = :xxppg_printer_operation.result_03
   and msi.organization_id =  :xxppg_printer_operation.organization_id
   and lot.inventory_item_id = msi.inventory_item_id
   and lot.lot_number        = :xxppg_printer_operation.result_04)
                           
                           
select lot_number from(
SELECT nvl(gppl.lot_number,mtlv.lot_number) lot_number
FROM apps.gme_batch_header gbh,
     apps.gme_material_details gmd,
     apps.mtl_material_transactions mmt,
     apps.gme_pending_product_lots gppl,
     apps.mtl_transaction_lot_val_v mtlv,
     apps.mtl_transaction_types MTT,
     apps.mtl_lot_numbers mln         
WHERE     1 = 1
    AND gbh.batch_id              = gmd.batch_id
    AND gbh.organization_id       = gmd.organization_id
    AND gmd.organization_id       = mmt.organization_id(+)
    AND gmd.inventory_item_id     = mmt.inventory_item_id(+)
    AND gmd.material_detail_id    = mmt.trx_source_line_id(+)
    and gmd.batch_id              = mmt.transaction_source_id(+)
    and nvl(mmt.transaction_id,0) = nvl(mtlv.transaction_id(+),0)
    and nvl(mmt.transaction_type_id,0) = nvl(mtt.transaction_type_id(+),0)
    and gmd.material_detail_id    = gppl.material_detail_id(+)
    and gmd.inventory_item_id     = mln.inventory_item_id
    and gmd.organization_id       = mln.organization_id
    and mln.lot_number            = nvl(mtlv.lot_number,gppl.lot_number)
    and gbh.batch_type            = '0' 
    AND gbh.batch_no              = :xxppg_printer_operation.result_02
    AND gbh.organization_id       = :xxppg_printer_operation.organization_id
    AND gmd.line_type             = 1
    AND :xxppg_printer_operation.result_01 in('N','S')
union
select mln.lot_number 
 from apps.mtl_lot_numbers mln
     ,apps.mtl_system_items_b msib
where mln.organization_id = :xxppg_printer_operation.organization_id
  and mln.organization_id = msib.organization_id
  and mln.inventory_item_id = msib.inventory_item_id
  and msib.segment1 = :xxppg_printer_operation.result_03
  and :xxppg_printer_operation.result_01 = 'C'
) where lot_number is not null 
order by lot_number                           


select lot.attribute3 from apps.mtl_system_items_b msi, apps.mtl_lot_numbers lot
 where msi.segment1        = '1490001L.20'
   and msi.organization_id =  92
   and lot.inventory_item_id = msi.inventory_item_id
   and lot.lot_number        = 'SUM000043';
