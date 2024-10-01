/* Formatted on 11/09/2015 15:54:57 (QP5 v5.227.12220.39724) */
  SELECT gr.recipe_no           Receita,
         gr.recipe_version      Versao,
         fms.formula_no         Formula,
         fms.formula_vers       Versao,
         frh.routing_no         Roteamento,
         frh.routing_vers       Versao,         
         decode(vr.recipe_use, 0, 'Producao',1,'Planej',2,'Custo',3,'Normativo',4,'Tecnico') "Uso Receita",
         msi.segment1           Produto,
         msi.primary_uom_code   UDM,
         par.organization_code  Org,
         vr.preference          Preferencia,
         vr.start_date          "Data Inicial",
         vr.end_date            "Data Fim",
         vr.min_qty             "Qtde.Min",	
         vr.max_qty             "Qtde.Max",
         vr.std_qty             "Qtd.Padrao",
         vr.PLANNED_PROCESS_LOSS "Perda", 
         custo_opm.categoria,
         INVENTARIO.CATEGORIA
    FROM apps.gmd_recipes               gr,
         apps.gmd_recipe_validity_rules vr,
         apps.fm_form_mst               fms,
         apps.fm_matl_dtl               fm,
         apps.mtl_system_items_b        msi,
         APPS.MTL_PARAMETERS            par,
         apps.fm_rout_hdr               frh,
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
           AND MIC.CATEGORY_SET_NAME IN ('Inventory')) INVENTARIO
--        
--            
--         
   WHERE par.organization_id      = gr.owner_organization_id        AND
         vr.recipe_id             = gr.recipe_id                    AND
         vr.recipe_use            = 2 /*custos*/                    AND
         vr.VALIDITY_RULE_STATUS in (700,900)                       AND 
         gr.owner_organization_id = msi.organization_id             AND
         gr.formula_id            = fm.formula_id                   AND
         gr.recipe_status        in (700,900)                       AND
         fms.formula_class       <> 'TING-PMC'                      AND
         fms.formula_id           = fm.formula_id                   AND
         fm.inventory_item_id     = msi.inventory_item_id           AND
         fm.line_type             = 1                               AND
         frh.routing_id(+)        = gr.routing_id                   AND
         msi.ORGANIZATION_ID      = CUSTO_OPM.ORGANIZATION_ID(+)    AND
         msi.INVENTORY_ITEM_ID    = CUSTO_OPM.INVENTORY_ITEM_ID(+)  AND
         msi.ORGANIZATION_ID      = INVENTARIO.ORGANIZATION_ID(+)   AND
         msi.INVENTORY_ITEM_ID    = INVENTARIO.INVENTORY_ITEM_ID(+) AND
         msi.inventory_item_id    = fm.inventory_item_id
--         msi.segment1 = '014.00';
ORDER BY organization_code, recipe_no, recipe_version ;


SELECT * from apps.gmd_recipes rec;

select * from apps.gmd_recipe_validity_rules;
