SELECT h.organization_id, h.batch_status, h.gl_posted_ind, count(*) 
 FROM apps.gme_material_details d, apps.MTL_TXN_REQUEST_Lines mo, apps.gme_batch_header h 
 WHERE h.batch_id = d.batch_id 
 AND h.batch_status in (1,2,3,4) 
 AND NVL(h.MIGRATED_BATCH_IND, 'N') = 'N' 
 AND NVL(move_order_line_id, 0) > 0 
 AND d.line_type = -1 
 AND d.move_order_line_id = mo.line_id -- invisible only 
 AND mo.line_status = 7 and gl_posted_ind = 1
 group by h.organization_id, h.batch_status, h.gl_posted_ind 
 order by h.organization_id, h.batch_status ; 