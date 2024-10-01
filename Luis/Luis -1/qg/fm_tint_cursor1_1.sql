    SELECT itm.segment1,
           gr.recipe_id,
            (SELECT sum((SELECT SUM(cst.CMPNT_COST) 
                                FROM apps.CM_CMPT_DTL cst
                               WHERE cst.delete_mark       = '0'
                                 AND cst.organization_id   = fmdx.organization_id
                                 AND cst.inventory_item_id = msix.inventory_item_id
                                 AND cst.cost_type_id      = '1005'
                                 AND cst.period_id         = (SELECT MAX(cstt.period_id)
                                                                FROM apps.CM_CMPT_DTL cstt, apps.gmf_period_statuses gps
                                                               WHERE TRUNC(gps.start_date) <= TRUNC(sysdate)  AND
                                                                     gps.cost_type_id       = cstt.cost_type_id     AND
                                                                     cstt.period_id         = gps.period_id         AND
                                                                     cstt.delete_mark       = '0'                   AND
                                                                     cstt.organization_id   = cst.organization_id   AND
                                                                     cstt.inventory_item_id = cst.inventory_item_id AND
                                                                     cstt.cost_type_id      = '1005'                AND
                                                                     cmpnt_cost       <> 0)) * fmdx.qty) custo
        --
              FROM apps.fm_matl_dtl fmx,
                   apps.fm_matl_dtl fmdx,
                   apps.gmd_recipes grx,
                   apps.mtl_system_items_b itmx,
                   apps.mtl_system_items_b msix
             WHERE fmdx.line_type            = -1                     AND           
                   fmdx.formula_id           = fmx.formula_id         AND
                   fmdx.organization_id      = fmx.organization_id    AND
                   grx.recipe_status         in (700,900)             AND
                   grx.formula_id            = fmx.formula_id         AND
                   fmx.inventory_item_id     = itmx.inventory_item_id AND
                   fmx.line_type             = 1                      AND
                   msix.inventory_item_id    = fmdx.inventory_item_id AND
                   msix.organization_id      = fmdx.organization_id   AND
                   itmx.inventory_item_id    = fmx.inventory_item_id  AND
                   itmx.organization_id      = fmx.organization_id    AND
                   grx.owner_organization_id = fmx.organization_id    AND
                   fmx.organization_id       = 92                     AND
                   fmx.formula_id            = fm.formula_id) /
          (SELECT sum((SELECT SUM(cst.CMPNT_COST) 
                                FROM apps.CM_CMPT_DTL cst
                               WHERE cst.delete_mark       = '0'
                                 AND cst.organization_id   = fmdx.organization_id
                                 AND cst.inventory_item_id = msix.inventory_item_id
                                 AND cst.cost_type_id      = '1005'
                                 AND cst.period_id         = (SELECT MAX(cstt.period_id)
                                                                FROM apps.CM_CMPT_DTL cstt, apps.gmf_period_statuses gps
                                                               WHERE TRUNC(gps.start_date) <= TRUNC(sysdate)  AND
                                                                     gps.cost_type_id       = cstt.cost_type_id     AND
                                                                     cstt.period_id         = gps.period_id         AND
                                                                     cstt.delete_mark       = '0'                   AND
                                                                     cstt.organization_id   = cst.organization_id   AND
                                                                     cstt.inventory_item_id = cst.inventory_item_id AND
                                                                     cstt.cost_type_id      = '1005'                AND
                                                                     cmpnt_cost       <> 0))* fmdx.qty) custo
        --
              FROM apps.fm_matl_dtl fmx,
                   apps.fm_matl_dtl fmdx,
                   apps.gmd_recipes grx,
                   apps.mtl_system_items_b itmx,
                   apps.mtl_system_items_b msix
             WHERE fmdx.line_type            = -1                     AND           
                   fmdx.formula_id           = fmx.formula_id         AND
                   fmdx.organization_id      = fmx.organization_id    AND
                   grx.recipe_status         in (700,900)             AND
                   grx.formula_id            = fmx.formula_id         AND
                   fmx.inventory_item_id     = itmx.inventory_item_id AND
                   fmx.line_type             = 1                      AND
                   msix.inventory_item_id    = fmdx.inventory_item_id AND
                   msix.organization_id      = fmdx.organization_id   AND
                   itmx.inventory_item_id    = fmx.inventory_item_id  AND
                   itmx.organization_id      = fmx.organization_id    AND
                   grx.owner_organization_id = fmx.organization_id    AND
                   fmx.organization_id       = 92                     AND
                   msix.primary_uom_code     = 'un' and
                   fmx.formula_id            = fm.formula_id) fator,
       (SELECT sum((SELECT SUM(cst.CMPNT_COST) 
                                FROM apps.CM_CMPT_DTL cst
                               WHERE cst.delete_mark       = '0'
                                 AND cst.organization_id   = fmdx.organization_id
                                 AND cst.inventory_item_id = msix.inventory_item_id
                                 AND cst.cost_type_id      = '1005'
                                 AND cst.period_id         = (SELECT MAX(cstt.period_id)
                                                                FROM apps.CM_CMPT_DTL cstt, apps.gmf_period_statuses gps
                                                               WHERE TRUNC(gps.start_date) <= TRUNC(sysdate)  AND
                                                                     gps.cost_type_id       = cstt.cost_type_id     AND
                                                                     cstt.period_id         = gps.period_id         AND
                                                                     cstt.delete_mark       = '0'                   AND
                                                                     cstt.organization_id   = cst.organization_id   AND
                                                                     cstt.inventory_item_id = cst.inventory_item_id AND
                                                                     cstt.cost_type_id      = '1005'                AND
                                                                     cmpnt_cost       <> 0)) * fmdx.qty) custo
        --
              FROM apps.fm_matl_dtl fmx,
                   apps.fm_matl_dtl fmdx,
                   apps.gmd_recipes grx,
                   apps.mtl_system_items_b itmx,
                   apps.mtl_system_items_b msix
             WHERE fmdx.line_type            = -1                     AND           
                   fmdx.formula_id           = fmx.formula_id         AND
                   fmdx.organization_id      = fmx.organization_id    AND
                   grx.recipe_status         in (700,900)             AND
                   grx.formula_id            = fmx.formula_id         AND
                   fmx.inventory_item_id     = itmx.inventory_item_id AND
                   fmx.line_type             = 1                      AND
                   msix.inventory_item_id    = fmdx.inventory_item_id AND
                   msix.organization_id      = fmdx.organization_id   AND
                   itmx.inventory_item_id    = fmx.inventory_item_id  AND
                   itmx.organization_id      = fmx.organization_id    AND
                   grx.owner_organization_id = fmx.organization_id    AND
                   fmx.organization_id       = 92                     AND
                   fmx.formula_id            = fm.formula_id) custo_total,
       (SELECT sum((SELECT SUM(cst.CMPNT_COST) 
                                FROM apps.CM_CMPT_DTL cst
                               WHERE cst.delete_mark       = '0'
                                 AND cst.organization_id   = fmdx.organization_id
                                 AND cst.inventory_item_id = msix.inventory_item_id
                                 AND cst.cost_type_id      = '1005'
                                 AND cst.period_id         = (SELECT MAX(cstt.period_id)
                                                                FROM apps.CM_CMPT_DTL cstt, apps.gmf_period_statuses gps
                                                               WHERE TRUNC(gps.start_date) <= TRUNC(sysdate)  AND
                                                                     gps.cost_type_id       = cstt.cost_type_id     AND
                                                                     cstt.period_id         = gps.period_id         AND
                                                                     cstt.delete_mark       = '0'                   AND
                                                                     cstt.organization_id   = cst.organization_id   AND
                                                                     cstt.inventory_item_id = cst.inventory_item_id AND
                                                                     cstt.cost_type_id      = '1005'                AND
                                                                     cmpnt_cost       <> 0))* fmdx.qty) custo
        --
              FROM apps.fm_matl_dtl fmx,
                   apps.fm_matl_dtl fmdx,
                   apps.gmd_recipes grx,
                   apps.mtl_system_items_b itmx,
                   apps.mtl_system_items_b msix
             WHERE fmdx.line_type            = -1                     AND           
                   fmdx.formula_id           = fmx.formula_id         AND
                   fmdx.organization_id      = fmx.organization_id    AND
                   grx.recipe_status         in (700,900)             AND
                   grx.formula_id            = fmx.formula_id         AND
                   fmx.inventory_item_id     = itmx.inventory_item_id AND
                   fmx.line_type             = 1                      AND
                   msix.inventory_item_id    = fmdx.inventory_item_id AND
                   msix.organization_id      = fmdx.organization_id   AND
                   itmx.inventory_item_id    = fmx.inventory_item_id  AND
                   itmx.organization_id      = fmx.organization_id    AND
                   grx.owner_organization_id = fmx.organization_id    AND
                   fmx.organization_id       = 92                     AND
                   msix.primary_uom_code     = 'un' and
                   fmx.formula_id            = fm.formula_id) custo_base               
      FROM apps.fm_form_mst fms,
           apps.fm_matl_dtl fm,
           apps.gmd_recipes gr,
           apps.gmd_recipe_validity_rules vr,
           apps.mtl_system_items_b itm
     WHERE fms.formula_class        = 'TING-PMC'            AND
           fms.formula_id           = fm.formula_id         AND
           vr.recipe_use            = 0                     AND 
           vr.validity_rule_status in (700,900)             AND 
           vr.recipe_id             = gr.recipe_id          AND
           gr.recipe_status        in (700,900)             AND
           gr.formula_id            = fm.formula_id         AND
           fm.inventory_item_id     = itm.inventory_item_id AND
           fm.line_type             = 1                     AND
           itm.inventory_item_id    = fm.inventory_item_id  AND
           itm.organization_id      = fm.organization_id;