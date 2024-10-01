SELECT ORG,
       TAG_NUMBER,
       SUBINVENTORY,
       ENDERECO,
       ITEM,
       ITEM_DESCRIPTION,
       LOT_NUMBER,
       VALIDADE,
       UOM,
       CONTAGEM,
       TAG_QUANTITY,
       TAG_UOM,
       STOCK_ENABLED_FLAG,
       COSTING_ENABLED_FLAG,
       STD_COST,
       PMA_COST,
       STD_VALUE,
       PMA_VALUE,
       SALDO_ESTOQUE,
       CATEGORIA_INVENTARIO,
       CATEGORIA_CUSTO,
       PHYSICAL_INVENTORY_NAME,
       (NVL (TAG_QUANTITY, 0) - NVL (SALDO_ESTOQUE, 0)) * PMA_COST
          DIF_VALUE_PMAC,
       (NVL (TAG_QUANTITY, 0) - NVL (SALDO_ESTOQUE, 0)) * STD_COST
          DIF_VALUE_STD,
       (NVL (TAG_QUANTITY, 0) - NVL (SALDO_ESTOQUE, 0)) DIF_QTY
  FROM (SELECT ''''||A.TAG_NUMBER TAG_NUMBER,
               (SELECT ORGANIZATION_CODE FROM APPS.MTL_PARAMETERS WHERE ORGANIZATION_ID = A.ORGANIZATION_ID) ORG,
               A.SUBINVENTORY,
               (SELECT SEGMENT1 || '.' || SEGMENT2 || '.' || SEGMENT3
                  FROM APPS.MTL_ITEM_LOCATIONS
                 WHERE INVENTORY_LOCATION_ID = A.LOCATOR_ID)
                  ENDERECO,
               ''''||MSI.SEGMENT1 ITEM,
               A.ITEM_DESCRIPTION,
               ''''||A.LOT_NUMBER LOT_NUMBER,
               LOT_EXPIRATION_DATE VALIDADE,
               MSI.PRIMARY_UOM_CODE UOM,
               '' CONTAGEM,
               A.TAG_QUANTITY,
               TAG_UOM,
               MSI.STOCK_ENABLED_FLAG,
               MSI.COSTING_ENABLED_FLAG,
               NVL (
                  (SELECT ROUND (SUM (ccd.cmpnt_cost), 2)
                     FROM apps.cm_cmpt_dtl ccd,
                          apps.cm_mthd_mst cmm,
                          apps.gmf_period_statuses gmf
                    WHERE     ccd.cost_type_id = cmm.cost_type_id
                          AND ccd.cost_type_id = gmf.cost_type_id
                          AND ccd.period_id = gmf.period_id
                          AND cmm.cost_mthd_code = 'STD'
                          AND ccd.inventory_item_id = msi.inventory_item_id
                          AND ccd.organization_id = msi.organization_id
                          AND b.creation_date BETWEEN gmf.start_date
                                                  AND gmf.end_date),
                  0)
                  std_cost,
               NVL (
                  (SELECT ROUND (SUM (ccd.cmpnt_cost), 2)
                     FROM apps.cm_cmpt_dtl ccd,
                          apps.cm_mthd_mst cmm,
                          apps.gmf_period_statuses gmf
                    WHERE     ccd.cost_type_id = cmm.cost_type_id
                          AND ccd.cost_type_id = gmf.cost_type_id
                          AND ccd.period_id = gmf.period_id
                          AND cmm.cost_mthd_code = 'PMAC'
                          AND ccd.inventory_item_id = msi.inventory_item_id
                          AND ccd.organization_id = msi.organization_id
                          AND b.creation_date BETWEEN gmf.start_date
                                                  AND gmf.end_date),
                  0)
                  pma_cost,
                 NVL (
                    (SELECT ROUND (SUM (ccd.cmpnt_cost), 2)
                       FROM apps.cm_cmpt_dtl ccd,
                            apps.cm_mthd_mst cmm,
                            apps.gmf_period_statuses gmf
                      WHERE     ccd.cost_type_id = cmm.cost_type_id
                            AND ccd.cost_type_id = gmf.cost_type_id
                            AND ccd.period_id = gmf.period_id
                            AND cmm.cost_mthd_code = 'STD'
                            AND ccd.inventory_item_id = msi.inventory_item_id
                            AND ccd.organization_id = msi.organization_id
                            AND b.creation_date BETWEEN gmf.start_date
                                                    AND gmf.end_date),
                    0)
               * tag_quantity
                  std_value,
                 NVL (
                    (SELECT ROUND (SUM (ccd.cmpnt_cost), 2)
                       FROM apps.cm_cmpt_dtl ccd,
                            apps.cm_mthd_mst cmm,
                            apps.gmf_period_statuses gmf
                      WHERE     ccd.cost_type_id = cmm.cost_type_id
                            AND ccd.cost_type_id = gmf.cost_type_id
                            AND ccd.period_id = gmf.period_id
                            AND cmm.cost_mthd_code = 'PMAC'
                            AND ccd.inventory_item_id = msi.inventory_item_id
                            AND ccd.organization_id = msi.organization_id
                            AND b.creation_date BETWEEN gmf.start_date
                                                    AND gmf.end_date),
                    0)
               * tag_quantity
                  pma_value,
               NVL (MOQ.QTDE, 0) SALDO_ESTOQUE,
               (SELECT MIC.CATEGORY_CONCAT_SEGS CATEGORIA
                  FROM APPS.MTL_ITEM_CATEGORIES_V MIC,
                       APPS.MTL_CATEGORIES_V MC
                 WHERE     MC.CATEGORY_ID = MIC.CATEGORY_ID
                       AND MIC.CATEGORY_SET_NAME = 'Inventory'
                       AND MIC.INVENTORY_ITEM_ID = MOQ.INVENTORY_ITEM_ID
                       AND MIC.ORGANIZATION_ID = MOQ.ORGANIZATION_ID)
                  CATEGORIA_INVENTARIO,
               (SELECT MIC.CATEGORY_CONCAT_SEGS CATEGORIA
                  FROM APPS.MTL_ITEM_CATEGORIES_V MIC,
                       APPS.MTL_CATEGORIES_V MC
                 WHERE     MC.CATEGORY_ID = MIC.CATEGORY_ID
                       AND MIC.CATEGORY_SET_NAME = 'Categoria de Custo'
                       AND MIC.INVENTORY_ITEM_ID = MOQ.INVENTORY_ITEM_ID
                       AND MIC.ORGANIZATION_ID = MOQ.ORGANIZATION_ID)
                  CATEGORIA_CUSTO,
               B.PHYSICAL_INVENTORY_NAME
          FROM APPS.MTL_PHYSICAL_INVENTORY_TAGS_V A,
               APPS.MTL_PHYSICAL_INVENTORIES_V B,
               APPS.MTL_SYSTEM_ITEMS_B MSI,
               (  SELECT MOQ.ORGANIZATION_ID,
                         MOQ.INVENTORY_ITEM_ID,
                         MOQ.SUBINVENTORY_CODE,
                         MOQ.LOT_NUMBER,
                         MOQ.LOCATOR_ID,
                            MIL.SEGMENT1
                         || '.'
                         || MIL.SEGMENT2
                         || '.'
                         || MIL.SEGMENT3
                         || '.'
                         || MIL.SEGMENT4
                         || '.'
                         || MIL.SEGMENT5
                            LOCAL_ESTOQUE,
                         SUM (MOQ.PRIMARY_TRANSACTION_QUANTITY) QTDE
                    FROM apps.MTL_ONHAND_QUANTITIES_DETAIL MOQ,
                         apps.MTL_ITEM_LOCATIONS MIL
                   WHERE     MOQ.LOCATOR_ID = MIL.INVENTORY_LOCATION_ID(+)
                         AND MOQ.ORGANIZATION_ID = MIL.ORGANIZATION_ID(+)
                GROUP BY MOQ.ORGANIZATION_ID,
                         MOQ.INVENTORY_ITEM_ID,
                         MOQ.SUBINVENTORY_CODE,
                         MOQ.LOT_NUMBER,
                         MOQ.LOCATOR_ID,
                            MIL.SEGMENT1
                         || '.'
                         || MIL.SEGMENT2
                         || '.'
                         || MIL.SEGMENT3
                         || '.'
                         || MIL.SEGMENT4
                         || '.'
                         || MIL.SEGMENT5) MOQ
         WHERE     A.INVENTORY_ITEM_ID = MSI.INVENTORY_ITEM_ID
               AND A.ORGANIZATION_ID = MSI.ORGANIZATION_ID
               AND A.PHYSICAL_INVENTORY_ID = B.PHYSICAL_INVENTORY_ID
               --  AND B.PHYSICAL_INVENTORY_NAME LIKE '%GVT%'
               AND A.INVENTORY_ITEM_ID = MOQ.INVENTORY_ITEM_ID(+)
               AND A.ORGANIZATION_ID = MOQ.ORGANIZATION_ID(+)
               AND A.SUBINVENTORY = MOQ.SUBINVENTORY_CODE(+)
               AND NVL (A.LOT_NUMBER, 0) = NVL (MOQ.LOT_NUMBER(+), 0)
               AND NVL (A.LOCATOR_ID, 0) = NVL (MOQ.LOCATOR_ID(+), 0)) OH
ORDER BY 1,2