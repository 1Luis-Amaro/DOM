select * from apps.mtl_parameters    
    
    SELECT msi.segment1,
           fmd.inventory_item_id,
           msip.segment1,
           CASE
              --WHEN msip.planning_make_buy_code  = 1 THEN
              --   1
              WHEN fmd.scale_type = 0 THEN
                 (fmd.qty / decode(fm.qty,0,1,fm.qty)) / decode(vr.std_qty,0,1,vr.std_qty)
              WHEN fmd.scale_type = 1 THEN
                 (fmd.qty / decode(fm.qty,0,1,fm.qty))
              ELSE
                 (fmd.qty / decode(fm.qty,0,1,fm.qty))
           END qty ,
--          CASE
              --WHEN msip.planning_make_buy_code  = 1 THEN
              --   1
--              WHEN fmd.scale_type = 0 THEN
--                 ((fmd.qty / decode(fm.qty,0,1,fm.qty)) / decode(vr.std_qty,0,1,vr.std_qty)) / (1 - (vr.planned_process_loss / 100))
--              WHEN fmd.scale_type = 1 THEN
--                 (fmd.qty / decode(fm.qty,0,1,fm.qty)) / (1 - (NVL(vr.planned_process_loss,0 / 100)))
--              ELSE
--                 (fmd.qty / decode(fm.qty,0,1,fm.qty)) / (1 - (NVL(vr.planned_process_loss,0) / 100))
--           END qty_cst,   
           fms.formula_no,
           fms.formula_vers,
           gr.recipe_no,
           gr.recipe_version,
           fmd.organization_id,
           0 as Nivel
      FROM apps.fm_form_mst_b fms,
           apps.fm_matl_dtl   fm,
           apps.fm_matl_dtl   fmd,
           apps.gmd_recipes_b gr,
           apps.gmd_recipe_validity_rules vr,
           apps.mtl_system_items_b msi,
           apps.mtl_system_items_b msip,
           (SELECT MIC.INVENTORY_ITEM_ID,
                   MIC.ORGANIZATION_ID,
                   MIC.CATEGORY_SET_NAME,
                   MIC.CATEGORY_CONCAT_SEGS CATEGORIA
              FROM APPS.MTL_ITEM_CATEGORIES_V MIC, APPS.MTL_CATEGORIES_V MC
             WHERE MC.CATEGORY_ID = MIC.CATEGORY_ID
               AND MIC.CATEGORY_SET_NAME IN ('Inventory')) INVENTARIO
     WHERE fmd.line_type              = -1                   AND           
           fmd.formula_id             = fm.formula_id        AND
           fmd.organization_id        = fm.organization_id   AND
--           
           /**** performance ****/
           vr.preference                  = 1               AND   
           vr.delete_mark                 = 0               AND   
           vr.recipe_use                  = 0               AND -- 0 = Produção - 2=Custos 
           vr.validity_rule_status       in (700,900)       AND 
           vr.recipe_id                   = gr.recipe_id    AND
           vr.start_date                 <= sysdate         AND
           vr.end_date                   is NULL            AND           
           /**** performance ****/
--           
        /*   gr.recipe_id                 = (SELECT MIN(gr1.recipe_id)
                                             FROM   apps.gmd_recipes_b             gr1
                                                   ,apps.gmd_recipe_validity_rules vr1
                                                   ,apps.fm_matl_dtl               fmd1
                                             WHERE  vr1.delete_mark           = 0
                                             AND    vr1.preference            = 1 
                                             AND    vr1.recipe_use            = 0
                                             AND    vr1.min_qty              <= msip.fixed_lot_multiplier
                                             AND    vr1.max_qty              >= msip.fixed_lot_multiplier
                                             AND    vr1.validity_rule_status IN (700, 900)
                                             AND    vr1.start_date           <= SYSDATE
                                             AND    vr1.end_date             IS NULL
                                             AND    vr1.recipe_id             = gr1.recipe_id
                                             AND    gr1.recipe_status        IN (700, 900)
                                             AND    fmd1.line_type            = 1
                                             AND    fmd1.inventory_item_id    = vr.inventory_item_id
                                             AND    gr1.formula_id            = fmd1.formula_id) and*/
--                                                  
           gr.recipe_status            in (700,900)             AND
           gr.formula_id                = fm.formula_id         AND
           fms.formula_id               = fm.formula_id         AND
           fm.line_type                 = 1                     AND
           fm.inventory_item_id         = msi.inventory_item_id AND
           fm.organization_id           = msi.organization_id   AND
           msip.inventory_item_id       = fmd.inventory_item_id AND
           msip.organization_id         = msi.organization_id   AND
           msip.segment1 <> msi.segment1 and
           MSI.ORGANIZATION_ID       = INVENTARIO.ORGANIZATION_ID AND
           MSI.INVENTORY_ITEM_ID     = INVENTARIO.INVENTORY_ITEM_ID AND
           msi.organization_id       = 89;
         
          