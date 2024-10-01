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

-------------------- Verifica transação pendente ------------------
select *
from apps.mtl_material_transactions_temp
where transaction_source_type_id = 5
and   transaction_source_id = 4199405;
-------------------- Verifica transação pendente ------------------


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


select *  
       from apps.mtl_transactions_interface mti
where 1=1 and mti.process_flag = 3 and mti.lock_flag = 2 AND source_code = 'DHL'--and mti.transaction_type_id = 2
and error_explanation like 'Para essa linha de transação, os registros de lote estão faltando ou a quantidade do lote não equivale à quantidade da transação';

select *  from apps.mtl_transactions_interface mti
where 1=1--mti.source_code = 'DHL'
 -- and mti.process_flag = 3 -- ERROR
 -- and mti.lock_flag = 2 -- UNLOCK
  --and mti.transaction_type_id = 2 -- Subinventory transfer
  --and error_explanation = 'Saldos negativos não permitidos'
  --and source_code like 'D%';
  and error_explanation like '%negativo%'; 'Quantidade deve ser menor ou igual a Disponível para transacionar';
  
-- Ve erro com falta de associação item x org
select msi.segment1, mp.organization_code from apps.mtl_transactions_interface mti, apps.mtl_system_items_b msi, apps.mtl_parameters mp
where 1=1--mti.source_code = 'DHL'
  and mp.organization_id    = mti.organization_id
 -- and msi.organization_id   = 86 --mti.organization_id
  and msi.inventory_item_id = mti.inventory_item_id
 -- and mti.process_flag = 3 -- ERROR
  and mti.lock_flag = 2 -- UNLOCK
  --and mti.transaction_type_id = 2 -- Subinventory transfer
  and error_explanation like 'O ID do%';

----------------- Ve erro de conversão Itens com Lote ------------------
select mtii.transaction_interface_id,
       mti.process_flag,
       msi.segment1,
       mti.lot_number,
       mti.transaction_quantity,
       mti.secondary_transaction_quantity,
       round(apps.INV_CONVERT.INV_UM_CONVERT((select inventory_item_id
                                                from apps.mtl_transactions_interface
                                               where transaction_interface_id = mti.transaction_interface_id),
                                             (select transaction_uom
                                                from apps.mtl_transactions_interface
                                               where transaction_interface_id = mti.transaction_interface_id),
                                             (select secondary_uom_code
                                                from apps.mtl_transactions_interface
                                               where transaction_interface_id = mti.transaction_interface_id)),14) conv,
      (select sum(secondary_transaction_quantity) / sum(transaction_quantity)
         from apps.mtl_onhand_quantities moq where
              moq.inventory_item_id = mtii.inventory_item_id and
              moq.lot_number        = mti.lot_number) conv_inv
  from apps.mtl_transaction_lots_interface mti,
       apps.mtl_system_items_b             msi,
       apps.mtl_transactions_interface     mtii
 where mti.transaction_interface_id in
      (select transaction_interface_id
         from apps.mtl_transactions_interface mtii
        where mtii.transaction_type_id in(52,33,62)) and
             (select transaction_uom 
                from apps.mtl_transactions_interface mtii
               where mtii.transaction_interface_id = mti.transaction_interface_id) is not null and
                     msi.organization_id           = mtii.organization_id   and
                     msi.inventory_item_id         = mtii.inventory_item_id and
                     mtii.transaction_interface_id = mti.transaction_interface_id;
----------------- Ve erro de conversão Itens com lote ------------------

----------------- Ve erro de conversão Itens com Lote ------------------
select mti.transaction_interface_id,
       mti.process_flag,
       msi.segment1,
       mti.secondary_transaction_quantity,
       round(apps.INV_CONVERT.INV_UM_CONVERT((select inventory_item_id
                                                from apps.mtl_transactions_interface
                                               where transaction_interface_id = mti.transaction_interface_id),
                                             (select transaction_uom
                                                from apps.mtl_transactions_interface
                                               where transaction_interface_id = mti.transaction_interface_id),
                                             (select secondary_uom_code
                                                from apps.mtl_transactions_interface
                                               where transaction_interface_id = mti.transaction_interface_id)),14) conv,
      (select sum(secondary_transaction_quantity) / sum(transaction_quantity)
         from apps.mtl_onhand_quantities moq where
              moq.inventory_item_id = mti.inventory_item_id) conv_inv
  from apps.mtl_system_items_b             msi,
       apps.mtl_transactions_interface     mti
 where mti.transaction_type_id in(52,33,62) and
       msi.organization_id   = mti.organization_id   and
       msi.inventory_item_id = mti.inventory_item_id;
