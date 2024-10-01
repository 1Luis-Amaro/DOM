SELECT TRUNC (TO_DATE('2016-09-30','rrrr/mm/dd hh24:mi:ss')) AS CREATION_DATE,
                oinv.organization_code Org,
                itm.segment1 Item,
                cinv.categoria categoria,
                ohq.lot_number Lote,
                ohq.subinventory_code Subinv,
                ohq.locator_id,
                mil.description  "Endereco",
                (SUM (ohq.transaction_quantity) + NVL(MAX(movto.saldo),0)) Saldo,
                MAX((SELECT SUM(cst.CMPNT_COST) FROM apps.CM_CMPT_DTL cst
                       WHERE cst.delete_mark       = '0'
                         AND cst.organization_id   = ohq.organization_id
                         AND cst.inventory_item_id = itm.inventory_item_id
                         AND cst.cost_type_id      = '1005'
                         AND cst.period_id         = (SELECT MAX(cstt.period_id)
                                                        FROM apps.CM_CMPT_DTL cstt, apps.gmf_period_statuses gps
                                                       WHERE TRUNC(gps.start_date) >= TRUNC(TO_DATE('2016-09-01','rrrr/mm/dd hh24:mi:ss')) AND
                                                             TRUNC(gps.start_date) <= TRUNC(TO_DATE('2016-09-30','rrrr/mm/dd hh24:mi:ss'))  AND
                                                             gps.cost_type_id       = cstt.cost_type_id     AND
                                                             cstt.period_id         = gps.period_id         AND
                                                             cstt.delete_mark       = '0'                   AND
                                                             cstt.organization_id   = cst.organization_id   AND
                                                             cstt.inventory_item_id = cst.inventory_item_id AND
                                                             cstt.cost_type_id      = '1005'                AND
                                                             cmpnt_cost       <> 0))) custo,         

                MAX((SELECT SUM(cst.CMPNT_COST) FROM apps.CM_CMPT_DTL cst
                      WHERE cst.delete_mark       = '0'
                        AND cst.organization_id   = ohq.organization_id
                        AND cst.inventory_item_id = itm.inventory_item_id
                        AND cst.cost_type_id      = '1000'
                        AND cst.period_id         = (SELECT MAX(cstt.period_id)
                                                       FROM apps.CM_CMPT_DTL cstt, apps.gmf_period_statuses gps
                                                      WHERE TRUNC(gps.start_date) >= TRUNC(TO_DATE('2016-09-01','rrrr/mm/dd hh24:mi:ss')) AND
                                                            TRUNC(gps.start_date) <= TRUNC(TO_DATE('2016-09-30','rrrr/mm/dd hh24:mi:ss'))  AND
                                                   -- WHERE TRUNC(gps.start_date)  < TRUNC(TO_DATE('2016-08-31','rrrr/mm/dd hh24:mi:ss'))   AND --'01-dez-2015'| AND
                                                            gps.cost_type_id       = cstt.cost_type_id     AND
                                                            cstt.period_id         = gps.period_id         AND
                                                            cstt.delete_mark       = '0'                   AND
                                                            cstt.organization_id   = cst.organization_id   AND
                                                            cstt.inventory_item_id = cst.inventory_item_id AND
                                                            cstt.cost_type_id      = '1000'                AND
                                                            cmpnt_cost       <> 0))) medio         

         
            FROM apps.mtl_system_items_b itm,
                 apps.mtl_onhand_quantities ohq,
                 apps.mtl_parameters oinv,
                 apps.mtl_item_locations mil,
                 
                (SELECT mic.inventory_item_id,
                        mic.organization_id,
                        mic.category_set_name,
                        mic.category_concat_segs categoria
                   FROM apps.mtl_item_categories_v mic, apps.mtl_categories_v mc
                  WHERE mc.category_id = mic.category_id AND
                        mic.category_set_name IN ('Inventory')) cinv,                 
                 
                (SELECT TRUNC (TO_DATE('2016-09-30','rrrr/mm/dd hh24:mi:ss')) AS CREATION_DATE,
                        mmt.organization_id,
                        mmt.inventory_item_id,
                        nvl(mtln.lot_number,null) lot_number,
                        mmt.subinventory_code,
                        sum(nvl(mtln.primary_quantity * -1, mmt.primary_quantity * -1)) saldo,
                        0
                   FROM apps.mtl_material_transactions      mmt,
                        apps.mtl_transaction_lot_numbers    mtln,
                        apps.mtl_system_items_b             itm,
                        apps.mtl_parameters                 oinv
                              
                   WHERE oinv.organization_id         = mmt.organization_id       AND
                         mmt.inventory_item_id        = mtln.inventory_item_id(+) AND
                         mmt.organization_id          = mtln.organization_id(+)   AND
                         mmt.transaction_id           = mtln.transaction_id(+)    AND
                         TRUNC(mmt.creation_date)     > TRUNC(TO_DATE('2016-09-30','rrrr/mm/dd hh24:mi:ss'))      AND
                         mmt.subinventory_code IS NOT NULL                        AND
                         mmt.inventory_item_id        = itm.inventory_item_id     AND
                         mmt.organization_id          = itm.organization_id      /* AND
                         itm.segment1                 = '045614-0007'*/
                   GROUP BY mmt.organization_id,
                            mmt.inventory_item_id,
                            mtln.lot_number,
                            mmt.subinventory_code) movto
                                     
           WHERE movto.organization_id(+)     = ohq.organization_id       AND
                 movto.inventory_item_id(+)   = ohq.inventory_item_id     AND
                 cinv.organization_id         = ohq.organization_id       AND
                 cinv.inventory_item_id       = ohq.inventory_item_id      AND
                 
                 nvl(movto.lot_number(+),' ') = nvl(ohq.lot_number,' ')   AND
                 movto.subinventory_code(+)   = ohq.subinventory_code     AND 
                 --itm.costing_enabled_flag     = 'Y'                       AND
                 itm.organization_id          = ohq.organization_id       AND
                 itm.inventory_item_id        = ohq.inventory_item_id     AND
                 --itm.segment1                 = 'AC-33-7841'   AND
                 ohq.organization_id          = oinv.organization_id      AND 
                 oinv.resource_account        is not null                 AND                
                 oinv.organization_id         = nvl('',oinv.organization_id) AND
                 ohq.locator_id               = mil.inventory_location_id and
                 mil.organization_id          = ohq.organization_id
                 
                 and itm.segment1 = 'KA-15-9456'
                                  
                 
        GROUP BY cinv.categoria,
                 oinv.organization_code,
                 itm.segment1,
                 ohq.lot_number,
                 ohq.subinventory_code,
                 MIL.DESCRIPTION,
                 ohq.locator_id;
                 
                 
        union         
                 
         SELECT TRUNC (TO_DATE('2016-09-30','rrrr/mm/dd hh24:mi:ss')) AS CREATION_DATE,
                oinv.organization_code Org,
                itm.segment1 Item,
                cinv.categoria categoria,                
                mtln.lot_number Lote,
                mmt.subinventory_code Subinv,
                mil.description  "Endereco",
                SUM(NVL(mtln.primary_quantity * -1, mmt.primary_quantity * -1)) Saldo,
                MAX((SELECT SUM(cst.CMPNT_COST) 
                       FROM apps.CM_CMPT_DTL cst
                      WHERE cst.delete_mark       = '0'
                        AND cst.organization_id   = mmt.organization_id
                        AND cst.inventory_item_id = mmt.inventory_item_id
                        AND cst.cost_type_id      = '1005'
                        AND cst.period_id         = (SELECT MAX(cstt.period_id)
                                                       FROM apps.CM_CMPT_DTL cstt, apps.gmf_period_statuses gps
                                                   -- WHERE TRUNC(gps.start_date)  < TRUNC(TO_DATE('2016-08-31','rrrr/mm/dd hh24:mi:ss'))   AND
                                                      WHERE TRUNC(gps.start_date) >= TRUNC(TO_DATE('2016-09-01','rrrr/mm/dd hh24:mi:ss')) AND
                                                            TRUNC(gps.start_date) <= TRUNC(TO_DATE('2016-09-30','rrrr/mm/dd hh24:mi:ss'))  AND
                                                            gps.cost_type_id       = cstt.cost_type_id     AND
                                                            cstt.period_id         = gps.period_id         AND
                                                            cstt.delete_mark       = '0'                   AND
                                                            cstt.organization_id   = cst.organization_id   AND
                                                            cstt.inventory_item_id = cst.inventory_item_id AND
                                                            cstt.cost_type_id      = '1005'                AND
                                                            cmpnt_cost       <> 0))) custo,         

                MAX((SELECT SUM(cst.CMPNT_COST) FROM apps.CM_CMPT_DTL cst
                      WHERE cst.delete_mark       = '0'
                        AND cst.organization_id   = mmt.organization_id
                        AND cst.inventory_item_id = mmt.inventory_item_id
                        AND cst.cost_type_id      = '1000'
                        AND cst.period_id         = (SELECT MAX(cstt.period_id)
                                                       FROM apps.CM_CMPT_DTL cstt, apps.gmf_period_statuses gps
                                                   -- WHERE TRUNC(gps.start_date)  < TRUNC(TO_DATE('2016-08-31','rrrr/mm/dd hh24:mi:ss'))   AND --'01-dez-2015' AND
                                                      WHERE TRUNC(gps.start_date) >= TRUNC(TO_DATE('2016-09-01','rrrr/mm/dd hh24:mi:ss')) AND
                                                            TRUNC(gps.start_date) <= TRUNC(TO_DATE('2016-09-30','rrrr/mm/dd hh24:mi:ss'))  AND
                                                            gps.cost_type_id       = cstt.cost_type_id     AND
                                                            cstt.period_id         = gps.period_id         AND
                                                            cstt.delete_mark       = '0'                   AND
                                                            cstt.organization_id   = cst.organization_id   AND
                                                            cstt.inventory_item_id = cst.inventory_item_id AND
                                                            cstt.cost_type_id      = '1000'                AND
                                                            cmpnt_cost       <> 0))) medio
                 
            FROM apps.mtl_system_items_b          itm,
                 apps.mtl_parameters              oinv,
                 apps.mtl_material_transactions   mmt,
                 apps.mtl_item_locations          mil,
                 
                (SELECT mic.inventory_item_id,
                        mic.organization_id,
                        mic.category_set_name,
                        mic.category_concat_segs categoria
                   FROM apps.mtl_item_categories_v mic, apps.mtl_categories_v mc
                  WHERE mc.category_id = mic.category_id AND
                        mic.category_set_name IN ('Inventory')) cinv,                 
                 
                 apps.mtl_transaction_lot_numbers mtln
                              
                                     
           WHERE mmt.inventory_item_id not in (select ohq.inventory_item_id 
                                                   FROM apps.mtl_onhand_quantities ohq
                                                  WHERE ohq.organization_id     = mmt.organization_id       AND
                                                        ohq.inventory_item_id   = mmt.inventory_item_id     AND
                                                        ohq.subinventory_code   = mmt.subinventory_code     AND
                                                        nvl(ohq.lot_number,' ') = nvl(mtln.lot_number,' ')) AND
                 cinv.organization_id       = mmt.organization_id       AND
                 cinv.inventory_item_id     = mmt.inventory_item_id     AND
                 itm.inventory_item_id      = mmt.inventory_item_id     AND
                 mmt.inventory_item_id      = mtln.inventory_item_id(+) AND
                 mmt.organization_id        = mtln.organization_id(+)   AND
                 mmt.transaction_id         = mtln.transaction_id(+)    AND
                 mmt.subinventory_code   is not null                    AND
                 TRUNC(mmt.creation_date)   > TRUNC(TO_DATE('2016-09-30','rrrr/mm/dd hh24:mi:ss')) AND --/*'2016-08-31'*/
                 mmt.organization_id        = oinv.organization_id      AND  
                 mmt.inventory_item_id      = itm.inventory_item_id     AND
                 --itm.costing_enabled_flag   = 'Y'                       AND         
                 itm.organization_id        = oinv.organization_id      AND
                 --itm.segment1               = 'AC-33-7841' AND
                 mmt.locator_id             = mil.inventory_location_id   AND
                 oinv.resource_account        is not null                 AND
                 oinv.organization_id       = nvl('',oinv.organization_id)
           GROUP BY cinv.categoria,
                    oinv.organization_code,
                    mmt.organization_id,
                    itm.segment1,
                    mtln.lot_number,
                    mmt.subinventory_code,
                    mil.description;