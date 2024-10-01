select msi.segment1, MIC.CATEGORY_CONCAT_SEGS, MIC2.CATEGORY_CONCAT_SEGS 
  from mtl_system_items_b msi,
       APPS.MTL_ITEM_CATEGORIES_V MIC,
       APPS.MTL_ITEM_CATEGORIES_V MIC2
 where --msi.organization_id    in (181,182) and
       mic.inventory_item_id  = msi.inventory_item_id and
       mic.organization_id    = 87  and
       MIC.CATEGORY_SET_NAME IN ('Categoria de Custo') and
       mic2.inventory_item_id  = msi.inventory_item_id and
       mic2.organization_id    = msi.organization_id   and
       MIC2.CATEGORY_SET_NAME IN ('Categoria de Custo') and
       MIC.CATEGORY_CONCAT_SEGS<> MIC2.CATEGORY_CONCAT_SEGS;
select * from apps.MTL_ITEM_CATEGORIES_INTERFACE mi;
----- rodar este update -----
update apps.MTL_ITEM_CATEGORIES_INTERFACE mi
   set MI.OLD_CATEGORY_id =  
       (select MIC.CATEGORY_id
          from apps.mtl_system_items_b msi,
               APPS.MTL_ITEM_CATEGORIES_V MIC
         where msi.organization_id    = 87 and
               msi.segment1           = mi.item_number     and
               mic.inventory_item_id  = msi.inventory_item_id and
               mic.organization_id    = msi.organization_id   and
               MIC.CATEGORY_SET_id = 1);
----- rodar este update -----

SELECT msi.segment1, mic.category_set_name, mic.CATEGORY_CONCAT_SEGS
  FROM APPS.MTL_ITEM_CATEGORIES_V MIC,
       apps.mtl_system_items_b msi
 where msi.inventory_item_id = mic.inventory_item_id and
       msi.organization_id   = mic.organization_id and
       msi.organization_id   = 182 and
       mic.category_set_name in ('Inventory','Categoria de Custo','FISCAL_CLASSIFICATION') ORDER BY 1;

SELECT msi.segment1, mic.category_set_name, mic.CATEGORY_CONCAT_SEGS
  FROM APPS.MTL_ITEM_CATEGORIES_V MIC,
       apps.mtl_system_items_b msi
 where msi.inventory_item_id = mic.inventory_item_id and
       msi.organization_id   = mic.organization_id and
       mic.category_set_name like '%FIS%';


------Verificar item sem categoria associada à organização de inventários

select msi.segment1, msi.organization_id from apps.mtl_system_items_b msi
 where organization_id in (181,182) and
       inventory_item_id not in
      (select mic.inventory_item_id
          from APPS.MTL_ITEM_CATEGORIES_V MIC
         where msi.organization_id    = mic.organization_id and
               MIC.CATEGORY_SET_NAME IN ('Categoria de Custo'))

 select *
          from APPS.MTL_ITEM_CATEGORIES_V MIC
         where mic.organization_id    = 181 and
               MIC.CATEGORY_SET_NAME like 'Categoria de Custo'
 
SELECT me.* from mtl_system_items_interface ms, mtl_interface_errors me where me.transaction_id = ms.transaction_id  ;

SELECT me.* from apps.mtl_interface_errors me order by 6 desc;  where table_name = 'MTL_ITEM_CATEGORIES_INTERFACE';

  select MI.OLD_CATEGORY_ID, 
       (select MIC.CATEGORY_ID
          from mtl_system_items_b msi,
               APPS.MTL_ITEM_CATEGORIES_V MIC
         where msi.organization_id    = 87 and
               msi.segment1           = mi.item_number     and
               mic.inventory_item_id  = msi.inventory_item_id and
               mic.organization_id    = msi.organization_id   and
               MIC.CATEGORY_SET_NAME IN ('Inventory')) old
  from MTL_ITEM_CATEGORIES_INTERFACE mi;
  
 select * from  
  from MTL_ITEM_CATEGORIES_INTERFACE mi,
       mtl_system_items_b msi,
       APPS.MTL_ITEM_CATEGORIES_V MIC
 where msi.organization_id    = 87 and
       msi.segment1           = mi.item_number     and
       mic.inventory_item_id  = msi.inventory_item_id and
       mic.organization_id    = msi.organization_id   and
       MIC.CATEGORY_SET_NAME IN ('Inventory');


select msi.SEGMENT1 
  from MTL_ITEM_CATEGORIES_INTERFACE mi,
       mtl_system_items_b msi
 where msi.organization_id    = mi.organization_id and
       msi.segment1           = mi.item_number;

select * from APPS.MTL_ITEM_CATEGORIES_V MIC where
     category_set_name = 'FISCAL_CLASSIFICATION' and
     organization_id = 182;

'Inventory','Categoria de Custo','FISCAL_CLASSIFICATION')


select * from dba_objects where object_name like '%MTL_ITEM_CA%';

select * from
   apps.MTL_ITEM_CATEGORIES_INTERFACE mi;
       
update MTL_ITEM_CATEGORIES_INTERFACE mi
  set --CATEGORY_SET_NAME = 'Inventário'
      PROCESS_FLAG = 1

        SELECT MIC.INVENTORY_ITEM_ID,
               MIC.ORGANIZATION_ID,
               MIC.CATEGORY_SET_NAME,
               mic.category_set_id,
               MIC.CATEGORY_CONCAT_SEGS CATEGORIA
          FROM APPS.MTL_ITEM_CATEGORIES_V MIC, APPS.MTL_CATEGORIES_V MC
         WHERE MC.CATEGORY_ID = MIC.CATEGORY_ID
           AND MIC.CATEGORY_SET_NAME IN ('Inventory');
old_category_name

select distinct(msi.segment1)
  from apps.mtl_system_items_b msi, 
       apps.mtl_system_items_b msi2
 where msi.organization_id in (181,182) and
       msi.inventory_item_id = msi2.inventory_item_id and
       msi2.organization_id not in (181,182) and
       msi2.organization_id  <> 87;
       
select * from apps.MTL_ITEM_CATEGORIES_INTERFACE;       
       
 select * from apps.mtl_parameters
 
 select segment1 from apps.mtl_system_items_b where inventory_item_id in (2002834,
2002978,
2003833,
2004425,
2003051)

select * from apps.MTL_ITEM_CATEGORIES_INTERFACE mi
  where mi.inventory_item_id not in (select inventory_item_id from apps.mtl_system_items_b msi);