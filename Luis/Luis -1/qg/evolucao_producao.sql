select * from calendar_bom;


SELECT ROWID,CALENDAR_CODE,DESCRIPTION,QUARTERLY_CALENDAR_TYPE,CALENDAR_START_DATE,CALENDAR_END_DATE,DATABASE_IN_SYNC,LAST_UPDATE_LOGIN,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE_CATEGORY,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10,ATTRIBUTE11,ATTRIBUTE12,ATTRIBUTE13,ATTRIBUTE14,ATTRIBUTE15,REQUEST_ID,PROGRAM_APPLICATION_ID,PROGRAM_ID,PROGRAM_UPDATE_DATE FROM apps.BOM_CALENDARS  order by calendar_code

select * from apps.msc_calendar_dates mcd
 where mcd.calendar_code = 'PPG:PPG_BR' AND
       to_char(CALENDAR_date,'mm/yyyy') = to_char(sysdate,'mm/yyyy') order by 1;
       mcd.calendar_date between sysdate - 14 and sysdate + 17;


-------------
select segment1,
       mmt.transaction_date,
       mmt.transaction_quantity,
      (select max(calendar_date)
         from apps.msc_calendar_dates mcd
        where mcd.calendar_code = 'PPG:PPG_BR' AND
              calendar_date <= mmt.transaction_date AND
              seq_num       is not null) data_cal
  from apps.mtl_system_items_b msi,
       apps.mtl_material_transactions mmt
 where msi.item_type like 'ACA%' and
       msi.inventory_item_status_code = 'Active' and
       mmt.inventory_item_id          = msi.inventory_item_id and
       mmt.organization_id            = msi.organization_id   and
       mmt.transaction_type_id in (15,18,17,44)               and
       to_char(mmt.transaction_date,'mm/yyyy') = to_char(sysdate,'mm/yyyy') order by 1;
       