----------------- Ve erro de conversão ------------------

  
----------------- Acerta erro de conversão --------------
begin
update apps.mtl_transactions_interface mti 
 set process_flag = 1, mti.secondary_transaction_quantity = round(apps.INV_CONVERT.INV_UM_CONVERT(mti.inventory_item_id, mti.transaction_uom, mti.secondary_uom_code),4)*mti.transaction_quantity 
where mti.process_flag = 3
and transaction_type_id in(52,33,62);

update apps.mtl_transaction_lots_interface mti 
 set process_flag = 1, mti.secondary_transaction_quantity = round(apps.INV_CONVERT.INV_UM_CONVERT((select inventory_item_id from apps.mtl_transactions_interface where transaction_interface_id = mti.transaction_interface_id), (select transaction_uom from apps.mtl_transactions_interface where transaction_interface_id = mti.transaction_interface_id), (select secondary_uom_code from apps.mtl_transactions_interface where transaction_interface_id = mti.transaction_interface_id)),4)*mti.transaction_quantity 
where transaction_interface_id in(select transaction_interface_id from apps.mtl_transactions_interface where transaction_type_id in(52,33,62))
and (select transaction_uom from apps.mtl_transactions_interface where transaction_interface_id = mti.transaction_interface_id) is not null;


end;

/************* Ve o erro de stuck de PÓ *******************/
select msi.segment1, mti.subinventory_code, mti.* --distinct(error_explanation) 
       from apps.mtl_transactions_interface mti, apps.mtl_system_items_b msi
where 1=1 and mti.process_flag = 3 and mti.lock_flag = 2 and source_code = 'OPM' and error_explanation is not null
 and mti.organization_id = msi.organization_id and mti.inventory_item_id = msi.inventory_item_id;

---- Verifica os erros da interface ----
select * -- distinct(error_explanation) 
       from apps.mtl_transactions_interface mti
where 1=1 and
      mti.process_flag = 3 and
      mti.lock_flag    = 2 and
      error_explanation like 'O sub%';


---- Verifica os erros da interface Original----
select  mti.* --distinct error_explanation
       from apps.mtl_transactions_interface mti
where 1=1 and mti.process_flag = 3 and mti.lock_flag = 2; --and inventory_item_id = 6424;

select distinct error_explanation
       from apps.mtl_transactions_interface mti
where 1=1 and mti.process_flag = 3 and mti.lock_flag = 2;

---- Verifica registros da interface ---- ERRO OPM
select  mti.* --distinct error_explanation, mti.process_flag 
       from apps.mtl_transactions_interface mti WHERE SOURCE_CODE = 'OPM'; and inventory_item_id = 6219; and source_header_id = 738296 /*and trx_source_line_id = 2160911*/ and INVENTORy_item_id = 403540;

--delete apps.mtl_transactions_interface mti --distinct error_explanation, mti.process_flag 
--       WHERE SOURCE_CODE = 'OPM' and source_header_id = 738296 /*and trx_source_line_id = 2160911*/ and INVENTORy_item_id = 6229; transaction_quantity = -1.09375;
update apps.mtl_transactions_interface mti
   set inventory_item_id = 6043,
       primary_quantity  = 32,
       transaction_uom   = 'un'
       where transaction_interface_id = 333471041;

/***** Processo de ordem parados e não processando *****/
update apps.mtl_transactions_interface mti
  set validation_required = null,
      transaction_mode = 3
where 1=1 and mti.process_flag = 1 and mti.lock_flag = 2 and SOURCE_CODE = 'OPM';

/***** Ver Processo de ordem parados e não processando *****/
select * from apps.mtl_transactions_interface mti
where 1=1 and mti.process_flag = 1 and mti.lock_flag = 2;

select * from apps.mtl_transactions_interface mti
where 1=1--mti.source_code = 'DHL'
  and mti.process_flag = 3 -- ERROR
  and mti.lock_flag = 2 -- UNLOCK
  --and mti.transaction_type_id = 2 -- Subinventory transfer
