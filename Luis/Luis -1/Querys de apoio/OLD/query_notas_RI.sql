SELECT FU.USER_NAME                                    CRIADO_POR
         ,CFIT.INVOICE_TYPE_CODE                          TIPO_NF
         ,CFIT.INVOICE_TYPE_ID                            INV_TYPE_ID
         ,PV.VENDOR_NAME                                  FORNECEDOR_CLIENTE
         ,CFFEA.DOCUMENT_NUMBER                           CNPJ
         ,CFFEA.IE                                        I_E
         ,CFEO.OPERATION_ID                               NUMERO_RI
         ,CFI1.OPERATION_ID                               RI_REVERSAO
         ,CFEO.GL_DATE                                    DATA_DO_RI
         ,CFEO.STATUS                                     STATUS_DO_RI
         ,CFI.FISCAL_DOCUMENT_MODEL                       MODELO
         ,CFI.SERIES                                      SERIE
         ,CFI.SUBSERIES                                   SUBSERIE
         ,CFI.ELETRONIC_INVOICE_KEY                       CHAVE_NFE
         ,CFI.INVOICE_NUM                                 NUMERO_NF
         ,CFI.INVOICE_DATE                                DATA_NF
         ,NVL(CFI.INVOICE_AMOUNT,0)                       VALOR_NOTA_FISCAL
         ,AT.NAME                                         VENCTO_NF
         ,AT1.NAME                                        VENCTO_OC
         ,CFI.ICMS_TYPE                                   TIPO_ICMS
         ,NVL(CFI.ICMS_BASE,0)                            BASE_ICMS_HEADER
         ,NVL(CFI.ICMS_AMOUNT,0)                          VALOR_ICMS
         ,NVL(CFI.IPI_AMOUNT,0)                           VALOR_IPI
         ,NVL(CFI.ISS_AMOUNT,0)                           VALOR_ISS
         ,NVL(CFI.INSS_AMOUNT,0)                          VALOR_INSS
         ,NVL(CFI.IR_AMOUNT,0)                            VALOR_IR
         ,CFIU.UTILIZATION_CODE                           UTILIZACAO_FISCAL
         ,CFFO.CFO_CODE                                   CFO
         ,CFIL.OPERATION_FISCAL_TYPE                      NOP
         ,NVL(CFIL.ICMS_BASE,0)                           BASE_ICMS_LINES
         ,NVL(CFIL.ICMS_TAX,0)                            ICMS_TAX_LINES
         ,NVL(CFIL.ICMS_AMOUNT,0)                         VALOR_ICMS_LINES
         ,CFIL.ICMS_TAX_CODE                              TIPO_ICMS_LINES
         ,NVL(CFIL.ICMS_AMOUNT_RECOVER,0)                 ICMS_RECUPERADO_LINES
         ,CFIL.TRIBUTARY_STATUS_CODE                      CST_ICMS_LINES
         ,NVL(CFIL.IPI_BASE_AMOUNT,0)                     BASE_IPI_LINES
         ,NVL(CFIL.IPI_TAX,0)                             IPI_TAX_LINES
         ,NVL(CFIL.IPI_AMOUNT,0)                          VALOR_IPI_LINES
         ,CFIL.IPI_TAX_CODE                               TIPO_IPI_LINES
         ,NVL(CFIL.IPI_AMOUNT_RECOVER,0)                  IPI_RECUPERADO_LINES
         ,CFIL.IPI_TRIBUTARY_CODE                         CST_IPI_LINES
         ,NVL(CFIL.PIS_BASE_AMOUNT,0)                     BASE_PIS_LINES
         ,NVL(CFIL.PIS_TAX_RATE,0)                        PIS_TAX_RATE_LINES
         ,NVL(CFIL.PIS_AMOUNT_RECOVER,0)                  PIS_RECUPERADO_LINES
         ,CFIL.PIS_TRIBUTARY_CODE                         CST_PIS
         ,NVL(CFIL.COFINS_BASE_AMOUNT,0)                  BASE_COFINS
         ,NVL(CFIL.COFINS_TAX_RATE,0)                     COFINS_TAX_RATE
         ,NVL(CFIL.COFINS_AMOUNT_RECOVER,0)               COFINS_RECUPERADO
         ,CFIL.COFINS_TRIBUTARY_CODE                      CST_COFINS
         ,PHA.SEGMENT1                                    NUMERO_OC
         ,MSIB.SEGMENT1                                   CODIGO_ITEM         
         ,CFIL.QUANTITY                                   QUANTIDADE
         ,CFIL.UNIT_PRICE                                 PRECO_UNITARIO
         ,MCBI.SEGMENT1                                   CAT_INV
         ,MCBI.SEGMENT2                                   SBU
         ,MCBI.SEGMENT3                                   PL          
         ,CFFC.CLASSIFICATION_CODE                        NCM
         ,CFIL.ITEM_ID                                    ITEM_ID
         ,AWG.NAME                                        GRUPO_RET_IMP
         ,CFST.SERVICE_TYPE_CODE                          TIPO_SERVICO
         ,CFIT.COST_ADJUST_FLAG                           COMPL_COST
         ,CFI.INVOICE_ID                                  INVOICE_ID
         ,CFIL.INVOICE_LINE_ID                            INVOICE_LINE_ID
         ,CFI.FIRST_PAYMENT_DATE                          FIRST_PAYMENT_DATE
         ,CFIL.FCI_NUMBER                                FCI_NUMBER 
     FROM CLL_F189_ENTRY_OPERATIONS CFEO
         ,CLL_F189_INVOICES CFI
         ,CLL_F189_INVOICES CFI1
         ,CLL_F189_FISCAL_ENTITIES_ALL CFFEA
         ,PO_VENDORS PV
         ,PO_VENDOR_SITES_ALL PVSA
         ,FND_USER FU
         ,CLL_F189_INVOICE_LINES CFIL
         ,CLL_F189_ITEM_UTILIZATIONS CFIU
         ,CLL_F189_FISCAL_OPERATIONS CFFO
         ,CLL_F189_INVOICE_TYPES CFIT
         ,PO_LINES_ALL PLA
         ,PO_LINE_LOCATIONS_ALL PLLA
         ,MTL_SYSTEM_ITEMS_B MSIB
         ,AP_TERMS AT
         ,AP_TERMS AT1
         ,PO_HEADERS_ALL PHA
         ,CLL_F189_FISCAL_CLASS CFFC
         ,AP_AWT_GROUPS AWG
         ,CLL_F189_SERVICE_TYPES CFST         
         , MTL_CATEGORIES_B MCBI
         , MTL_CATEGORY_SETS MCSI
         , MTL_ITEM_CATEGORIES MICI                  
    WHERE CFEO.ORGANIZATION_ID           = CFI.ORGANIZATION_ID
      AND CFEO.OPERATION_ID              = CFI.OPERATION_ID
      AND CFEO.STATUS                    = 'COMPLETE'
      AND CFI.ENTITY_ID                  = CFFEA.ENTITY_ID
      AND CFI.INVOICE_ID                 = CFIL.INVOICE_ID
      AND CFI.INVOICE_TYPE_ID            = CFIT.INVOICE_TYPE_ID
      AND CFI.ORGANIZATION_ID            = CFIT.ORGANIZATION_ID
      AND CFIL.UTILIZATION_ID            = CFIU.UTILIZATION_ID
      AND CFIL.CFO_ID                    = CFFO.CFO_ID
      AND CFFEA.VENDOR_SITE_ID           = PVSA.VENDOR_SITE_ID
      AND PVSA.VENDOR_ID                 = PV.VENDOR_ID
      AND CFEO.CREATED_BY                = FU.USER_ID
      AND CFI.INVOICE_ID                 = CFI1.INVOICE_PARENT_ID (+)
      AND CFIL.LINE_LOCATION_ID          = PLLA.LINE_LOCATION_ID (+)
      AND PLLA.PO_LINE_ID                = PLA.PO_LINE_ID (+)
      AND PLA.PO_HEADER_ID               = PHA.PO_HEADER_ID (+)
      AND CFIL.ITEM_ID                   = MSIB.INVENTORY_ITEM_ID (+)
      AND CFIL.ORGANIZATION_ID           = MSIB.ORGANIZATION_ID (+)
      AND CFI.TERMS_ID                   = AT.TERM_ID
      AND PHA.TERMS_ID                   = AT1.TERM_ID (+)
      AND CFIL.CLASSIFICATION_ID         = CFFC.CLASSIFICATION_ID
      AND CFIL.AWT_GROUP_ID              = AWG.GROUP_ID (+)
      AND CFIL.FEDERAL_SERVICE_TYPE_ID   = CFST.SERVICE_TYPE_ID (+)      
      AND MCBI.STRUCTURE_ID = MCSI.STRUCTURE_ID       
      AND UPPER(MCSI.CATEGORY_SET_NAME) IN ('INVENTORY','INVENTÁRIO')
      AND MICI.CATEGORY_SET_ID = MCSI.CATEGORY_SET_ID
      AND MICI.INVENTORY_ITEM_ID = CFIL.ITEM_ID
      AND MICI.ORGANIZATION_ID = CFI.ORGANIZATION_ID
      AND MICI.CATEGORY_ID = MCBI.CATEGORY_ID                                                            
   UNION
   SELECT FU.USER_NAME                                    CRIADO_POR
         ,CFIT.INVOICE_TYPE_CODE                          TIPO_NF
         ,CFIT.INVOICE_TYPE_ID                            INV_TYPE_ID
         ,HP.PARTY_NAME                                   FORNECEDOR_CLIENTE
         ,CFFEA.DOCUMENT_NUMBER                           CNPJ
         ,CFFEA.IE                                        I_E
         ,CFEO.OPERATION_ID                               NUMERO_RI
         ,CFI1.OPERATION_ID                               RI_REVERSAO
         ,CFEO.GL_DATE                                    DATA_DO_RI
         ,CFEO.STATUS                                     STATUS_DO_RI
         ,CFI.FISCAL_DOCUMENT_MODEL                       MODELO
         ,CFI.SERIES                                      SERIE
         ,CFI.SUBSERIES                                   SUBSERIE
         ,CFI.ELETRONIC_INVOICE_KEY                       CHAVE_NFE
         ,CFI.INVOICE_NUM                                 NUMERO_NF
         ,CFI.INVOICE_DATE                                DATA_NF
         ,NVL(CFI.INVOICE_AMOUNT,0)                       VALOR_NOTA_FISCAL
         ,AT.NAME                                         VENCTO_NF
         ,NULL                                            VENCTO_OC
         ,CFI.ICMS_TYPE                                   TIPO_ICMS
         ,NVL(CFI.ICMS_BASE,0)                            BASE_ICMS_HEADER
         ,NVL(CFI.ICMS_AMOUNT,0)                          VALOR_ICMS
         ,NVL(CFI.IPI_AMOUNT,0)                           VALOR_IPI
         ,NVL(CFI.ISS_AMOUNT,0)                           VALOR_ISS
         ,NVL(CFI.INSS_AMOUNT,0)                          VALOR_INSS
         ,NVL(CFI.IR_AMOUNT,0)                            VALOR_IR
         ,CFIU.UTILIZATION_CODE                           UTILIZACAO_FISCAL
         ,CFFO.CFO_CODE                                   CFO
         ,CFIL.OPERATION_FISCAL_TYPE                      NOP
         ,NVL(CFIL.ICMS_BASE,0)                           BASE_ICMS_LINES
         ,NVL(CFIL.ICMS_TAX,0)                            ICMS_TAX_LINES
         ,NVL(CFIL.ICMS_AMOUNT,0)                         VALOR_ICMS_LINES
         ,CFIL.ICMS_TAX_CODE                              TIPO_ICMS_LINES
         ,NVL(CFIL.ICMS_AMOUNT_RECOVER,0)                 ICMS_RECUPERADO_LINES
         ,CFIL.TRIBUTARY_STATUS_CODE                      CST_ICMS_LINES
         ,NVL(CFIL.IPI_BASE_AMOUNT,0)                     BASE_IPI_LINES
         ,NVL(CFIL.IPI_TAX,0)                             IPI_TAX_LINES
         ,NVL(CFIL.IPI_AMOUNT,0)                          VALOR_IPI_LINES
         ,CFIL.IPI_TAX_CODE                               TIPO_IPI_LINES
         ,NVL(CFIL.IPI_AMOUNT_RECOVER,0)                  IPI_RECUPERADO_LINES
         ,CFIL.IPI_TRIBUTARY_CODE                         CST_IPI_LINES
         ,NVL(CFIL.PIS_BASE_AMOUNT,0)                     BASE_PIS_LINES
         ,NVL(CFIL.PIS_TAX_RATE,0)                        PIS_TAX_RATE_LINES
         ,NVL(CFIL.PIS_AMOUNT_RECOVER,0)                  PIS_RECUPERADO_LINES
         ,CFIL.PIS_TRIBUTARY_CODE                         CST_PIS
         ,NVL(CFIL.COFINS_BASE_AMOUNT,0)                  BASE_COFINS
         ,NVL(CFIL.COFINS_TAX_RATE,0)                     COFINS_TAX_RATE
         ,NVL(CFIL.COFINS_AMOUNT_RECOVER,0)               COFINS_RECUPERADO
         ,CFIL.COFINS_TRIBUTARY_CODE                      CST_COFINS
         ,NULL                                            NUMERO_OC
         ,MSIB.SEGMENT1                                   CODIGO_ITEM         
         ,CFIL.QUANTITY                                   QUANTIDADE
         ,CFIL.UNIT_PRICE                                 PRECO_UNITARIO
         ,MCBI.SEGMENT1                                   CAT_INV
         ,MCBI.SEGMENT2                                   SBU
         ,MCBI.SEGMENT3                                   PL                           
         ,CFFC.CLASSIFICATION_CODE                        NCM
         ,CFIL.ITEM_ID                                    ITEM_ID
         ,AWG.NAME                                        GRUPO_RET_IMP
         ,CFST.SERVICE_TYPE_CODE                          TIPO_SERVICO
         ,CFIT.COST_ADJUST_FLAG                           COMPL_COST
         ,CFI.INVOICE_ID                                  INVOICE_ID
         ,CFIL.INVOICE_LINE_ID                            INVOICE_LINE_ID
         ,CFI.FIRST_PAYMENT_DATE                          FIRST_PAYMENT_DATE
         ,CFIL.FCI_NUMBER                                FCI_NUMBER
     FROM CLL_F189_ENTRY_OPERATIONS CFEO
         ,CLL_F189_INVOICES CFI
         ,CLL_F189_INVOICES CFI1
         ,CLL_F189_FISCAL_ENTITIES_ALL CFFEA
         ,HZ_CUST_SITE_USES_ALL HCSUA    
         ,HZ_CUST_ACCT_SITES_ALL HCASA      
         ,HZ_CUST_ACCOUNTS_ALL HCAA
         ,HZ_PARTIES HP
         ,FND_USER FU
         ,CLL_F189_INVOICE_LINES CFIL
         ,CLL_F189_ITEM_UTILIZATIONS CFIU
         ,CLL_F189_FISCAL_OPERATIONS CFFO
         ,CLL_F189_INVOICE_TYPES CFIT
         ,OE_ORDER_LINES_ALL OOLA
         ,MTL_SYSTEM_ITEMS_B MSIB
         ,AP_TERMS AT
         ,CLL_F189_FISCAL_CLASS CFFC
         ,AP_AWT_GROUPS AWG
         ,CLL_F189_SERVICE_TYPES CFST         
         , MTL_CATEGORIES_B MCBI
         , MTL_CATEGORY_SETS MCSI
         , MTL_ITEM_CATEGORIES MICI         
    WHERE CFEO.ORGANIZATION_ID           = CFI.ORGANIZATION_ID
      AND CFEO.OPERATION_ID              = CFI.OPERATION_ID
      AND CFEO.STATUS                    = 'COMPLETE'
      AND CFI.ENTITY_ID                  = CFFEA.ENTITY_ID
      AND CFI.INVOICE_ID                 = CFIL.INVOICE_ID
      AND CFI.INVOICE_TYPE_ID            = CFIT.INVOICE_TYPE_ID
      AND CFI.ORGANIZATION_ID            = CFIT.ORGANIZATION_ID
      AND CFIL.UTILIZATION_ID            = CFIU.UTILIZATION_ID
      AND CFIL.CFO_ID                    = CFFO.CFO_ID
      AND CFFEA.CUST_ACCT_SITE_ID        = HCSUA.CUST_ACCT_SITE_ID          
      AND HCSUA.SITE_USE_CODE            = 'SHIP_TO'
      AND HCSUA.CUST_ACCT_SITE_ID        = HCASA.CUST_ACCT_SITE_ID        
      AND HCASA.CUST_ACCOUNT_ID          = HCAA.CUST_ACCOUNT_ID            
      AND HCAA.PARTY_ID                  = HP.PARTY_ID
      AND CFEO.CREATED_BY                = FU.USER_ID
      AND CFI.INVOICE_ID                 = CFI1.INVOICE_PARENT_ID (+)
      AND OOLA.LINE_ID           = CFIL.RMA_INTERFACE_ID 
      AND OOLA.INVENTORY_ITEM_ID         = MSIB.INVENTORY_ITEM_ID (+)
      AND OOLA.ORG_ID                    = MSIB.ORGANIZATION_ID (+)
      AND CFI.TERMS_ID                   = AT.TERM_ID
      AND CFIL.CLASSIFICATION_ID         = CFFC.CLASSIFICATION_ID
      AND CFIL.AWT_GROUP_ID              = AWG.GROUP_ID (+)
      AND CFIL.FEDERAL_SERVICE_TYPE_ID   = CFST.SERVICE_TYPE_ID (+)      
      AND MCBI.STRUCTURE_ID = MCSI.STRUCTURE_ID       
      AND UPPER(MCSI.CATEGORY_SET_NAME) IN ('INVENTORY','INVENTÁRIO')
      AND MICI.CATEGORY_SET_ID = MCSI.CATEGORY_SET_ID
      AND MICI.INVENTORY_ITEM_ID = CFIL.ITEM_ID
      AND MICI.ORGANIZATION_ID = CFI.ORGANIZATION_ID
      AND MICI.CATEGORY_ID = MCBI.CATEGORY_ID      
