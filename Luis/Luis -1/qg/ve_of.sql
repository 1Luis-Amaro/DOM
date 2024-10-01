
SELECT grs.* /*decode(MAX (NVL (TO_NUMBER (grs.attribute1, fmtnumber), 1)),
                    null, 1,
                    MAX (NVL (TO_NUMBER (grs.attribute1, fmtnumber), 1)))
        INTO l_max_cargas*/
        FROM apps.gme_batch_steps gbs,
             apps.gmd_recipe_step_materials grs,
             apps.gme_material_details gmd
       WHERE     gbs.batch_id = 455790
             AND grs.routingstep_id = gbs.routingstep_id
             AND grs.FORMULALINE_ID = gmd.FORMULALINE_ID
             AND gmd.batch_id = 455790
             --AND grs.recipe_id = 134365 --p_recipe_id
             AND gmd.line_type = -1;

select batch_id, gmd.* from apps.gme_material_details  gmd where inventory_item_id = 329528 and line_type = 1;

select * from apps.gme_batch_header where batch_id = 362539;

select inventory_item_id from apps.mtl_system_items_b where segment1 = '284008BR';

select * from apps.gmd_recipes where recipe_no = '284008BR/14000-18000';

select * from apps.gmd_recipe_step_materials grs where recipe_id = 
134365;

SELECT  mmt.primary_quantity, transaction_type_id, TRUNC(SYSDATE - 193), TRUNC(SYSDATE - 103)
    FROM    inv.mtl_material_transactions mmt, apps.mtl_system_items_b msib
    WHERE   TRUNC(mmt.transaction_date) > TRUNC(SYSDATE - 193) 
    AND     TRUNC(mmt.transaction_date) < TRUNC(SYSDATE - 103)
    --AND     mmt.transaction_type_id = 35 -- IN (33, 37, 35, 43) -- Venda e RMA, consumo prod e estorno de consumo prod
    AND     msib.organization_id    = 92              
    AND     msib.inventory_item_id  = 10295
    AND     mmt.inventory_item_id   = 10295
    AND     mmt.organization_id     = 92;