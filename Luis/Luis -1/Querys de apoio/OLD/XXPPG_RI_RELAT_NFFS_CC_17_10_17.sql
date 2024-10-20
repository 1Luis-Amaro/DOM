SELECT FU.USER_NAME CRIADO_POR,
       CFIT.INVOICE_TYPE_CODE TIPO_NF,
       CFIT.INVOICE_TYPE_ID INV_TYPE_ID,
       PV.VENDOR_NAME FORNECEDOR_CLIENTE,
       CFFEA.DOCUMENT_NUMBER CNPJ,
       CFFEA.IE I_E,
       CFEO.OPERATION_ID NUMERO_RI,
       CFI1.OPERATION_ID RI_REVERSAO,
       CFEO.GL_DATE DATA_DO_RI,
       CFEO.STATUS STATUS_DO_RI,
       CFI.FISCAL_DOCUMENT_MODEL MODELO,
       CFI.SERIES SERIE,
       CFI.SUBSERIES SUBSERIE,
       CFI.ELETRONIC_INVOICE_KEY CHAVE_NFE,
       CFI.INVOICE_NUM NUMERO_NF,
       CFI.INVOICE_DATE DATA_NF,
       NVL (CFI.INVOICE_AMOUNT, 0) VALOR_NOTA_FISCAL,
       AT.NAME VENCTO_NF,
       AT1.NAME VENCTO_OC,
       CFI.ICMS_TYPE TIPO_ICMS,
       NVL (CFI.ICMS_BASE, 0) BASE_ICMS_HEADER,
       NVL (CFI.ICMS_AMOUNT, 0) VALOR_ICMS,
       NVL (CFI.IPI_AMOUNT, 0) VALOR_IPI,
       NVL (CFI.ISS_AMOUNT, 0) VALOR_ISS,
       NVL (CFI.INSS_AMOUNT, 0) VALOR_INSS,
       NVL (CFI.IR_AMOUNT, 0) VALOR_IR,
       CFIU.UTILIZATION_CODE UTILIZACAO_FISCAL,
       CFFO.CFO_CODE CFO,
       CFIL.OPERATION_FISCAL_TYPE NOP,
       NVL (CFIL.ICMS_BASE, 0) BASE_ICMS_LINES,
       NVL (CFIL.ICMS_TAX, 0) ICMS_TAX_LINES,
       NVL (CFIL.ICMS_AMOUNT, 0) VALOR_ICMS_LINES,
       CFIL.ICMS_TAX_CODE TIPO_ICMS_LINES,
       NVL (CFIL.ICMS_AMOUNT_RECOVER, 0) ICMS_RECUPERADO_LINES,
       CFIL.TRIBUTARY_STATUS_CODE CST_ICMS_LINES,
       NVL (CFIL.IPI_BASE_AMOUNT, 0) BASE_IPI_LINES,
       NVL (CFIL.IPI_TAX, 0) IPI_TAX_LINES,
       NVL (CFIL.IPI_AMOUNT, 0) VALOR_IPI_LINES,
       CFIL.IPI_TAX_CODE TIPO_IPI_LINES,
       NVL (CFIL.IPI_AMOUNT_RECOVER, 0) IPI_RECUPERADO_LINES,
       CFIL.IPI_TRIBUTARY_CODE CST_IPI_LINES,
       NVL (CFIL.PIS_BASE_AMOUNT, 0) BASE_PIS_LINES,
       NVL (CFIL.PIS_TAX_RATE, 0) PIS_TAX_RATE_LINES,
       NVL (CFIL.PIS_AMOUNT_RECOVER, 0) PIS_RECUPERADO_LINES,
       CFIL.PIS_TRIBUTARY_CODE CST_PIS,
       NVL (CFIL.COFINS_BASE_AMOUNT, 0) BASE_COFINS,
       NVL (CFIL.COFINS_TAX_RATE, 0) COFINS_TAX_RATE,
       NVL (CFIL.COFINS_AMOUNT_RECOVER, 0) COFINS_RECUPERADO,
       CFIL.COFINS_TRIBUTARY_CODE CST_COFINS,
       PHA.SEGMENT1 NUMERO_OC,
       MSIB.SEGMENT1 CODIGO_ITEM,
       CFIL.QUANTITY QUANTIDADE,
       CFIL.UNIT_PRICE PRECO_UNITARIO,
       MCBI.SEGMENT1 CAT_INV,
       MCBI.SEGMENT2 SBU,
       MCBI.SEGMENT3 PL,
       CFFC.CLASSIFICATION_CODE NCM,
       CFIL.ITEM_ID ITEM_ID,
       AWG.NAME GRUPO_RET_IMP,
       CFST.SERVICE_TYPE_CODE TIPO_SERVICO,
       CFIT.COST_ADJUST_FLAG COMPL_COST,
       CFI.INVOICE_ID INVOICE_ID,
       CFIL.INVOICE_LINE_ID INVOICE_LINE_ID,
       to_char (CFI.FIRST_PAYMENT_DATE) FIRST_PAYMENT_DATE,
       CFIL.FCI_NUMBER FCI_NUMBER, 
       CFIT.description tipo_de_nota,
       (  SELECT SUM (ipi_base_amount)
            FROM cll.cll_f189_invoice_lines A
           WHERE A.INVOICE_ID = CFI.INVOICE_ID
        GROUP BY A.invoice_id)
          BASE_IPI_NF,
       cfi.subst_icms_base BASE_CALC_ICMSST_TOT_NF,
       cfil.icms_st_base BASE_CALC_ICMSST_LIN,
       cfi.subst_icms_amount ICMSST_TOT_NF,
       cfil.icms_st_amount ICMSST_LINHA,
       (  SELECT SUM (pis_base_amount)
            FROM cll.cll_f189_invoice_lines a
           WHERE A.INVOICE_ID = CFI.INVOICE_ID
        GROUP BY a.invoice_id)
          BASE_PIS_NF,
       (SELECT name
          FROM hr.hr_all_organization_units haou
         WHERE haou.organization_id = cfi.organization_id)
          NOME_ESTABELECIMENTO,
       CFID.REFERENCE referencia,
       CFID.FUNCTIONAL_CR,
       CFID.FUNCTIONAL_DR,
       gcck.concatenated_segments conta,
       cfs.state_code COD_ESTADO_FORNECEDOR,
       CFS.DESCRIPTION ESTADO_FORNECEDOR,
       cfil.diff_icms_tax DIFERENCIAL_DE_ALIQUOTA,
       (SELECT segment1 
          FROM apps.po_headers_all
         WHERE po_header_id = (SELECT DISTINCT po_header_id
                                 FROM apps.po_line_locations_all
                                WHERE line_location_id = CFIL.line_location_id)) NUMERO_PEDIDO,
       (SELECT he.first_name||' '||he.last_name
           FROM apps.per_all_people_f he,
                apps.po_distributions_all         pda,
                apps.po_line_locations_all    plla,
                apps.po_headers_all           pha
          WHERE he.person_id (+)      = pda.deliver_to_person_id
            AND pda.line_location_id(+) = plla.line_location_id
            AND plla.line_location_id(+) = CFIL.line_location_id
            AND plla.po_header_id = pha.po_header_id
            AND ROWNUM = 1) SOLICITANTE
  FROM apps.CLL_F189_ENTRY_OPERATIONS CFEO,
       apps.CLL_F189_INVOICES CFI,
       apps.CLL_F189_INVOICES CFI1,
       apps.CLL_F189_FISCAL_ENTITIES_ALL CFFEA,
       apps.PO_VENDORS PV,
       apps.PO_VENDOR_SITES_ALL PVSA,
       apps.FND_USER FU,
       apps.CLL_F189_INVOICE_LINES CFIL,
       apps.CLL_F189_ITEM_UTILIZATIONS CFIU,
       apps.CLL_F189_FISCAL_OPERATIONS CFFO,
       apps.CLL_F189_INVOICE_TYPES CFIT,
       apps.PO_LINES_ALL PLA,
       apps.PO_LINE_LOCATIONS_ALL PLLA,
       apps.MTL_SYSTEM_ITEMS_B MSIB,
       apps.AP_TERMS AT,
       apps.AP_TERMS AT1,
       apps.PO_HEADERS_ALL PHA,
       apps.CLL_F189_FISCAL_CLASS CFFC,
       apps.AP_AWT_GROUPS AWG,
       apps.CLL_F189_SERVICE_TYPES CFST,
       apps.MTL_CATEGORIES_B MCBI,
       apps.MTL_CATEGORY_SETS MCSI,
       apps.MTL_ITEM_CATEGORIES MICI,
       apps.cll_f189_invoice_dist cfid,
       apps.gl_code_combinations_kfv gcck,
       apps.cll_f189_states cfs
 WHERE     CFEO.ORGANIZATION_ID = CFI.ORGANIZATION_ID
       AND CFEO.OPERATION_ID = CFI.OPERATION_ID
       AND CFEO.STATUS = 'COMPLETE'
       AND CFI.ENTITY_ID = CFFEA.ENTITY_ID
       AND CFI.INVOICE_ID = CFIL.INVOICE_ID
       AND CFI.INVOICE_TYPE_ID = CFIT.INVOICE_TYPE_ID
       AND CFI.ORGANIZATION_ID = CFIT.ORGANIZATION_ID
       AND CFIL.UTILIZATION_ID = CFIU.UTILIZATION_ID
       AND CFIL.CFO_ID = CFFO.CFO_ID
       AND CFFEA.VENDOR_SITE_ID = PVSA.VENDOR_SITE_ID
       AND PVSA.VENDOR_ID = PV.VENDOR_ID
       AND CFEO.CREATED_BY = FU.USER_ID
       AND CFI.INVOICE_ID = CFI1.INVOICE_PARENT_ID(+)
       AND CFIL.LINE_LOCATION_ID = PLLA.LINE_LOCATION_ID(+)
       AND PLLA.PO_LINE_ID = PLA.PO_LINE_ID(+)
       AND PLA.PO_HEADER_ID = PHA.PO_HEADER_ID(+)
       AND CFIL.ITEM_ID = MSIB.INVENTORY_ITEM_ID(+)
       AND CFIL.ORGANIZATION_ID = MSIB.ORGANIZATION_ID(+)
       AND CFI.TERMS_ID = AT.TERM_ID
       AND PHA.TERMS_ID = AT1.TERM_ID(+)
       AND CFIL.CLASSIFICATION_ID = CFFC.CLASSIFICATION_ID
       AND CFIL.AWT_GROUP_ID = AWG.GROUP_ID(+)
       AND CFIL.FEDERAL_SERVICE_TYPE_ID = CFST.SERVICE_TYPE_ID(+)
       AND MCBI.STRUCTURE_ID = MCSI.STRUCTURE_ID
       AND UPPER (MCSI.CATEGORY_SET_NAME) IN ('INVENTORY', 'INVENTÁRIO')
       AND MICI.CATEGORY_SET_ID = MCSI.CATEGORY_SET_ID
       AND MICI.INVENTORY_ITEM_ID = CFIL.ITEM_ID
       AND MICI.ORGANIZATION_ID = CFI.ORGANIZATION_ID
       AND MICI.CATEGORY_ID = MCBI.CATEGORY_ID
       AND cfid.code_combination_id = gcck.code_combination_id
       AND cfi.operation_id = cfid.operation_id
       AND cfi.organization_id = cfid.organization_id
       AND cfs.state_id = CFFEA.STATE_ID
