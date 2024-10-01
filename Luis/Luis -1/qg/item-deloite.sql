select segment1,
       global_attribute2,
       primary_uom_code,
       creation_date,
       description,
       FISCAL_CLASSIFICATION.categoria,
       item_type 
   from apps.mtl_system_items_b mic,
          (SELECT MIC.INVENTORY_ITEM_ID,
               MIC.ORGANIZATION_ID,
               MIC.CATEGORY_SET_NAME,
               MIC.CATEGORY_CONCAT_SEGS CATEGORIA
          FROM APPS.MTL_ITEM_CATEGORIES_V MIC, APPS.MTL_CATEGORIES_V MC
         WHERE MC.CATEGORY_ID = MIC.CATEGORY_ID
           AND MIC.CATEGORY_SET_NAME IN ('FISCAL_CLASSIFICATION')) FISCAL_CLASSIFICATION
   where mic.ORGANIZATION_ID = FISCAL_CLASSIFICATION.ORGANIZATION_ID(+)
     AND mic.INVENTORY_ITEM_ID = FISCAL_CLASSIFICATION.INVENTORY_ITEM_ID(+)
     and mic.organization_id = 87;

select * from apps.mtl_parameters;

select * from apps.mtl_system_items_b where organization_id = 87;