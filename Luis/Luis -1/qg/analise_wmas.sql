select * from apps.integracao i, apps.DOCUMENTO d 
 where d.SEQUENCIAINTEGRACAO   = i.SEQUENCIAINTEGRACAO and
       i.sequenciaintegracao = 5395078;
       
       
select * from apps.MOVIMENTOESTOQUE where   sequenciaintegracao = 5395083;      



xxppg_inv_alt_status_item_pkg.a_status_item_p;



SELECT dds.lotefabricacao
          , dds.quantidadeinicial
          , dds.sequenciaintegracao
          , dds.sequenciadocumento
          , dds.sequenciadetalhe 
       FROM documentodetalhesequencia  dds
      WHERE dds.lotefabricacao = 'B15070706' ;
      
      
      
/* Formatted on 22/02/2016 16:14:00 (QP5 v5.227.12220.39724) */
  SELECT ROW_ID,
         STATUS_ID,
         STATUS_CODE,
         ENABLED_FLAG,
         DESCRIPTION,
         RESERVABLE_TYPE,
         INVENTORY_ATP_CODE,
         AVAILABILITY_TYPE,
         ZONE_CONTROL,
         LOCATOR_CONTROL,
         LOT_CONTROL,
         SERIAL_CONTROL,
         ONHAND_CONTROL,
         LAST_UPDATED_BY,
         LAST_UPDATE_LOGIN,
         LAST_UPDATE_DATE,
         CREATED_BY,
         CREATION_DATE,
         REQUEST_ID,
         PROGRAM_APPLICATION_ID,
         PROGRAM_ID,
         PROGRAM_UPDATE_DATE,
         ATTRIBUTE1,
         ATTRIBUTE2,
         ATTRIBUTE3,
         ATTRIBUTE4,
         ATTRIBUTE5,
         ATTRIBUTE6,
         ATTRIBUTE7,
         ATTRIBUTE8,
         ATTRIBUTE9,
         ATTRIBUTE10,
         ATTRIBUTE11,
         ATTRIBUTE12,
         ATTRIBUTE13,
         ATTRIBUTE14,
         ATTRIBUTE15,
         ATTRIBUTE_CATEGORY,
         LPN_CONTROL
    FROM MTL_MATERIAL_STATUSES_VL
ORDER BY status_code      ;

select RESERVABLE_TYPE from apps.MTL_MATERIAL_STATUSES_VL where status_code = 'Quarentena'; 

 