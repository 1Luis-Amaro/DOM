select * from apps.mtl_parameters;

SELECT MESSAGE_TYPE,
       MESSAGE_ITEM,
       MESSAGE_ITEM_DESCR,
       ATTRIBUTE14 "Peso",
       ATTRIBUTE22 "DESCRICAO EMBALAGEM GVT1",
       ATTRIBUTE23 "DESCRICAO EMBALAGEM GVT2"
  from apps.XXPPG_PRINTER_MESSAGES_V A
 where MESSAGE_TYPE = 'INFORMACAO_ADICIONAL_ITEM'; and
       message_item = 'RV6092.45';
       
       
---------------
/* Formatted on 02/12/2020 00:38:53 (QP5 v5.294) */
SELECT NVL((SELECT ATTRIBUTE14
              FROM apps.XXPPG_PRINTER_MESSAGES_V A
             WHERE a.MESSAGE_TYPE = 'INFORMACAO_ADICIONAL_ITEM' AND
                   a.message_item = :xxppg_printer_operation.result_03),
           (SELECT CASE
                     WHEN (ROUND (
                              inv_convert.inv_um_convert (inventory_item_id,
                                                          primary_uom_code,
                                                          secondary_uom_code),
                              2)) < 1
                     THEN
                           ROUND (
                              inv_convert.inv_um_convert (inventory_item_id,
                                                          primary_uom_code,
                                                          'ml'),
                              2)
                        || ' ml'
                     ELSE
                           ROUND (
                              inv_convert.inv_um_convert (inventory_item_id,
                                                          primary_uom_code,
                                                          secondary_uom_code),
                              2)
                        || ' '
                        || UPPER (secondary_uom_code)
                  END
             FROM apps.mtl_system_items_b msib
            WHERE msib.organization_id = :xxppg_printer_operation.organization_id
              AND msib.segment1 = :xxppg_printer_operation.result_03)) from dual       