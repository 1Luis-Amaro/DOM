

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
           msip.segment1 <> msi.segment1 
           --MSI.SEGMENT1 = 'BP-01.01'
           --           
           /*msi.segment1 in 
           ('8201144982.99') 
'8201144992.99',
'8201144996.99',
'8201144998.99',
'8201146154.99',
'8201146157.99',
'8201293185',
'8201293189',
'8201293191',
'8201293192',
'8201293193',
'8201293198',
'8201293200',
'8201293202',
'8201293203',
'8201293204',
'8201293472',
'8201293474',
'8201293477',
'8201293479',
'8201293480',
'8201293511',
'8201356697',
'8201356702',
'8201356863',
'8201356867',
'8201356872',
'8201356875',
'8201356877',
'8201356879',
'8201356880',
'8201356884',
'8201356894',
'8201356918',
'8201356920',
'8201356935',
'8201356940',
'8201419190',
'8201452942',
'8201453127',
'8201457291',
'8201457298',
'8201461037',
'8201461039',
'8201488540',
'8201489127',
'8201501619',
'8201501665',
'8201531179',
'8201540251.99',
'8201540263.99',
'8201540317.99',
'8201540321.99',
'8201540326.99',
'8201540330.99',
'8201540338.99',
'8201540340.99',
'8201540342.99',
'8201548126',
'8201548202',
'8201550055',
'8201550056',
'8201550059',
'8201550060',
'8201558932',
'8201563984',
'8201606885',
'8201606929',
'8201606933',
'8201608570',
'8201608587',
'8201608588',
'8201608773',
'8201608776',
'8201608778',
'8201608798',
'8201643207',
'8201659243',
'8201659251',
'8201659257',
'8201659344',
'8201659349',
'8201659361',
'8201659363',
'8201659365',
'8201669745',
'992013189R',
'992016338R',
'992016401R',
'992016544R',
'992016630R',
'992017165R')*/
           --
           --msi.segment1 = '8201144982.99' --'TOEA-6247Z.79' --'8201144996.99' --'8201540330.99' --'TOEA-6247Z.79'
           --msi.inventory_item_id        = 2701
--           
    UNION ALL
--    
    -- Parte RECURSIVA
--
--
    SELECT c.segment1,
           fmdi.inventory_item_id,
--    
           case 
              when fmdi.scale_type = 0 then
                 ((fmdi.qty / fmi.qty) / vri.std_qty) * c.qty
              when fmdi.scale_type = 1 then
                 (fmdi.qty / fmi.qty) * c.qty
              else
                 (fmdi.qty / fmi.qty) * c.qty
           end qty ,
           fmdi.formula_id,
           gri.recipe_id,
           fmdi.organization_id,      
           c.nivel + 1
--           
      FROM apps.fm_form_mst_b fmsi
      join apps.fm_matl_dtl   fmi  
        on NVL(fmsi.formula_class,'SM') <> 'TING-PMC' AND
           fmsi.formula_id               = fmi.formula_id
--
      join apps.gmd_recipes_b gri
        on gri.recipe_status        in (700,900)            AND
           gri.recipe_id            = (select max(gr1.recipe_id)
                                         FROM apps.gmd_recipes_b gr1,
                                              apps.gmd_recipe_validity_rules vr1
                                        WHERE vr1.delete_mark                 = 0                   AND
                                              vr1.preference                  = 1                   AND      
                                              vr1.recipe_use                  = 0 /*Custos*/       AND
                                              vr1.validity_rule_status       in (700,900)           AND
                                              vr1.start_date                 <= sysdate             AND
                                              vr1.end_date                   is NULL                AND
                                              vr1.organization_id             = fmi.organization_id AND
                                              vr1.recipe_id                   = gr1.recipe_id       AND
                                              gr1.recipe_status              in (700,900)           AND
                                              gr1.formula_id                  = fmi.formula_id)       
