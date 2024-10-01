                               (SELECT abs(sum(nvl(mtl1.transaction_quantity,0)))
                                  FROM apps.mtl_material_transactions   mtl1
                                     , apps.mtl_transaction_lot_numbers mtln
                                 WHERE mtl1.transaction_id      = mtln.transaction_id(+)
                                   AND mtl1.TRANSACTION_TYPE_ID IN (35,43)
                                   AND mtl1.inventory_item_id   = itm.inventory_item_id
                                   AND MTL1.organization_id     = itm.organization_id
                                   AND mtl1.transaction_date BETWEEN ADD_MONTHS(TRUNC(TO_DATE(par_dt_referencia,'rrrr/mm/dd hh24:mi:ss')),-3)
                                                                 AND TRUNC(TO_DATE(par_dt_referencia,'rrrr/mm/dd hh24:mi:ss')) )
                                                                                            cons_ult_03m;


select * FROM apps.mtl_material_transactions   mtl1;


SELECT abs(sum(nvl(mtl1.transaction_quantity,0)))
  FROM apps.mtl_material_transactions   mtl1
     , apps.mtl_transaction_lot_numbers mtln
     , apps.mtl_system_items_b msi
 WHERE mtl1.transaction_id      = mtln.transaction_id(+)
   AND mtl1.TRANSACTION_TYPE_ID IN (35,43) -- WIP - WIP Return
   AND mtl1.inventory_item_id   = msi.inventory_item_id
   AND MTL1.organization_id     = msi.organization_id
   AND mtl1.transaction_date BETWEEN TO_DATE('2016/01/01','rrrr/mm/dd hh24:mi:ss')
                                 AND TO_DATE('2016/01/31','rrrr/mm/dd hh24:mi:ss')
   and msi.segment1 = 'SRC-75';




SELECT  abs(sum(nvl(mtl1.transaction_quantity,0)))
  FROM apps.mtl_material_transactions   mtl1
     , apps.mtl_transaction_lot_numbers mtln
     , apps.mtl_system_items_b msi
 WHERE mtl1.transaction_id      = mtln.transaction_id(+)
   AND mtl1.TRANSACTION_TYPE_ID IN (33,15) -- Sales order issue - RMA Receipt
   AND mtl1.inventory_item_id   = msi.inventory_item_id
   AND MTL1.organization_id     = msi.organization_id
   AND mtl1.transaction_date BETWEEN TO_DATE('2015/12/01','rrrr/mm/dd hh24:mi:ss')
                                 AND TO_DATE('2016/01/31','rrrr/mm/dd hh24:mi:ss')
   and msi.segment1 = 'LT3007BRSSA.50';
