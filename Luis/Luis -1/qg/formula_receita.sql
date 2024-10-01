SELECT * from apps.XXPPG_CERTANALI_EMAIL


xxppg_1075_util_function

select * from apps.xxppg_1075_util_function;

select * from apps.mtl_system_items_b where organization_id =  87 and segment1 = 'SRC-75';

SELECT INVENTORY_ITEM_FLAG from apps.mtl_system_items_b where organization_id = 87 and segment1 = 'SRC-75';inventory_item_id = :lines.item_id;

select formula_no,
       formula_vers,
       recipe_no,
       recipe_version,
       frh.routing_no,
       grv.recipe_use,
       fd.line_type,
       fd.line_no,
       msi.segment1,
       fd.qty,
       release_type,
       fd.scale_type,
       fd.rounding_direction,
       fd.scale_multiple,
       fd.cost_alloc,
       fd.contribute_yield_ind
  from apps.fm_form_mst fm,
       apps.fm_matl_dtl fd,
       apps.mtl_system_items_b msi,
       apps.gmd_recipes gr,
       apps.gmd_recipe_validity_rules grv,
       apps.fm_rout_hdr               frh
 where fm.owner_organization_id  = 181                  and
       fm.formula_status        in (700,900)            and
       gr.formula_id             = fm.formula_id        and
       gr.recipe_status         in (700,900)            and
       grv.recipe_id             = gr.recipe_id         and
       grv.VALIDITY_RULE_STATUS in (700,900)            and
       grv.recipe_use            = 0                    and
       fd.formula_id             = fm.formula_id        and
       msi.inventory_item_id     = fd.inventory_item_id and
       msi.organization_id       = 181                  and
       frh.routing_id            = gr.routing_id;