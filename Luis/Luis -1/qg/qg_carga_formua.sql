---- formula -----
select fm.formula_no, 
       fm.formula_vers,
       fm.formula_desc1,
       fm.formula_class,
       'PIN',
       fd.line_type,
       fd.line_no,
       msi.segment1,
       fd.qty,
       fd.RELEASE_TYPE,
       fd.SCALE_TYPE,
       fd.SCALE_MULTIPLE,
       fd.ROUNDING_DIRECTION,
       fd.SCRAP_FACTOR,
       fd.PHANTOM_TYPE,
       fd.CONTRIBUTE_STEP_QTY_IND,
       fd.CONTRIBUTE_YIELD_IND,
       fd.*       
  from apps.fm_form_mst fm,
       apps.gmd_recipes gr,
       apps.fm_matl_dtl fd,
       apps.mtl_system_items_b msi
 where fm.owner_organization_id = 182          and
       fm.FORMULA_STATUS in (700,900)          and
       gr.formula_id           = fm.formula_id and
       gr.recipe_status in  (700,900)          and
       fd.formula_id           = fm.formula_id and
       msi.organization_id     = 182           and
       msi.inventory_item_id   = fd.inventory_item_id;

--------Receita ------------
select gr.recipe_no,
       gr.recipe_version,
       fm.formula_no, 
       fm.formula_vers,
       fm.formula_desc1,
       fm.formula_class,
       'PIN',
       fd.line_type,
       msi.segment1,
       msi.primary_uom_code,
       fd.qty,
       fd.RELEASE_TYPE,
       fd.SCALE_TYPE,
       fd.SCALE_MULTIPLE,
       fd.ROUNDING_DIRECTION,
       fd.SCRAP_FACTOR,
       fd.PHANTOM_TYPE,
       fd.CONTRIBUTE_STEP_QTY_IND,
       fd.CONTRIBUTE_YIELD_IND,
       rot.ROUTING_NO       
  from apps.fm_form_mst fm,
       apps.gmd_recipes gr,
       apps.fm_matl_dtl fd,
       apps.mtl_system_items_b msi,
       apps.gmd_routings rot,
       apps.GMD_RECIPE_STEP_MATERIALS  GRS
 where fm.owner_organization_id = 182          and
       fm.FORMULA_STATUS in (700,900)          and
       gr.formula_id           = fm.formula_id and
       gr.recipe_status in  (700,900)          and
       fd.formula_id           = fm.formula_id and
       fd.line_type            = 1             and
       msi.organization_id     = 182           and
       msi.inventory_item_id   = fd.inventory_item_id and
       rot.routing_id          = gr.routing_id        and
       grs.formulaline_id      = fd.formulaline_id;

---------- Regra de Validade

--------Receita ------------
select gr.recipe_no,
       gr.recipe_version,
       fm.formula_no, 
       fm.formula_vers,
       fm.formula_desc1,
       fm.formula_class,
       'AMB',
       fd.line_type,
       msi.segment1,
       msi.primary_uom_code,
       fd.qty,
       fd.RELEASE_TYPE,
       fd.SCALE_TYPE,
       fd.SCALE_MULTIPLE,
       fd.ROUNDING_DIRECTION,
       fd.SCRAP_FACTOR,
       fd.PHANTOM_TYPE,
       fd.CONTRIBUTE_STEP_QTY_IND,
       fd.CONTRIBUTE_YIELD_IND,
       rot.ROUTING_NO,
       rv.*
  from apps.fm_form_mst fm,
       apps.gmd_recipes gr,
       apps.fm_matl_dtl fd,
       apps.mtl_system_items_b msi,
       apps.gmd_routings rot,
       apps.GMD_RECIPE_STEP_MATERIALS  GRS,
       apps.gmd_recipe_validity_rules rv
 where fm.owner_organization_id = 181          and
       fm.FORMULA_STATUS in (700,900)          and
       gr.formula_id           = fm.formula_id and
       gr.recipe_status in  (700,900)          and
       rv.recipe_id            = gr.recipe_id  and
       fd.formula_id           = fm.formula_id and
       fd.line_type            = 1             and
       msi.organization_id     = 181           and
       msi.inventory_item_id   = fd.inventory_item_id and
       rot.routing_id          = gr.routing_id        and
       grs.formulaline_id      = fd.formulaline_id;



------ step material
select gr.recipe_no,
       gr.recipe_version,
       fm.formula_no, 
       fm.formula_vers,
       fm.formula_desc1,
       fm.formula_class,
       'PIN',
       fd.line_type,
       fd.line_no,
       msi.segment1,
       msi.primary_uom_code,
       fd.qty,
       fd.RELEASE_TYPE,
       fd.SCALE_TYPE,
       fd.SCALE_MULTIPLE,
       fd.ROUNDING_DIRECTION,
       fd.SCRAP_FACTOR,
       fd.PHANTOM_TYPE,
       fd.CONTRIBUTE_STEP_QTY_IND,
       fd.CONTRIBUTE_YIELD_IND,
       rot.ROUTING_NO ,
       fr.routingstep_no      
  from apps.fm_form_mst fm,
       apps.gmd_recipes gr,
       apps.fm_matl_dtl fd,
       apps.mtl_system_items_b msi,
       apps.gmd_routings rot,
       apps.GMD_RECIPE_STEP_MATERIALS  GRS,
       apps.FM_ROUT_DTL fr 
 where fm.owner_organization_id = 182          and
       fm.FORMULA_STATUS in (700,900)          and
       gr.formula_id           = fm.formula_id and
       gr.recipe_status in  (700,900)          and
       fd.formula_id           = fm.formula_id and
       --fd.line_type            = 1             and
       msi.organization_id     = 182           and
       msi.inventory_item_id   = fd.inventory_item_id and
       rot.routing_id          = gr.routing_id        and
       grs.formulaline_id      = fd.formulaline_id    and
       fr.routing_id           = gr.routing_id        and
       fr.routingstep_id       = grs.routingstep_id;
       
select * from apps.FM_ROUT_DTL        



--------Receita ------------
select gr.recipe_no,
       gr.recipe_version,
       fm.formula_no, 
       fm.formula_vers,
       fm.formula_desc1,
       fm.formula_class,
       'AMB',
       fd.line_type,
       msi.segment1,
       msi.primary_uom_code,
       fd.qty,
       fd.RELEASE_TYPE,
       fd.SCALE_TYPE,
       fd.SCALE_MULTIPLE,
       fd.ROUNDING_DIRECTION,
       fd.SCRAP_FACTOR,
       fd.PHANTOM_TYPE,
       fd.CONTRIBUTE_STEP_QTY_IND,
       fd.CONTRIBUTE_YIELD_IND,
       rot.ROUTING_NO       
  from apps.fm_form_mst fm,
       apps.gmd_recipes gr,
       apps.fm_matl_dtl fd,
       apps.mtl_system_items_b msi,
       apps.gmd_routings rot,
       apps.GMD_RECIPE_STEP_MATERIALS  GRS
 where fm.owner_organization_id = 181          and
       fm.FORMULA_STATUS in (700,900)          and
       gr.formula_id           = fm.formula_id and
       gr.recipe_status in  (700,900)          and
       fd.formula_id           = fm.formula_id and
       fd.line_type            = 1             and
       msi.organization_id     = 181           and
       msi.inventory_item_id   = fd.inventory_item_id and
       rot.routing_id          = gr.routing_id        and
       grs.formulaline_id      = fd.formulaline_id;






select * from apps.GMD_RECIPE_STEP_MATERIALS ;


select * from apps.gmd_routings;