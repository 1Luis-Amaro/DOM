SELECT INVENTORY_ITEM_ID FROM APPS.mtl_system_items_b WHERE SEGMENT1 = 'LT15103SSA.51';

select * from apps.MTL_SYSTEM_ITEMS_INTERFACE;

update apps.MTL_SYSTEM_ITEMS_INTERFACE set transaction_type = 'UPDATE';

select destination_organization_id,
       deliver_to_location_id 
  from  apps.po_distributions_all
 WHERE po_header_id = 1026364;