select * from apps.fnd_flex_values c where c.flex_value = '0000'

SELECT * from apps.fnd

select * from apps.dba_object;


  
SELECT a.flex_value_set_name, b.flex_value, b.description
  FROM apps.fnd_flex_value_sets a
     , apps.fnd_flex_values_vl  b
WHERE a.flex_value_set_id   = b.flex_value_set_id   
   AND a.flex_value_set_name LIKE 'XXGL_COST_CENTER' 
ORDER BY 1,2,3 
 
