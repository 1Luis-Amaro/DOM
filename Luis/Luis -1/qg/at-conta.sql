select segment1 from apps.mtl_system_items_b where segment1 like 'INTPMC%' AND organization_id = 92;

select concatenated_segments,
       code_combination_id,
       enabled_flag
  from apps.gl_code_combinations_kfv gc
 where concatenated_segments in ('3545-51002-3110-31100000-000000-0000-0000',
                                 '3545-51103-3110-31100000-000000-0000-0000',
                                 '3545-51104-3110-31100000-000000-0000-0000',
                                 '3545-51102-3110-31100000-000000-0000-0000',
                                 '3545-51000-3110-31100000-000000-0000-0000');

SELECT expense_account from apps.MTL_SYSTEM_ITEMS_INTERFACE;

select SALES_ACCOUNT from apps.mtl_system_items_b;


select concatenated_segments,
       code_combination_id,
       enabled_flag
  from apps.gl_code_combinations_kfv gc
 where concatenated_segments in ('3545-51102-6181-58101901-604000-1724-0000');
 
SELECT EXPENSE_ACCOUNT from apps.mtl_system_items_b where segment1 = 'D800' 