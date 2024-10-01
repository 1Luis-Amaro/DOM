         SELECT gbh.batch_no,
                MSI.SEGMENT1, 
                SUM(gmd.actual_qty),
                max(xxdados.total_cons) consumo, 
                (SUM(gmd.actual_qty) / max(xxdados.total_cons) * 100) percent
           FROM apps.gme_material_details gmd,
                apps.mtl_system_items_vl  msi,
                apps.gme_batch_step_items gbsi,
                apps.gme_batch_steps      gbs,
                apps.gme_batch_header     gbh,
                (SELECT dados.batch_id, dados.batch_no, dados.total_cons total_cons, ROWNUM
                  FROM (SELECT gbh.batch_id,
                               gbh.batch_no,
                               SUM(gmdt.actual_qty) total_cons
                          FROM apps.gme_material_details gmd,
                               apps.gme_material_details gmdt,
                               apps.gme_batch_header     gbh,
                               apps.mtl_system_items_b   msi
                         WHERE gmd.batch_id              = gbh.batch_id
                           AND gbh.batch_type            = 0
                           AND gbh.organization_id       = 92 --organization_id da ordem de produção
                           AND gbh.actual_cmplt_date IS NOT NULL
                           AND gbh.batch_status          = 4 
                           AND msi.segment1              = 'NIHB-00004' --Item da Ordem de Produção
                           AND msi.organization_id       = gbh.organization_id
                           AND gmd.inventory_item_id     = msi.inventory_item_id
                           AND gmd.line_type             = 1
                           AND gmdt.batch_id             = gbh.batch_id
                           AND gmdt.line_type            = -1
                           AND gmdt.contribute_yield_ind = 'Y'
                           group by gbh.batch_id,gbh.batch_no, gbh.actual_cmplt_date
                           ORDER BY ACTUAL_CMPLT_DATE DESC,gbh.batch_id) DADOS
                 WHERE ROWNUM <= 3) xxdados
          WHERE     msi.inventory_item_id     = gmd.inventory_item_id
            AND msi.organization_id       = gmd.organization_id
            AND gbsi.material_detail_id   = gmd.material_detail_id
            AND gbsi.batch_id             = gmd.batch_id
            AND gbsi.batchstep_id         = gbs.batchstep_id
            AND gbh.batch_id              = XXDADOS.BATCH_ID 
            AND gmd.batch_id              = gbh.batch_id
            AND gbs.batchstep_no          = 140
            AND gbh.organization_id       = 92 -- organization_id da ordem de produção
            AND gmd.line_type             = -1
            AND msi.segment1              = 'SEB-45' --Ingrediente 
            AND gmd.contribute_yield_ind  = 'Y'
            GROUP BY msi.segment1, gbh.batch_no
            ORDER BY batch_no            
            

                
                
        --group by segment1;


2128,68849
2170,1625
2153,44


         SELECT SUM(gmd.actual_qty)/
               (SELECT SUM(total)
                  FROM (SELECT dados.batch_id,
                              (select SUM(gmd.actual_qty)
                                 FROM apps.gme_material_details gmd
                                WHERE gmd.batch_id = dados.batch_id AND
                                      gmd.line_type= -1 AND
                                      gmd.contribute_yield_ind = 'Y') total
                          FROM (SELECT gbh.batch_id
                                  FROM apps.gme_material_details gmd,
                                       apps.gme_batch_header     gbh,
                                       apps.mtl_system_items_b   msi
                                 WHERE gmd.batch_id            = gbh.batch_id
                                   AND gbh.batch_type          = 0
                                   AND gbh.organization_id     = 92
                                   AND gbh.batch_status        = 4 
                                   AND msi.organization_id     = 92
                                   AND msi.segment1            = 'NIHB-00004' --${item.xxppg_batch_cq_cor.item.value}
                                   AND gmd.inventory_item_id   = msi.inventory_item_id
                                   AND gmd.line_type           = 1
                                   ORDER BY ACTUAL_CMPLT_DATE DESC) DADOS
                         WHERE ROWNUM <= 3)) total_consumo 
           FROM apps.gme_material_details gmd,
                apps.mtl_system_items_vl  msi,
                apps.gme_batch_step_items gbsi,
                apps.gme_batch_steps      gbs,
                apps.gme_batch_header     gbh,
                (SELECT dados.batch_id,
                        dados.total_cons total_cons
                  FROM (SELECT gbh.batch_id,
                               SUM(gmdt.actual_qty) total_cons
                          FROM apps.gme_material_details gmd,
                               apps.gme_material_details gmdt,
                               apps.gme_batch_header     gbh,
                               apps.mtl_system_items_b   msi
                         WHERE gmd.batch_id              = gbh.batch_id
                           AND gbh.organization_id       = 92
                           AND gbh.actual_cmplt_date IS NOT NULL
                           AND gbh.batch_status          = 4 
                           AND msi.segment1              = 'NIHB-00004' --${item.xxppg_batch_cq_cor.item.value}
                           AND msi.organization_id       = gbh.organization_id
                           AND gmd.inventory_item_id     = msi.inventory_item_id
                           AND gmd.line_type             = 1
                           AND gmdt.batch_id             = gbh.batch_id
                           AND gmdt.line_type            = -1
                           AND gmdt.contribute_yield_ind = 'Y'
                           group by gbh.batch_id, gbh.actual_cmplt_date
                           ORDER BY ACTUAL_CMPLT_DATE DESC,gbh.batch_id) DADOS
                 WHERE ROWNUM <= 3) xxdados
          WHERE     msi.inventory_item_id     = gmd.inventory_item_id
            AND msi.organization_id       = gmd.organization_id
            AND gbsi.material_detail_id   = gmd.material_detail_id
            AND gbsi.batch_id             = gmd.batch_id
            AND gbsi.batchstep_id         = gbs.batchstep_id
            AND gbh.batch_id              = XXDADOS.BATCH_ID 
            AND gmd.batch_id              = gbh.batch_id
            AND gbs.batchstep_no          = 140
            AND gbh.organization_id       = 92
            AND gmd.line_type             = -1
          --  AND msi.segment1              = ${item.xxppg_batch_aggregation_item.componente.value}
            GROUP BY msi.segment1;
            