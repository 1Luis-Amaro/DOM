select msi.segment1,
       mp.organization_code,
       msi.item_type,
       msi.INVENTORY_ITEM_STATUS_CODE,
       gc.concatenated_segments conta_nova, 
       gc1.concatenated_segments conta_atual
  from apps.MTL_SYSTEM_ITEMS_INTERFACE msii,
       apps.mtl_system_items_b         msi,
       apps.mtl_parameters             mp,
       apps.gl_code_combinations_kfv   gc,
       apps.gl_code_combinations_kfv   gc1
   where msi.inventory_item_id          = msii.inventory_item_id and 
         msi.organization_id            = msii.organization_id   and
         --msi.INVENTORY_ITEM_STATUS_CODE = 'Active'               and
         mp.organization_id             = msi.organization_id    and
         gc.code_combination_id(+)      = msii.expense_account   and
         gc1.code_combination_id(+)     = msi.expense_account   and
         --msi.organization_id            <> 87                   and
         nvl(gc.concatenated_segments,1) <> nvl(gc1.concatenated_segments,1);
         
 select * from apps.gl_code_combinations_kfv   gc1  where ENABLED_FLAG = 'Y';    
 
 select organization_code, segment1, INVENTORY_ITEM_STATUS_CODE, PLANNING_MAKE_BUY_CODE from apps.MTL_SYSTEM_ITEMS_INTERFACE msii;
 
 SELECT * 
 FROM apps.fm_matl_dtl 
 WHERE formula_id IN ( 
 SELECT formula_id, batch_no 
 FROM apps.gme_batch_header 
 WHERE batch_id = 1260119); 