UNION
SELECT FU.USER_NAME CRIADO_POR,
       CFIT.INVOICE_TYPE_CODE TIPO_NF,
       CFIT.INVOICE_TYPE_ID INV_TYPE_ID,
       HP.PARTY_NAME FORNECEDOR_CLIENTE,
       CFFEA.DOCUMENT_NUMBER CNPJ,
       CFFEA.IE I_E,
       CFEO.OPERATION_ID NUMERO_RI,
       CFI1.OPERATION_ID RI_REVERSAO,
       CFEO.GL_DATE DATA_DO_RI,
       CFEO.STATUS STATUS_DO_RI,
       CFI.FISCAL_DOCUMENT_MODEL MODELO,
       CFI.SERIES SERIE,
       CFI.SUBSERIES SUBSERIE,
       CFI.ELETRONIC_INVOICE_KEY CHAVE_NFE,
       CFI.INVOICE_NUM NUMERO_NF,
       CFI.INVOICE_DATE DATA_NF,
       NVL (CFI.INVOICE_AMOUNT, 0) VALOR_NOTA_FISCAL,
       AT.NAME VENCTO_NF,
       NULL VENCTO_OC,
       CFI.ICMS_TYPE TIPO_ICMS,
       NVL (CFI.ICMS_BASE, 0) BASE_ICMS_HEADER,
       NVL (CFI.ICMS_AMOUNT, 0) VALOR_ICMS,
       NVL (CFI.IPI_AMOUNT, 0) VALOR_IPI,
       NVL (CFI.ISS_AMOUNT, 0) VALOR_ISS,
       NVL (CFI.INSS_AMOUNT, 0) VALOR_INSS,
       NVL (CFI.IR_AMOUNT, 0) VALOR_IR,
       CFIU.UTILIZATION_CODE UTILIZACAO_FISCAL,
       CFFO.CFO_CODE CFO,
       CFIL.OPERATION_FISCAL_TYPE NOP,
       NVL (CFIL.ICMS_BASE, 0) BASE_ICMS_LINES,
       NVL (CFIL.ICMS_TAX, 0) ICMS_TAX_LINES,
       NVL (CFIL.ICMS_AMOUNT, 0) VALOR_ICMS_LINES,
       CFIL.ICMS_TAX_CODE TIPO_ICMS_LINES,
       NVL (CFIL.ICMS_AMOUNT_RECOVER, 0) ICMS_RECUPERADO_LINES,
       CFIL.TRIBUTARY_STATUS_CODE CST_ICMS_LINES,
       NVL (CFIL.IPI_BASE_AMOUNT, 0) BASE_IPI_LINES,
       NVL (CFIL.IPI_TAX, 0) IPI_TAX_LINES,
       NVL (CFIL.IPI_AMOUNT, 0) VALOR_IPI_LINES,
       CFIL.IPI_TAX_CODE TIPO_IPI_LINES,
       NVL (CFIL.IPI_AMOUNT_RECOVER, 0) IPI_RECUPERADO_LINES,
       CFIL.IPI_TRIBUTARY_CODE CST_IPI_LINES,
       NVL (CFIL.PIS_BASE_AMOUNT, 0) BASE_PIS_LINES,
       NVL (CFIL.PIS_TAX_RATE, 0) PIS_TAX_RATE_LINES,
       NVL (CFIL.PIS_AMOUNT_RECOVER, 0) PIS_RECUPERADO_LINES,
       CFIL.PIS_TRIBUTARY_CODE CST_PIS,
       NVL (CFIL.COFINS_BASE_AMOUNT, 0) BASE_COFINS,
       NVL (CFIL.COFINS_TAX_RATE, 0) COFINS_TAX_RATE,
       NVL (CFIL.COFINS_AMOUNT_RECOVER, 0) COFINS_RECUPERADO,
       CFIL.COFINS_TRIBUTARY_CODE CST_COFINS,
       NULL NUMERO_OC,
       MSIB.SEGMENT1 CODIGO_ITEM,
       CFIL.QUANTITY QUANTIDADE,
       CFIL.UNIT_PRICE PRECO_UNITARIO,
       MCBI.SEGMENT1 CAT_INV,
       MCBI.SEGMENT2 SBU,
       MCBI.SEGMENT3 PL,
       CFFC.CLASSIFICATION_CODE NCM,
       CFIL.ITEM_ID ITEM_ID,
       AWG.NAME GRUPO_RET_IMP,
       CFST.SERVICE_TYPE_CODE TIPO_SERVICO,
       CFIT.COST_ADJUST_FLAG COMPL_COST,
       CFI.INVOICE_ID INVOICE_ID,
       CFIL.INVOICE_LINE_ID INVOICE_LINE_ID,
       to_char (CFI.FIRST_PAYMENT_DATE) FIRST_PAYMENT_DATE,
       CFIL.FCI_NUMBER FCI_NUMBER, 
       CFIT.description tipo_de_nota,
       (  SELECT SUM (ipi_base_amount)
            FROM cll.cll_f189_invoice_lines A
           WHERE A.INVOICE_ID = CFI.INVOICE_ID
        GROUP BY A.invoice_id)
          BASE_IPI_NF,
       cfi.subst_icms_base BASE_CALC_ICMSST_TOT_NF,
       cfil.icms_st_base BASE_CALC_ICMSST_LIN,
       cfi.subst_icms_amount ICMSST_TOT_NF,
       cfil.icms_st_amount ICMSST_LINHA,
       (  SELECT SUM (pis_base_amount)
            FROM cll.cll_f189_invoice_lines a
           WHERE A.INVOICE_ID = CFI.INVOICE_ID
        GROUP BY a.invoice_id)
          BASE_PIS_NF,
       (SELECT name
          FROM hr.hr_all_organization_units haou
         WHERE haou.organization_id = cfi.organization_id)
          NOME_ESTABELECIMENTO,
       CFID.REFERENCE referencia,
       CFID.FUNCTIONAL_CR,
       CFID.FUNCTIONAL_DR,
       gcck.concatenated_segments conta,
       cfs.state_code COD_ESTADO_FORNECEDOR,
       CFS.DESCRIPTION ESTADO_FORNECEDOR,
       cfil.diff_icms_tax DIFERENCIAL_DE_ALIQUOTA,
       (SELECT segment1 
          FROM apps.po_headers_all
         WHERE po_header_id = (SELECT DISTINCT po_header_id
                                 FROM apps.po_line_locations_all
                                WHERE line_location_id = CFIL.line_location_id)) NUMERO_PEDIDO,
       (SELECT he.first_name||' '||he.last_name
           FROM apps.per_all_people_f he,
                apps.po_distributions_all         pda,
                apps.po_line_locations_all    plla,
                apps.po_headers_all           pha
          WHERE he.person_id (+)      = pda.deliver_to_person_id
            AND pda.line_location_id(+) = plla.line_location_id
            AND plla.line_location_id(+) = CFIL.line_location_id
            AND plla.po_header_id = pha.po_header_id
            AND ROWNUM = 1) SOLICITANTE
  FROM apps.CLL_F189_ENTRY_OPERATIONS CFEO,
       apps.CLL_F189_INVOICES CFI,
       apps.CLL_F189_INVOICES CFI1,
       apps.CLL_F189_FISCAL_ENTITIES_ALL CFFEA,
       apps.HZ_CUST_SITE_USES_ALL HCSUA,
       apps.HZ_CUST_ACCT_SITES_ALL HCASA,
       apps.HZ_CUST_ACCOUNTS_ALL HCAA,
       apps.HZ_PARTIES HP,
       apps.FND_USER FU,
       apps.CLL_F189_INVOICE_LINES CFIL,
       apps.CLL_F189_ITEM_UTILIZATIONS CFIU,
       apps.CLL_F189_FISCAL_OPERATIONS CFFO,
       apps.CLL_F189_INVOICE_TYPES CFIT,
       apps.OE_ORDER_LINES_ALL OOLA,
       apps.MTL_SYSTEM_ITEMS_B MSIB,
       apps.AP_TERMS AT,
       apps.CLL_F189_FISCAL_CLASS CFFC,
       apps.AP_AWT_GROUPS AWG,
       apps.CLL_F189_SERVICE_TYPES CFST,
       apps.MTL_CATEGORIES_B MCBI,
       apps.MTL_CATEGORY_SETS MCSI,
       apps.MTL_ITEM_CATEGORIES MICI, 
       apps.cll_f189_invoice_dist cfid,
       apps.gl_code_combinations_kfv gcck,
       apps.cll_f189_states cfs
 WHERE     CFEO.ORGANIZATION_ID = CFI.ORGANIZATION_ID
       AND CFEO.OPERATION_ID = CFI.OPERATION_ID
       AND CFEO.STATUS = 'COMPLETE'
       AND CFI.ENTITY_ID = CFFEA.ENTITY_ID
       AND CFI.INVOICE_ID = CFIL.INVOICE_ID
       AND CFI.INVOICE_TYPE_ID = CFIT.INVOICE_TYPE_ID
       AND CFI.ORGANIZATION_ID = CFIT.ORGANIZATION_ID
       AND CFIL.UTILIZATION_ID = CFIU.UTILIZATION_ID
       AND CFIL.CFO_ID = CFFO.CFO_ID
       AND CFFEA.CUST_ACCT_SITE_ID = HCSUA.CUST_ACCT_SITE_ID
       AND HCSUA.SITE_USE_CODE = 'SHIP_TO'
       AND HCSUA.CUST_ACCT_SITE_ID = HCASA.CUST_ACCT_SITE_ID
       AND HCASA.CUST_ACCOUNT_ID = HCAA.CUST_ACCOUNT_ID
       AND HCAA.PARTY_ID = HP.PARTY_ID
       AND CFEO.CREATED_BY = FU.USER_ID
       AND CFI.INVOICE_ID = CFI1.INVOICE_PARENT_ID(+)
       AND OOLA.LINE_ID = CFIL.RMA_INTERFACE_ID
       AND OOLA.INVENTORY_ITEM_ID = MSIB.INVENTORY_ITEM_ID(+)
       AND OOLA.ORG_ID = MSIB.ORGANIZATION_ID(+)
       AND CFI.TERMS_ID = AT.TERM_ID
       AND CFIL.CLASSIFICATION_ID = CFFC.CLASSIFICATION_ID
       AND CFIL.AWT_GROUP_ID = AWG.GROUP_ID(+)
       AND CFIL.FEDERAL_SERVICE_TYPE_ID = CFST.SERVICE_TYPE_ID(+)
       AND MCBI.STRUCTURE_ID = MCSI.STRUCTURE_ID
       AND UPPER (MCSI.CATEGORY_SET_NAME) IN ('INVENTORY', 'INVENTÁRIO')
       AND MICI.CATEGORY_SET_ID = MCSI.CATEGORY_SET_ID
       AND MICI.INVENTORY_ITEM_ID = CFIL.ITEM_ID
       AND MICI.ORGANIZATION_ID = CFI.ORGANIZATION_ID
       AND MICI.CATEGORY_ID = MCBI.CATEGORY_ID
       AND cfid.code_combination_id = gcck.code_combination_id
       AND cfi.operation_id = cfid.operation_id
       AND cfi.organization_id = cfid.organization_id
       AND cfs.state_id = CFFEA.STATE_ID