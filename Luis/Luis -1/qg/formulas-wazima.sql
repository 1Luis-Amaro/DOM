/* Formatted on 11/09/2015 15:54:57 (QP5 v5.227.12220.39724) */
  SELECT itm2.segment1 Item,
         gr.recipe_no receita,
         fms.formula_no Formula,
         fms.formula_vers Vers,
         inventario.categoria "Categ Inventario",
         custo_opm.categoria "Categ Custos",
         frh.routing_no,
         oper.ROUTINGSTEP_no,
         op.OPRN_NO,
         itm.segment1,
         fm.line_no,
         fm.qty,
         ROUND(tab_cost.unit_total, 5)  custo_unitario
    FROM apps.gmd_recipe_step_materials step,
         apps.fm_rout_dtl oper,
         apps.fm_rout_hdr frh,
         apps.gmd_operations op,
         apps.gmd_recipes gr,
         apps.gmd_recipe_validity_rules vr,
         apps.fm_form_mst fms,
         apps.fm_matl_dtl fm,
         apps.fm_matl_dtl fm2,         
         apps.mtl_system_items_b itm,
         apps.mtl_system_items_b itm2,
        (SELECT MIC.INVENTORY_ITEM_ID,
                MIC.ORGANIZATION_ID,
                MIC.CATEGORY_SET_NAME,
                MIC.CATEGORY_CONCAT_SEGS CATEGORIA
           FROM APPS.MTL_ITEM_CATEGORIES_V MIC, APPS.MTL_CATEGORIES_V MC
          WHERE MC.CATEGORY_ID = MIC.CATEGORY_ID
            AND MIC.CATEGORY_SET_NAME IN ('Categoria de Custo')) CUSTO_OPM,
--            
       (SELECT MIC.INVENTORY_ITEM_ID,
               MIC.ORGANIZATION_ID,
               MIC.CATEGORY_SET_NAME,
               MIC.CATEGORY_CONCAT_SEGS CATEGORIA
          FROM APPS.MTL_ITEM_CATEGORIES_V MIC, APPS.MTL_CATEGORIES_V MC
         WHERE MC.CATEGORY_ID = MIC.CATEGORY_ID
           AND MIC.CATEGORY_SET_NAME IN ('Inventory')) INVENTARIO,
  --          
    --    
        (SELECT CCD.ORGANIZATION_ID,
                               CCD.INVENTORY_ITEM_ID,
                               SUM(CCD.CMPNT_COST) UNIT_TOTAL
                          FROM apps.CM_CMPT_DTL CCD
                              ,(SELECT MAX(PERIOD_ID) PERIOD_ID,
                                       CCD1.ORGANIZATION_ID,
                                       CCD1.INVENTORY_ITEM_ID
                                  FROM apps.CM_CMPT_DTL CCD1
                                 WHERE CCD1.DELETE_MARK = '0'
                                   AND CCD1.COST_TYPE_ID = '1005'
                                   AND CCD1.CMPNT_COST <> 0
                                 GROUP BY CCD1.ORGANIZATION_ID,
                                          CCD1.INVENTORY_ITEM_ID ) tab_cost
                         WHERE CCD.DELETE_MARK       = '0'
                           AND CCD.COST_TYPE_ID      = '1005'
                           AND CCD.ORGANIZATION_ID   = tab_cost.ORGANIZATION_ID
                           AND CCD.INVENTORY_ITEM_ID = tab_cost.INVENTORY_ITEM_ID
                           AND CCD.PERIOD_ID         = tab_cost.PERIOD_ID
                           AND CCD.CMPNT_COST       <> 0
                        GROUP BY CCD.ORGANIZATION_ID,
                                 CCD.INVENTORY_ITEM_ID  ) tab_cost
--         
   WHERE --step.recipe_id           = 2795                           AND
         itm.inventory_item_id      = tab_cost.inventory_item_id(+)  AND
         itm.organization_id        = tab_cost.organization_id(+)    AND
--
         /**** performance ****/
         vr.preference                =  1                              AND   
         vr.delete_mark               = 0                              AND
         vr.recipe_use                = 0 /*Producao*/                AND --Custos 
         vr.validity_rule_status     in (700,900)                      AND
         vr.recipe_id                 = gr.recipe_id                   AND
         vr.start_date               <= sysdate                        AND
         vr.end_date                  is NULL                          AND
         frh.routing_id(+)            = gr.routing_id                  AND
         oper.ROUTINGSTEP_ID(+)       = step.ROUTINGSTEP_ID            AND
         op.OPRN_ID(+)                = oper.OPRN_ID                   AND
         itm.inventory_item_id        = fm.inventory_item_id           AND
         itm.organization_id          = 92                             AND
         gr.formula_id                = fm.formula_id                  AND
         gr.recipe_status            in (700,900)                      AND
         fms.formula_id               = fm.formula_id                  AND
         fms.formula_status in (700,900) and
         fm.line_type                 = -1                             AND
         fm.formulaline_id            = step.FORMULALINE_ID(+)         AND
         fm2.line_type                = 1                              AND
         fm2.formula_id               = fm.formula_id                  AND
         inventario.organization_id   = itm.organization_id(+)         AND
         inventario.inventory_item_id = itm.inventory_item_id(+)       AND
         itm2.ORGANIZATION_ID         = CUSTO_OPM.ORGANIZATION_ID(+)   AND
         itm2.INVENTORY_ITEM_ID       = CUSTO_OPM.INVENTORY_ITEM_ID(+) AND
         itm2.inventory_item_id       = fm2.inventory_item_id          AND
         itm2.organization_id         = 92 and       
         itm2.segment1                in ('CR681','CR691B','E6176','E6279','E6355','E6445','W7122','W7815','W7821','W7826','W7911','WE-97-2619-BR','HEQ-8716-BR','HT-63-5694-BR','WE-91-4727-BR','WR-87-5531-BR','WE-22-1101-BR','WE2740-BR','WE-33-7744-BR','WE-38-3550-BR','WE-39-8534-BR','WE-48-3739-BR','WE-58-2954-BR','WE-66-7667-BR','WE-67-9751-BR','WE-74-5044-BR','WE-79-5458-BR','WE-84-5115-BR','WE-89-1162-BR','WE-93-7263-BR')
ORDER BY recipe_no, routingstep_no, line_no;


select * from gmd_recipes;

select * from fm_rout_hdr;