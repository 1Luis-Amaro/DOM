SELECT MP.ORGANIZATION_CODE                                                  ORGANIZACAO
       ,MSI.SEGMENT1 /*|| '.' || MSI.SEGMENT2 || '.' || MSI.SEGMENT3*/       ITEM
       ,MSI.INVENTORY_ITEM_STATUS_CODE                                       STATUS
       ,MSIT.DESCRIPTION                                                     DESCRICAO
--       ,MSIT.LONG_DESCRIPTION                                                DESCRICAO_LONGA
       ,MSI.PRIMARY_UNIT_OF_MEASURE                                          UN_PRIM
       ,MSI.SECONDARY_UOM_CODE                                               UN_SEC
--
       ,MSI.ITEM_TYPE                                                        TIPO_ITEM
       ,MSI.GLOBAL_ATTRIBUTE2                                                UTILIZACAO_FISCAL          
--       
--
       ,DECODE(MSI.INVENTORY_ITEM_FLAG, 'Y', 'SIM', 'N', 'NAO')              ITEM_INVENTARIO
       ,DECODE(MSI.STOCK_ENABLED_FLAG, 'Y', 'SIM', 'N', 'NAO')               ITEM_ESTOCAVEL       
       ,DECODE(MSI.MTL_TRANSACTIONS_ENABLED_FLAG, 'Y', 'SIM', 'N', 'NAO')    ITEM_TRANSACIONAVEL
--
       ,DECODE(MSI.INVENTORY_ASSET_FLAG, 'Y', 'SIM', 'N', 'NAO')             VALOR_ATIVO_INVENTARIO
       ,DECODE(MSI.COSTING_ENABLED_FLAG, 'Y', 'SIM', 'N', 'NAO')             CUSTEADO
       ,DECODE(MSI.DEFAULT_INCLUDE_IN_ROLLUP_FLAG, 'Y', 'SIM', 'N', 'NAO')   ROLLUP
--
--       ,(SELECT CONCATENATED_SEGMENTS   FROM APPS.GL_CODE_COMBINATIONS_KFV GCC WHERE GCC.CODE_COMBINATION_ID =        MSI.EXPENSE_ACCOUNT)                                                 CONTA_DESPESA
--       ,(SELECT CONCATENATED_SEGMENTS   FROM APPS.GL_CODE_COMBINATIONS_KFV GCC WHERE GCC.CODE_COMBINATION_ID =        MSI.SALES_ACCOUNT)                                                   CONTA_VENDA       
       ,MC.CONCATENATED_SEGMENTS                                             CODIGO_CATEGORIA_INV
       ,MIC3.CATEGORY_CONCAT_SEGS                                            CODIGO_CATEGORIA_CUSTO       
--
--,MSI.*      
  FROM APPS.MTL_SYSTEM_ITEMS_B         MSI  
       ,APPS.MTL_PARAMETERS            MP
       ,APPS.MTL_SYSTEM_ITEMS_TL       MSIT
--       
       -- CATEGORIA INV
       ,APPS.MTL_CATEGORIES_B_KFV      MC
--       ,APPS.MTL_CATEGORIES_TL         MCT
       ,APPS.MTL_ITEM_CATEGORIES       MIC
       ,APPS.MTL_ITEM_CATEGORIES_V     MIC2
       ,APPS.MTL_ITEM_CATEGORIES_V     MIC3
       ,APPS.MTL_ITEM_CATEGORIES_V     MIC4
--       
--       
 WHERE MSI.ORGANIZATION_ID       = MP.ORGANIZATION_ID
-- AND   MP.ORGANIZATION_CODE = 'BEL'
-- AND   MSI.SEGMENT1 IN ('2036632','2102020')
 -- JOINS CATEGORIA INV
 AND   MSI.INVENTORY_ITEM_ID     = MIC.INVENTORY_ITEM_ID(+)
 AND   MSI.ORGANIZATION_ID       = MIC.ORGANIZATION_ID(+)
 AND   MIC.CATEGORY_ID           = MC.CATEGORY_ID(+)
-- AND   MIC.CATEGORY_ID           = MCT.CATEGORY_ID(+)
 AND   MSIT.ORGANIZATION_ID(+)   = MSI.ORGANIZATION_ID
 AND   MSIT.INVENTORY_ITEM_ID(+) = MSI.INVENTORY_ITEM_ID 
 AND   MIC.CATEGORY_SET_ID(+)    = 1
 --AND   MCT.LANGUAGE              = 'PTB'
 AND   MSIT.LANGUAGE             = 'PTB'
-- and   MCT.LANGUAGE(+)           = MSIT.LANGUAGE
 and   msi.inventory_item_id     = mic2.inventorY_item_id(+)
 and   msi.organization_id       = mic2.organization_id(+)
 and   msi.inventory_item_id     = mic3.inventorY_item_id(+)
 and   msi.organization_id       = mic3.organization_id(+)
 and   msi.inventory_item_id     = mic4.inventorY_item_id(+)
 and   msi.organization_id       = mic4.organization_id (+)
 and   mic2.category_set_name(+) like 'Compras'
 and   mic3.category_set_name(+) like 'Categoria de Custo'
 and   mic4.category_set_name(+) like 'FISCAL_CLASSIFICATION' -- and MSI.segment1 = 'D800'
 --ORDER BY 2,1
 ;
 
select count(*) from apps.mtl_system_items_b;
 