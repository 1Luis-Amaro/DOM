select * from apps.fm_matl_dtl;

select * from apps.fm_form_mst fms;

select * from gmd_recipes;

select * from gmd_recipe_customers;

select mp.* from apps.mtl_system_items_b msi join apps.mtl_parameters mp on mp.organization_id = msi.organization_id ;


    SELECT fmd.inventory_item_id,
           fmd.qty,
           0 as Nivel
      FROM apps.fm_matl_dtl        fmd,
           apps.fm_form_mst        fms,
           apps.fm_matl_dtl        fm,
           apps.mtl_system_items_b itm
     WHERE fmd.line_type          = -1                    AND           
           fmd.formula_id         = fm.formula_id         AND
           fmd.organization_id    = fm.organization_id    AND
           
           fms.formula_status    in (700,900)             AND
           fms.formula_class     <> 'TING-PMC'            AND
           fms.formula_id         = fm.formula_id         AND
           
           fm.line_type           = 1                     AND
           fm.organization_id     = itm.organization_id   AND
           fm.inventory_item_id   = itm.inventory_item_id AND
           
           itm.segment1           = 'C190-0950.04';







    SELECT fms.*
           /*fmd.inventory_item_id,
           fmd.qty,
           1 as Nivel*/
      FROM apps.fm_form_mst fms,
           apps.fm_matl_dtl fm,
           apps.fm_matl_dtl fmd,
           apps.mtl_system_items_b itm
     WHERE fms.formula_class     <> 'TING-PMC'            AND
           fms.formula_id         = fm.formula_id         AND
           fmd.line_type          = -1                    AND
           fmd.formula_id         = fm.formula_id         AND
           fmd.organization_id    = fm.organization_id    AND
           fm.inventory_item_id   = itm.inventory_item_id AND
           fm.line_type           = 1                     AND
           itm.inventory_item_id  = fm.inventory_item_id  AND
           itm.organization_id    = fm.organization_id    AND
           itm.segment1 = 'C190-0950.04'