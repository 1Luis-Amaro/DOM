select m.template_name,
       m1.user_attribute_name,
       m1.attribute_name,
       m1.report_user_value,
       m1.enabled_flag,
       m1.mandatory_flag
       --m1.*
  from apps.MTL_ITEM_TEMPLATES_ALL_V    m,
       apps.MTL_ITEM_TEMPL_ATTRIBUTES_V m1
 where m.template_id = m1.template_id
   and m.template_name not like '@%'
   and m1.user_attribute_name is not null;
 
  
select * from apps.MTL_ITEM_TEMPL_ATTRIBUTES_V
 ;