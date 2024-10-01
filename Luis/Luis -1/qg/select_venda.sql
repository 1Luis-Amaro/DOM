select transaction_source_id, segment1, btc.batch_no, mmt.source_code, mmt.transaction_id from apps.mtl_material_transactions mmt, apps.mtl_system_items_b itm, apps.gme_batch_header btc WHERE
   itm.inventory_item_id     = mmt.inventory_item_id   and
   itm.organization_id       = 92                      and
   mmt.inventory_item_id     = 1010                    and
   mmt.transaction_source_id = 30172                   and
   --mmt.lote_number           = 'SUM000003'             and
   btc.batch_id              = mmt.transaction_source_id;
        
   
select * from apps.mtl_material_transactions   