and error_explanation is null;

  


/*** Resubmete tudo **/
update apps.mtl_transactions_interface mti 
 set process_flag = 1;


update apps.mtl_transaction_lots_interface mti 
 set process_flag = 1;

/*** Libera processamento de linhas com 'Stuck' ***/
update apps.mtl_transactions_interface mti
 set mti.lock_flag = 2
where mti.lock_flag = 1;

select * 
       from apps.mtl_transactions_interface mti
where 1=1 and mti.lock_flag = 1;

select * from apps.mtl_transactions_interface mti
 --set mti.lock_flag = 2
where mti.lock_flag = 1;

select * from apps.mtl_transactions_interface mti
 where mti.lock_flag = 1;
 
 
 ---- Verifica os erros da interface ----
select * from apps.mtl_transactions_interface mti 
where 1=1 and
      mti.process_flag = 3 and
      mti.lock_flag    = 2 and
     (error_explanation like 'O subinventário de transfer%' or
      error_explanation like 'Transfer subinv%')
      
update apps.mtl_transactions_interface mti 
  set transfer_subinventory = 'FAB' 
where 1=1 and
      mti.process_flag = 3 and
      mti.lock_flag    = 2 and
     (error_explanation like 'O subinventário de transfer%' or
      error_explanation like 'Transfer subinv%')

select TRANSACTION_QUANTITY, SECONDARY_TRANSACTION_QUANTITY from apps.mtl_transactions_interface mti where inventory_item_id = 393559;

---- Verifica registros OPM e Saldo Disponível para o processo.
select mti.inventory_item_id, msi.segment1,
       sum(mti.transaction_quantity),
       mti.inventory_item_id,
       mti.subinventory_code,
       sum(ohq.transaction_quantity),
       nvl(sum(ohq.transaction_quantity),0) + sum(mti.transaction_quantity) saldo,
       sum(mti.SECONDARY_TRANSACTION_QUANTITY) seq_saldo
  from apps.mtl_transactions_interface mti,
       apps.mtl_onhand_quantities      ohq,
       apps.mtl_system_items_b         msi
 where SOURCE_CODE              = 'OPM'                 and
       msi.organization_id      = mti.organization_id   and
       msi.inventory_item_id    = mti.inventory_item_id and
       ohq.organization_id(+)   = mti.organization_id   and
       ohq.inventory_item_id(+) = mti.inventory_item_id and
       ohq.subinventory_code(+) = mti.subinventory_code
 group by mti.inventory_item_id,
          mti.subinventory_code,
          msi.segment1;

select * from apps.mtl_transactions_interface mti where inventory_item_id = 6205;

update apps.mtl_transactions_interface
   set transfer_subinventory = 'FAB'
 WHERE ERROR_CODE = 'Subinventário de transferência inválido';

6300 - 1
6083 - 5

---- Verifica os erros da interface ----
select inventory_item_id,
       transaction_quantity -- distinct(error_explanation) 
       from apps.mtl_transactions_interface mti
where 1=1 and mti.process_flag = 3 and mti.lock_flag = 2 and source_code = 'XXPPG Subinventory Transfer'; and
error_explanation like 'Para essa linha de transaç%';

select * from apps.mtl_system_items_b where inventory_item_id = 403540 and organization_id = 92;


---- Verifica os erros da interface ----
select * 
  from apps.mtl_transactions_interface mti
where 1=1 and
 --mti.process_flag = 3 and mti.lock_flag = 2 and 
 inventory_item_id = 6083;

403540 - 30 - 5-3212
6083 - 10 - 24-4150

-----------------------------------------------------------------------------------------------
---- Verifica os erros da interface ----
update apps.mtl_transactions_interface mti
   set inventory_item_id    = 6083 , 
       transaction_quantity = 10,
       source_code          = 'XXPPG Subinventory Transfer'
where 1=1 and transaction_interface_id = 305671179;


select * --mti.subinventory_code, 
 from apps.mtl_transactions_interface mti
where transaction_interface_id = 305671173;

delete apps.mtl_transaction_lots_interface mti 
where transaction_interface_id = 305671173;

select * from apps.mtl_transaction_lots_interface mti 
where transaction_interface_id = 305671179;



subinventory_code = 'EMB',
transfer_subinventory = 'FAB'


305671173
305671179