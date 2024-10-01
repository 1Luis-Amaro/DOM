SELECT SUM(cst.CMPNT_COST) custo 
                                 FROM apps.CM_CMPT_DTL cst,
                                      apps.cm_mthd_mst cmm
                                WHERE cst.delete_mark       = '0'
                                  AND cst.organization_id   = 86--msib.organization_id
                                  AND cst.inventory_item_id = 2735--msib.inventory_item_id
                                  AND cst.cost_type_id      = cmm.cost_type_id
                                  AND cmm.cost_mthd_code    = 'PMAC'
                                  AND cst.period_id         = (SELECT MAX(cstt.period_id)
                                                                 FROM apps.CM_CMPT_DTL cstt,
                                                                      apps.gmf_period_statuses gps,
                                                                      apps.cm_mthd_mst         cmmt
                                                                WHERE TRUNC(gps.start_date) <= TRUNC(SYSDATE)  AND
                                                                      gps.cost_type_id       = cstt.cost_type_id     AND
                                                                      gps.period_status      = 'C'                   AND
                                                                      cstt.period_id         = gps.period_id         AND
                                                                      cstt.delete_mark       = '0'                   AND
                                                                      cstt.organization_id   = cst.organization_id   AND
                                                                      cstt.inventory_item_id = cst.inventory_item_id AND
                                                                      cstt.cost_type_id      = cmmt.cost_type_id     AND
                                                                      cmmt.cost_mthd_code    = 'PMAC'                 AND
                                                                      cmpnt_cost            <> 0)
