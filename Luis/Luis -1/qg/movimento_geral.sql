select msi.segment1,
       mp.organization_code,
       trunc(mmt.transaction_date),
       sum(abs(mmt.transaction_quantity))
  from apps.mtl_material_transactions mmt,
       apps.mtl_system_items_b        msi,
       apps.mtl_parameters            mp
 where msi.inventory_item_id  = mmt.inventory_item_id              and
       msi.organization_id    = mmt.organization_id                and
       msi.item_type       like 'MP%'  /* = 'MP' */                            and
       mmt.transaction_date  >= to_date('01/02/2022','dd/mm/yyyy') and
       mmt.transaction_date   < to_date('01/02/2023','dd/mm/yyyy') and
       msi.organization_id    = mp.organization_id                 and
       mmt.transaction_type_id = 35 --35
       group by mp.organization_code, trunc(mmt.transaction_date), msi.segment1 order by 2, 1, 3;
       
SELECT * from apps.MTL_TRANSACTION_TYPES order by 1;       

WIP ISSUE - 35
SALES ISSUE - 33