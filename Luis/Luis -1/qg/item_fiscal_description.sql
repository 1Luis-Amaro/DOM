SELECT MSI.ITEM_TYPE               "Nome Template",
       MSI.SEGMENT1                "CÛdigo do Item",
       MP.ORGANIZATION_CODE        "CÛdigo da OrganizaÁ„o",
       MSI.PRIMARY_UOM_CODE        "UN",
       msi.secondary_uom_code      "UN Secundaria",
       msi.item_type               "Tipo item",
       MSI.GLOBAL_ATTRIBUTE8       "Aplic do Item de Invent",
       MSI.GLOBAL_ATTRIBUTE2       "Classe da Cond da TransaÁ„o",
       MSI.GLOBAL_ATTRIBUTE3       "Origem do Item",
       MSI.GLOBAL_ATTRIBUTE4       "Tipo Fiscal do Item",
       MSI.GLOBAL_ATTRIBUTE6       "SituaÁ„o Trib Estadual",
       MSI.GLOBAL_ATTRIBUTE5       "SituaÁ„o Trib Federal",
       MSI.GLOBAL_ATTRIBUTE10      "EAN13",
       MSI.GLOBAL_ATTRIBUTE16      "Importar Conteudo",
       MSI.GLOBAL_ATTRIBUTE17      "Valor Parcela estrangeira",
       MSI.GLOBAL_ATTRIBUTE18      "Valor Total Envio Inter",
       MSI.GLOBAL_ATTRIBUTE19      "Numero FCI",       
       FISCAL_CLASSIFICATION.CATEGORIA "NCM",
       art.tax_rate,       
       MSI.INVENTORY_ITEM_STATUS_CODE,
       msi.RECEIVING_ROUTING_ID    "Roteiro Recebimento",
       MMS.STATUS_CODE             "Status Lote",
       TRANSLATE(TRANSLATE(SUBSTR(MSI.DESCRIPTION,1,80),'ABCDEFGHIJKLMNOPQRSTUWVXYZabcdefghijklmnopqrstuwvxyz01234567890—¡…Õ”⁄¿»Ã“Ÿ¬ Œ‘€√’ƒÀœ÷‹«Ò·ÈÌÛ˙‡ËÏÚ˘‚ÍÓÙ˚„ı‰ÎÔˆ¸Áñ∫™≤∞.-!"''`#$%().:[/]{}®+???ø;ß&¥*<>'
                                                       ,'ABCDEFGHIJKLMNOPQRSTUWVXYZabcdefghijklmnopqrstuwvxyz01234567890NAEIOUAEIOUAEIOUAOAEIOUCnaeiouaeiouaeiouaoaeiouc-'),CHR(10),' ') "Descricao",
       TRANSLATE(TRANSLATE(SUBSTR(MST.LONG_DESCRIPTION,1,180),'ABCDEFGHIJKLMNOPQRSTUWVXYZabcdefghijklmnopqrstuwvxyz01234567890—¡…Õ”⁄¿»Ã“Ÿ¬ Œ‘€√’ƒÀœ÷‹«Ò·ÈÌÛ˙‡ËÏÚ˘‚ÍÓÙ˚„ı‰ÎÔˆ¸Áñ∫™≤∞.-!"''`#$%().:[/]{}®+???ø;ß&¥*<>'
                                                             ,'ABCDEFGHIJKLMNOPQRSTUWVXYZabcdefghijklmnopqrstuwvxyz01234567890NAEIOUAEIOUAEIOUAOAEIOUCnaeiouaeiouaeiouaoaeiouc-'),CHR(10),' ') "Descricao Longa"
       --TRANSLATE(SUBSTR(MST.LONG_DESCRIPTION,1,180),CHR(10),' ') "Descricao Longa2"
--       
       --
--
  FROM APPS.MTL_SYSTEM_ITEMS MSI,
       APPS.MTL_PARAMETERS MP,
       APPS.MTL_SYSTEM_ITEMS_TL MST,
       apps.MTL_MATERIAL_STATUSES_VL MMS,
       apps.jl_zz_ar_tx_fsc_cls_all fcl,
          apps.jl_zz_ar_tx_categ_all brt,
          apps.ar_vat_tax_all_b art,
          apps.ar_system_parameters_all sys,
       (SELECT MIC.INVENTORY_ITEM_ID,
               MIC.ORGANIZATION_ID,
               MIC.CATEGORY_SET_NAME,
               MIC.CATEGORY_CONCAT_SEGS CATEGORIA
          FROM APPS.MTL_ITEM_CATEGORIES_V MIC, APPS.MTL_CATEGORIES_V MC
         WHERE MC.CATEGORY_ID = MIC.CATEGORY_ID
           AND MIC.CATEGORY_SET_NAME IN ('Inventory')) INVENTARIO,
       (SELECT MIC.INVENTORY_ITEM_ID,
               MIC.ORGANIZATION_ID,
               MIC.CATEGORY_SET_NAME,
               MIC.CATEGORY_CONCAT_SEGS CATEGORIA
          FROM APPS.MTL_ITEM_CATEGORIES_V MIC, APPS.MTL_CATEGORIES_V MC
         WHERE MC.CATEGORY_ID = MIC.CATEGORY_ID
           AND MIC.CATEGORY_SET_NAME IN ('FISCAL_CLASSIFICATION')) FISCAL_CLASSIFICATION
--
 WHERE 1 = 1
   AND MMS.STATUS_id(+)          = MSI.DEFAULT_LOT_STATUS_id
   AND MSI.ORGANIZATION_ID       = MP.ORGANIZATION_ID
   AND MSI.ORGANIZATION_ID       = MST.ORGANIZATION_ID
   AND MSI.INVENTORY_ITEM_ID     = MST.INVENTORY_ITEM_ID
   AND MST.LANGUAGE              = 'PTB'
   AND MSI.ORGANIZATION_ID       = INVENTARIO.ORGANIZATION_ID(+)
   AND MSI.INVENTORY_ITEM_ID     = INVENTARIO.INVENTORY_ITEM_ID(+)
   AND MSI.ORGANIZATION_ID       = FISCAL_CLASSIFICATION.ORGANIZATION_ID(+)
   AND MSI.INVENTORY_ITEM_ID     = FISCAL_CLASSIFICATION.INVENTORY_ITEM_ID(+)
   and (msi.item_type like 'ACA%' or
        msi.item_type = 'MP' and MSI.GLOBAL_ATTRIBUTE3 <> 0) 
   and msi.organization_id = 87
   --AND INVENTARIO.CATEGORIA LIKE '%REF%'
  -- AND msi.organization_id = 92
  -- and msi.organization_id = 92
 --  AND MSI.ITEM_TYPE LIKE 'ACA%'
  -- AND INVENTARIO.CATEGORIA LIKE '%REF%';
   --
  -- AND MSI.SEGMENT1 = '4-3101';
   --
 --  
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
--
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
     FROM apps.jl_zz_ar_tx_fsc_cls_all fcl,
          apps.jl_zz_ar_tx_categ_all brt,
          apps.ar_vat_tax_all_b art,
          apps.ar_system_parameters_all sys
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
         -- AND fcl.fiscal_classification_code = '45049000'
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