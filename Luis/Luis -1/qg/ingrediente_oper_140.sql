SELECT distinct
       msi.segment1,
       msi.item_type       
           FROM apps.gme_material_details gmd,
                apps.mtl_system_items_vl  msi,
                apps.gme_batch_step_items gbsi,
                apps.gme_batch_steps      gbs,
                apps.gme_batch_header     gbh
          WHERE     msi.inventory_item_id   = gmd.inventory_item_id
                AND msi.organization_id     = gmd.organization_id
                AND gbsi.material_detail_id = gmd.material_detail_id
                AND gbsi.batch_id           = gmd.batch_id
                AND gbsi.batchstep_id       = gbs.batchstep_id
                --AND gbh.batch_id          = x_batch_id
                AND gmd.batch_id            = gbh.batch_id
                and gbs.batchstep_no        = 140 --Vem da LOV
                and gbh.organization_id     = 92
                and gmd.line_type           = -1
                and trunc(gbh.ACTUAL_CMPLT_DATE) >= trunc(sysdate - 360)


select * from apps.gme_batch_header     gbh