--                   
--
      join apps.gmd_recipe_validity_rules vri
        on /**** performance ****/
           vri.preference                  = 1                   AND      
           vri.delete_mark                 = 0                   AND
           vri.recipe_use                  = 0                   AND --Custos 
           vri.validity_rule_status       in (700,900)           AND 
           vri.start_date                 <= sysdate             AND
           NVL(vri.end_date,(SYSDATE + 1)) > sysdate             AND
           vri.organization_id             = fmi.organization_id AND           
           vri.recipe_id                   = gri.recipe_id
           /**** performance ****/
--           
      join apps.fm_matl_dtl fmdi
        on fmdi.line_type           = -1                    AND
           fmdi.formula_id          = fmi.formula_id        AND
           fmdi.formula_id          = gri.formula_id        AND
           fmdi.organization_id     = fmi.organization_id    
--
--           
      join apps.mtl_system_items_b msii
        on fmi.inventory_item_id   = msii.inventory_item_id AND
           fmi.line_type           = 1                      AND
           msii.inventory_item_id  = fmi.inventory_item_id  AND
           msii.organization_id    = fmi.organization_id 
           --
--           
      join  cteMenuNivel c 
        on msii.inventory_item_id = c.inventory_item_id AND
           fmdi.inventory_item_id <> c.inventory_item_id and
           c.nivel                < 190
--
)      
--
--cycle inventory_item_id set is_cycle to '1' default '0'
--
SELECT c.segment1,
       msi.segment1 Ingrediente,
       msi.primary_uom_code,
       msi.item_type,
       --c.formula_id,
       --c.inventory_item_id,
       c.qty,
       c.Nivel,
--       
       MSI.GLOBAL_ATTRIBUTE2       "Classe da Cond da Transação",
       MSI.GLOBAL_ATTRIBUTE3       "Origem do Item",
       MSI.GLOBAL_ATTRIBUTE4       "Tipo Fiscal do Item",
--       MSI.GLOBAL_ATTRIBUTE6       "Situação Trib Estadual",
--      MSI.GLOBAL_ATTRIBUTE5       "Situação Trib Federal",
--      MSI.GLOBAL_ATTRIBUTE10      "EAN13",
--       MSI.GLOBAL_ATTRIBUTE16      "Importar Conteudo",
--       MSI.GLOBAL_ATTRIBUTE17      "Valor Parcela estrangeira",
--       MSI.GLOBAL_ATTRIBUTE18      "Valor Total Envio Inter",
--       MSI.GLOBAL_ATTRIBUTE19      "Numero FCI",       
       FISCAL_CLASSIFICATION.CATEGORIA "NCM"       
--       
--       
--       
  FROM cteMenuNivel c, apps.mtl_system_items_b msi,
       (SELECT MIC.INVENTORY_ITEM_ID,
               MIC.ORGANIZATION_ID,
               MIC.CATEGORY_SET_NAME,
               MIC.CATEGORY_CONCAT_SEGS CATEGORIA
          FROM APPS.MTL_ITEM_CATEGORIES_V MIC, APPS.MTL_CATEGORIES_V MC
         WHERE MC.CATEGORY_ID = MIC.CATEGORY_ID
           AND MIC.CATEGORY_SET_NAME IN ('FISCAL_CLASSIFICATION')) FISCAL_CLASSIFICATION
 WHERE msi.inventory_item_id      = c.inventory_item_id AND
       msi.organization_id        = c.organization_id   AND
       msi.planning_make_buy_code = 2                   AND
       msi.item_type             <> 'INS/EMB'           AND
       msi.item_type             <> 'MISC'           AND
       MSI.ORGANIZATION_ID        = FISCAL_CLASSIFICATION.ORGANIZATION_ID(+) AND
       MSI.INVENTORY_ITEM_ID      = FISCAL_CLASSIFICATION.INVENTORY_ITEM_ID(+) and
       c.nivel > 20;

select * from apps.mtl_system_items_b where segment1 in ('SRC-75','HE-15-8633');