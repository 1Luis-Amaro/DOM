SELECT --MSI.ITEM_TYPE               "Nome Template",
       MSI.SEGMENT1                "Código do Item",
       MP.ORGANIZATION_CODE        "Código da Organização",
       MSI.PRIMARY_UOM_CODE        "UN",
       msi.item_type               "Tipo item",
       phc.HAZARD_CLASS,
       pun.un_number,
       pun.description     
       --
--
  FROM APPS.MTL_SYSTEM_ITEMS MSI,
       APPS.MTL_PARAMETERS MP,
       APPS.MTL_SYSTEM_ITEMS_TL MST,
       apps.MTL_MATERIAL_STATUSES_VL MMS,
       apps.po_un_numbers pun,
       apps.po_hazard_classes phc
--
 WHERE 1 = 1
   AND MMS.STATUS_id(+)          = MSI.DEFAULT_LOT_STATUS_id
   AND MSI.ORGANIZATION_ID       = MP.ORGANIZATION_ID
   AND MSI.ORGANIZATION_ID       = MST.ORGANIZATION_ID
   AND MSI.INVENTORY_ITEM_ID     = MST.INVENTORY_ITEM_ID
   AND MST.LANGUAGE              = 'PTB'
   AND pun.un_number_id          = msi.un_number_id
   AND msi.organization_id       = 92
   AND phc.hazard_class_id       = MSI.HAZARD_CLASS_ID;
   
   AND MSI.SEGMENT1 = '4-3101';
   
SELECT * FROM apps.po_hazard_classes;
   
          and fcl.tax_category_id = brt.tax_category_id
          AND brt.tax_rule_set = sys.global_attribute13
          AND fcl.tax_code IS NOT NULL
          AND fcl.tax_code = art.tax_code
          AND NVL (art.tax_type, 'VAT') = 'VAT'
          AND NVL (art.tax_class, 'O') = 'O'
          AND NVL (art.enabled_flag, 'Y') = 'Y'
          AND art.set_of_books_id = sys.set_of_books_id
          AND NVL (fcl.org_id, -99) = NVL (brt.org_id, -99)
          AND NVL (fcl.org_id, -99) = NVL (art.org_id, -99)
          AND NVL (fcl.org_id, -99) = NVL (sys.org_id, -99)
          AND fcl.fiscal_classification_code = FISCAL_CLASSIFICATION.CATEGORIA
          AND brt.tax_category = 'IPI_C'
          AND fcl.tax_category_id =
                 DECODE (LTRIM (art.global_attribute1, '0123456789 '),
                         NULL, TO_NUMBER (art.global_attribute1),
                         NULL)
          AND fcl.start_date_active <=
                 NVL (art.end_date, TO_DATE ('4712/12/31', 'YYYY/MM/DD'))
          AND fcl.end_date_active >= art.start_date
          AND NOT EXISTS
                     (SELECT 1
                        FROM apps.ar_vat_tax art1
                       WHERE     art1.tax_code = art.tax_code
                             AND art1.set_of_books_id = art.set_of_books_id
                             AND NVL (art1.tax_type, 'VAT') = 'VAT'
                             AND NVL (art1.tax_class, 'O') = 'O'
                             AND NVL (art1.enabled_flag, 'Y') = 'Y'
                             AND art1.global_attribute1 =
                                    art.global_attribute1
                             AND art1.start_date > art.start_date
                             AND art1.start_date <= fcl.end_date_active)   

ORDER BY 2,3;




MTL_SYSTEM_ITEMS_TL T, MTL_SYSTEM_ITEMS_B B
    WHERE     B.INVENTORY_ITEM_ID = T.INVENTORY_ITEM_ID
          AND B.ORGANIZATION_ID = T.ORGANIZATION_ID
          AND T.LANGUAGE = USERENV ('LANG');





   SELECT fcl.fiscal_classification_code,
          brt.tax_category,
          art.tax_rate,
          fcl.base_rate,
          fcl.start_date_active,
          fcl.end_date_active,
          fcl.enabled_flag
     FROM jl_zz_ar_tx_fsc_cls_all fcl,
          jl_zz_ar_tx_categ_all brt,
          ar_vat_tax_all_b art,
          ar_system_parameters_all sys
    WHERE     fcl.tax_category_id = brt.tax_category_id
          AND brt.tax_rule_set = sys.global_attribute13
          AND fcl.tax_code IS NOT NULL
          AND fcl.tax_code = art.tax_code
          AND NVL (art.tax_type, 'VAT') = 'VAT'
          AND NVL (art.tax_class, 'O') = 'O'
          AND NVL (art.enabled_flag, 'Y') = 'Y'
          AND art.set_of_books_id = sys.set_of_books_id
          AND NVL (fcl.org_id, -99) = NVL (brt.org_id, -99)
          AND NVL (fcl.org_id, -99) = NVL (art.org_id, -99)
          AND NVL (fcl.org_id, -99) = NVL (sys.org_id, -99)
          AND fcl.fiscal_classification_code = '45049000'
          AND brt.tax_category = 'IPI_C'
          AND fcl.tax_category_id =
                 DECODE (LTRIM (art.global_attribute1, '0123456789 '),
                         NULL, TO_NUMBER (art.global_attribute1),
                         NULL)
          AND fcl.start_date_active <=
                 NVL (art.end_date, TO_DATE ('4712/12/31', 'YYYY/MM/DD'))
          AND fcl.end_date_active >= art.start_date
          AND NOT EXISTS
                     (SELECT 1
                        FROM ar_vat_tax art1
                       WHERE     art1.tax_code = art.tax_code
                             AND art1.set_of_books_id = art.set_of_books_id
                             AND NVL (art1.tax_type, 'VAT') = 'VAT'
                             AND NVL (art1.tax_class, 'O') = 'O'
                             AND NVL (art1.enabled_flag, 'Y') = 'Y'
                             AND art1.global_attribute1 =
                                    art.global_attribute1
                             AND art1.start_date > art.start_date
                             AND art1.start_date <= fcl.end_date_active)