  select msibp.segment1,
         msibp.INVENTORY_ITEM_STATUS_CODE Status,
         inventario.CATEGORIA  "Categ Inventario",
         --msibp.unit_weight Peso_liquido,
         msibe.segment1 Embalagem,
         msibe.description,
         nvl(wci.max_load_quantity,1)   multiplo_embalagem
        ,msibp.minimum_license_quantity multiplo_venda
        ,nvl(msibe.unit_weight,0)       peso_embalagem
        ,nvl(msibp.unit_weight,0)       peso_liquido
       ,(nvl(msibe.unit_weight,0) / nvl(wci.max_load_quantity,1)) + nvl(msibp.unit_weight,0) Peso_bruto
    from wsh.wsh_container_items        wci
        ,inv.mtl_system_items_b         msibe
        ,inv.mtl_system_items_b         msibp
        ,(SELECT MIC.INVENTORY_ITEM_ID,
                 MIC.ORGANIZATION_ID,
                 MIC.CATEGORY_SET_NAME,
                 MIC.CATEGORY_CONCAT_SEGS CATEGORIA
            FROM APPS.MTL_ITEM_CATEGORIES_V MIC, APPS.MTL_CATEGORIES_V MC
           WHERE MC.CATEGORY_ID = MIC.CATEGORY_ID
             AND MIC.CATEGORY_SET_NAME IN ('Inventory')) INVENTARIO
--
   where wci.load_item_id  (+)          = MSIBP.inventory_item_id
     and wci.preferred_flag (+)         = 'Y'
     and msibe.organization_id (+)      = wci.master_organization_id
     and msibe.inventory_item_id (+)    = wci.container_item_id
     and wci.master_organization_id (+) = 92
     and msibp.organization_id          = 92
    -- and msibp.segment1                 LIKE 'TOEE-6355Z.C6'
     --
   AND msibp.ORGANIZATION_ID   = INVENTARIO.ORGANIZATION_ID(+)
   AND msibp.INVENTORY_ITEM_ID = INVENTARIO.INVENTORY_ITEM_ID(+)
   --
   AND inventario.CATEGORIA LIKE 'ACA%' -- Finished goods (Refinish)   
     
