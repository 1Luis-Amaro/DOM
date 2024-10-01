SELECT gse.disposition
,gse.*
         FROM   apps.gme_batch_header             gbh
               ,apps.gme_batch_groups_association gbga
               ,apps.gme_batch_groups_b           gbgb
               ,apps.gme_material_details         gmd
               ,apps.mtl_system_items_b           msib
               ,apps.mtl_item_categories_v        micv
               ,apps.gmd_samples                  gs
               ,apps.gmd_sampling_events          gse
         WHERE  gbh.batch_id = gbga.batch_id
         AND    gbga.group_id = gbgb.group_id
         AND    gbh.batch_id = gmd.batch_id
         AND    gmd.inventory_item_id = msib.inventory_item_id
         AND    gmd.organization_id = msib.organization_id
         AND    msib.inventory_item_id = micv.inventory_item_id
         AND    msib.organization_id = micv.organization_id
         AND    gbh.batch_id = gs.batch_id
         AND    gs.sampling_event_id = gse.sampling_event_id
         AND    micv.segment1 = 'SEMI' --categoria de inventario semi
         AND    micv.category_set_id = 1 --categoria inventory
         AND    gmd.line_type = 1 --producto
         AND    gs.sample_no =
                (SELECT MAX(sample_no)
                  FROM   apps.gmd_samples
                  WHERE  batch_id = gbh.batch_id)
         AND    gbgb.group_name =
                (SELECT gbgb.group_name
                  FROM   apps.gme_batch_header             gbh
                        ,apps.gme_batch_groups_association gbga
                        ,apps.gme_batch_groups_b           gbgb
                  WHERE  gbh.batch_id = gbga.batch_id
                  AND    gbga.group_id = gbgb.group_id
                  AND    gbh.batch_id = 90158); --p_batch_id); --ordem de ACA parametro ejemplo
