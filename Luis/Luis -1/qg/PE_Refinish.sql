--
-- GeraÁ„o de relatÛrio de Estrutura no nÌvel 0. Filtro por itens acabados de GVT e SUM n„o Inativos e Obsoletos.
--
--


--WITH cteMenuNivel(id,Nome,Nivel,NomeCompleto)
--AS
--(
--    -- Ancora
--    SELECT id,Nome,1 AS 'Nivel',CAST(Nome AS VARCHAR(255)) AS 'NomeCompleto' 
--    FROM tbMenu WHERE idPai IS NULL
--    
--    UNION ALL
    
--    -- Parte RECURSIVA
--    SELECT 
--        m.id,m.Nome,c.Nivel + 1 AS 'Nivel',
--        CAST((c.NomeCompleto + '/' + m.Nome) AS VARCHAR(255)) 'NomeCompleto' 
--    FROM tbMenu m INNER JOIN cteMenuNivel c ON m.idPai = c.id
    
--)
--SELECT Nivel,NomeCompleto FROM cteMenuNivel




WITH cteMenuNivel(segment1,inventory_item_id,qty, formula_id, recipe_id, organization_id, Nivel)
AS
(
    -- Ancora
    SELECT msi.segment1,
           fmd.inventory_item_id,
           CASE
              WHEN msip.planning_make_buy_code  = 1 THEN
                 1
              WHEN fmd.scale_type = 0 THEN
                 (fmd.qty / fm.qty) / vr.std_qty
              WHEN fmd.scale_type = 1 THEN
                 (fmd.qty / fm.qty)
              ELSE
                 (fmd.qty / fm.qty)
           END qty ,
           fmd.formula_id,
           gr.recipe_id,
           fmd.organization_id,
           0 as Nivel
      FROM apps.fm_form_mst_b fms,
           apps.fm_matl_dtl   fm,
           apps.fm_matl_dtl   fmd,
           apps.gmd_recipes_b gr,
           apps.gmd_recipe_validity_rules vr,
           apps.mtl_system_items_b msi,
           apps.mtl_system_items_b msip
     WHERE fmd.line_type              = -1                   AND           
           fmd.formula_id             = fm.formula_id        AND
           fmd.organization_id        = fm.organization_id   AND
--           
           /**** performance ****/
           vr.preference                  = 1               AND   
           vr.delete_mark                 = 0               AND   
           vr.recipe_use                  = 0               AND --Custos 
           vr.validity_rule_status       in (700,900)       AND 
           vr.recipe_id                   = gr.recipe_id    AND
           vr.start_date                 <= sysdate         AND
           vr.end_date                   is NULL            AND           
           /**** performance ****/
--           
           gr.recipe_id                 = (select max(gr1.recipe_id)
                                             FROM apps.gmd_recipes_b gr1,
                                                  apps.gmd_recipe_validity_rules vr1
                                            WHERE /**** Performance ****/
                                                  vr1.delete_mark           = 0                  AND
                                                  vr1.preference            = 1                  AND      
                                                  vr1.recipe_use            = 0 /*Custos*/      AND
                                                  vr1.validity_rule_status in (700,900)          AND
                                                  vr1.start_date           <= sysdate            AND
                                                  vr1.end_date             is null               AND
                                                  vr1.organization_id       = fm.organization_id AND
                                                  vr1.recipe_id             = gr1.recipe_id      AND
                                                  /**** Performance ****/
                                                  gr1.recipe_status        in (700,900)          AND
                                                  gr1.formula_id            = fm.formula_id) AND
--                                                  
           gr.recipe_status            in (700,900)             AND
           gr.formula_id                = fm.formula_id         AND
--           
           NVL(fms.formula_class,'SM') <> 'TING-PMC'            AND
           fms.formula_id               = fm.formula_id         AND
           fm.line_type                 = 1                     AND
           fm.inventory_item_id         = msi.inventory_item_id AND
           fm.organization_id           = msi.organization_id   AND
           msip.inventory_item_id       = fmd.inventory_item_id AND
           msip.organization_id         = msi.organization_id   AND
           --MSI.SEGMENT1 = 'BP-01.01'
           --
           msi.organization_id         IN (86,92)               AND
           msi.item_type             LIKE 'ACA%'   
         --  MSI.SEGMENT1 = '022.01'              
           --msi.inventory_item_status_code NOT IN ('Inactive','Obsoleto') AND
           --msi.segment1 in ('ZM463.01')
           --
           --msi.segment1 = '8201144982.99' --'TOEA-6247Z.79' --'8201144996.99' --'8201540330.99' --'TOEA-6247Z.79'
           --msi.inventory_item_id        = 2701
--
)      
--
--cycle inventory_item_id set is_cycle to '1' default '0'
--
SELECT mp.organization_code,
       c.segment1,
----       punb.un_number ONU,
----       msib.attribute1 "SIRE",
----       msib.attribute2 "Desc Legal",
----       phc.description "Class Risco",
----       msib.attribute3 "Class Embalagem",
----       inventario.categoria,
       msib.inventory_item_status_code,
