SELECT mso.sales_order_number
      ,mso.demand_id
      ,mso.parent_demand_id
      ,mso.demand_source_header_id
      ,mso.demand_source_line
      ,mso.reservation_type
      ,mso.refresh_number
      ,mso.last_update_date
      ,msi.item_name
      ,mso.primary_uom_quantity
      ,mso.completed_quantity
      ,mso.requirement_date
FROM apps.msc_system_items msi
    ,apps.msc_sales_orders mso
WHERE msi.plan_id = -1 /* Collection Plan */
AND mso.sr_instance_id = msi.sr_instance_id /* Same Instance */
AND mso.organization_id = msi.organization_id
AND mso.inventory_item_id = msi.inventory_item_id
AND mso.inventory_item_id = 218385
AND mso.organization_id = 92
ORDER BY 1;


SELECT mpl.compile_designator
      ,msi.item_name
      ,msi.organization_code
      ,mrp_ml.meaning mrp_planning_desc
      ,msi.mrp_planning_code
      ,safety_ml.meaning safety_stock_desc
      ,msi.safety_stock_code
      ,msi.safety_stock_percent
      ,msi.safety_stock_bucket_days
      ,msi.fixed_safety_stock_qty
FROM apps.mfg_lookups mrp_ml
    ,apps.mfg_lookups safety_ml
    ,apps.msc_plans mpl
    ,apps.msc_system_items msi
WHERE 'MRP_PLANNING_CODE' = mrp_ml.lookup_type (+)
AND mrp_ml.lookup_code = msi.mrp_planning_code
AND 'MTL_SAFETY_STOCK_TYPE' = safety_ml.lookup_type (+)
AND safety_ml.lookup_code = msi.safety_stock_code (+)
AND msi.sr_instance_id = mpl.sr_instance_id
AND msi.plan_id = mpl.plan_id
AND msi.organization_id = 92
--AND msi.inventory_item_id IN ( 1496, 4594, 1639)
AND msi.safety_stock_code = 2
AND msi.safety_stock_bucket_days = 0
AND msi.safety_stock_percent IS NOT NULL
AND msi.plan_id = -1
ORDER BY 1, 2, 3;

select segment1, ITEM_TYPE, mp.organization_code
  from apps.mtl_system_items_b msi, apps.mtl_parameters mp
  where mp.organization_id            = msi.organization_id and
        mp.organization_code         <> 'ITM' AND
        msi.MRP_SAFETY_STOCK_CODE     = 2 and
        msi.safety_stock_bucket_days  = 0 and
        mrp_safety_stock_percent     <> 0;

