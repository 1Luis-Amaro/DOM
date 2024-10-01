/* Formatted on 11/09/2015 15:54:57 (QP5 v5.227.12220.39724) */
  SELECT par.organization_code, 
         rec.recipe_no,
         rec.recipe_version,
         decode(vr.recipe_use, 0, 'Producao',1,'Planej',2,'Custo',3,'Normativo',4,'Tecnico') Uso,
         vr.preference,
         vr.validity_rule_status,
         vr.std_qty, 
         vr.end_date,        
         vr.PLANNED_PROCESS_LOSS, 
         fms.formula_no,
         fms.formula_vers,
         fms.formula_status,
         custo_opm.categoria,
         INVENTARIO.CATEGORIA
    FROM apps.gmd_recipes rec,
         apps.gmd_recipe_validity_rules vr,
         apps.fm_form_mst fms,
         apps.fm_matl_dtl fm,
         apps.mtl_system_items_b itm,
         APPS.MTL_PARAMETERS par,
        (SELECT MIC.INVENTORY_ITEM_ID,
                MIC.ORGANIZATION_ID,
                MIC.CATEGORY_SET_NAME,
                MIC.CATEGORY_CONCAT_SEGS CATEGORIA
           FROM APPS.MTL_ITEM_CATEGORIES_V MIC, APPS.MTL_CATEGORIES_V MC
          WHERE MC.CATEGORY_ID = MIC.CATEGORY_ID
            AND MIC.CATEGORY_SET_NAME IN ('Categoria de Custo')) CUSTO_OPM,
       (SELECT MIC.INVENTORY_ITEM_ID,
               MIC.ORGANIZATION_ID,
               MIC.CATEGORY_SET_NAME,
               MIC.CATEGORY_CONCAT_SEGS CATEGORIA
          FROM APPS.MTL_ITEM_CATEGORIES_V MIC, APPS.MTL_CATEGORIES_V MC
         WHERE MC.CATEGORY_ID = MIC.CATEGORY_ID
           AND MIC.CATEGORY_SET_NAME IN ('Inventory')) INVENTARIO,
         apps.gmd_qc_status_tl st,
         apps.gmd_qc_status_tl st2,
         apps.gmd_qc_status_tl st3
--        
--            
--         
   WHERE st.status_code         = vr.validity_rule_status        AND
         st.source_lang         = 'PTB'                          AND
         st.entity_type         = 'S'                            AND
         st2.status_code        = fms.formula_status             AND
         st2.source_lang         = 'PTB'                          AND
         st2.entity_type         = 'S'                            AND
         st3.status_code        = rec.recipe_status              AND
         st3.source_lang         = 'PTB'                          AND
         st3.entity_type         = 'S'                            AND
         par.organization_id    = rec.owner_organization_id      AND
         vr.recipe_id           = rec.recipe_id                  AND
         rec.owner_organization_id = itm.organization_id AND
         rec.formula_id         = fm.formula_id                  AND
         fms.formula_class     <> 'TING-PMC' AND
         fms.formula_id         = fm.formula_id                  AND
         fm.inventory_item_id   = itm.inventory_item_id          AND
         fm.line_type           = 1                              AND
         itm.ORGANIZATION_ID    = CUSTO_OPM.ORGANIZATION_ID(+)   AND
         itm.INVENTORY_ITEM_ID  = CUSTO_OPM.INVENTORY_ITEM_ID(+) AND
         itm.ORGANIZATION_ID    = INVENTARIO.ORGANIZATION_ID(+)   AND
         itm.INVENTORY_ITEM_ID  = INVENTARIO.INVENTORY_ITEM_ID(+) AND
--         
         itm.inventory_item_id  = fm.inventory_item_id
--         itm.segment1 = '014.00';
ORDER BY organization_code, recipe_no, recipe_version ;


SELECT * from apps.gmd_recipes rec;


