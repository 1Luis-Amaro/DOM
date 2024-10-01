                             SELECT 'AUT' KIT_SBU
                                    , FMD.ORGANIZATION_ID       ORG_ID
                                    , GRV.INVENTORY_ITEM_ID     ITEM_ID_KIT
                                    , MSI.SEGMENT1              ITEM_KIT
                                    , FMD.INVENTORY_ITEM_ID     ITEM_ID_FG
                                    , MSI2.SEGMENT1             ITEM_FG
                                    , MCB.CONCATENATED_SEGMENTS ITEM_CATEG
                                    , FMD.QTY                   ITEM_QTDE
                                    , ROW_NUMBER() 
                                 OVER (PARTITION BY GRV.INVENTORY_ITEM_ID
                                                  , FMD.INVENTORY_ITEM_ID
                                           ORDER BY GRV.INVENTORY_ITEM_ID
                                                  , GRV.PREFERENCE
                                                  , GR.RECIPE_ID  DESC
                                                  , GR.FORMULA_ID DESC ) PREFERENCE_SEQ
                                 FROM APPS.GMD_RECIPES               GR,
                                      APPS.GMD_RECIPE_VALIDITY_RULES GRV,
                                      APPS.FM_FORM_MST               FFM,
                                      APPS.FM_MATL_DTL               FMD,
                                      APPS.MTL_ITEM_CATEGORIES       MIC,
                                      APPS.MTL_CATEGORY_SETS_TL      MCS,
                                      APPS.MTL_CATEGORIES_KFV        MCB,
                                      apps.mtl_system_items_b        msi,
                                      apps.mtl_system_items_b        msi2
                                WHERE FFM.FORMULA_ID            = GR.FORMULA_ID
                                  AND GRV.RECIPE_ID             = GR.RECIPE_ID
                                  AND FFM.FORMULA_ID            = FMD.FORMULA_ID
                                  AND GRV.INVENTORY_ITEM_ID     = MIC.INVENTORY_ITEM_ID
                                  AND FMD.ORGANIZATION_ID       = MIC.ORGANIZATION_ID
                                  AND MIC.CATEGORY_SET_ID       = MCS.CATEGORY_SET_ID
                                  AND MIC.CATEGORY_ID           = MCB.CATEGORY_ID
                                  AND MCS.CATEGORY_SET_NAME     = 'PPG_BR_COM_SUB_FAMILIA'
                                  AND REGEXP_LIKE(MCB.SEGMENT1,   'MODULO PINTURA')
                                  AND MCS.LANGUAGE              = 'US'
                                  AND FFM.FORMULA_STATUS       IN (700,900)
                                  AND GRV.VALIDITY_RULE_STATUS IN (700,900)
                                  AND FMD.LINE_TYPE             = -1
                                  AND GRV.RECIPE_USE(+)         =  0
                                  AND msi.inventory_item_id     =  GRV.INVENTORY_ITEM_ID
                                  AND msi2.inventory_item_id    = FMD.INVENTORY_ITEM_ID
                                  AND msi.organization_id       = fmd.organization_id 
                                  AND msi2.organization_id       = fmd.organization_id
                                  order by 4, 2