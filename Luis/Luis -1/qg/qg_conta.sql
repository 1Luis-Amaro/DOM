select * from apps.gl_code_combinations_kfv   gc1  where ENABLED_FLAG = 'Y' AND CONCATENATED_SEGMENTS = '3545-51000-4110-41100000-000000-0000-0000'; '3545-51000-2513-25130100-000000-9001-0000'; 

custos      = '3545-51000-4110-41100000-000000-0000-0000' - id 2032
faturamento = '3545-51000-2513-25130100-000000-9001-0000' - ID 1000


'3545-51004-5344-54409000-576920-0000-0000'

select CONCATENATED_SEGMENTS account,
       segment1 LOCATION, 
       segment2 MINOR,
       segment3 PRIME,
       segment4 SUBACCOUNT,
       segment5 COSTCENTER,
       segment6 PRODUCTLINE,
       segment7 INTERLOCATION
  from apps.gl_code_combinations_kfv   gc1  where ENABLED_FLAG = 'Y'
  ; 
  
  
select * from apps.gl_code_combinationS_V;   

select distinct
       b.CONCATENATED_SEGMENTS account,
       b.segment1 LOCATION, c.description LOCATION_DESC,
       b.segment2 MINOR, d.description MINOR_LOC_DESC,
       b.segment3 ACCOUNT, e.description ACCOUNT_DESC,
       b.segment4 SUB_ACCOUNT, f.description SUB_ACCOUNT_DESC,
       b.segment5 COST_CENTER, g.description COST_CNTR_DESC,
       b.segment6 PROD_LINE, h.description PROD_LINE_DESC,
       b.segment7 INTER_LOC, i.description INTER_LOC_DESC,
       b.enabled_flag
  from apps.gl_code_combinations_kfv b,
       apps.fnd_flex_values_vl c,-- XXGL_LOCATION
       apps.fnd_flex_value_sets c1,
       apps.fnd_flex_values_vl d,-- XXGL_MINOR_LOC
       apps.fnd_flex_value_sets d1,
       apps.fnd_flex_values_vl e,-- XXGL_ACCOUNT
       apps.fnd_flex_value_sets e1,
       apps.fnd_flex_values_vl f,-- XXGL_SUB_ACCOUNT
       apps.fnd_flex_value_sets f1,
       apps.fnd_flex_values_vl g,-- XXGL_COST_CENTER
       apps.fnd_flex_value_sets g1,
       apps.fnd_flex_values_vl h,-- XXGL_PROD_LINE
       apps.fnd_flex_value_sets h1,
       apps.fnd_flex_values_vl i,-- XXGL_INTER_LOC
       apps.fnd_flex_value_sets i1
 where b.segment1             = c.flex_value
   and c1.flex_value_set_id   = c.flex_value_set_id   
   and c1.flex_value_set_name LIKE 'XXGL_LOCATION'
   and b.segment2             = d.flex_value
   and d1.flex_value_set_id   = d.flex_value_set_id   
   and d1.flex_value_set_name LIKE 'XXGL_MINOR_LOCATION'
   and b.segment3             = e.flex_value
   and e1.flex_value_set_id   = e.flex_value_set_id   
   and e1.flex_value_set_name LIKE 'XXGL_ACCOUNT'
   and b.segment4             = f.flex_value
   and f1.flex_value_set_id   = f.flex_value_set_id   
   and f1.flex_value_set_name LIKE 'XXGL_SUB_ACCOUNT'
   and b.segment5             = g.flex_value
   and g1.flex_value_set_id   = g.flex_value_set_id   
   and g1.flex_value_set_name LIKE 'XXGL_COST_CENTER'
   and b.segment6             = h.flex_value
   and h1.flex_value_set_id   = h.flex_value_set_id   
   and h1.flex_value_set_name LIKE 'XXGL_PRODUCT_LINE'
   and b.segment7             = i.flex_value
   and i1.flex_value_set_id   = i.flex_value_set_id   
   and i1.flex_value_set_name LIKE 'XXGL_INTER_LOCATION'
   and b.ENABLED_FLAG         = 'Y'
   order by b.segment1, b.segment2