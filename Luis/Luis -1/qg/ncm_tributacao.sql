 

SELECT fcl.ROWID,
          fcl.fsc_cls_id,
          fcl.fiscal_classification_code,
          fcl.tax_category_id,
          brt.tax_category,
          fcl.tax_code,
          art.description,
          art.tax_rate,
          fcl.base_rate,
          fcl.start_date_active,
          fcl.end_date_active,
          fcl.enabled_flag,
          fcl.org_id,
          fcl.last_updated_by,
          fcl.last_update_date,
          fcl.last_update_login,
          fcl.creation_date,
          fcl.created_by,
          fcl.attribute_category,
          fcl.attribute1,
          fcl.attribute2,
          fcl.attribute3,
          fcl.attribute4,
          fcl.attribute5,
          fcl.attribute6,
          fcl.attribute7,
          fcl.attribute8,
          fcl.attribute9,
          fcl.attribute10,
          fcl.attribute11,
          fcl.attribute12,
          fcl.attribute13,
          fcl.attribute14,
          fcl.attribute15
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