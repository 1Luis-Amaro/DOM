select 
mti.transaction_type_id,mp.organization_code org, msi.segment1 item, mtli.lot_number, mtt.transaction_type_name,mti.subinventory_code,mti.transfer_subinventory
,round(apps.INV_CONVERT.INV_UM_CONVERT(mti.inventory_item_id, mti.transaction_uom, nvl(mti.secondary_uom_code,msi.secondary_uom_code)),2) convert_rate
,round(apps.INV_CONVERT.INV_UM_CONVERT(mti.inventory_item_id, mti.transaction_uom, nvl(mti.secondary_uom_code,msi.secondary_uom_code)),2) *mti.transaction_quantity new_sec_qty
,mti.transaction_uom,mti.transaction_quantity
,mtli.transaction_quantity lot_transaction_quantity
,mti.secondary_uom_code, mti.secondary_transaction_quantity
,mti.process_flag, mti.lock_flag, mti.error_code, mti.error_explanation

from apps.mtl_transactions_interface mti
,    apps.mtl_transaction_lots_interface mtli
,    apps.mtl_parameters mp
,    apps.mtl_system_items_b msi
,    apps.mtl_transaction_types mtt
where mti.transaction_interface_id = mtli.transaction_interface_id (+)
  and mti.organization_id = mp.organization_id
  and msi.organization_id = 87
  and mti.inventory_item_id = msi.inventory_item_id 
  and mti.transaction_type_id = mtt.transaction_type_id
  --and mti.source_code = 'DHL'
  and mti.process_flag = 3 -- ERROR
  --and mti.lock_flag = 2 -- UNLOCK
  --and mti.transaction_type_id = 2  -- Subinventory transfe
  --33 Sales Order issue
  
;



='begin

update apps.mtl_transactions_interface mti 
 set process_flag = 1, mti.secondary_transaction_quantity = round(apps.INV_CONVERT.INV_UM_CONVERT(mti.inventory_item_id, mti.transaction_uom, mti.secondary_uom_code),4)*mti.transaction_quantity 
where mti.process_flag = 3
and transaction_type_id in(52,33);

update apps.mtl_transaction_lots_interface mti 
 set process_flag = 1, mti.secondary_transaction_quantity = round(apps.INV_CONVERT.INV_UM_CONVERT((select inventory_item_id from apps.mtl_transactions_interface where transaction_interface_id = mti.transaction_interface_id), (select transaction_uom from apps.mtl_transactions_interface where transaction_interface_id = mti.transaction_interface_id), (select secondary_uom_code from apps.mtl_transactions_interface where transaction_interface_id = mti.transaction_interface_id)),4)*mti.transaction_quantity 
where transaction_interface_id in(select transaction_interface_id from apps.mtl_transactions_interface where transaction_type_id in(52,33))
 and (select transaction_uom from apps.mtl_transactions_interface where transaction_interface_id = mti.transaction_interface_id) is not null;

delete apps.mtl_transactions_interface mti  
where mti.process_flag = 3
and transaction_type_id in(2)
and error_code in(''Subinventário de transferência inválido'',''Subinventário inválido'');

commit;
end'

delete apps.mtl_transaction_lots_interface mti 
where transaction_interface_id not in(select transaction_interface_id from apps.mtl_transactions_interface);

update apps.mtl_transaction_lots_interface mti 
 set process_flag = 1, mti.transaction_quantity =  mti.transaction_quantity*-1
where mti.transaction_quantity < 0
 and transaction_interface_id in(select transaction_interface_id from apps.mtl_transactions_interface where transaction_type_id in(2))
;

delete from apps.mtl_transaction_lots_interface mtli
where mtli.transaction_interface_id in (select mti.transaction_interface_id from apps.mtl_transactions_interface mti
                                       where mti.transaction_interface_id = mtli.transaction_interface_id
                                         --and mti.source_code = 'DHL'
                                         and mti.process_flag = 3 -- ERROR
                                         and mti.lock_flag = 2 -- UNLOCK
                                         and mti.transaction_type_id = 2); -- Subinventory transfer

