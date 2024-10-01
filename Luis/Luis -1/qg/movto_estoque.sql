select mp.organization_code,
       msi.segment1,
       msi.item_type,
       mt.SUBINVENTORY_CODE,
       mtt.transaction_type_name,
       mt.PRIMARY_QUANTITY,
       mt.transaction_date,
       oac.period_name
  from apps.mtl_parameters            mp, 
       apps.mtl_system_items_b        msi,
       apps.mtl_material_transactions mt,
       apps.MTL_TRANSACTION_TYPES     mtt,
       apps.org_acct_periods_v        oac
 where mtt.transaction_type_id = mt.transaction_type_id and
       oac.acct_period_id      = mt.acct_period_id      and
       mp.organization_id      = mt.organization_id     and
       msi.organization_id     = mt.organization_id     and
       msi.inventory_item_id   = mt.inventory_item_id   and
       mp.organization_code    = 'SUM'                  and
       mt.transaction_date    >= to_date('19/08/2023 16:00:00', 'dd/mm/yyyy hh24:mi:ss') and
       mt.transaction_date    <  to_date('01/01/2024 00:00:00', 'dd/mm/yyyy hh24:mi:ss');; 
       
select * from apps.MTL_TRANSACTION_TYPES mtt;  
select * from apps.mtl_material_transactions mt;

select * from apps.ORG_ACCT_PERIODS_V ;

select * from apps.ar_payment_schedules_all;     