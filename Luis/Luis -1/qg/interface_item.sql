--MKT-101001--
select long_description from apps.mtl_system_items_b where segment1 = 'MKT-101001';

select * from apps.mtl_system_items_tl;

select UNIT_WEIGHT from apps.mtl_system_items_interface;

SELECT count(*) FROM APPS.MTL_SYSTEM_ITEMS_INTERFACE;

SELECT segment1, RECEIVING_ROUTING_ID from APPS.MTL_SYSTEM_ITEMS_B WHERE organization_id = 88 and item_type like 'ACA%';

select organization_id, organization_code from apps.mtl_parameters;

SELECT distinct(organization_id) FROM APPS.MTL_SYSTEM_ITEMS_INTERFACE;

select * from apps.mtl_parameters where organization_id in (92);

select msi.segment1, mp.organization_code from apps.mtl_system_items_b msi, apps.mtl_parameters mp where msi.EXPENSE_ACCOUNT = -99999 and msi.organization_id = mp.organization_id;

