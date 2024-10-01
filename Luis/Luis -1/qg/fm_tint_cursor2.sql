    SELECT msi.segment1,
           msi.primary_uom_code, 
           itm.segment1,
           msi.description,
           fmd.qty,
           (SELECT SUM(cst.CMPNT_COST) FROM apps.CM_CMPT_DTL cst
                       WHERE cst.delete_mark       = '0'
                         AND cst.organization_id   = fmd.organization_id
                         AND cst.inventory_item_id = msi.inventory_item_id
                         AND cst.cost_type_id      = '1005'
                         AND cst.period_id         = (SELECT MAX(cstt.period_id)
                                                        FROM apps.CM_CMPT_DTL cstt, apps.gmf_period_statuses gps
                                                       WHERE TRUNC(gps.start_date) <= TRUNC(sysdate) AND
                                                             --TRUNC(gps.start_date) <= TRUNC(TO_DATE('2018-02-28','rrrr/mm/dd hh24:mi:ss'))  AND
                                                             gps.cost_type_id       = cstt.cost_type_id     AND
                                                             cstt.period_id         = gps.period_id         AND
                                                             cstt.delete_mark       = '0'                   AND
                                                             cstt.organization_id   = cst.organization_id   AND
                                                             cstt.inventory_item_id = cst.inventory_item_id AND
                                                             cstt.cost_type_id      = '1005'                AND
                                                             cmpnt_cost       <> 0)) custo8
--
      FROM apps.fm_matl_dtl fm,
           apps.fm_matl_dtl fmd,
           apps.gmd_recipes gr,
           apps.mtl_system_items_b itm,
           apps.mtl_system_items_b msi
     WHERE fmd.line_type           = -1                   AND           
           fmd.formula_id          = fm.formula_id        AND
           fmd.organization_id     = fm.organization_id   AND
           --vr.preference           = 1                    AND      
           gr.recipe_status        in (700,900)           AND
           gr.formula_id           = fm.formula_id        AND
 --
           --
           fm.inventory_item_id     = itm.inventory_item_id AND
           fm.line_type             = 1                     AND
           msi.inventory_item_id    = fmd.inventory_item_id and
           msi.organization_id      = fmd.organization_id   and
           itm.inventory_item_id    = fm.inventory_item_id  AND
           itm.organization_id      = fm.organization_id    and
           gr.owner_organization_id = fm.organization_id    and
           fm.organization_id       = 92                    and
           gr.recipe_id = 5043;
           fm.formula_id            = 66232;
           
