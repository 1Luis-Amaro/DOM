         WITH cteMenuNivel (segment1,
                            inventory_item_id,
                            qty,
                            Nivel,
                            formula_id,
                            recipe_id,
                            top_formula,
                            formula_no,
                            recipe_no,
                            tipo_linha,
                            planned_process_loss,
                            planned_process_loss_perda,
                            planned_process_loss_rout,
                            planeed_loss_ant,
                            line_no,
                            contribute_yield_ind,
                            line_type)
              AS (-- Ancora
                  SELECT msi.segment1,
                         fmd.inventory_item_id,
                         CASE
                            WHEN fmd.scale_type = 0 THEN
                               (fmd.qty / fm.qty) / vr.std_qty
                               --
                            WHEN fmd.scale_type = 1 or vr.std_qty <= 1 THEN
                               (fmd.qty / fm.qty)
                             --  
                            WHEN fmd.scale_type = 2 AND trunc(((fmd.qty / fm.qty) * vr.std_qty),0) <> ((fmd.qty / fm.qty) * vr.std_qty) AND fmd.rounding_direction = 1 THEN
                              (((TRUNC(((fmd.qty / fm.qty) * vr.std_qty),0)) + 1) / vr.std_qty)
                            --
                            WHEN fmd.scale_type = 2 AND trunc(((fmd.qty / fm.qty) * vr.std_qty),0) <> ((fmd.qty / fm.qty) * vr.std_qty) AND fmd.rounding_direction = 2 THEN
                               ((TRUNC(((fmd.qty / fm.qty) * vr.std_qty),0)) / vr.std_qty)
                              -- 
                            WHEN fmd.scale_type = 2 AND trunc(((fmd.qty / fm.qty) * vr.std_qty),0) <> ((fmd.qty / fm.qty) * vr.std_qty) AND fmd.rounding_direction = 0 THEN
                                ((ROUND(((fmd.qty / fm.qty) * vr.std_qty),0)) / vr.std_qty)
                            ELSE
                               (fmd.qty / fm.qty)
                               --
                               --
                            --ELSE (fmd.qty / fm.qty)
                         END
                         qty,
                         0 AS Nivel,
                         fms.formula_id,
                         gr.recipe_id,
                         fms.formula_no top_formula,
                         fms.formula_no,
                         gr.recipe_no,
                         DECODE (fmd.line_type, 1, 'Produto', 'Ingrediente')
                            tipo_linha,
                         vr.planned_process_loss,
                         --
                         CASE
                            WHEN fmd.contribute_yield_ind = 'Y' THEN
                                 (100 - nvl(vr.planned_process_loss,0)) / 100
                            ELSE 1
                         END planned_process_loss_perda, --ajl
                         --
                         (100 - nvl(vr.planned_process_loss,0)) / 100 planned_process_loss_rout,
                         --
                         1 planeed_loss_ant,
                         --
                         fmd.line_no,
                         fmd.contribute_yield_ind,
                         fmd.line_type
                    FROM apps.fm_form_mst fms,
                         apps.fm_matl_dtl fm,
                         apps.fm_matl_dtl fmd,
                         apps.gmd_recipes gr,
                         apps.gmd_recipe_validity_rules vr,
                         apps.mtl_system_items_b msi
                        -- xxppg.xxppg_opm_r147 indent
                   WHERE nvl(fms.formula_class,'SC') <> 'TING-PMC'              AND
                         fms.formula_id           = fm.formula_id               AND
                        -- fmd.line_type           = -1                           AND
                         fmd.formula_id           = fm.formula_id               AND
                         fmd.organization_id      = fm.organization_id          AND
                         --
                         /**** performance ****/
                         --vr.preference                  = 1               AND
                         vr.recipe_validity_rule_id    in (SELECT MAX(vr1.recipe_validity_rule_id)
                                                             FROM apps.gmd_recipe_validity_rules vr1
                                                            WHERE vr1.delete_mark           = 0                  AND
                                                                  vr1.recipe_use            = 2 /*Custos*/       AND
                                                                  vr1.validity_rule_status in (700,900)          AND
                                                                  vr1.start_date           <= sysdate            AND
                                                                  vr1.end_date             is null               AND
                                                                  vr1.organization_id       = fm.organization_id AND
                                                                  vr1.recipe_id             = gr.recipe_id) AND
                         vr.delete_mark                 = 0               AND   
                         vr.recipe_use                  = 2               AND --Custos 
                         vr.validity_rule_status       in (700,900)       AND 
                         vr.recipe_id                   = gr.recipe_id    AND
                         vr.start_date                 <= sysdate         AND
                         vr.end_date                   is NULL            AND           
                         /**** performance ****/
                         gr.recipe_id                 = (select max(gr1.recipe_id)
                                                           FROM apps.gmd_recipes_b gr1,
                                                                apps.gmd_recipe_validity_rules vr1
                                                          WHERE /**** Performance ****/
                                                                vr1.delete_mark           = 0                  AND
                                                                --vr1.preference            = 1                  AND      
                                                                vr1.recipe_use            = 2 /*Custos*/      AND
                                                                vr1.validity_rule_status in (700,900)          AND
                                                                vr1.start_date           <= sysdate            AND
                                                                vr1.end_date             is null               AND
                                                                vr1.organization_id       = fm.organization_id AND
                                                                vr1.recipe_id             = gr1.recipe_id      AND
                                                                /**** Performance ****/
                                                                gr1.recipe_status        in (700,900)          AND
                                                                gr1.formula_id            = fm.formula_id) AND
                         gr.recipe_status        IN (700, 900)            AND
                         gr.formula_id            = fm.formula_id         AND
                         fm.inventory_item_id     = msi.inventory_item_id       AND
                         fm.line_type             = 1                           AND
                         msi.inventory_item_id    = fm.inventory_item_id        AND
                         msi.organization_id      = fm.organization_id          AND
                         msi.organization_id      = 92         AND
                        -- msi.segment1            in ('D800.10',
                        --                             'D800.11')
--                         
                         msi.segment1            in ('NIBD-00002.51',
                                                     'NIBD-00002.22')
                  UNION ALL
                  -- Parte RECURSIVA
--
                  SELECT c.segment1,
                         fmdi.inventory_item_id,
                         CASE
                            WHEN fmdi.scale_type = 0 THEN
                               (((fmdi.qty / fmi.qty) / vri.std_qty) * c.qty)
--                               
                            WHEN fmdi.scale_type = 1 or vri.std_qty <= 1 THEN
                               (fmdi.qty / fmi.qty) * c.qty
--                               
                            WHEN fmdi.scale_type = 2 AND trunc(((fmdi.qty / fmi.qty) * vri.std_qty),0) <> ((fmdi.qty / fmi.qty) * vri.std_qty) AND fmdi.rounding_direction = 1 THEN
                              (((TRUNC(((fmdi.qty / fmi.qty) * vri.std_qty),0)) + 1) / vri.std_qty) * c.qty
--                            
                            WHEN fmdi.scale_type = 2 AND trunc(((fmdi.qty / fmi.qty) * vri.std_qty),0) <> ((fmdi.qty / fmi.qty) * vri.std_qty) AND fmdi.rounding_direction = 2 THEN
                               ((TRUNC(((fmdi.qty / fmi.qty) * vri.std_qty),0)) / vri.std_qty) * c.qty
--                               
                            WHEN fmdi.scale_type = 2 AND trunc(((fmdi.qty / fmi.qty) * vri.std_qty),0) <> ((fmdi.qty / fmi.qty) * vri.std_qty) AND fmdi.rounding_direction = 0 THEN
                                ((ROUND(((fmdi.qty / fmi.qty) * vri.std_qty),0)) / vri.std_qty) * c.qty
                            ELSE
                               (fmdi.qty / fmi.qty) * c.qty
                         END qty,
                         c.nivel + 1,
                         fmsi.formula_id,
                         gri.recipe_id,
                         c.top_formula,
                         fmsi.formula_no,
                         gri.recipe_no,
                         DECODE (fmdi.line_type, 1, 'Produto', 'Ingrediente') tipo_linha,
                         vri.planned_process_loss,
--                         
                         CASE
                            WHEN fmdi.contribute_yield_ind = 'Y' THEN
                                 c.planned_process_loss_perda * ((100 - nvl(vri.planned_process_loss,0)) / 100)
                            ELSE c.planned_process_loss_perda
                         END planned_process_loss_perda, --ajl
--                         
                         c.planned_process_loss_rout * ((100 - nvl(vri.planned_process_loss,0)) / 100) planned_process_loss_rout,
--                         
                         CASE
                            WHEN fmdi.contribute_yield_ind = 'Y' THEN
                               (((100 - nvl(c.planned_process_loss, 0)) / 100) * planeed_loss_ant) 
                            ELSE 
                               1
                         END planeed_loss_ant,
--                         
                         fmdi.line_no,
                         fmdi.contribute_yield_ind,
                         fmdi.line_type
--                         
                    FROM apps.fm_form_mst_b fmsi
--                    
                    JOIN apps.fm_matl_dtl fmi
                            ON nvl(fmsi.formula_class,'SC') <> 'TING-PMC' AND
                               fmsi.formula_id = fmi.formula_id           --AND
--                               
                         --
                    JOIN apps.gmd_recipes_b gri
                            ON gri.recipe_status IN (700, 900) AND
                               gri.recipe_id = (select max(gr1.recipe_id)
                                                  FROM apps.gmd_recipes_b gr1,
                                                       apps.gmd_recipe_validity_rules vr1
                                                 WHERE vr1.delete_mark                 = 0                   AND
                                                       --vr1.preference                  = 1                   AND      
                                                       vr1.recipe_use                  = 2 /*Custos*/       AND
                                                       vr1.validity_rule_status       in (700,900)           AND
                                                       vr1.start_date                 <= sysdate             AND
                                                       vr1.end_date                   is NULL                AND
                                                       vr1.organization_id             = fmi.organization_id AND
                                                       vr1.recipe_id                   = gr1.recipe_id       AND
                                                       gr1.recipe_status              in (700,900)           AND
                                                       gr1.formula_id                  = fmi.formula_id) 
--                                               
                    JOIN apps.gmd_recipe_validity_rules vri
                            on /**** performance ****/
                               --vri.preference                  = 1                   AND      
                               vri.recipe_validity_rule_id    in (SELECT MAX(vr1.recipe_validity_rule_id)
                                                                    FROM apps.gmd_recipe_validity_rules vr1
                                                                   WHERE vr1.delete_mark           = 0                  AND
                                                                         vr1.recipe_use            = 2 /*Custos*/       AND
                                                                         vr1.validity_rule_status in (700,900)          AND
                                                                         vr1.start_date           <= sysdate            AND
                                                                         vr1.end_date             is null               AND
                                                                         vr1.organization_id       = fmi.organization_id AND
                                                                         vr1.recipe_id             = gri.recipe_id) AND
                               vri.delete_mark                 = 0                   AND
                               vri.recipe_use                  = 2                   AND --Custos 
                               vri.validity_rule_status       in (700,900)           AND 
                               vri.start_date                 <= sysdate             AND
                               NVL(vri.end_date,(SYSDATE + 1)) > sysdate             AND
                               vri.organization_id             = fmi.organization_id AND           
                               vri.recipe_id                   = gri.recipe_id
                               /**** performance ****/
--                    
                    JOIN apps.fm_matl_dtl fmdi
                            ON --fmdi.line_type           = -1                    AND
                               fmdi .formula_id     = fmi.formula_id AND
                               fmdi.formula_id      = gri.formula_id AND
                               fmdi.organization_id = fmi.organization_id
--                         
                    JOIN apps.mtl_system_items_b msii
                            ON fmi.inventory_item_id  = msii.inventory_item_id AND
                               fmi.line_type          = 1                      AND
                               msii.inventory_item_id = fmi.inventory_item_id  AND
                               msii.organization_id   = fmi.organization_id
                    JOIN cteMenuNivel c
                            ON msii.inventory_item_id = c.inventory_item_id AND
                               c.line_type = -1 and
                               c.nivel < 20)             -- OSM 25/05/2016
                    --
                    CYCLE inventory_item_id SET is_cycle TO '1' DEFAULT '0' -- OSM 30/04/2016
           --
           SELECT c.segment1,
                  c.inventory_item_id,
                  msib.segment1,
                  msib.description,
                  msib.primary_uom_code,
                  (SELECT REPLACE (fl.meaning, '%', 'pp')
                     FROM apps.FND_LOOKUPS fl
                    WHERE lookup_type                        = 'JLBR_ITEM_ORIGIN' AND
                          NVL (end_date_active, SYSDATE + 1) > SYSDATE            AND
                          fl.lookup_code                     = msib.GLOBAL_ATTRIBUTE3) ORIGEM,
                  c.qty,
                  c.Nivel,
                  c.formula_id,
                  c.recipe_id,
                  cat.segment1 item_type,
                  c.top_formula,
                  c.formula_no,
                  c.recipe_no,
                  c.tipo_linha,
                  c.line_no,
                  c.contribute_yield_ind,
                  DECODE (c.tipo_linha,
                         'Produto', DECODE (c.planned_process_loss,
                                            0, NULL,
                                            c.planned_process_loss),
                          NULL) perda,
                  --
                  nvl(c.planned_process_loss_perda,0) perda2,
                  nvl(c.planned_process_loss_rout,0)  perda3,
                  c.planeed_loss_ant                  perda_ant,
