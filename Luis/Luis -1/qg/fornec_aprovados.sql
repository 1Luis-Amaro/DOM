

select msi.segment1,
       pas.owning_organization_name,
       pas.vendor_name,
       pas.vendor_business_type_dsp,
       pas.vendor_site_code,
       pas.primary_vendor_item,
       pas.asl_status_dsp,
       pas.vendor_id
  from apps.PO_ASL_SUPPLIERS_V           pas,
       apps.mtl_system_items_b           msi,
       apps.QA_SL_SP_RCV_CRITERIA_V      qss /*,
       apps.QA_SL_CRITERIA_ASSOCIATION_V qsc*/
       --
 where msi.inventory_item_id = pas.item_id                AND
       msi.organization_id   = pas.owning_organization_id AND
       --qsc.criteria_id       = qss.criteria_id            AND
       qss.vendor_id(+)      = pas.vendor_id              AND
       qss.item_id(+)        = pas.item_id;

select * from apps.QA_SL_CRITERIA_ASSOCIATION_V ORDER BY CRITERIA_ID; 


select * from apps.QA_SL_SP_RCV_CRITERIA_V ORDER BY CRITERIA_ID; 

select pas.owning_organization_name,
       pas.vendor_name,
       pas.vendor_business_type_dsp,
       pas.vendor_site_code,
       pas.primary_vendor_item,
       pas.asl_status_dsp,
       pas.vendor_id 
 
 Select * from apps.PO_ASL_SUPPLIERS_v          pas;