SELECT msi.segment1 "Item",
       inventario.categoria,
       cv.TO_UOM_code "UN Destino",
       cv.CONVERSION_RATE,
       msi.primary_uom_code "UN Item",
       cv.DISABLE_DATE
       FROM apps.MTL_UOM_CLASS_CONVERSIONS cv, apps.mtl_system_items_b msi,
           (SELECT MIC.INVENTORY_ITEM_ID,
                   MIC.ORGANIZATION_ID,
                   MIC.CATEGORY_SET_NAME,
                   MIC.CATEGORY_CONCAT_SEGS CATEGORIA
              FROM APPS.MTL_ITEM_CATEGORIES_V MIC, APPS.MTL_CATEGORIES_V MC
             WHERE MC.CATEGORY_ID = MIC.CATEGORY_ID
               AND MIC.CATEGORY_SET_NAME IN ('Inventory')) INVENTARIO
/*para publicar no Excel4apps deve estar Inventário*/
 where cv.inventory_item_id    = msi.inventory_item_id        AND
       msi.organization_id     = INVENTARIO.ORGANIZATION_ID   AND
       msi.inventory_item_id   = INVENTARIO.INVENTORY_ITEM_ID AND
       msi.stock_enabled_flag  = 'Y'                          AND
       msi.inventory_item_flag = 'Y'                          AND
       msi.organization_id  = 87