-- Exclui Transacao
delete from apps.mtl_transactions_interface mti
where 1=1--mti.source_code = 'DHL'
  and mti.process_flag = 3 -- ERROR
  and mti.lock_flag = 2 -- UNLOCK
  and mti.transaction_type_id = 2 -- Subinventory transfer


SELECT 'MTL_TRANSACTIONS_INTERFACE_V' TABELA, count(*) FROM APPS.MTL_TRANSACTIONS_INTERFACE_V  -- WHERE SOURCE_CODE = '1'
UNION ALL
SELECT 'MTL_TRANSACTION_LOTS_INTERFACE' TABELA,count(*) FROM APPS.MTL_TRANSACTION_LOTS_INTERFACE -- WHERE SOURCE_CODE = '1'
UNION ALL
SELECT 'MTL_SERIAL_NUMBERS_INTERFACE' TABELA,count(*) FROM APPS.MTL_SERIAL_NUMBERS_INTERFACE;

SELECT * FROM APPS.MTL_SECONDARY_INVENTORIES WHERE ORGANIZATION_ID = 329 FOR UPDATE;

SELECT INVENTORY_ITEM_ID,ITEM_DESCRIPTION,PRIMARY_UOM_CODE,ITEM_SEGMENT1,ORGANIZATION_ID,ORGANIZATION_CODE,ORGANIZATION_NAME,TRANSACTION_QUANTITY,PRIMARY_QUANTITY,TRANSACTION_UOM,TRANSACTION_DATE,ACCT_PERIOD_ID,SUBINVENTORY_CODE,LOCATOR_ID,TRANSACTION_SOURCE_NAME,TRANSACTION_SOURCE_TYPE_ID,TRANSACTION_SOURCE_TYPE_NAME,TRANSACTION_ACTION_ID,TRANSACTION_ACTION_NAME,TRANSACTION_TYPE_ID,TRANSACTION_TYPE_NAME,REASON_ID,REASON_NAME,TRANSACTION_REFERENCE,TRANSACTION_COST,DISTRIBUTION_ACCOUNT_ID,SECONDARY_TRANSACTION_QUANTITY,SECONDARY_UOM_CODE
, ERROR_CODE, ERROR_EXPLANATION FROM APPS.MTL_TRANSACTIONS_INTERFACE_V

UPDATE mtl_transactions_interface a 
set   INVENTORY_ITEM_ID  = (select distinct INVENTORY_ITEM_ID from mtl_system_items where segment1 = a.ITEM_SEGMENT1)
, SECONDARY_UOM_CODE = (select distinct SECONDARY_UOM_CODE from mtl_system_items where segment1 = a.ITEM_SEGMENT1)

SELECT * FROM APPS.MTL_ONHAND_QUANTITIES_DETAIL WHERE ORGANIZATION_ID = 329 AND INVENTORY_ITEM_ID = 4540789 FOR UPDATE;

SELECT * FROM APPS.MTL_TRANSACTIONS_INTERFACE WHERE TRANSACTION_HEADER_ID IN(60364970,60366754,64696402) FOR UPDATE;
SELECT * FROM APPS.MTL_TRANSACTION_LOTS_INTERFACE WHERE TRANSACTION_INTERFACE_ID IN(SELECT TRANSACTION_INTERFACE_ID FROM APPS.MTL_TRANSACTIONS_INTERFACE_V WHERE TRANSACTION_HEADER_ID IN(60364970,60366754,64696402)) FOR UPDATE;

SELECT * FROM APPS.MTL_TRANSACTION_LOTS_INTERFACE WHERE SOURCE_CODE = '1' FOR UPDATE;
SELECT * FROM APPS.MTL_SERIAL_NUMBERS_INTERFACE WHERE SOURCE_CODE = '1';

