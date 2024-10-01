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
         itm.organization_id       in (181,182) and
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
      -- itm.organization_id          = 92                             AND
         gr.formula_id                = fm.formula_id                  AND
         gr.recipe_status            in (700,900)                      AND
         fms.formula_id               = fm.formula_id                  AND
         fm.line_type                 = -1                             AND
         fm.formulaline_id            = step.FORMULALINE_ID(+)         AND
         fm2.line_type                = 1                              AND
         fm2.formula_id               = fm.formula_id                  AND
         inventario.organization_id   = itm.organization_id(+)         AND
         inventario.inventory_item_id = itm.inventory_item_id(+)       AND
         itm2.ORGANIZATION_ID         = CUSTO_OPM.ORGANIZATION_ID(+)   AND
         itm2.INVENTORY_ITEM_ID       = CUSTO_OPM.INVENTORY_ITEM_ID(+) AND
         itm2.inventory_item_id       = fm2.inventory_item_id          AND
         itm2.organization_id   in (181,182)                            
ORDER BY recipe_no, routingstep_no, line_no;


select * from gmd_recipes;

select * from fm_rout_hdr;










  SELECT gr.recipe_no receita,
         frh.routing_no,
         oper.ROUTINGSTEP_no
    FROM apps.fm_rout_dtl oper,
         apps.fm_rout_hdr frh,
         apps.gmd_recipes gr
   WHERE frh.routing_id            = gr.routing_id                  AND
         oper.routing_id           = gr.routing_id AND
          gr.owner_organization_id in (181,182);


select ATTRIBUTE_CATEGORY,
ATTRIBUTE1,
ATTRIBUTE10,
ATTRIBUTE11,
ATTRIBUTE12,
ATTRIBUTE13,
ATTRIBUTE14,
ATTRIBUTE15,
ATTRIBUTE16,
ATTRIBUTE17,
ATTRIBUTE18,
ATTRIBUTE19,
ATTRIBUTE2,
ATTRIBUTE20,
ATTRIBUTE21,
ATTRIBUTE22,
ATTRIBUTE23,
ATTRIBUTE24,
ATTRIBUTE25,
ATTRIBUTE26,
ATTRIBUTE27,
ATTRIBUTE28,
ATTRIBUTE29,
ATTRIBUTE3,
ATTRIBUTE30,
ATTRIBUTE4,
ATTRIBUTE5,
ATTRIBUTE6,
ATTRIBUTE7,
ATTRIBUTE8,
ATTRIBUTE9,
CREATED_BY,
CREATION_DATE,
EFFECTIVE_ING_REPLACEMENT_DATE,
FORMULA_ID,
FORMULA_LINE_NO,
FORMULALINE_ID,
INVENTORY_ITEM_ID,
ITEM_TYPE,
ITEM_TYPE_LOOKUP,
LAST_UPDATE_DATE,
LAST_UPDATE_LOGIN,
LAST_UPDATED_BY,
ORGANIZATION_ID,
ORGN_CODE,
RECIPE_ID,
RECIPE_NO,
RECIPE_VERSION,
ROUTING_ID,
ROUTING_STEP_NO,
ROUTINGSTEP_ID,
STG_RECORD_ID,
STG_REQUEST_ID
 from XXGMD_STEPMATASSOC_CNV_STG order by 9 desc;