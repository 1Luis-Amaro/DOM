select * from apps.mtl_material_transactions 
 where transaction_id in (1770212518,1770357977,1765445840);
 
update apps.mtl_material_transactions
   set PRIMARY_QUANTITY = SECONDARY_TRANSACTION_QUANTITY
 where transaction_id in (1770212518);

delete from apps.mtl_onhand_quantities
 where inventory_item_id = 6776 and
       subinventory_code = 'DRE';
       
delete from mtl_onhand_quantities_detail
 where inventory_item_id = 6776 and
       subinventory_code = 'DRE';     


select * from apps.mtl_onhand_quantities
 where inventory_item_id = 6776 and
       subinventory_code = 'DRE';
       
select * from mtl_onhand_quantities_detail
 where inventory_item_id = 6776 and
       subinventory_code = 'DRE';       