DELETE FROM APPS.MTL_TRANSACTIONS_INTERFACE;
DELETE FROM APPS.MTL_TRANSACTION_LOTS_INTERFACE WHERE PROCESS_FLAG IN(0,3);
DELETE FROM APPS.MTL_SERIAL_NUMBERS_INTERFACE;

SELECT * FROM apps.mtl_interface_errors
WHERE 1=1
AND CREATION_DATE > SYSDATE-32
AND TRANSACTION_ID IN(SELECT TRANSACTION_HEADER_ID FROM apps.mtl_transactions_interface
WHERE CREATION_DATE > SYSDATE-32--INVENTORY_ITEM_ID = 36327
)

select * from all_tables
where table_name like 'MTL%TRA%TEMP%';

SELECT * FROM APPS.MTL_TRANSACTIONS_TEMP_ALL_V
WHERE TRANSACTION_HEADER_ID = 49607423; --4540184
SELECT * FROM APPS.RCV_VIEW_INTERFACE_V


WHERE INVENTORY_ITEM_ID = 4540244;
WHERE 1=1
--AND organization_id = 114
--AND Trunc(TRANSACTION_DATE) < Trunc(SYSDATE) --inventory_item_id = 20913
AND inventory_item_id = 21126
--WHERE CREATION_DATE > SYSDATE-34 AND  CREATION_DATE <= SYSDATE-3;

select distribution_account_id from apps.MTL_MATERIAL_TRANSACTIONS
WHERE TRANSACTION_DATE < SYSDATE
--inventory_item_id = 21162 AND organization_id = 134 and creation_date > '24/12/2010';



SELECT * FROM apps.mtl_parameters;
SELECT PROCESS_FLAG,COUNT(*) FROM APPS.MTL_TRANSACTIONS_INTERFACE A WHERE ORGANIZATION_ID = '366'
AND inventory_item_id = '4540446' GROUP BY PROCESS_FLAG;

select distinct inventory_item_id,segment1,description from apps.mtl_system_items_b
where inventory_item_id in (
'4540541','4540446');


SELECT A.ORGANIZATION_ID, A.* FROM APPS.MTL_TRANSACTIONS_INTERFACE A WHERE SOURCE_HEADER_ID = 1 ORDER BY 1;
SELECT * FROM APPS.MTL_TRANSACTION_LOTS_INTERFACE WHERE SOURCE_LINE_ID = 1 ORDER BY 1;

--SELECT PROCESS_FLAG from apps.mtl_transaction_lots_interface;
UPDATE apps.mtl_transaction_lots_interface SET PROCESS_FLAG = 1;
UPDATE APPS.MTL_TRANSACTIONS_INTERFACE SET PROCESS_FLAG = 1;
UPDATE INV.MTL_TRANSACTION_LOTS_INTERFACE SET SOURCE_LINE_ID = 1;

DELETE FROM APPS.MTL_TRANSACTIONS_INTERFACE WHERE SOURCE_LINE_ID IN(733934,733795,733933);
--DELETE FROM APPS.MTL_TRANSACTIONS_INTERFACE WHERE SOURCE_HEADER_ID IN(329748,329533,329747);
DELETE FROM APPS.MTL_TRANSACTION_LOTS_INTERFACE WHERE SOURCE_LINE_ID is null;

SELECT * FROM DBA_SEQUENCES
WHERE SEQUENCE_NAME LIKE 'MTL%TRANS%'

SELECT * FROM APPS.MTL_TRANSACTION_LOTS_TEMP
WHERE TRANSACTION_TEMP_ID IN(
SELECT TRANSACTION_TEMP_ID FROM APPS.MTL_MATERIAL_TRANSACTIONS_TEMP
)

UPDATE APPS.MTL_TRANSACTIONS_INTERFACE SET LPN_ID = NULL

UPDATE apps.mtl_transactions_interface SET TRANSACTION_DATE = SYSDATE, CREATION_DATE = SYSDATE, LAST_UPDATE_DATE = SYSDATE

