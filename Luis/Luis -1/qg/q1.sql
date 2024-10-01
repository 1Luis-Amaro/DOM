SELECT DISTINCT aa.organization_code
              , item_segments
              , aa.organization_code
              , aa.category_set_id
              , aa.category_name
              , aa.order_type_text
              , aa.quantity_rate
  FROM apps.msc_orders_v aa
WHERE 1 = 1
   AND category_set_id = 1004
   AND plan_id = -1
   AND NOT EXISTS
           (SELECT *
              FROM apps.msc_orders_v a
             WHERE 1 = 1
               AND category_set_id = 1004
               AND aa.inventory_item_id = a.inventory_item_id
               AND plan_id > 0)
