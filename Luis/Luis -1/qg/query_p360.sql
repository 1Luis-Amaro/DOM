select msi.segment1,
       msi.organization_id,
       mp.organization_code,
       msi.inventory_item_status_code,
      (select max(transaction_date)
         from apps.mtl_material_transactions mtt 
        where mtt.inventory_item_id = msi.inventory_item_id and
              mtt.organization_id   = msi.organization_id) "Last Transaction Date",
       to_char(trunc(msi.creation_date),'mm/dd/yyyy')      "Creation Date",
       to_char(trunc(msi.last_update_date),'mm/dd/yyyy')   "Last Update Date"
  from apps.mtl_system_items_b msi,
       apps.mtl_parameters     mp
 where msi.organization_id in (83,86,89,92,141,142,181,182) and
       msi.item_type in ('ACA','ACARV','INT','SEMI','MP','EMB') and
       mp.organization_id = msi.organization_id;
 
select * from mtl_material_transactions;

select * from apps.mtl_parameters;