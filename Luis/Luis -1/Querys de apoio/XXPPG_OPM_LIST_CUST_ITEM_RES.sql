  SELECT god.organization_code org
       , gps.calendar_code calendario
       , gps.period_code periodo
       , msib.segment1 || ' | ' || msib.description item_desc
       , (SELECT mc.concatenated_segments
            FROM apps.mtl_item_categories_v mic
               , apps.mtl_categories_kfv mc
               , apps.mtl_category_sets_v mcs
           WHERE mcs.structure_id = mic.structure_id
             AND mic.organization_id = msib.organization_id
             AND mic.inventory_item_id = msib.inventory_item_id
             AND mc.category_id = mic.category_id
             AND mic.category_set_id = (SELECT category_set_id
                                          FROM apps.mtl_default_category_sets
                                         WHERE functional_area_id = 19))
           cat_custo
       , (SELECT mc.concatenated_segments
            FROM apps.mtl_item_categories_v mic
               , apps.mtl_categories_kfv mc
               , apps.mtl_category_sets_v mcs
           WHERE mcs.structure_id = mic.structure_id
             AND mic.organization_id = msib.organization_id
             AND mic.inventory_item_id = msib.inventory_item_id
             AND mc.category_id = mic.category_id
             AND mic.category_set_id = (SELECT category_set_id
                                          FROM apps.mtl_default_category_sets
                                         WHERE functional_area_id = 1))
           cat_inv
       , cmm.cost_mthd_code metodo
       , decode(ccm.usage_ind,1,'Material',2,'Despesas Indiretas',3,'Recurso',4,'Alocacao',5,'Ajuste STD') Tipo
       , round(SUM (ccd.cmpnt_cost),5) cst_unit
       , msib.primary_uom_code udm
    FROM apps.mtl_system_items_b msib
       , apps.gmf_organization_definitions god
       , apps.cm_cmpt_dtl ccd
       , apps.cm_mthd_mst cmm
       , apps.gmf_period_statuses gps
       , apps.cm_cmpt_mst ccm
   WHERE ccd.inventory_item_id = msib.inventory_item_id
     AND ccd.organization_id = msib.organization_id
     AND ccd.organization_id = god.organization_id
     AND ccd.cost_type_id = cmm.cost_type_id
     AND ccd.period_id = gps.period_id
     AND ccd.cost_cmpntcls_id = ccm.cost_cmpntcls_id
     AND ccd.delete_mark = 0
     AND cmm.delete_mark = 0
     AND gps.delete_mark = 0
GROUP BY god.organization_code
       , gps.calendar_code
       , gps.period_code
       , msib.segment1 || ' | ' || msib.description
       , cmm.cost_mthd_code
       , msib.primary_uom_code
       , msib.inventory_item_id
       , msib.organization_id
       , ccm.usage_ind
ORDER BY god.organization_code
       , gps.period_code
       , msib.segment1 || ' | ' || msib.description
       , cmm.cost_mthd_code
       , TIpo
       ;