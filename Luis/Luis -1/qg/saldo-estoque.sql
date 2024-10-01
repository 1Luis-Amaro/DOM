SELECT org.organization_code,
       itm.segment1,
       inv.lot_number,
       inv.transaction_quantity,       
       expiration_date,
       origination_date,
       inv.subinventory_code,
       inventario.categoria
 from apps.mtl_onhand_quantities inv,
      apps.mtl_system_items_b itm,
      apps.mtl_lot_numbers lot,
      apps.mtl_parameters org,
      (SELECT MIC.INVENTORY_ITEM_ID,
              MIC.ORGANIZATION_ID,
              MIC.CATEGORY_SET_NAME,
              MIC.CATEGORY_CONCAT_SEGS CATEGORIA
         FROM APPS.MTL_ITEM_CATEGORIES_V MIC, APPS.MTL_CATEGORIES_V MC
        WHERE MC.CATEGORY_ID = MIC.CATEGORY_ID
          AND MIC.CATEGORY_SET_NAME IN ('Inventory')) inventario      
WHERE inventario.ORGANIZATION_ID   = ITM.ORGANIZATION_ID   AND
      inventario.INVENTORY_ITEM_ID = itm.INVENTORY_ITEM_ID AND
      --inventario.categoria         like '%PMC%'            AND
      lot.inventory_item_id(+)        = inv.inventory_item_id AND
      lot.lot_number      (+)         = inv.lot_number        AND
      itm.inventory_item_id        = inv.inventory_item_id AND
      itm.organization_id          = inv.organization_id   and
      --itm.segment1                 = 'PCT1N-8008.4P' and
      inv.organization_id          = org.organization_id and
      not org.organization_code like 'T%' and
      not org.organization_code like 'SG%';
      
      
SELECT mp.organization_code,
       itm.segment1,
       lot.lot_number,
       expiration_date,
       origination_date
 from apps.mtl_system_items_b itm,
      apps.mtl_lot_numbers    lot,
      apps.mtl_parameters     mp      
WHERE lot.inventory_item_id = ITM.inventory_item_id AND
      itm.organization_id   = 92                    AND
      itm.organization_id   = mp.organization_id    AND
      lot.organization_id   = mp.organization_id;
      
      
SELECT * FROM apps.MTL_LOT_NUMBERS;    

select * from apps.mtl_parameters;  