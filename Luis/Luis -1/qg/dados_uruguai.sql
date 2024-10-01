select mp.organization_code,
       msi.segment1,
       TRANSLATE(TRANSLATE(SUBSTR(MSI.DESCRIPTION,1,180),'ABCDEFGHIJKLMNOPQRSTUWVXYZabcdefghijklmnopqrstuwvxyz01234567890|—¡…Õ”⁄¿»Ã“Ÿ¬ Œ‘€√’ƒÀœ÷‹«Ò·ÈÌÛ˙‡ËÏÚ˘‚ÍÓÙ˚„ı‰ÎÔˆ¸Áñ∫™≤∞.-!"''`#$%().:[/]{}®+???ø;ß&¥*<>'
                                                        ,'ABCDEFGHIJKLMNOPQRSTUWVXYZabcdefghijklmnopqrstuwvxyz01234567890.NAEIOUAEIOUAEIOUAOAEIOUCnaeiouaeiouaeiouaoaeiouc-'),CHR(10),' ') "Descricao"
       ,
       mc.CROSS_REFERENCE_TYPE,
       mc.CROSS_REFERENCE,
       msi.INVENTORY_ITEM_STATUS_CODE,
       msi.INVOICE_ENABLED_FLAG,
       msi.item_type
  from apps.mtl_system_items_b      msi,
       apps.mtl_parameters          mp,
       APPS.MTL_CROSS_REFERENCES_V  mc,
       apps.HR_ORGANIZATION_UNITS_V hou,
       apps.hr_locations_v          hl 
 where mp.organization_id             = msi.organization_id   and
       mc.inventory_item_id(+)        = msi.inventory_item_id and
       MC.CROSS_REFERENCE_TYPE(+)     = 'GS1'                 and
       msi.INVENTORY_ITEM_STATUS_CODE = 'Active'              and
       msi.INVOICE_ENABLED_FLAG       = 'Y'                   and
       hou.organization_id            = msi.organization_id   and
       hl.location_id                 = hou.location_id       and
       mp.organization_code = 'MUH'; 
 
 
 SELECT * from APPS.MTL_CROSS_REFERENCES_V ;
 
 select * from apps.mtl_parameters     mp where organization_id = 83; MASTER_ORGANIZATION_ID;
 
 select * from apps.hr_locations_v where location_id in (141,
13951,
3446,
13950,
30183);
 select * from apps.HR_ORGANIZATION_UNITS_V where organization_id in (83,
115,
137,
459,
759) ;
 
 select mp.organization_code, hl.country
   from apps.hr_locations_v          hl,
        apps.mtl_parameters          mp,
        apps.HR_ORGANIZATION_UNITS_V hou
  where hl.location_id                 = hou.location_id and
        mp.organization_id             = hou.organization_id and mp.organization_id = 367;