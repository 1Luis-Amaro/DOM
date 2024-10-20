  SELECT TRUNC (SYSDATE) AS CREATION_DATE,
         oinv.organization_code Org,
         itm.segment1 Item,
         ohq.lot_number Lote,
         ohq.subinventory_code Subinventario,
         SUM (ohq.transaction_quantity) Saldo,
         SUM (cst.CMPNT_COST)
    FROM apps.mtl_system_items_b ITM,
         apps.MTL_ONHAND_QUANTITIES OHQ,
         apps.mtl_parameters oinv,
         apps.CM_CMPT_DTL cst
   WHERE     cst.delete_mark       = '0'
         AND cst.organization_id   = ohq.organization_id
         AND cst.inventory_item_id = itm.inventory_item_id
         AND cst.cost_type_id      = '1005'
         AND cst.period_id         = (select max(period_id)
                                        FROM apps.CM_CMPT_DTL
                                       WHERE delete_mark       = '0'                   AND
                                             organization_id   = ohq.organization_id   AND
                                             inventory_item_id = itm.inventory_item_id AND
                                             cost_type_id      = '1005'                AND
                                             cmpnt_cost       <> 0)
         AND oinv.organization_id  = ohq.organization_id
         AND itm.organization_id   = ohq.organization_id
         AND itm.inventory_item_id = ohq.inventory_item_id
         AND OHQ.organization_id   = 92
GROUP BY oinv.organization_code,
         itm.segment1,
         ohq.lot_number,
         ohq.subinventory_code,
         ohq.subinventory_code;
         
         
         
SELECT PERIOD_ID,
       ORGANIZATION_ID,
       INVENTORY_ITEM_ID,
       CMPNTCOST_ID,
       COST_CMPNTCLS_ID,
       COST_ANALYSIS_CODE,
       CMPNT_COST,
       COSTCALC_ORIG,
       DELETE_MARK,
       ROLLOVER_IND,
       COST_TYPE_ID
  FROM apps.CM_CMPT_DTL
WHERE   1 = 1 --   cost_level = 1
       AND (delete_mark = '0')
       AND (ORGANIZATION_ID = '81')
--       AND (INVENTORY_ITEM_ID = '12785')
       AND (COST_TYPE_ID = '1005')
       AND period_id = (select max(period_id) 
                          FROM apps.CM_CMPT_DTL
                       WHERE   1 = 1 --   cost_level = 1
                         AND (delete_mark = '0')
                         AND (ORGANIZATION_ID = '81')
                      --   AND (INVENTORY_ITEM_ID = '12785')
                         AND (COST_TYPE_ID = '1005')
                         AND CMPNT_COST <> 0);
         