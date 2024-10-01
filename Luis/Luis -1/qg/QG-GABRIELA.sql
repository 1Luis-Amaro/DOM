select mp.organization_code  org,
       msi.segment1          produto,
       msi.SHELF_LIFE_DAYS   Validade_ACA,
       msii.segment1         ingrediente,
       msii.SHELF_LIFE_DAYS  Validade_Semi
  from apps.mtl_system_items_b msi,
       apps.fm_matl_dtl        fd,
       apps.mtl_system_items_b msii,
       apps.fm_matl_dtl        fdi,
       apps.gmd_recipes        gr,
       apps.mtl_parameters     mp
 where msi.item_type                  = 'ACA'                 AND
       msi.organization_id            = 86                    AND
       msi.inventory_item_status_code = 'Active'              AND
       msii.item_type                in ('SEMI','INT')        AND
       mp.organization_id             = msi.organization_id   AND
       fd.organization_id             = msi.organization_id   AND
       fd.inventory_item_id           = msi.inventory_item_id AND
       fd.line_type                   = 1                     AND
       fdi.formula_id                 = fd.formula_id         AND
       fdi.line_type                  = -1                    AND
       msii.inventory_item_id         = fdi.inventory_item_id AND
       gr.recipe_id                 = (SELECT MAX(gr1.recipe_id)
                                             FROM   apps.gmd_recipes_b             gr1
                                                   ,apps.gmd_recipe_validity_rules vr1
                                                   ,apps.fm_matl_dtl               fmd1
                                             WHERE  vr1.delete_mark         = 0
                                             AND    vr1.recipe_use          = 2
                                             AND    vr1.validity_rule_status IN (700, 900)
                                             AND    vr1.start_date          <= SYSDATE
                                             AND    vr1.end_date            IS NULL
                                            -- AND    vr1.organization_id     in (86,90,92,181,182)
                                             AND    vr1.recipe_id           = gr1.recipe_id
                                             AND    gr1.recipe_status IN (700, 900)
                                             AND    fmd1.line_type          = 1
                                             AND    fmd1.inventory_item_id  = msi.inventory_item_id
                                             AND    gr1.formula_id          = fmd1.formula_id) and
--                                                  
           gr.recipe_status            in (700,900)             AND
           gr.formula_id                = fd.formula_id         AND
           msii.organization_id           = msi.organization_id;  and msi.segment1 = 'D800.10';
       
       
select * from apps.fm_matl_dtl   fm_matl_dtl;
       
select msi.segment1
  from apps.mtl_system_items_b msi,
       apps.fm_matl_dtl        fd
 where msi.item_type                  = 'ACA'                 AND
       --msi.inventory_item_status_code = 'Active'              AND
       fd.organization_id             = msi.organization_id   AND
       fd.inventory_item_id           = msi.inventory_item_id AND
       fd.line_type                   = 1                     and msi.segment1 = 'D800.10';
       