UPDATE APPS.MTL_TRANSACTIONS_INTERFACE SET LPN_ID = NULL

SELECT  DISTINCT inventory_item_id FROM apps.mtl_system_items;
WHERE segment1 IN('R570920002'); --,'N150555113','N151505010','N150555111');

--delete from apps.mtl_transactions_interface WHERE SOURCE_CODE <> 'CARGA INICIAL SALDO 09042012';
--delete from apps.mtl_transaction_lots_interface;
--UPDATE apps.MTL_MATERIAL_TRANSACTIONS_TEMP SET lock_flag = 'N',transaction_mode= 3 WHERE  TRANSACTION_HEADER_ID = 14097036;


SELECT * FROM APPS.MTL_TRANSACTIONS_INTERFACE_V;


select distinct(error_explanation) 
       --mti.*  
       from apps.mtl_transactions_interface mti
where 1=1 and mti.process_flag = 3 and mti.lock_flag = 2; --and mti.transaction_type_id = 2
and error_explanation like 'Saldos negativos não permitidos';

delete from apps.mtl_transactions_interface mti
where 1=1--mti.source_code = 'DHL'
  and mti.process_flag = 3 -- ERROR
  and mti.lock_flag = 2 -- UNLOCK
  --and mti.transaction_type_id = 2 -- Subinventory transfer
  --and error_explanation = 'Saldos negativos não permitidos'
  --and source_code like 'D%';
  and error_explanation = 'Saldos negativos não permitidos';
  
-- Ve erro com falta de associação item x org
select msi.segment1, mp.organization_code from apps.mtl_transactions_interface mti, apps.mtl_system_items_b msi, apps.mtl_parameters mp
where 1=1--mti.source_code = 'DHL'
  and mp.organization_id    = mti.organization_id
  and msi.organization_id   = 92
  and msi.inventory_item_id = mti.inventory_item_id
  and mti.process_flag = 3 -- ERROR
  and mti.lock_flag = 2 -- UNLOCK
  --and mti.transaction_type_id = 2 -- Subinventory transfer
  and error_explanation like 'O ID do%';



  
begin

update apps.mtl_transactions_interface mti 
 set process_flag = 1, mti.secondary_transaction_quantity = round(apps.INV_CONVERT.INV_UM_CONVERT(mti.inventory_item_id, mti.transaction_uom, mti.secondary_uom_code),4)*mti.transaction_quantity 
where mti.process_flag = 3
and transaction_type_id in(52,33,62);

update apps.mtl_transaction_lots_interface mti 
 set process_flag = 1, mti.secondary_transaction_quantity = round(apps.INV_CONVERT.INV_UM_CONVERT((select inventory_item_id from apps.mtl_transactions_interface where transaction_interface_id = mti.transaction_interface_id), (select transaction_uom from apps.mtl_transactions_interface where transaction_interface_id = mti.transaction_interface_id), (select secondary_uom_code from apps.mtl_transactions_interface where transaction_interface_id = mti.transaction_interface_id)),4)*mti.transaction_quantity 
where transaction_interface_id in(select transaction_interface_id from apps.mtl_transactions_interface where transaction_type_id in(52,33,62))
and (select transaction_uom from apps.mtl_transactions_interface where transaction_interface_id = mti.transaction_interface_id) is not null;

commit;
end;


---- Verifica os erros da interface ----

select distinct(error_explanation) 
       from apps.mtl_transactions_interface mti
where 1=1 and mti.process_flag = 3 and mti.lock_flag = 2;


select count(*) from apps.mtl_transactions_interface mti
where 1=1--mti.source_code = 'DHL'
  and mti.process_flag = 3 -- ERROR
  and mti.lock_flag = 2 -- UNLOCK
  --and mti.transaction_type_id = 2 -- Subinventory transfer
and error_explanation = 'Negative balances not allowed';

  