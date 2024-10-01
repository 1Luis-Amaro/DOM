select * from apps.mtl_system_items_interface;

SELECT a.segment1, a.organization_id, b.source_lang, a.description, b.description, b.long_description from apps.mtl_system_items_b a, apps.mtl_system_items_tl b
where a.organization_id   = b.organization_id   and
      a.inventory_item_id = b.inventory_item_id and
      a.last_update_date < '04-FEB-2015';
      -- and
      --a.segment1 = 'KCC-8533';
      
select * from apps.mtl_system_items_tl;      


select * from apps.XXGMD_RECIPE_HDR_CNV_STG WHERE stg_process_status <> 'P';
