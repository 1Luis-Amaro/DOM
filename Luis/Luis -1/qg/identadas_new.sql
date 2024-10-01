

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




WITH cteMenuNivel(inventory_item_id,qty,Nivel, formula_id)
AS
(
    -- Ancora
    SELECT fmd.inventory_item_id,
           CASE 
              WHEN fmd.scale_type = 0 THEN
                 (fmd.qty / fm.qty) / vr.std_qty
              WHEN fmd.scale_type = 1 THEN
                 (fmd.qty / fm.qty)
              ELSE
                 (fmd.qty / fm.qty)
           END qty ,
      fmd.formula_id,

           0 as Nivel
      FROM apps.fm_form_mst fms,
           apps.fm_matl_dtl fm,
           apps.fm_matl_dtl fmd,
           apps.gmd_recipes gr,
           apps.gmd_recipe_validity_rules vr,
           apps.mtl_system_items_b itm
     WHERE NVL(fms.formula_class,'SM') <> 'TING-PMC'           AND
           fms.formula_id             = fm.formula_id        AND
           fmd.line_type              = -1                   AND           
           fmd.formula_id             = fm.formula_id        AND
           fmd.organization_id        = fm.organization_id   AND
           vr.recipe_validity_rule_id = (SELECT MAX(vr1.recipe_validity_rule_id)
                                     FROM apps.gmd_recipe_validity_rules vr1
                                    WHERE vr1.preference                  = 1              AND      
                                          vr1.recipe_use                  = 2              AND --Custos 
                                          vr1.validity_rule_status       in (700,900)      AND 
                                          vr1.recipe_id                   = gr.recipe_id   AND
                                          TRUNC(vr1.start_date)          <= trunc(sysdate) AND
                                          NVL(vr1.end_date,'01-jan-2999') > trunc(sysdate)) AND
           gr.recipe_status           in (700,900)           AND
           gr.formula_id              = fm.formula_id        AND
           gr.recipe_id               = (select max(gr1.recipe_id)
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
           itm.segment1 = '8201144996.99' --'8201540330.99' --'TOEA-6247Z.79'
           
    UNION ALL
    
    -- Parte RECURSIVA


    SELECT fmdi.inventory_item_id,
    
           case 
              when fmdi.scale_type = 0 then
                 ((fmdi.qty / fmi.qty) / vri.std_qty) * c.qty
              when fmdi.scale_type = 1 then
                 (fmdi.qty / fmi.qty) * c.qty
              else
                 (fmdi.qty / fmi.qty) * c.qty
           end qty ,
     fmdi.formula_id,      
           c.nivel + 1
           
      FROM apps.fm_form_mst fmsi
      join apps.fm_matl_dtl fmi  
        on NVL(fmsi.formula_class,'SM')     <> 'TING-PMC'             AND
           fmsi.formula_id         = fmi.formula_id

      join apps.gmd_recipes gri
        on gri.recipe_status        in (700,900)            AND
           gri.recipe_id            = (select max(gr1.recipe_id)
                                         FROM apps.fm_matl_dtl fm1,
                                              apps.gmd_recipes gr1,
                                              apps.gmd_recipe_validity_rules vr1,
                                              apps.fm_form_mst fms1
                                        WHERE fms1.formula_id          = fm1.formula_id        AND
                                              fms1.formula_status     in (700,900)             AND
                                              fm1.inventory_item_id    = fmi.inventory_item_id AND
                                              fm1.line_type            = 1                     AND
                                              vr1.preference           = 1                    AND      
                                              vr1.recipe_use           = 2 /*Custos*/         AND
                                              vr1.validity_rule_status in (700,900)            AND
                                              vr1.recipe_id            = gr1.recipe_id          AND
                                              gr1.recipe_status        in (700,900)            AND
                                              gr1.formula_id           = fm1.formula_id)       
                   

      join apps.gmd_recipe_validity_rules vri
        on vri.recipe_use              = 2                    AND --Custos 
           vri.validity_rule_status    in (700,900)           AND
           vri.recipe_validity_rule_id = (SELECT MAX(vr1.recipe_validity_rule_id)
                                            FROM apps.gmd_recipe_validity_rules vr1
                                           WHERE vr1.preference                  = 1              AND      
                                                 vr1.recipe_use                  = 2              AND --Custos 
                                                 vr1.validity_rule_status       in (700,900)      AND 
                                                 vr1.recipe_id                   = gri.recipe_id   AND
                                                 TRUNC(vr1.start_date)          <= trunc(sysdate) AND
                                                 NVL(vr1.end_date,'01-jan-2999') > trunc(sysdate)) AND
           vri.recipe_id               = gri.recipe_id

      join apps.fm_matl_dtl fmdi
        on fmdi.line_type           = -1                    AND
           fmdi.formula_id          = fmi.formula_id        AND
           fmdi.formula_id          = gri.formula_id        AND
           fmdi.organization_id     = fmi.organization_id    

           
      join apps.mtl_system_items_b itmi
        on fmi.inventory_item_id   = itmi.inventory_item_id AND
           fmi.line_type           = 1                      AND
           itmi.inventory_item_id  = fmi.inventory_item_id  AND
           itmi.organization_id    = fmi.organization_id
      join  cteMenuNivel c on itmi.inventory_item_id = c.inventory_item_id
)      


cycle inventory_item_id set is_cycle to '1' default '0'

SELECT msi.segment1,
       c.formula_id,
       c.inventory_item_id,
       c.qty,
       c.Nivel,
       msi.global_attribute3,
       msi.global_attribute4 
  FROM cteMenuNivel c, apps.mtl_system_items_b msi
 WHERE msi.inventory_item_id = c.inventory_item_id AND
       msi.organization_id   = 92;
