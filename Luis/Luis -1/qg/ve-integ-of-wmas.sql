SELECT msib.segment1, Mic.Inventory_Item_Id 
       FROM apps.org_organization_definitions ood
          , apps.hr_all_organization_units    haou      
          , apps.mtl_item_categories          mic
          , apps.mtl_categories_b             mc
          , apps.mtl_category_sets_vl         mcs
          , apps.mtl_system_items_b           msib
          , apps.mtl_parameters               mp
          , apps.cll_f189_fiscal_entities_all cffe
          , apps.hr_locations_all             hla      
          , apps.gme_material_details         gmd -- detalhes da OP
          , apps.gme_batch_header             gbh -- cabeçalho da OP
          , apps.fm_form_mst_vl               fmmv
          , apps.gmd_recipes                  gr
          , apps.gmd_recipe_validity_rules    grvr
          , apps.fm_rout_hdr                  frh
          , apps.fm_rout_dtl                  frd
          , apps.gmf_organization_definitions god 
          , apps.mtl_secondary_inventories    msi
       /*   , ( -- INI Ajuste solicitado por Dalmir Bohn
            SELECT frd.routingstep_no    etapa
                 , frd.routingstep_no    atividade
                 , msi.segment1          item
                 , md.wip_plan_qty       qtde--md.plan_qty    qtde md.plan_qty       qtde
                 , grs.attribute1        repete
                 , gbh.batch_id
                 , msi.inventory_item_id id_item  
                 , md.material_detail_id
             FROM  apps.mtl_system_items_b               msi
                 , apps.gme_material_details             md 
                 , apps.gme_batch_header                 gbh
                 , apps.gmd_recipe_validity_rules        grv 
                 , apps.gme_batch_step_activities        gba
                 , apps.gme_batch_steps                  gbs
                 , apps.gmd_recipes                      grr
                 , apps.gmd_operation_activities         goa  
                 , apps.gme_batch_step_items             grs 
                 , apps.gmd_operations_b                 gob
               --, gmd_recipe_step_materials        grsm
                 , apps.fm_rout_dtl                      frd 
               --, fm_rout_hdr                      frh 
                 , apps.fm_matl_dtl                      fmd
             WHERE 1=1
               AND msi.inventory_item_id            = md.inventory_item_id 
               AND msi.organization_id              = md.organization_id 
               AND  md.batch_id                     = gbh.batch_id 
               AND grv.recipe_validity_rule_id (+)  = gbh.recipe_validity_rule_id
               AND gbh.batch_id                     = gba.batch_id
               AND gbs.batch_id                     = gba.batch_id
               AND gbs.batchstep_id                 = gba.batchstep_id
               AND grr.recipe_id                    = grv.recipe_id
               AND grr.formula_id                   = gbh.formula_id 
               AND grr.routing_id                   = gbh.routing_id
               AND gbs.oprn_id                      = goa.oprn_id
               AND gba.oprn_line_id                 = goa.oprn_line_id
               AND md.material_detail_id            = grs.material_detail_id 
               AND gbh.batch_id                     = grs.batch_id
               AND gbs.batchstep_id                 = grs.batchstep_id
               AND gob.oprn_id                      = gbs.oprn_id
             --AND grsm.recipe_id                   = grv.recipe_id
             --AND grsm.routingstep_id              = gbs.routingstep_id
               AND frd.routing_id                   = grr.routing_id
               AND frd.routingstep_id               = gbs.routingstep_id
               AND frd.oprn_id                      = gbs.oprn_id
             --AND frh.routing_id                   = frd.routing_id 
             --AND fmd.formula_id                   = gbh.formula_id 
             --AND fmd.formulaline_id               = grsm.formulaline_id (+)
             --AND fmd.inventory_item_id            = msi.inventory_item_id 
             --AND fmd.organization_id              = msi.organization_id
               AND md.formulaline_id                = fmd.formulaline_id (+)
               AND md.line_type                     = -1
             --  AND gbh.batch_status                 = 2
              -- AND NVL(md.wip_plan_qty, 0)          > 0    --- #1
             ORDER BY frd.routingstep_no  
          ) xx          
*/
      WHERE --ood.operating_unit              = 92
         haou.organization_id            = 92
        AND mp.organization_id              = 92
        AND haou.organization_id            = 92 
        AND cffe.location_id                = haou.location_id
        AND cffe.entity_type_lookup_code    = 'LOCATION'
        AND hla.location_id                 = haou.location_id
        AND msib.inventory_item_id          = gmd.inventory_item_id    
        AND msib.organization_id            = gmd.organization_id
        AND mc.segment1                     = 'WMAS'
        AND mcs.category_set_name           = 'FAMILIA ARMAZENAGEM'
        AND mic.category_set_id             = mcs.category_set_id
        AND mic.category_id                 = mc.category_id
        AND Msib.Organization_Id            = Mic.Organization_Id   
      --AND xx.id_item                      = Mic.Inventory_Item_Id 
        AND msi.secondary_inventory_name(+) = gmd.subinventory
        AND msi.organization_id         (+) = gmd.organization_id
        and gmd.line_type                   = -1
        AND gmd.batch_id                    = gbh.batch_id
      --AND gmd.material_detail_id          = xx.material_detail_id
        AND gbh.recipe_validity_rule_id     = grvr.recipe_validity_rule_id (+)
        AND gr.recipe_id                (+) = grvr.recipe_id
        AND gr.formula_id                   = fmmv.formula_id              (+)
        AND gr.routing_id                   = frh.routing_id               (+)
        AND gbh.organization_id             = god.organization_id
        AND frd.routing_id              (+) = frh.routing_id
        AND NVL(gmd.attribute15, 'N')       = 'N'
 --       AND xx.batch_id                     = gmd.batch_id
        and gbh.batch_no = 24774 --26288
        --AND gbh.batch_status                = 2
        --AND NVL(xx.qtde, 0)                 > 0         --- #1 
        AND frh.routing_class              IN ( SELECT lookup_code
                                                  FROM apps.fnd_lookup_values
                                                 WHERE lookup_type = 'XPPG_BR_OPM_IFACE_WMAS' );