----       msi.segment1 Ingrediente,
       TRANSLATE(TRANSLATE(SUBSTR(msi.description,1,80),'ABCDEFGHIJKLMNOPQRSTUWVXYZabcdefghijklmnopqrstuwvxyz01234567890—¡…Õ”⁄¿»Ã“Ÿ¬ Œ‘€√’ƒÀœ÷‹«Ò·ÈÌÛ˙‡ËÏÚ˘‚ÍÓÙ˚„ı‰ÎÔˆ¸Áñ∫™≤∞.-!"''`#$%().:[/]{}®+???ø;ß&¥*<>'
                                                       ,'ABCDEFGHIJKLMNOPQRSTUWVXYZabcdefghijklmnopqrstuwvxyz01234567890NAEIOUAEIOUAEIOUAOAEIOUCnaeiouaeiouaeiouaoaeiouc-'),CHR(10),' ') "Descricao",
----       pun.un_number "ONU Ingrediente",  
----       msi.attribute1 "SIRE",
----       msi.attribute2 "Desc Legal",
----       msi.attribute3 "Class Embalagem",
--       msi.primary_uom_code,
----       msi.item_type,
       --c.formula_id,
       --c.inventory_item_id,
----       c.qty,
       --c.Nivel,
--       
--       MSI.GLOBAL_ATTRIBUTE2       "Classe da Cond da TransaÁ„o",
--       MSI.GLOBAL_ATTRIBUTE3       "Origem do Item",
--       MSI.GLOBAL_ATTRIBUTE4       "Tipo Fiscal do Item",
--       MSI.GLOBAL_ATTRIBUTE6       "SituaÁ„o Trib Estadual",
--      MSI.GLOBAL_ATTRIBUTE5       "SituaÁ„o Trib Federal",
--      MSI.GLOBAL_ATTRIBUTE10      "EAN13",
--       MSI.GLOBAL_ATTRIBUTE16      "Importar Conteudo",
--       MSI.GLOBAL_ATTRIBUTE17      "Valor Parcela estrangeira",
--       MSI.GLOBAL_ATTRIBUTE18      "Valor Total Envio Inter",
--       MSI.GLOBAL_ATTRIBUTE19      "Numero FCI",       
----       FISCAL_CLASSIFICATION.CATEGORIA "NCM"     ,
       msib.SHELF_LIFE_DAYS,
       ( nvl(cv.CONVERSION_RATE,1)) "Peso Especifico"  
--       
--       
--       
  FROM cteMenuNivel c,
       apps.mtl_system_items_b   msi,
       apps.mtl_system_items_b   msib,
       apps.po_un_numbers        pun,
       apps.po_un_numbers        punb,
       apps.mtl_parameters       mp,
       apps.PO_HAZARD_CLASSES_TL phc,
       (SELECT MIC.INVENTORY_ITEM_ID,
               MIC.ORGANIZATION_ID,
               MIC.CATEGORY_SET_NAME,
               MIC.CATEGORY_CONCAT_SEGS CATEGORIA
          FROM APPS.MTL_ITEM_CATEGORIES_V MIC, APPS.MTL_CATEGORIES_V MC
         WHERE MC.CATEGORY_ID = MIC.CATEGORY_ID
           AND MIC.CATEGORY_SET_NAME IN ('FISCAL_CLASSIFICATION')) FISCAL_CLASSIFICATION,
       (SELECT MIC.INVENTORY_ITEM_ID,
               MIC.ORGANIZATION_ID,
               MIC.CATEGORY_SET_NAME,
               MIC.CATEGORY_CONCAT_SEGS CATEGORIA
          FROM APPS.MTL_ITEM_CATEGORIES_V MIC, APPS.MTL_CATEGORIES_V MC
         WHERE MC.CATEGORY_ID = MIC.CATEGORY_ID
           AND MIC.CATEGORY_SET_NAME IN ('Inventory')) INVENTARIO,
           apps.MTL_UOM_CLASS_CONVERSIONS cv
--           
 WHERE mp.organization_id         = c.organization_id    AND
       phc.hazard_class_id        = msib.hazard_class_id AND
       phc.language               = 'US'                AND
       msib.segment1              = c.segment1           AND
       msib.organization_id       = c.organization_id    AND
      (msi.item_type like 'SEMI%' OR
       msi.item_type like 'INT%') AND
       pun.un_number_id           = msi.un_number_id     AND
       punb.un_number_id          = msib.un_number_id    AND
       msi.inventory_item_id      = c.inventory_item_id  AND
       msi.organization_id        = c.organization_id    AND
       msib.ORGANIZATION_ID       = INVENTARIO.ORGANIZATION_ID(+) AND
       msib.INVENTORY_ITEM_ID     = INVENTARIO.INVENTORY_ITEM_ID(+) AND
       cv.inventory_item_id(+)    = msi.inventory_item_id           AND
       cv.from_uom_code           = 'kg' and
       cv.to_uom_code(+)          = 'l'          AND
       INVENTARIO.CATEGORIA like '%REF%' and
--       
     --  msi.planning_make_buy_code = 2                   AND
     --  msi.item_type             <> 'INS/EMB'           AND
     --  msi.item_type             <> 'MISC'           AND
       MSI.ORGANIZATION_ID        = FISCAL_CLASSIFICATION.ORGANIZATION_ID(+) AND
       MSI.INVENTORY_ITEM_ID      = FISCAL_CLASSIFICATION.INVENTORY_ITEM_ID(+)
       order by 1,2,4;

select * from apps.mtl_system_items_b where segment1 in ('SRC-75','HE-15-8633');