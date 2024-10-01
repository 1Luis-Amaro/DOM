/* Formatted on 26/05/2015 17:44:04 (QP5 v5.227.12220.39724) */
  SELECT TRUNC (SYSDATE) AS CREATION_DATE,
         oinv.organization_code,
         dlxb.codigo_item,
         dlxb.nro_lote,
         ohq.subinventory_code SUBINVENTARIO,
         SUM (dlxb.CANTIDAD) CANTIDAD,
         SUM (OHQ.transaction_quantity) TRANSACTION_QUANTITY,
         SUM (OHQ.transaction_quantity - dlxb.CANTIDAD) DIFERENCIA
    FROM mtl_system_items_b itm,
         mtl_parameters oinv,
         fnd_lookup_values_vl lv,
         (  SELECT organization_id,
                   inventory_item_id,
                   subinventory_code,
                   lot_number,
                   SUM (transaction_quantity) transaction_quantity
              FROM mtl_onhand_quantities oh
          GROUP BY organization_id,
                   inventory_item_id,
                   subinventory_code,
                   lot_number) ohq,
         xxppg_inv_dhl_f_all dlxb
   WHERE     oinv.organization_id = dlxb.org_id
         AND ohq.organization_id = itm.organization_id
         AND ohq.inventory_item_id = itm.inventory_item_id
         AND ohq.subinventory_code = lv.description
         AND ohq.lot_number = dlxb.nro_lote
         AND ITM.ORGANIZATION_ID = dlxb.org_id
         AND ITM.SEGMENT1 = dlxb.codigo_item
         AND lv.view_application_id = 3
         AND LV.LOOKUP_TYPE = 'XPPGBR_SUBINVENTORY_DHL'
         AND LV.LOOKUP_CODE = dlxb.subinventario
         AND lv.enabled_flag = 'Y'
         AND SYSDATE BETWEEN NVL (lv.start_date_active, SYSDATE)
                         AND NVL (lv.end_date_active, SYSDATE)
         AND --     dlxb.codigo_item         = '135441.20'                 AND
            dlxb.ORG_ID = 92                                       --P_ORG_ID,
GROUP BY oinv.organization_code,
         dlxb.CODIGO_ITEM,
         dlxb.NRO_LOTE,
         ohq.subinventory_code,
         lv.description
UNION ALL
  SELECT TRUNC (SYSDATE) AS CREATION_DATE,
         oinv.organization_code,
         dlxb.CODIGO_ITEM,
         dlxb.NRO_LOTE,
         lv.description SUBINVENTARIO,
         SUM (dlxb.CANTIDAD) CANTIDAD,
         0 TRANSACTION_QUANTITY,
         0 DIFERENCIA
    FROM mtl_system_items_b itm,
         xxppg_inv_dhl_f_all dlxb,
         mtl_parameters oinv,
         fnd_lookup_values_vl lv
   WHERE     oinv.organization_id = dlxb.org_id
         AND itm.organization_id = dlxb.ORG_ID
         AND itm.segment1 = dlxb.CODIGO_ITEM
         AND lv.view_application_id = 3
         AND LV.LOOKUP_TYPE = 'XPPGBR_SUBINVENTORY_DHL'
         AND LV.LOOKUP_CODE = dlxb.subinventario
         AND lv.enabled_flag = 'Y'
         AND SYSDATE BETWEEN NVL (lv.start_date_active, SYSDATE)
                         AND NVL (lv.end_date_active, SYSDATE)
         AND       --   dlxb.codigo_item       = 'D789.11'                 AND
            dlxb.ORG_ID = 92                                      /*P_ORG_ID*/
         AND CODIGO_ITEM NOT IN
                (SELECT DISTINCT msi.SEGMENT1
                   FROM mtl_system_items_b msi, mtl_onhand_quantities ohq
                  WHERE     OHQ.ORGANIZATION_ID = ITM.ORGANIZATION_ID
                        AND OHQ.INVENTORY_ITEM_ID = ITM.INVENTORY_ITEM_ID
                        AND OHQ.SUBINVENTORY_CODE = lv.description
                        AND OHQ.LOT_NUMBER = dlxb.NRO_LOTE
                        AND msi.organization_id = ohq.organization_id
                        AND msi.inventory_item_id = ohq.inventory_item_id)
GROUP BY oinv.organization_code,
         dlxb.CODIGO_ITEM,
         dlxb.NRO_LOTE,
         lv.description
UNION ALL
  SELECT TRUNC (SYSDATE) AS CREATION_DATE,
         oinv.organization_code,
         itm.segment1,
         ohq.lot_number,
         ohq.subinventory_code SUBINVENTARIO,
         0 CANTIDAD,
         SUM (ohq.transaction_quantity) TRANSACTION_QUANTITY,
         SUM (ohq.transaction_quantity) DIFERENCIA
    FROM mtl_system_items_b ITM, MTL_ONHAND_QUANTITIES OHQ, mtl_parameters oinv
   WHERE     oinv.organization_id = ohq.organization_id
         AND itm.organization_id = ohq.organization_id
         AND itm.inventory_item_id = ohq.inventory_item_id
         AND ohq.subinventory_code IN
                (SELECT DISTINCT LV.description
                   FROM fnd_lookup_values_vl lv
                  WHERE     lv.view_application_id = 3
                        AND LV.LOOKUP_TYPE = 'XPPGBR_SUBINVENTORY_DHL'
                        AND LV.description = ohq.subinventory_code
                        AND lv.enabled_flag = 'Y'
                        AND SYSDATE BETWEEN NVL (lv.start_date_active, SYSDATE)
                                        AND NVL (lv.end_date_active, SYSDATE))
         AND OHQ.organization_id = 92                             /*P_ORG_ID*/
         AND itm.segment1 NOT IN
                (SELECT DISTINCT codigo_item
                   FROM xxppg_inv_dhl_f_all dlx, fnd_lookup_values_vl lv1
                  WHERE     dlx.org_id = oinv.organization_id
                        AND dlx.codigo_item = itm.segment1
                        AND dlx.subinventario = lv1.lookup_code
                        AND dlx.nro_lote = ohq.lot_number
                        AND lv1.view_application_id = 3
                        AND lv1.LOOKUP_TYPE = 'XPPGBR_SUBINVENTORY_DHL'
                        AND lv1.description = ohq.subinventory_code
                        AND lv1.enabled_flag = 'Y'
                        AND SYSDATE BETWEEN NVL (lv1.start_date_active,
                                                 SYSDATE)
                                        AND NVL (lv1.end_date_active, SYSDATE))
GROUP BY oinv.organization_code,
         itm.segment1,
         ohq.lot_number,
         ohq.subinventory_code,
         ohq.subinventory_code;