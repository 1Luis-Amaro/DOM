SELECT frd.routingstep_no
       , msi.segment1
       , md.plan_qty
       , grs.attribute1
       , goa.activity
       , gbh.batch_id
    FROM fm_rout_hdr frh
       , fm_rout_dtl frd
       , gmd_operations_b gob
       , gmd_operation_activities goa
       , gmd_recipes grr
       , gme_batch_header gbh
       , gmd_recipe_step_materials grs
       , gmd_recipe_validity_rules grv
       , gme_material_details md
       , fm_matl_dtl          fmd
       , mtl_system_items_b   msi
       , gme_material_details mdp
       , mtl_system_items_b   msip
   WHERE 1 = 1
     AND frh.routing_id         = frd.routing_id
     AND gob.oprn_id            = frd.oprn_id
     AND goa.oprn_id            = gob.oprn_id
     AND grr.recipe_id          = grs.recipe_id
     AND frh.routing_id         = grr.routing_id
     AND grs.routingstep_id     = frd.routingstep_id
     AND gbh.routing_id         = frh.routing_id
     AND grv.recipe_validity_rule_id = gbh.recipe_validity_rule_id
     AND grr.recipe_id          = grv.recipe_id
     AND fmd.formula_id         = grr.formula_id
     AND grs.formulaline_id     = fmd.formulaline_id
     AND msi.inventory_item_id  = fmd.inventory_item_id
     AND msi.organization_id    = fmd.organization_id
     AND md.batch_id            = gbh.batch_id
     AND md.formulaline_id      = fmd.formulaline_id
     AND gbh.batch_no           = 104
     AND mdp.batch_id           = gbh.batch_id
     AND mdp.line_type          = 1
     AND msip.inventory_item_id = mdp.inventory_item_id
     AND msip.organization_id   = mdp.organization_id
     AND   xxppg_inv_oper_preactor_pkg.get_category_segment(msip.inventory_item_id,msip.organization_id) <> 'ACA'
     
ORDER BY frd.routingstep_no;
