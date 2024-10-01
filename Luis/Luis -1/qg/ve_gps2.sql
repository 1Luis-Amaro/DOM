    WITH ctemenunivel(inventory_item_id,
      qty,
      formula_id,
      organization_id,
      nivel,
      item_lookup_code,
      ingred_controlado,
      perc_tolerancia,
      tp_substancia) AS
       (
       
          SELECT fmd.inventory_item_id
               ,CASE
                  WHEN fmd.scale_type = 0 THEN
                   (fmd.qty / fm.qty) / vr.std_qty
                  ELSE
                   (fmd.qty / fm.qty)
                END qty
               ,fmd.formula_id
               ,fmd.organization_id
               ,0 AS nivel
               ,flvv.lookup_code
               ,CASE
                  WHEN flvv.lookup_code IS NULL THEN
                   NULL --'NAO'
                  ELSE
                   'SIM'
                END ingred_controlado
               ,nvl(flvvsub.tag, 0) / 100 perc_tolerancia
               ,nvl(flvv.description, 'N/A') tp_substancia --nvl(flvvsub.lookup_code, 'N/A') tp_substancia
        FROM   apps.fm_form_mst               fms
               ,apps.fm_matl_dtl               fm
               ,apps.fm_matl_dtl               fmd
               ,apps.gmd_recipes               gr
               ,apps.gmd_recipe_validity_rules vr
               ,apps.mtl_system_items_b        msi
               ,apps.fnd_lookup_values_vl      flvv
               ,apps.fnd_lookup_values_vl      flvvsub
        WHERE  nvl(fms.formula_class, 'SM') <> 'TING-PMC'
        AND    fms.formula_id = (SELECT NFORMULAID 
                                   FROM MPI_GPSI_LEGACYFORMULA
                                  WHERE smfgcode = msi.segment1 AND
                                        TIMESTAMP = (SELECT max(timestamp)
                                                       FROM MPI_GPSI_LEGACYFORMULA
                                                      WHERE smfgcode = msi.segment1))
        AND    fms.formula_id = fm.formula_id
        AND    fmd.line_type = -1
        AND    fmd.formula_id = fm.formula_id
        AND    fmd.organization_id = fm.organization_id
        AND    fmd.contribute_yield_ind = 'Y'
   --     AND    /**** performance ****/
   --            vr.preference = 1
   --     AND    vr.delete_mark = 0
   --     AND    vr.recipe_use = 0
   --     AND    --Custos 
   --            vr.validity_rule_status IN (700, 900)
        AND    vr.recipe_id = gr.recipe_id
  --      AND    vr.start_date <= SYSDATE
  --      AND    nvl(vr.end_date, '01-jan-2999') > SYSDATE
   --     AND    
              /**** performance ****/
   --            gr.recipe_status IN (700, 900)
        AND    gr.formula_id = fm.formula_id
   --     AND    gr.recipe_id =
   --            (SELECT MAX(gr1.recipe_id)
   --              FROM   apps.fm_matl_dtl               fm1
   --                    ,apps.gmd_recipes               gr1
   --                    ,apps.gmd_recipe_validity_rules vr1
   --                    ,apps.fm_form_mst               fms1
   --              WHERE  fms1.formula_id = fm1.formula_id
   --              AND    fms1.formula_status IN (700, 900)
   --              AND    fm1.inventory_item_id = msi.inventory_item_id
   --              AND    fm1.line_type = 1
   --              AND    
   --                    /**** Performance ****/
   --                     vr1.delete_mark = 0
   --              AND    vr1.preference = 1
   --              AND    vr1.recipe_use = 0 /*Custos*/
   --              AND    vr1.validity_rule_status IN (700, 900)
   --              AND    vr1.start_date <= SYSDATE
   --              AND    nvl(vr1.end_date, (SYSDATE + 1)) > SYSDATE
   --              AND    vr1.recipe_id = gr1.recipe_id
   --              AND    
                       /**** Performance ****/
  --                      gr1.recipe_status IN (700, 900)
   --              AND    gr1.formula_id = fm1.formula_id)
        AND    fm.inventory_item_id = msi.inventory_item_id
        AND    fm.line_type = 1
        AND    msi.inventory_item_id = fm.inventory_item_id
        AND    msi.organization_id = fm.organization_id
        AND    msi.inventory_item_id = 1347692 --7852
        --
        AND flvv.lookup_type(+) IN ('XXPPG_1079_PF_INGREDIENTE','XXPPG_1079_PF_INGREDIENTE_EXP')
              --
        --AND  (('CONTROLADO' = 'CONTROLADO' and flvv.lookup_type IN ('XXPPG_1079_PF_INGREDIENTE')) or
        --      ('REPORTAVEL' = 'REPORTAVEL' and flvv.lookup_type IN ('XXPPG_1079_PF_INGREDIENTE_EXP')))
              --
        AND    flvvsub.lookup_type(+) = 'XXPPG_1079_PF_SUBSTANCIA'
        AND    fmd.contribute_yield_ind = 'Y'
        AND    flvvsub.lookup_code(+) = flvv.description
        AND    flvv.lookup_code(+) = msi.segment1
        AND    flvvsub.enabled_flag(+) = 'Y'
        AND    nvl(flvvsub.end_date_active(+), SYSDATE) >= SYSDATE
        AND    flvv.enabled_flag(+) = 'Y'
        AND    nvl(flvv.end_date_active(+), SYSDATE) >= SYSDATE;
        --
        UNION ALL
        -- Parte RECURSIVA
        SELECT fmdi.inventory_item_id
               ,CASE
                  WHEN fmdi.scale_type = 0 THEN
                   ((fmdi.qty / fmi.qty) / vri.std_qty) * c.qty
              --    WHEN fmdi.scale_type = 1 THEN
              --     (fmdi.qty / fmi.qty) * c.qty
                  ELSE
                   (fmdi.qty / fmi.qty) * c.qty
                END qty
               ,fmdi.formula_id
               ,fmdi.organization_id
               ,c.nivel + 1
               ,c.item_lookup_code
               ,c.ingred_controlado
               ,c.perc_tolerancia
               ,c.tp_substancia
        --
        FROM   apps.fm_form_mst fmsi
        JOIN   apps.fm_matl_dtl fmi
        ON     nvl(fmsi.formula_class, 'SM') <> 'TING-PMC'
        AND    fmsi.formula_id = fmi.formula_id
        --
        JOIN   apps.gmd_recipes gri
        ON     gri.recipe_status IN (700, 900)
        AND    gri.recipe_id =
               (SELECT MAX(gr1.recipe_id)
                 FROM   apps.fm_matl_dtl               fm1
                       ,apps.gmd_recipes               gr1
                       ,apps.gmd_recipe_validity_rules vr1
                       ,apps.fm_form_mst               fms1
                 WHERE  fms1.formula_id = fm1.formula_id
                 AND    fms1.formula_status IN (700, 900)
                 AND    fm1.inventory_item_id = fmi.inventory_item_id
                 AND    fm1.line_type = 1
                 AND    vr1.delete_mark = 0
                 AND    vr1.preference = 1
                 AND    vr1.recipe_use = 0 /*Custos*/
                 AND    vr1.validity_rule_status IN (700, 900)
                 AND    vr1.start_date <= SYSDATE
                 AND    nvl(vr1.end_date, (SYSDATE + 1)) > SYSDATE
                 AND    vr1.recipe_id = gr1.recipe_id
                 AND    gr1.recipe_status IN (700, 900)
                 AND    gr1.formula_id = fm1.formula_id)
        --
        JOIN   apps.gmd_recipe_validity_rules vri
        ON     vri.recipe_use = 0
        AND    --Custos 
               vri.validity_rule_status IN (700, 900)
        AND    vri.preference = 1
        AND    vri.delete_mark = 0
        AND    vri.recipe_use = 0
        AND    --Custos 
               vri.validity_rule_status IN (700, 900)
        AND    vri.start_date <= SYSDATE
        AND    nvl(vri.end_date, (SYSDATE + 1)) > SYSDATE
        AND    vri.recipe_id = gri.recipe_id
        --    
        JOIN   apps.fm_matl_dtl fmdi
        ON     fmdi.line_type = -1
        AND    fmdi.formula_id = fmi.formula_id
        AND    fmdi.formula_id = gri.formula_id
        AND    fmdi.organization_id = fmi.organization_id
        AND    fmdi.contribute_yield_ind = 'Y'
        --     
        JOIN   apps.mtl_system_items_b msii
        ON     fmi.inventory_item_id = msii.inventory_item_id
        AND    fmi.line_type = 1
        AND    msii.inventory_item_id = fmi.inventory_item_id
        AND    msii.organization_id = fmi.organization_id
        JOIN   ctemenunivel c
        ON     msii.inventory_item_id = c.inventory_item_id
        --
        ) --cycle inventory_item_id SET is_cycle TO '1' DEFAULT '0'
   --select * from ctemenunivel;
   SELECT DISTINCT substance, perc_total_controlado
      FROM   (SELECT flvv.description substance --flvvsub.lookup_code substance
                    ,nvl(flvvsub.tag, 0) / 100 perc_tolerancia
                    ,flvv.lookup_code ingred_controlado
                    ,c.qty qtd
                    ,(SUM(nvl(c.qty, 0)) over(PARTITION BY NULL)) qty_total
                    ,flvv.tag
                    ,round((((SUM(nvl(c.qty, 0)) over(PARTITION BY flvv.lookup_code)) * (flvv.tag / 100)) / (SUM(nvl(c.qty, 1)) over(PARTITION BY NULL))) * 100,2) perc_total_controlado
              FROM   ctemenunivel              c
                    ,apps.mtl_system_items_b   msi
                    ,apps.fnd_lookup_values_vl flvv
                    ,apps.fnd_lookup_values_vl flvvsub
              WHERE  msi.inventory_item_id = c.inventory_item_id
              AND    msi.organization_id = c.organization_id
              AND    planning_make_buy_code = 2
              --AND    flvv.lookup_type(+) IN (g_lookup_ingred, g_lookup_ingred_exp)
             -- AND    (('REPORTAVEL' = 'CONTROLADO' and flvv.lookup_type IN ('XXPPG_1079_PF_INGREDIENTE')) or
             --         ('REPORTAVEL' = 'REPORTAVEL' and flvv.lookup_type IN ('XXPPG_1079_PF_INGREDIENTE_EXP')))  
              and flvv.lookup_type(+) = case when 'controlado' = 'REPORTAVEL' then  'XXPPG_1079_PF_INGREDIENTE_EXP' else 'XXPPG_1079_PF_INGREDIENTE' end                 
              AND    flvv.lookup_code(+) = msi.segment1
              AND    flvvsub.lookup_type(+) = 'XXPPG_1079_PF_SUBSTANCIA'
              AND    flvvsub.lookup_code(+) = flvv.description
              AND    flvvsub.enabled_flag(+) = 'Y'
              AND    nvl(flvvsub.end_date_active(+), SYSDATE) >= SYSDATE
              AND    flvv.enabled_flag(+) = 'Y'
              AND    nvl(flvv.end_date_active(+), SYSDATE) >= SYSDATE)
      WHERE  ingred_controlado IS NOT NULL
      AND    substance IS NOT NULL and perc_total_controlado >= 0
      
      