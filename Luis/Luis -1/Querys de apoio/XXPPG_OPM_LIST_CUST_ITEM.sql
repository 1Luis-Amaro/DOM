SELECT god.organization_code org
       , gps.calendar_code calendario
       , gps.period_code periodo
       , msib.segment1 cod_item
       ,    msib.segment1
         || ' - '
         || msib.description
           item_desc
       , cmv.category_concat_segs cate_inv
       , cmm.cost_mthd_code metodo
       , SUM (ccd.cmpnt_cost) cst_unit
       , msib.primary_uom_code udm
    FROM apps.cm_cmpt_dtl ccd
       , apps.mtl_system_items_b msib
       , apps.gmf_organization_definitions god
       , apps.cm_mthd_mst cmm
       , apps.gmf_period_statuses gps
       , apps.mtl_categories_v cmv
       , apps.mtl_item_categories mic
       , apps.mtl_category_sets mcs
   WHERE ccd.inventory_item_id = msib.inventory_item_id
     AND ccd.organization_id = msib.organization_id
     AND ccd.organization_id = god.organization_id
     AND ccd.cost_type_id = cmm.cost_type_id
     AND ccd.period_id = gps.period_id
     AND ccd.inventory_item_id = mic.inventory_item_id
     AND ccd.organization_id = mic.organization_id
     AND cmv.category_id = mic.category_id
     AND mcs.category_set_id = mic.category_set_id
     AND mic.category_set_id = (SELECT category_set_id
                                  FROM apps.mtl_default_category_sets
                                 WHERE functional_area_id = 1)
     AND ccd.delete_mark = 0                               
     AND cmm.delete_mark = 0
     AND gps.delete_mark = 0
GROUP BY god.organization_code
       , gps.calendar_code
       , gps.period_code
       , msib.segment1
       ,    msib.segment1
         || ' - '
         || msib.description
       , cmv.category_concat_segs
       , cmm.cost_mthd_code
       , msib.primary_uom_code
ORDER BY god.organization_code
       , gps.period_code
       , msib.segment1
       , cmm.cost_mthd_code