select * from apps.gme_batch_header where batch_no = 66491 and organization_id = 92;

select * from apps.gme_material_details where batch_id = 769643;

select formula_no from apps.FM_FORM_MST where formula_id = 95164;

select * from apps.mtl_material_transactions where organization_id = 92 /*and inventory_item_id like 5633*/ and transaction_source_id = 769643; and source_code = 'OPM';

select inventory_item_id from apps.mtl_system_items_b where segment1 = '5500088L.01';

SELECT distinct inventory_item_id, segment1 from apps.mtl_system_items_b where inventory_item_id in (5564,16030);

select * from apps.gmd_recipe_validity_rules where recipe_validity_rule_id >= 710000;

711002

select formula_no from apps.FM_FORM_MST fm 
   where (select count(*) 
            from apps.fm_matl_dtl   fmd
           where fmd.formula_id = fm.formula_id and
                 fmd.line_type = 1) > 1 and fm.formula_status in (700,900);


select * 
            from apps.fm_matl_dtl   fmd
