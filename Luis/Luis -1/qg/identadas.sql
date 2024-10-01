

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




WITH cteMenuNivel(inventory_item_id,qty,Nivel)
AS
(
    -- Ancora
    SELECT fmd.inventory_item_id,
           CASE 
              WHEN fms.scale_type = 0 THEN
                 fmd.qty / fms.total_output_qty
              WHEN fms.scale_type = 1 THEN
                 fmd.qty
              ELSE
                 fmd.qty
           END qty ,

           0 as Nivel
      FROM apps.fm_form_mst fms,
           apps.fm_matl_dtl fm,
           apps.fm_matl_dtl fmd,
           apps.gmd_recipes gr,
           apps.gmd_recipe_validity_rules vr,
           apps.mtl_system_items_b itm
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
           fm.formula_id          = (select max(fm1.formula_id)
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
           itm.inventory_item_id  = fm.inventory_item_id  AND
           itm.organization_id    = fm.organization_id    AND
           itm.segment1 = 'TOEA-6247Z.79' --'PPG3825-803.C6'
           
    UNION ALL
    
    -- Parte RECURSIVA


    SELECT fmdi.inventory_item_id,
    
           case 
              when fmdi.scale_type = 0 then
                 (fmdi.qty / vri.std_qty) * c.qty
              when fmdi.scale_type = 1 then
                 fmdi.qty * c.qty
              else
                 fmdi.qty * c.qty
           end qty ,
           
           c.nivel + 1
           
      FROM apps.fm_form_mst fmsi
      join apps.fm_matl_dtl fmi  
        on fmsi.formula_class     <> 'TING-PMC'             AND
           fmsi.formula_id         = fmi.formula_id
           
      join apps.gmd_recipes gri
        on gri.recipe_status        in (700,900)            AND
           gri.formula_id           = fmi.formula_id        

      join apps.gmd_recipe_validity_rules vri
        on vri.recipe_use           = 2                    AND --Custos 
           vri.validity_rule_status in (700,900)           AND 
           vri.recipe_id            = gri.recipe_id
           
      join apps.fm_matl_dtl fmdi
        on fmdi.line_type           = -1                     AND
           fmdi.formula_id          = fmi.formula_id         AND
           fmdi.organization_id     = fmi.organization_id    AND
           fmdi.formula_id          = (select max(fm1.formula_id)
                                         FROM apps.fm_matl_dtl fm1,
                                              apps.gmd_recipes gr,
                                              apps.gmd_recipe_validity_rules vr,
                                              apps.fm_form_mst fms1
                                        WHERE fms1.formula_id         = fm1.formula_id        AND
                                              fms1.formula_status    in (700,900)             AND
                                              fm1.inventory_item_id   = fmi.inventory_item_id AND
                                              fm1.line_type           = 1                     AND
                                              vr1.preference          = 1                    AND      
                                              vr.recipe_use           = 2 /*Custos*/         AND
                                              vr.validity_rule_status in (700,900)            AND
                                              vr.recipe_id            = gr.recipe_id          AND
                                              gr.recipe_status        in (700,900)            AND
                                              gr.formula_id           = fm1.formula_id)       
           
      join apps.mtl_system_items_b itmi
        on fmi.inventory_item_id   = itmi.inventory_item_id AND
           fmi.line_type           = 1                      AND
           itmi.inventory_item_id  = fmi.inventory_item_id  AND
           itmi.organization_id    = fmi.organization_id
      join  cteMenuNivel c on itmi.inventory_item_id = c.inventory_item_id

)
SELECT msi.segment1,
       c.inventory_item_id,
       c.qty,
       c.Nivel,
       msi.global_attribute3,
       msi.global_attribute4 
  FROM cteMenuNivel c, apps.mtl_system_items_b msi
 WHERE msi.inventory_item_id = c.inventory_item_id AND
       msi.organization_id   = 92;
       
        AND
       msi.primary_uom_code  = 'kg' AND
       msi.global_attribute4 = 'C'






/*

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
         
         itm.inventory_item_id  = fm.inventory_item_id
--         itm.segment1 = '014.00';
ORDER BY organization_code, recipe_no, recipe_version ;


SELECT * from apps.gmd_recipes rec;




*/