    SELECT msi.segment1,
           itm.segment1,
           msi.description,
           --fmd.inventory_item_id,
           CASE 
              WHEN fmd.scale_type = 0 THEN
                 fmd.qty / vr.std_qty
              WHEN fmd.scale_type = 1 THEN
                 fmd.qty
              ELSE
                 fmd.qty
           END qty

      FROM apps.fm_form_mst fms,
           apps.fm_matl_dtl fm,
           apps.fm_matl_dtl fmd,
           apps.gmd_recipes gr,
           apps.gmd_recipe_validity_rules vr,
           apps.mtl_system_items_b itm,
           apps.mtl_system_items_b msi
     WHERE fms.formula_class      <> 'TING-PMC'           AND
           fms.formula_id          = fm.formula_id        AND
           fmd.line_type           = -1                   AND           
           fmd.formula_id          = fm.formula_id        AND
           fmd.organization_id     = fm.organization_id   AND
           vr.preference           = 1                    AND      
           vr.recipe_use           = 2                    AND --Custos 
           vr.validity_rule_status in (700,900)           AND 
           vr.recipe_id            = gr.recipe_id         AND
           gr.recipe_status        in (700,900)           AND
           gr.formula_id           = fm.formula_id        AND
           gr.recipe_id            = (select max(gr1.recipe_id)
                                        FROM apps.fm_matl_dtl fm1,
                                             apps.gmd_recipes gr1,
                                             apps.gmd_recipe_validity_rules vr1,
                                             apps.fm_form_mst fms1
                                       WHERE fms1.formula_id           = fm1.formula_id        AND
                                             fms1.formula_status      in (700,900)             AND
                                             fm1.inventory_item_id     = itm.inventory_item_id AND
                                             fm1.line_type             = 1                     AND
                                             vr1.preference            = 1                    AND      
                                             vr1.recipe_use            = 2 /*Custos*/         AND
                                             vr1.validity_rule_status in (700,900)             AND
                                             vr1.recipe_id             = gr1.recipe_id         AND
                                             gr1.recipe_status        in (700,900)             AND
                                             gr1.formula_id            = fm1.formula_id)       AND  
           
           fm.inventory_item_id   = itm.inventory_item_id AND
           fm.line_type           = 1                     AND
           msi.inventory_item_id  = fmd.inventory_item_id and
           msi.organization_id    = fmd.organization_id   and
           itm.inventory_item_id  = fm.inventory_item_id  AND
           itm.organization_id    = fm.organization_id    AND
           itm.segment1 in ('FIBB-00022.48',
'FIBB-00031.48',
'FIBB-00034.48',
'FIBB-00047.48',
'FIBD-00001.48',
'FIBD-00008.48',
'FIBD-00024.48',
'FIBD-00036.48',
'FIPB-00003.C4',
'FIVB-00002.C8',
'SPTS-00031.57',
'SPTS-00038.22',
'FIEB-00004.22',
'FIEA-00018.57',
'FIEB-00002.22',
'FIEB-00003.22',
'FIEB-00004.S5',
'FIEB-00005.22',
'FIEE-00006.22',
'SPTS-00006.97',
'SPTS-00036.63',
'FIEA-00019.57',
'FIEB-00002.22',
'FIEB-00003.22',
'FIEB-00004.22',
'FIEB-00004.S5',
'FIEB-00005.22',
'FIEE-00007.22',
'FIHA-00001.22',
'FIHA-00002.22',
'FIHA-00003.22',
'FIHA-00004.22',
'FIHB-00001.22',
'FIHB-00002.22',
'FIHB-00003.22',
'FIHB-00004.22',
'FIHC-00001.22',
'FIHC-00003.22',
'FIHC-00004.22',
'FIHC-00005.22',
'FIHC-00006.22',
'FIHC-00007.22',
'FIHC-00008.22',
'FIPB-00002.22',
'FIPC-00001.B4',
'FIPC-00002.22',
'FIPE-00001.22',
'FIPE-00002.22',
'FIPE-00003.22',
'FIPE-00004.22',
'FIRA-00002.22',
'FIRB-00002.22',
'FIRC-00003.22',
'FIRC-00011.22',
'FIRC-00012.22',
'FIRC-00013.22',
'FIRC-00014.22',
'FIRC-00015.22',
'FIRC-00016.22',
'FIRC-00017.22',
'FIRD-00007.22',
'FIRD-00008.22',
'FIRD-00009.22',
'FISA-00001.22',
'FISA-00002.22',
'FISA-00003.22',
'FISA-00004.22',
'FISA-00007.22',
'FISB-00002.22',
'FISB-00003.22',
'FITB-00002.22',
'FIVC-00001.22',
'IVSA-00011.10',
'PALA-00104.22',
'SPTS-00006.22',
'SPTS-00038.22',
'FIPC-00001.B4',
'IVBB-00008.48',
'IVBB-00014.48',
'IVBC-00002.51',
'IVEA-00004.59',
'IVEB-00001.T8',
'IVEB-00002.79',
'IVEB-00004.6A',
'IVEE-00003.22',
'IVRA-00001.22',
'IVRB-00001.57',
'IVRC-00002.63',
'IVRC-00003.57',
'IVRC-00006.63',
'IVRC-00007.63',
'IVRC-00008.63',
'IVRC-00009.97',
'IVRD-00002.63',
'IVRD-00003.57',
'IVRO-00002.57',
'IVRO-00002.97',
'IVSA-00002.48',
'IVSA-00003.C8',
'IVSA-00004.48',
'IVSA-00011.10',
'IVSB-00001.65',
'IVTB-00008.C25',
'IVTB-00010.48',
'IVTB-00021.48',
'IVTB-00025.48',
'IVTB-00038.48',
'IVTD-00005.01',
'IVTD-00007.01',
'IVTD-00014.01',
'IVTD-00018.01',
'IVTD-00022.01',
'IVTD-00035.01',
'IVTD-00048.01',
'IVTD-00049.01',
'IVTD-00050.01',
'IVTD-00060.01',
'IVVB-00002.48',
'PALA-00009.47',
'PALA-00010.47',
'PALA-00018.48',
'SPTS-00001.97',
'SPTS-00006.97',
'SPTS-00008.97',
'SPTS-00034.97' )
