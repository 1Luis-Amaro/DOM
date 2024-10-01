select * from apps.gme_batch_header gbh where
   gbh.organization_id = 92 and batch_status in (1,2);
   
   
select COUNT(*) --SEGMENT1, msi.process_yield_subinventory, gmd.subinventory 
  from apps.gme_batch_header     gbh,
       apps.gme_material_details gmd,
       apps.mtl_system_items_b   msi 
 where gbh.organization_id             = 92                   and
       --h.batch_no        = 68897 and
       gmd.batch_id                    = gbh.batch_id          and
       gmd.line_type                   = 1                     and
       gmd.subinventory                = 'FAB'                 and
       msi.organization_id             = gbh.organization_id   and
       msi.inventory_item_id           = gmd.inventory_item_id and
       msi.process_yield_subinventory <> gmd.subinventory      and
       msi.item_type                   = 'ACA'                 AND
       msi.process_yield_subinventory  = 'FMT';

update apps.gme_material_details gmd
   set gmd.subinventory = 'FMT' 
 where gmd.line_type = 1 and
       gmd.batch_id in (select gmd.batch_id
                          from apps.gme_batch_header     gbh,
                               apps.gme_material_details gmd1,
                               apps.mtl_system_items_b   msi
                         where gbh.organization_id             = 92                   and
                               gmd1.batch_id                    = gbh.batch_id          and
                               gmd1.line_type                   = 1                     and
                               gmd1.subinventory                = 'FAB'                 and
                               msi.organization_id             = gbh.organization_id   and
                               msi.inventory_item_id           = gmd1.inventory_item_id and
                               msi.process_yield_subinventory <> gmd1.subinventory      and
                               msi.item_type                   = 'ACA'                 AND
                               msi.process_yield_subinventory  = 'FMT');     
                               
                               
select count (*)
  from apps.gme_material_details gmd
 where gmd.line_type = 1 and
       gmd.batch_id in (select gbh.batch_id
                          from apps.gme_batch_header     gbh,
                               apps.gme_material_details gmd1,
                               apps.mtl_system_items_b   msi
                         where gbh.organization_id             = 92                     and
                               gmd1.batch_id                   = gbh.batch_id           and
                               gmd1.line_type                  = 1                      and
                               gmd1.subinventory               = 'FAB'                  and
                               msi.organization_id             = gbh.organization_id    and
                               msi.inventory_item_id           = gmd1.inventory_item_id and
                               msi.process_yield_subinventory <> gmd1.subinventory      and
                               msi.item_type                   = 'ACA'                 AND
                               msi.process_yield_subinventory  = 'FMT');                                    