SELECT frd.routingstep_no    etapa,
 gbs.oprn_id,
frd.*,
 gbs.oprn_id
                 , frd.routingstep_no    atividade
                 , msi.segment1          item
                 , md.wip_plan_qty       qtde--md.plan_qty    qtde md.plan_qty       qtde
                 , grs.attribute1        repete
                 , gbh.batch_id
                 , msi.inventory_item_id id_item  
                 , md.material_detail_id
             FROM  apps.mtl_system_items_b               msi
                 , apps.gme_material_details             md 
                 , apps.gme_batch_header                 gbh
                 , apps.gmd_recipe_validity_rules        grv 
                 , apps.gme_batch_step_activities        gba
                 , apps.gme_batch_steps                  gbs
                 , apps.gmd_recipes                      grr
                 , apps.gmd_operation_activities         goa  
                 , apps.gme_batch_step_items             grs 
                 , apps.gmd_operations_b                 gob
               --, gmd_recipe_step_materials        grsm
                 , apps.fm_rout_dtl                      frd 
               --, fm_rout_hdr                      frh 
                 , apps.fm_matl_dtl                      fmd
             WHERE 1=1
               AND msi.inventory_item_id            = md.inventory_item_id 
               AND msi.organization_id              = md.organization_id 
               AND md.batch_id                      = gbh.batch_id 
               AND grv.recipe_validity_rule_id (+)  = gbh.recipe_validity_rule_id
               AND gbh.batch_id                     = gba.batch_id
               AND gbs.batch_id                     = gba.batch_id
               AND gbs.batchstep_id                 = gba.batchstep_id
               AND grr.recipe_id                    = grv.recipe_id
               AND grr.formula_id                   = gbh.formula_id 
               AND grr.routing_id                   = gbh.routing_id
               AND gbs.oprn_id                      = goa.oprn_id
               AND gba.oprn_line_id                 = goa.oprn_line_id
               AND md.material_detail_id            = grs.material_detail_id 
               AND gbh.batch_id                     = grs.batch_id
               AND gbs.batchstep_id                 = grs.batchstep_id
               AND gob.oprn_id                      = gbs.oprn_id
             --AND grsm.recipe_id                   = grv.recipe_id
             --AND grsm.routingstep_id              = gbs.routingstep_id
               AND frd.routing_id                   = grr.routing_id
               AND frd.routingstep_id               = gbs.routingstep_id
--               AND frd.oprn_id                      = gbs.oprn_id
             --AND frh.routing_id                   = frd.routing_id 
             --AND fmd.formula_id                   = gbh.formula_id 
             --AND fmd.formulaline_id               = grsm.formulaline_id (+)
             --AND fmd.inventory_item_id            = msi.inventory_item_id 
             --AND fmd.organization_id              = msi.organization_id
               AND md.formulaline_id                = fmd.formulaline_id (+)
               AND md.line_type                     = -1
               and gbh.batch_no = 24774
               
             --  AND gbh.batch_status                 = 2
              -- AND NVL(md.wip_plan_qty, 0)          > 0    --- #1
             ORDER BY frd.routingstep_no, msi.segment1;
             
             
             
            SELECT md.material_detail_id
             FROM  apps.gme_material_details             md 
                 , apps.gme_batch_header                 gbh
                 , apps.fm_matl_dtl                      fmd
             WHERE 1=1
             
               AND gbs.batch_id                     = gba.batch_id
               AND gbs.batchstep_id                 = gba.batchstep_id
               AND md.material_detail_id            = grs.material_detail_id 
               AND gbh.batch_id                     = grs.batch_id
               AND gbs.batchstep_id                 = grs.batchstep_id
             
             
             
             
               AND  md.batch_id                     = gbh.batch_id 
               AND md.formulaline_id                = fmd.formulaline_id (+)
               AND md.line_type                     = -1
               and gbh.batch_no = 24774
               
             --  AND gbh.batch_status                 = 2
              -- AND NVL(md.wip_plan_qty, 0)          > 0    --- #1
                 