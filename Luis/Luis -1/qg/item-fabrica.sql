SELECT segment1,
       inventario.categoria,
       PROCESS_YIELD_SUBINVENTORY
  from apps.mtl_system_items_b msi,
        (SELECT MIC.INVENTORY_ITEM_ID,
               MIC.ORGANIZATION_ID,
               MIC.CATEGORY_SET_NAME,
               MIC.CATEGORY_CONCAT_SEGS CATEGORIA
          FROM APPS.MTL_ITEM_CATEGORIES_V MIC, APPS.MTL_CATEGORIES_V MC
         WHERE MC.CATEGORY_ID = MIC.CATEGORY_ID
           AND MIC.CATEGORY_SET_NAME IN ('Inventory')) INVENTARIO
 where msi.organization_id = 92 and
       msi.PROCESS_YIELD_SUBINVENTORY = 'FAB' and
       item_type = 'ACA' and
       MSI.ORGANIZATION_ID       = INVENTARIO.ORGANIZATION_ID(+) AND
       MSI.INVENTORY_ITEM_ID     = INVENTARIO.INVENTORY_ITEM_ID(+);