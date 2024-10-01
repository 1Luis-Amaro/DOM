SELECT calendar_date 
  FROM apps.BOM_CALENDAR_DATES
 WHERE calendar_code  = 'PPG SUM 3T'  and
       calendar_date >= '01/feb-2022' and
       calendar_date <= '31/jan-2023' order by 1 desc;
-- Select the dates for the Calendar --

select RESERVABLE_TYPE , mms.* from apps.MTL_MATERIAL_STATUSES_VL mms;

select * from apps.MTL_SECONDARY_INVENTORIES_FK_V;

select * from apps.mtl_system_items_b ;

select * from 
(
select msi.segment1,
       mp.organization_code,
       calendar_date,
       (select sum(mmt.transaction_quantity)
          from apps.mtl_material_transactions mmt,
               apps.MTL_SECONDARY_INVENTORIES_FK_V  ms,
               apps.MTL_MATERIAL_STATUSES_VL  mms
         where msi.inventory_item_id         = mmt.inventory_item_id              and
               msi.organization_id           = mmt.organization_id                and
               ms.SECONDARY_INVENTORY_NAME   = mmt.subinventory_code              and
               ms.organization_id            = mmt.organization_id                and
               mms.STATUS_CODE               = ms.STATUS_CODE                     and
               mmt.transaction_date          < calendar_date + 1                  and
               ms.RESERVABLE_TYPE            = 1) saldo
  from apps.mtl_system_items_b        msi,
       apps.mtl_parameters            mp,
       apps.BOM_CALENDAR_DATES        bcd
 where bcd.calendar_code          = 'PPG SUM 3T'                       and
       bcd.calendar_date         >= '01/feb-2022'                      and
       bcd.calendar_date         <= '31/jan-2023'                      and
       msi.item_type in ('ACA','ACARV','INT','SEMI','MP','EMB')
       msi.organization_id        = mp.organization_id)
  where saldo > 0;
       
SELECT * from apps.MTL_TRANSACTION_TYPES order by 1;       

WIP ISSUE - 35
SALES ISSUE - 33