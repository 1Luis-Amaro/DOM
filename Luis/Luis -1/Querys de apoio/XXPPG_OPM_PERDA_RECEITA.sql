  SELECT god.organization_code org
       , msib.segment1 ||' - '||msib.description "item desc"
       , cmv.category_concat_segs cate_custo
       , grb.recipe_no receita
       , grb.recipe_version r_vers
       , (SELECT gsv.meaning
            FROM apps.gmd_status_vl gsv
           WHERE grb.recipe_status = gsv.status_code) status_receita
       , DECODE (grvr.recipe_use,  0, 'Prod',  2, 'Custo') uso
       , grvr.std_qty
       , grvr.detail_uom udm
       , grvr.planned_process_loss perda
       , (SELECT gsv.meaning
            FROM apps.gmd_status_vl gsv
           WHERE grvr.validity_rule_status = gsv.status_code) status_regra
       , grvr.preference pref
    FROM apps.gmd_recipe_validity_rules grvr
       , apps.gmf_organization_definitions god
       , apps.gmd_recipes_b grb
       , apps.mtl_system_items_b msib
       , apps.mtl_categories_v cmv
       , apps.mtl_item_categories mic
       , apps.mtl_category_sets mcs
   WHERE grvr.organization_id = god.organization_id
     AND grvr.recipe_id = grb.recipe_id
     AND grvr.inventory_item_id = msib.inventory_item_id
     AND grvr.organization_id = msib.organization_id
     AND grvr.inventory_item_id = mic.inventory_item_id
     AND grvr.organization_id = mic.organization_id
     AND cmv.category_id = mic.category_id
     AND mcs.category_set_id = mic.category_set_id
     AND mic.category_set_id = (SELECT category_set_id
                                  FROM apps.mtl_default_category_sets
                                 WHERE functional_area_id = 19) 
ORDER BY god.organization_code
       , cmv.category_concat_segs
       , msib.segment1
       , DECODE (grvr.recipe_use,  0, 'Prod',  2, 'Custo')