--                  
                  CASE WHEN 1 = (SELECT 1
                                   FROM cteMenuNivel c1
                                  WHERE c1.inventory_item_id = c.inventory_item_id AND
                                        c1.tipo_linha        = 'Produto' AND
                                        ROWNUM = 1) THEN
                       0
                       ELSE                    
--                  
                          NVL (
                             (SELECT ROUND (SUM (gcd.cmpnt_cost), 11) custo
                                FROM gmf.cm_cmpt_dtl gcd,
                                     gmf_period_statuses gps
                               WHERE gcd.period_id = gps.period_id AND
                                     gps.calendar_code           = 'PPG_2016'      AND
                                     gcd.period_id               = 242          AND
                                     gps.cost_type_id            = 1005       AND
                                    -- msib.planning_make_buy_code = 2                  AND
                                     gcd.delete_mark             = '0'                    AND
                                     gcd.inventory_item_id       = msib.inventory_item_id AND
                                     gcd.organization_id         = msib.organization_id), 0)
                  END custo,
--                             
                  CASE WHEN global_attribute3 IN (1, 2, 6, 7) THEN --
                            'I'
                       WHEN global_attribute3 = 0 THEN --
                            'N'
                       ELSE
                            'INDEF.' --
                  END flag_imported_item,
                  msib.global_attribute3,
                  msib.global_attribute4
             FROM cteMenuNivel c,
                  apps.mtl_system_items_b msib,
                  (SELECT mic.organization_id,
                          mic.inventory_item_id,
                          mcb.segment1,
                          mcst.category_set_name
                     FROM mtl_item_categories mic,
                          mtl_category_sets_tl mcst,
                          mtl_category_sets_b mcs,
                          mtl_categories_b mcb
                    WHERE mic.category_set_id = mcs.category_set_id  AND
                          mcs.category_set_id = mcst.category_set_id AND
                          mcst.language       = 'US'                 AND
                          mic.category_id     = mcb.category_id) cat
            WHERE msib.inventory_item_id = c.inventory_item_id   AND
                  msib.organization_id   = 92   AND
                  msib.inventory_item_id = cat.inventory_item_id AND
                  msib.organization_id   = cat.organization_id   AND
                  cat.category_set_name IN ('Inventory', 'Inventario')
         ORDER BY c.top_formula,
                  c.Nivel,
                  c.formula_no,
                  c.tipo_linha DESC,
                  c.line_no;