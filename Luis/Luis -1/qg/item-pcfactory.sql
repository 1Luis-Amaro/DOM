/* Formatted on 01/07/2015 14:18:12 (QP5 v5.227.12220.39724) */
  SELECT msi.segment1                                                   --, ftt.*
    FROM apps.mtl_system_items_b msi,
         (SELECT MIC.INVENTORY_ITEM_ID,
                 MIC.ORGANIZATION_ID,
                 MIC.CATEGORY_SET_NAME,
                 MIC.CATEGORY_CONCAT_SEGS CATEGORIA
            FROM APPS.MTL_ITEM_CATEGORIES_V MIC, APPS.MTL_CATEGORIES_V MC
           WHERE MC.CATEGORY_ID        = MIC.CATEGORY_ID
             AND MIC.CATEGORY_SET_NAME IN ('Inventory')) INVENTARIO         
   WHERE 1 = 1
         AND inventario.categoria like 'SEMI%'
         AND i1.ORGANIZATION_ID   = INVENTARIO.ORGANIZATION_ID
         AND i1.INVENTORY_ITEM_ID = INVENTARIO.INVENTORY_ITEM_ID
         --AND i1.segment1  like 'D800%'
