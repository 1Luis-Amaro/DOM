select * from gmd_recipes where owner_organization_id = 181 and trunc(creation_date) = trunc(sysdate);

select * from apps.fm_rout_hdr where OWNER_ORGANIZATION_ID = 181;

select fd.formula_id, 
       formula_no,
       formula_vers, 
       line_type, 
       line_no, 
       msi.segment1,
       msi.description,
       qty
  from apps.fm_form_mst fm,
       apps.FM_MATL_DTL fd,
       apps.mtl_system_items_b msi
  where owner_organization_id = 182 and
        fm.formula_id = fd.formula_id and 
        msi.organization_id = 182 and
        msi.inventory_item_id = fd.inventory_item_id ;

select * from fm_material_dtl;

select msi.segment1, gr.recipe_no, recipe_use, min_qty, max_qty, std_qty, grv.* 
  from gmd_recipe_validity_rules grv,
       gmd_recipes               gr,
       mtl_system_items_b        msi
 where grv.orgn_code = 'AMB' and
       gr.recipe_id  = grv.recipe_id and
       msi.inventory_item_id = grv.inventory_item_id and
       msi.organization_id   = 181;