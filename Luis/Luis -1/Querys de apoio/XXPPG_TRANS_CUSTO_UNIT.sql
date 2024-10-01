SELECT mp.organization_code org
       , msib.segment1 || ' | ' || msib.description item
       , to_char(mmt.transaction_date,'mm/yyyy') periodo
       , mtt.transaction_type_name transacao
       , SUM (mmt.primary_quantity) qtd_total
       , msib.primary_uom_code udm
       , (SELECT SUM (cmpnt_cost)
            FROM apps.cm_cmpt_dtl ccd
               , apps.cm_mthd_mst cmm
               , apps.gmf_period_statuses gps
           WHERE ccd.inventory_item_id = mmt.inventory_item_id
             AND ccd.organization_id = mmt.organization_id
             AND ccd.period_id = gps.period_id
             AND ccd.cost_type_id = cmm.cost_type_id
             AND cmm.cost_mthd_code = 'STD'
             AND TO_CHAR (gps.start_date
                        , 'mm/yyyy') = TO_CHAR (mmt.transaction_date
                                              , 'mm/yyyy'))
           cst_std
       , (SELECT SUM (cmpnt_cost)
            FROM apps.cm_cmpt_dtl ccd
               , apps.cm_mthd_mst cmm
               , apps.gmf_period_statuses gps
           WHERE ccd.inventory_item_id = mmt.inventory_item_id
             AND ccd.organization_id = mmt.organization_id
             AND ccd.period_id = gps.period_id
             AND ccd.cost_type_id = cmm.cost_type_id
             AND cmm.cost_mthd_code = 'PMAC'
             AND TO_CHAR (gps.start_date
                        , 'mm/yyyy') = TO_CHAR (mmt.transaction_date
                                              , 'mm/yyyy'))
           cst_pmac
    FROM apps.mtl_material_transactions mmt
       , apps.mtl_transaction_types mtt
       , apps.mtl_system_items_b msib
       , apps.mtl_parameters mp
   WHERE mmt.organization_id = msib.organization_id
     AND mmt.inventory_item_id = msib.inventory_item_id
     AND mmt.transaction_type_id = mtt.transaction_type_id
     AND mmt.organization_id = mp.organization_id
     /*AND mmt.transaction_date BETWEEN TO_DATE ('01/02/2015'
                                             , 'dd/mm/yyyy')
                                  AND TO_DATE ('28/02/2015'
                                             , 'dd/mm/yyyy')*/
GROUP BY mp.organization_code
       , msib.segment1 || ' | ' || msib.description
       , mtt.transaction_type_name
       , msib.primary_uom_code
       , mmt.inventory_item_id
       , mmt.organization_id
       , to_char(mmt.transaction_date,'mm/yyyy')
ORDER BY mp.organization_code
       , msib.segment1 || ' | ' || msib.description
       , mtt.transaction_type_name