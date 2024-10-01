 
--Organização	Receita	Versão da Receita	Status	Descrição	Fórmula	Versão da fórmula	Roteiro	Versão roteiro	Calcular Qtd. Da Etapa	Bloq Impressão Ordem ?	Quantidade de saída total	UDM	UDM da Perda Fixa

                 
 SELECT LV.* --NVL(lv.description,grv.routing_class) --grv.routing_class - FEV-2018 Inclusao lookup XXPPG_CLASSE_ROTEIRO
        FROM gmd_routings_vl      grv,
             fnd_lookup_values_vl lv 
       WHERE 778     = grv.routing_id         AND
             LV.LOOKUP_CODE(+)  = grv.routing_class      AND
             LV.LOOKUP_TYPE(+)  = 'XXPPG_CLASSE_ROTEIRO' AND
             lv.enabled_flag(+) = 'Y'                    AND        
             SYSDATE BETWEEN NVL (lv.start_date_active, SYSDATE) AND
                             NVL (lv.end_date_active, SYSDATE);

select decode (900,700,'Aprovado para Uso Geral',900,'Congelado') from dual;

select * from apps.gmd_recipes gr;
select * from apps.gmd_recipes_b gr;
select * from apps.gmd_recipes_vl gr;
select * from gmd_routings_vl;

select * from apps.fm_form_mst fms;

 SELECT LV.* --NVL(lv.description,grv.routing_class) --grv.routing_class - FEV-2018 Inclusao lookup XXPPG_CLASSE_ROTEIRO
        FROM fnd_lookup_values_vl lv 
       WHERE LV.LOOKUP_TYPE(+)  = 'XXPPG_CLASSE_ROTEIRO' AND
             lv.enabled_flag(+) = 'Y'                    AND        
             SYSDATE BETWEEN NVL (lv.start_date_active, SYSDATE) AND
                             NVL (lv.end_date_active, SYSDATE);


  SELECT 
         mp.organization_code       "Organizacao",
         gr.recipe_no               "Receita",
         --gr.recipe_id,
         gr.recipe_version          "Versao",
         decode(gr.recipe_status,700,'Aprovado para Uso Geral',
                                 900,'Congelado') "Status",
         gr.recipe_description      "Descricao",
         fms.formula_no             "Formula",
         fms.formula_vers           "Vers formula",
         grv.routing_no             "Roteiro",
         grv.routing_vers           "Vers roteiro",
         gr.calculate_step_quantity "Calcular Qtd. Da Etapa",
         fms.yield_uom              "UDM",
         gr.attribute1              "Bloq Impressao",
         fms.total_output_qty,
         routing_class_desc         "Celula",
         inventario.categoria       "Categ Inventario",
         itm.segment1               "Item"
         --grv.routing_id,
         --ROUND(tab_cost.unit_total,5) "custo_unitario"
    FROM apps.gmd_recipes               gr,
         apps.gmd_recipe_validity_rules vr,
         gmd_routings_vl                grv,
         gmd_routing_class_vl           grcv,
         apps.fm_form_mst               fms,
         apps.fm_matl_dtl               fm2,         
         apps.mtl_system_items_b        itm,
         apps.mtl_parameters            mp,
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
--         
   WHERE --step.recipe_id           = 2795                           AND
         itm.inventory_item_id      = tab_cost.inventory_item_id(+)  AND
         itm.organization_id        = tab_cost.organization_id(+)    AND
--
         /**** performance ****/
         --vr.preference                =  1                              AND   
         vr.delete_mark               = 0                              AND
         vr.recipe_use                = 0 /*Producao*/                 AND --Custos 
         vr.validity_rule_status     in (700,900)                      AND
         vr.recipe_id                 = gr.recipe_id                   AND
         vr.start_date               <= sysdate                        AND
         vr.end_date                  is NULL                          AND
         itm.inventory_item_id        = fm2.inventory_item_id          AND
         mp.organization_id           = itm.organization_id            AND
         itm.organization_id          = gr.owner_organization_id       AND
         gr.recipe_status            in (700,900)                      AND
         grcv.routing_class           = grv.routing_class              AND
         grv.routing_id               = gr.routing_id                  AND
         fms.formula_id               = gr.formula_id                  AND
         fm2.line_type                = 1                              AND
         fm2.formula_id               = fms.formula_id                 AND
         inventario.organization_id   = itm.organization_id(+)         AND
         inventario.inventory_item_id = itm.inventory_item_id(+) and
        --FMS.formula_no like 'D80%' and
        --gr.recipe_no = 'D800/12000' and
         gr.attribute1 <> 'S'
ORDER BY recipe_no;


select * from gmd_recipes;

select * from fm_rout_hdr;