select inventory_item_id from mtl_system_items_b where segment1 = 'SRC-75';

select * --plan_id, NETTABLE_INVENTORY_QUANTITY
  from MSC_SYSTEM_ITEMS msi where plan_id = 1021and item_name = 'AWW-1215'; /*Quantidade disponível no MRP*/

SELECT *
           FROM apps.msc_orders_v mo1 --, msc.msc_category_set_id_lid mcl
          WHERE     1 = 1
--                AND mo1.category_set_id = mcl.category_set_id
--                AND mcl.sr_category_set_id = p_category_set_id
                AND mo1.source_table = 'MSC_SUPPLIES'
                --AND TO_CHAR (NVL (mo1.old_due_date, mo1.new_due_date), 'MM/YYYY') =
                  --     TO_CHAR (ADD_MONTHS (SYSDATE, p_mes), 'MM/RRRR')
               -- AND mo1.order_type = 18                                                                  -- On Hand
--                AND mo1.inventory_item_id = 1234
--                AND mo1.organization_id = 92
--                AND mo1.plan_id = 5;
and plan_id = 1021
and item_segments = 'AWW-1215'
and organization_id = 92