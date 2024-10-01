select mti.* from mtl_transactions_interface mti where TRANSACTION_INTERFACE_ID = 1310450062;
 
select  mti.* from mtl_transaction_lots_interface mti where TRANSACTION_INTERFACE_ID = 1310450062;

 select * from MTL_MATERIAL_TRANSACTIONS where organization_id = 182 and trunc(transaction_date) = '24-apr-2020'
 
 SELECT * from XXPPG_OWNED_INVENTORY;
 
select * from apps.per_people_f PPF where LAST_NAME like '%MARCELINO' OR LAST_NAME like '%Bianco%'

select PLANNING_MAKE_BUY_CODE from mtl_system_items_b where segment1 = '884.0001T'