select organization_id, inventory_item_id, segment1 from apps.mtl_system_items_b where
   segment1 in ('PIT980.45',
'PIT6001.45',
'PIT6090.45',
'PIT49030.10');

SELECT msi.organization_id, msi.segment1 from apps.MTL_SYSTEM_ITEMS_INTERFACE msii, apps.mtl_system_items_b msi
  where msi.organization_id = msii.organization_id and msi.inventory_item_id = msii.inventory_item_id;

select organization_id, segment1 from apps.mtl_system_items_b where inventory_item_id = 1169692;

update set START_AUTO_LOT_NUMBER = 1 ;

SELECT h.organization_id, h.batch_status, h.gl_posted_ind, count(*) 
 FROM gme_material_details d, MTL_TXN_REQUEST_Lines mo, gme_batch_header h 
 WHERE h.batch_id = d.batch_id 
 AND h.batch_status in (1,2,3,4) 
 AND NVL(h.MIGRATED_BATCH_IND, 'N') = 'N' 
 AND NVL(move_order_line_id, 0) > 0 
 AND d.line_type = -1 
 AND d.move_order_line_id = mo.line_id -- invisible only 
 AND mo.line_status = 7 
 group by h.organization_id, h.batch_status, h.gl_posted_ind 
 order by h.organization_id, h.batch_status ;