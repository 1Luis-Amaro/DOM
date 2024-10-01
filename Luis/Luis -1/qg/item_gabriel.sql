select segment1,
       inventario.categoria,
       DEFAULT_LOT_STATUS_id --segment1
  from apps.mtl_system_items_b msi,
         (SELECT MIC.INVENTORY_ITEM_ID,
               MIC.ORGANIZATION_ID,
               MIC.CATEGORY_SET_NAME,
               MIC.CATEGORY_CONCAT_SEGS CATEGORIA
          FROM APPS.MTL_ITEM_CATEGORIES_V MIC, APPS.MTL_CATEGORIES_V MC
         WHERE MC.CATEGORY_ID = MIC.CATEGORY_ID
           AND MIC.CATEGORY_SET_NAME IN ('Inventory')) INVENTARIO
--
 where msi.organization_id = 92 and 
       msi.DEFAULT_LOT_STATUS_id    = 324 and
       inventario.organization_id   = msi.organization_id   and
       inventario.inventory_item_id = msi.inventory_item_id and
       inventario.categoria     like 'ACA.AUT%'
       
       

SELECT status_id, status_code from apps.MTL_MATERIAL_STATUSES_VL order by 2;