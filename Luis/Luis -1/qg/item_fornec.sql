
 
SELECT MSI.ITEM_TYPE                   "Template",
       MSI.SEGMENT1                    "Item",
       MSI.DESCRIPTION                 "Descricao",
       MSI.PRIMARY_UOM_CODE            "UN",
       FISCAL_CLASSIFICATION.CATEGORIA "NCM",       
       inventario.CATEGORIA            "Ateg Inv",
       MSI.INVENTORY_ITEM_STATUS_CODE  "Status",  
       
       MSI.GLOBAL_ATTRIBUTE2           "Classe Trans",
       --MSI.GLOBAL_ATTRIBUTE3        "Origem do Item",
       MSI.GLOBAL_ATTRIBUTE4           "Com/Fab",
       MSI.GLOBAL_ATTRIBUTE6           "Cod Trib Estadual",
       MSI.GLOBAL_ATTRIBUTE5           "Cod Trib Federal",
       art.tax_rate                    "Aliq IPI",
       pas.primary_vendor_item         "Item Fornec",
       pv.vendor_name                  "Fornecedor",
       DECODE(Assa.Global_Attribute9
             ,2,(lpad(Assa.Global_Attribute10,9,'0') || Assa.Global_Attribute11 || Assa.Global_Attribute12)
             ,3,'E'||lpad(SUBSTR(Assa.Global_Attribute10,4,6),6,'0')||'000100'
             ,1,lpad(Assa.Global_Attribute10,9,'0')||Assa.Global_Attribute12) CNPJ,
       
       pas.primary_vendor_item "Item do Fornecedor"
       
  from apps.po_vendors                pv,
       apps.po_vendor_sites_all       pvs,
       apps.po_approved_supplier_list pas,
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
           AND MIC.CATEGORY_SET_NAME IN ('FISCAL_CLASSIFICATION')) FISCAL_CLASSIFICATION,
       apps.jl_zz_ar_tx_fsc_cls_all   fcl,
       apps.jl_zz_ar_tx_categ_all     brt,
       apps.ar_vat_tax_all_b          art,
       apps.ar_system_parameters_all  sys,           
       apps.mtl_system_items_b        msi,
       APPS.Ap_Supplier_Sites_All     Assa

       
  where PAS.VENDOR_SITE_ID = PVS.VENDOR_SITE_ID(+)                   AND
         ((PAS.VENDOR_SITE_ID          IS NOT NULL AND
           PVS.VENDOR_SITE_CODE        IS NOT NULL) OR 
          (PAS.VENDOR_SITE_ID          IS NULL     AND
           PVS.VENDOR_SITE_CODE        IS NULL))                     AND
        PAS.VENDOR_ID                   = PV.VENDOR_ID(+)            AND
        pas.item_id (+)                 = msi.inventory_item_id      AND
        pas.owning_organization_id (+)  = msi.organization_id        AND
        Assa.Vendor_Id(+)               = pas.Vendor_Id              AND
        fcl.tax_category_id             = brt.tax_category_id        AND
        brt.tax_rule_set                = sys.global_attribute13     AND
        fcl.tax_code                    IS NOT NULL                  AND
        fcl.tax_code                    = art.tax_code               AND
        NVL (art.tax_type, 'VAT')       = 'VAT'                      AND
        NVL (art.tax_class, 'O')        = 'O'                        AND
        NVL (art.enabled_flag, 'Y')     = 'Y'                        AND
        art.set_of_books_id             = sys.set_of_books_id        AND
        NVL (fcl.org_id, -99)           = NVL (brt.org_id, -99)      AND
        NVL (fcl.org_id, -99)           = NVL (art.org_id, -99)      AND
        NVL (fcl.org_id, -99)           = NVL (sys.org_id, -99)      AND
        fcl.fiscal_classification_code  = FISCAL_CLASSIFICATION.CATEGORIA AND
        brt.tax_category                = 'IPI_C'                         AND
        fcl.tax_category_id             = DECODE (LTRIM (art.global_attribute1, '0123456789 '),
                                                  NULL, TO_NUMBER (art.global_attribute1),
                                                  NULL)                   AND
        fcl.start_date_active          <= NVL (art.end_date, TO_DATE ('4712/12/31', 'YYYY/MM/DD')) AND
        fcl.end_date_active            >= art.start_date                  AND
        NOT EXISTS (SELECT 1
                      FROM apps.ar_vat_tax art1
                     WHERE art1.tax_code = art.tax_code                   AND
                           art1.set_of_books_id = art.set_of_books_id     AND
                           NVL (art1.tax_type, 'VAT') = 'VAT'             AND
                           NVL (art1.tax_class, 'O') = 'O'                AND
                           NVL (art1.enabled_flag, 'Y') = 'Y'             AND
                           art1.global_attribute1 = art.global_attribute1 AND
                           art1.start_date > art.start_date               AND
                           art1.start_date <= fcl.end_date_active)                   AND   
        
        MSI.ORGANIZATION_ID             = INVENTARIO.ORGANIZATION_ID(+)              AND
        MSI.INVENTORY_ITEM_ID           = INVENTARIO.INVENTORY_ITEM_ID(+)            AND
        MSI.ORGANIZATION_ID             = FISCAL_CLASSIFICATION.ORGANIZATION_ID(+)   AND
        MSI.INVENTORY_ITEM_ID           = FISCAL_CLASSIFICATION.INVENTORY_ITEM_ID(+) AND
        MSI.INVENTORY_ITEM_STATUS_CODE  = 'Active'
        
        --and msi.segment1 = 'SRC-75'
        ORDER BY 2;
        
        
SELECT INVENTORY_ITEM_STATUS_CODE from apps.mtl_system_items_b;        
select * from apps.PO_ASL_SUPPLIERS_V;        
        