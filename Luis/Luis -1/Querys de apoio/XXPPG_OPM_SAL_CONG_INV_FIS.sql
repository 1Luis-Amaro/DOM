  SELECT MOQ.ORGANIZATION_CODE,
         CODIGO_ITEM,
         DESCRIPTION,
         SUBINVENTORY_CODE,
         LOCAL,
         LOT_NUMBER,
         UOM,
         QTDE,
         INVENTORY_ITEM_ID,
         ORGANIZATION_ID,
         STOCK_ENABLED_FLAG,
         COSTING_ENABLED_FLAG,
         NVL (
            (SELECT ROUND (SUM (ccd.cmpnt_cost), 2)
               FROM apps.cm_cmpt_dtl ccd,
                    apps.cm_mthd_mst cmm,
                    apps.gmf_period_statuses gmf
              WHERE     ccd.cost_type_id = cmm.cost_type_id
                    AND ccd.cost_type_id = gmf.cost_type_id
                    AND ccd.period_id = gmf.period_id
                    AND cmm.cost_mthd_code = 'STD'
                    AND ccd.inventory_item_id = moq.inventory_item_id
                    AND ccd.organization_id = moq.organization_id
                    AND SYSDATE BETWEEN gmf.start_date AND gmf.end_date),
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
                    AND ccd.inventory_item_id = moq.inventory_item_id
                    AND ccd.organization_id = moq.organization_id
                    AND SYSDATE BETWEEN gmf.start_date AND gmf.end_date),
            0)
            pmac_cost,
           NVL (
              (SELECT ROUND (SUM (ccd.cmpnt_cost), 2)
                 FROM apps.cm_cmpt_dtl ccd,
                      apps.cm_mthd_mst cmm,
                      apps.gmf_period_statuses gmf
                WHERE     ccd.cost_type_id = cmm.cost_type_id
                      AND ccd.cost_type_id = gmf.cost_type_id
                      AND ccd.period_id = gmf.period_id
                      AND cmm.cost_mthd_code = 'STD'
                      AND ccd.inventory_item_id = moq.inventory_item_id
                      AND ccd.organization_id = moq.organization_id
                      AND SYSDATE BETWEEN gmf.start_date AND gmf.end_date),
              0)
         * MOQ.QTDE
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
                      AND ccd.inventory_item_id = moq.inventory_item_id
                      AND ccd.organization_id = moq.organization_id
                      AND SYSDATE BETWEEN gmf.start_date AND gmf.end_date),
              0)
         * MOQ.QTDE
            pmac_value,
         (SELECT MIC.CATEGORY_CONCAT_SEGS CATEGORIA
            FROM APPS.MTL_ITEM_CATEGORIES_V MIC, APPS.MTL_CATEGORIES_V MC
           WHERE     MC.CATEGORY_ID = MIC.CATEGORY_ID
                 AND MIC.CATEGORY_SET_NAME = 'Inventory'
                 AND MIC.INVENTORY_ITEM_ID = MOQ.INVENTORY_ITEM_ID
                 AND MIC.ORGANIZATION_ID = MOQ.ORGANIZATION_ID)
            CATEGORIA_INVENTARIO,
         (SELECT MIC.CATEGORY_CONCAT_SEGS CATEGORIA
            FROM APPS.MTL_ITEM_CATEGORIES_V MIC, APPS.MTL_CATEGORIES_V MC
           WHERE     MC.CATEGORY_ID = MIC.CATEGORY_ID
                 AND MIC.CATEGORY_SET_NAME = 'Categoria de Custo'
                 AND MIC.INVENTORY_ITEM_ID = MOQ.INVENTORY_ITEM_ID
                 AND MIC.ORGANIZATION_ID = MOQ.ORGANIZATION_ID)
            CATEGORIA_CUSTO
    FROM (  SELECT MP.ORGANIZATION_CODE,
                   ''''||MSI.SEGMENT1 CODIGO_ITEM,
                   MSI.DESCRIPTION,
                   MOQ.SUBINVENTORY_CODE,
                      MIL.SEGMENT1
                   || '.'
                   || MIL.SEGMENT2
                   || '.'
                   || MIL.SEGMENT3
                   || '.'
                   || MIL.SEGMENT4
                   || '.'
                   || MIL.SEGMENT5
                      LOCAL,
                   ''''||MOQ.LOT_NUMBER LOT_NUMBER,
                   MSI.PRIMARY_UOM_CODE UOM,
                   SUM (MOQ.PRIMARY_TRANSACTION_QUANTITY) QTDE,
                   MOQ.INVENTORY_ITEM_ID,
                   MOQ.ORGANIZATION_ID,
                   MSI.STOCK_ENABLED_FLAG,
                   MSI.COSTING_ENABLED_FLAG
              FROM apps.MTL_ONHAND_QUANTITIES_DETAIL MOQ,
                   apps.MTL_ITEM_LOCATIONS MIL,
                   apps.MTL_SYSTEM_ITEMS_B MSI,
                   apps.MTL_PARAMETERS MP,
                   apps.HR_ALL_ORGANIZATION_UNITS hou
             WHERE     MOQ.LOCATOR_ID = MIL.INVENTORY_LOCATION_ID(+)
                   AND MOQ.ORGANIZATION_ID = MIL.ORGANIZATION_ID(+)
                   AND MOQ.ORGANIZATION_ID = HOU.ORGANIZATION_ID
                   AND MOQ.INVENTORY_ITEM_ID = MSI.INVENTORY_ITEM_ID
                   AND MOQ.ORGANIZATION_ID = MSI.ORGANIZATION_ID
                   AND MOQ.ORGANIZATION_ID = MP.ORGANIZATION_ID
          --      AND MSI.SEGMENT1 IN('121186L.10')
          --AND MOQ.ORGANIZATION_ID = 86

          GROUP BY MP.ORGANIZATION_CODE || ' - ' || HOU.NAME,
                   MOQ.SUBINVENTORY_CODE,
                   MOQ.ORGANIZATION_ID,
                   MOQ.LOCATOR_ID,
                   MIL.DESCRIPTION,
                   MOQ.INVENTORY_ITEM_ID,
                   MSI.STOCK_ENABLED_FLAG,
                   MSI.COSTING_ENABLED_FLAG,
                   MSI.DESCRIPTION,
                   MP.ORGANIZATION_CODE,
                      MIL.SEGMENT1
                   || '.'
                   || MIL.SEGMENT2
                   || '.'
                   || MIL.SEGMENT3
                   || '.'
                   || MIL.SEGMENT4
                   || '.'
                   || MIL.SEGMENT5,
                   MSI.SEGMENT1,
                   MOQ.LOT_NUMBER,
                   MOQ.TRANSACTION_UOM_CODE,
                   MSI.PRIMARY_UOM_CODE,
                   MIL.ATTRIBUTE1) MOQ
ORDER BY 1,
         4,
         2,
         6