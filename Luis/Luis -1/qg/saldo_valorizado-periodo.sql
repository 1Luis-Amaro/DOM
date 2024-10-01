       
 SELECT TRUNC (SYSDATE) AS CREATION_DATE,
        oinv.organization_code Org,
        itm.segment1 Item,
        ohq.lot_number Lote,
        ohq.subinventory_code Subinv,
        (SUM (ohq.transaction_quantity) + NVL(MAX(movto.saldo),0)) Saldo,
        MAX((select sum(cst.CMPNT_COST) from apps.CM_CMPT_DTL cst
                               where cst.delete_mark       = '0'
                                    AND cst.organization_id   = ohq.organization_id
                                    AND cst.inventory_item_id = itm.inventory_item_id
                                    AND cst.cost_type_id      = '1005'
                                    AND cst.period_id         = (select max(cstt.period_id)
                                                                   FROM apps.CM_CMPT_DTL cstt, apps.gmf_period_statuses gps
                                                                  WHERE trunc(gps.start_date)  < '01-dec-2015'         AND
                                                                        gps.cost_type_id       = cstt.cost_type_id     AND
                                                                        cstt.period_id         = gps.period_id         AND
                                                                        cstt.delete_mark       = '0'                   AND
                                                                        cstt.organization_id   = cst.organization_id   AND
                                                                        cstt.inventory_item_id = cst.inventory_item_id AND
                                                                        cstt.cost_type_id      = '1005'                AND
                                                                        cmpnt_cost       <> 0))) custo,         

        MAX((select sum(cst.CMPNT_COST) from apps.CM_CMPT_DTL cst
                               where cst.delete_mark       = '0'
                                    AND cst.organization_id   = ohq.organization_id
                                    AND cst.inventory_item_id = itm.inventory_item_id
                                    AND cst.cost_type_id      = '1000'
                                    AND cst.period_id         = (select max(cstt.period_id)
                                                                   FROM apps.CM_CMPT_DTL cstt, apps.gmf_period_statuses gps
                                                                  WHERE trunc(gps.start_date)  < '01-dec-2015'         AND
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
         
        (SELECT TRUNC (SYSDATE) AS CREATION_DATE,
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
                 TRUNC(mmt.creation_date)    >= '01-dec-2015'             AND
                 mmt.subinventory_code IS NOT NULL                        AND
                 mmt.inventory_item_id        = itm.inventory_item_id     AND
                 mmt.organization_id          = itm.organization_id       /*AND
                 itm.segment1                 = '1540003L.20'*/
           GROUP BY mmt.organization_id,
                    mmt.inventory_item_id,
                    mtln.lot_number,
                    mmt.subinventory_code) movto
                             
   WHERE movto.organization_id(+)     = ohq.organization_id     AND
         movto.inventory_item_id(+)   = ohq.inventory_item_id   AND
         nvl(movto.lot_number(+),' ') = nvl(ohq.lot_number,' ') AND
         movto.subinventory_code(+)   = ohq.subinventory_code   AND 
         oinv.organization_id         = ohq.organization_id     AND
         itm.costing_enabled_flag     = 'Y'                     AND
         itm.organization_id          = ohq.organization_id     AND
         itm.inventory_item_id        = ohq.inventory_item_id   /*AND
         itm.segment1                 = '1540003L.20'*/
         
GROUP BY oinv.organization_code,
         itm.segment1,
         ohq.lot_number,
         ohq.subinventory_code,
         ohq.subinventory_code
         
union         
         
 SELECT TRUNC (SYSDATE) AS CREATION_DATE,
        oinv.organization_code Org,
        itm.segment1 Item,
        mtln.lot_number Lote,
        mmt.subinventory_code Subinv,
        sum(nvl(mtln.primary_quantity * -1, mmt.primary_quantity * -1)) Saldo,
        MAX((select sum(cst.CMPNT_COST) from apps.CM_CMPT_DTL cst
                               where cst.delete_mark       = '0'
                                    AND cst.organization_id   = mmt.organization_id
                                    AND cst.inventory_item_id = mmt.inventory_item_id
                                    AND cst.cost_type_id      = '1005'
                                    AND cst.period_id         = (select max(cstt.period_id)
                                                                   FROM apps.CM_CMPT_DTL cstt, apps.gmf_period_statuses gps
                                                                  WHERE trunc(gps.start_date)  < '01-dec-2015'         AND
                                                                        gps.cost_type_id       = cstt.cost_type_id     AND
                                                                        cstt.period_id         = gps.period_id         AND
                                                                        cstt.delete_mark       = '0'                   AND
                                                                        cstt.organization_id   = cst.organization_id   AND
                                                                        cstt.inventory_item_id = cst.inventory_item_id AND
                                                                        cstt.cost_type_id      = '1005'                AND
                                                                        cmpnt_cost       <> 0))) custo,         

        MAX((select sum(cst.CMPNT_COST) from apps.CM_CMPT_DTL cst
                               where cst.delete_mark       = '0'
                                    AND cst.organization_id   = mmt.organization_id
                                    AND cst.inventory_item_id = mmt.inventory_item_id
                                    AND cst.cost_type_id      = '1000'
                                    AND cst.period_id         = (select max(cstt.period_id)
                                                                   FROM apps.CM_CMPT_DTL cstt, apps.gmf_period_statuses gps
                                                                  WHERE trunc(gps.start_date)  < '01-dec-2015'         AND
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
         apps.mtl_transaction_lot_numbers mtln
                      
                             
   WHERE mmt.inventory_item_id not in (select ohq.inventory_item_id 
                                           FROM apps.mtl_onhand_quantities ohq
                                          WHERE ohq.organization_id     = mmt.organization_id       AND
                                                ohq.inventory_item_id   = mmt.inventory_item_id     AND
                                                ohq.subinventory_code   = mmt.subinventory_code     AND
                                                nvl(ohq.lot_number,' ') = nvl(mtln.lot_number,' ')) AND
         oinv.organization_id       = mmt.organization_ID       AND
         itm.organization_id        = mmt.organization_ID       AND
         itm.inventory_item_id      = mmt.inventory_item_id     AND
         mmt.inventory_item_id      = mtln.inventory_item_id(+) AND
         mmt.organization_id        = mtln.organization_id(+)   AND
         mmt.transaction_id         = mtln.transaction_id(+)    AND
         mmt.subinventory_code   is not null                    AND
         TRUNC(mmt.creation_date)  >= '01-dec-2015'             AND
         mmt.inventory_item_id      = itm.inventory_item_id     AND
         itm.costing_enabled_flag   = 'Y'                     AND         
         itm.organization_id        = mmt.organization_id     /*AND
         itm.segment1               = '1540003L.20'*/
   GROUP BY oinv.organization_code,
            mmt.organization_id,
            itm.segment1,
            mtln.lot_number,
            mmt.subinventory_code;