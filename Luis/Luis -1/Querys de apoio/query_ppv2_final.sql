SELECT PV.SEGMENT1 COD_FORN
     , PV.VENDOR_NAME NOME_FORN
     , HAOU.ORGANIZATION_ID COD_ORG
     , HAOU.NAME NAME_ORG
     , MSIB.SEGMENT1 COD_PROD
     , MSIB.PRIMARY_UOM_CODE UM
     , MSIB.DESCRIPTION DESCR_PROD
     , MCBC.SEGMENT1 CAT_CUSTO
     , MCBI.SEGMENT1 CAT_INV            
     , CFIU.UTILIZATION_CODE TIPO_UTILIZACAO 
     , CFIU.DESCRIPTION DESCR_UTILIZACAO 
     , CFIT.INVOICE_TYPE_CODE TIPO_NATUREZA
     , CFIT.DESCRIPTION DESCR_NATUTEZA                     
     , CFFEA.DOCUMENT_NUMBER NR_DOCTO
     , TRUNC(CFI.INVOICE_DATE) DATA_TRANS
     , PHA.SEGMENT1 NR_OC
     , CFI.INVOICE_NUM NR_RI
     , CFIL.QUANTITY QUANTIDADE
     , NVL(CFI.INVOICE_AMOUNT,0) VL_LIQUIDO
     , NVL(CFI.ICMS_AMOUNT,0) ICMS
     , NVL(CFI.IPI_AMOUNT,0) IPI  
     , NVL(CFIL.PIS_BASE_AMOUNT,0) PIS
     , NVL(CFIL.COFINS_BASE_AMOUNT,0) CONFIS
     , NVL(CFI.GROSS_TOTAL_AMOUNT,0) VL_BRUTO
     , SUM(PLA.UNIT_PRICE*PLA.QUANTITY) VL_OC
     , SUM(PLA.UNIT_PRICE*PLA.QUANTITY) - SUM(PLA.UNIT_PRICE*PLLA.QUANTITY_RECEIVED) VL_SALDO_OC
     , SUM(PLA.QUANTITY) - SUM(PLLA.QUANTITY_RECEIVED) QTD_SALDO_OC
     , PHA.AUTHORIZATION_STATUS STATUS_OC
     , TRUNC(PLLA.PROMISED_DATE) DATA_ENTREGA
     ,to_char(SUM(ccd2.cmpnt_cost*CFIL.QUANTITY),'999G999G990D000000000') TOT_STD
     ,to_char(SUM(ccd.cmpnt_cost*CFIL.QUANTITY),'999G999G990D000000000')  TOT_PMAC       
     , PPV_SLA.VALOR_PPV_DR
     , PPV_SLA.VALOR_PPV_CR                            
     , to_char((NVL(CFI.INVOICE_AMOUNT,0)) - (SUM(ccd2.cmpnt_cost*CFIL.QUANTITY)),'999G999G990D000000000') FORM_PPV
     , MCBI.SEGMENT2 SBU
     , MCBI.SEGMENT3 PL                                 
 FROM apps.CLL_F189_ENTRY_OPERATIONS CFEO
    , apps.CLL_F189_INVOICES CFI
    , apps.CLL_F189_INVOICES CFI1
    , apps.CLL_F189_FISCAL_ENTITIES_ALL CFFEA
    , apps.PO_VENDORS PV
    , apps.PO_VENDOR_SITES_ALL PVSA
    , apps.FND_USER FU
    , apps.CLL_F189_INVOICE_LINES CFIL
    , apps.CLL_F189_ITEM_UTILIZATIONS CFIU
    , apps.CLL_F189_FISCAL_OPERATIONS CFFO
    , apps.CLL_F189_INVOICE_TYPES CFIT
    , apps.PO_LINES_ALL PLA
    , apps.PO_LINE_LOCATIONS_ALL PLLA
    , apps.MTL_SYSTEM_ITEMS_B MSIB
    , apps.AP_TERMS AT
    , apps.AP_TERMS AT1
    , apps.PO_HEADERS_ALL PHA
    , apps.CLL_F189_FISCAL_CLASS CFFC
    , apps.AP_AWT_GROUPS AWG
    , apps.CLL_F189_SERVICE_TYPES CFST         
    , apps.HR_ALL_ORGANIZATION_UNITS HAOU         
    , apps.MTL_CATEGORIES_B MCBI
    , apps.MTL_CATEGORY_SETS MCSI
    , apps.MTL_ITEM_CATEGORIES MICI                  
    , apps.MTL_CATEGORIES_B MCBC
    , apps.MTL_CATEGORY_SETS MCSC
    , apps.MTL_ITEM_CATEGORIES MICC         
    , apps.gmf_period_statuses gps   
    , apps.cm_cmpt_dtl ccd        
    , apps.gmf_period_statuses gps2
    , apps.cm_cmpt_dtl ccd2              
    , (SELECT COST_TYPE_ID FROM apps.CM_MTHD_MST WHERE COST_MTHD_CODE = 'STD' AND ROWNUM = 1)    STD
    , (SELECT COST_TYPE_ID FROM apps.CM_MTHD_MST WHERE COST_MTHD_CODE = 'PMAC' AND ROWNUM = 1)    PMAC         
    , (SELECT rct.transaction_id
            ,poh.po_header_id
       FROM apps.rcv_shipment_headers rsh 
          , apps.rcv_shipment_lines rsl 
          , apps.rcv_transactions rct 
          , apps.po_headers_all poh 
          , apps.po_lines_all pol 
      WHERE poh.po_header_id = pol.po_header_id 
        AND poh.po_header_id = rsl.po_header_id 
        AND rsl.shipment_header_id = rsh.shipment_header_id 
        AND rct.po_header_id = poh.po_header_id 
        AND rct.po_line_id = pol.po_line_id 
        AND rct.shipment_header_id = rsh.shipment_header_id 
        AND rct.shipment_line_id = rsl.shipment_line_id  
        AND RCT.TRANSACTION_TYPE = 'RECEIVE') PO_RCV
    , (SELECT DECODE(SIGN(GXEL.TRANS_AMOUNT), 1, GXEL.TRANS_AMOUNT,0,0,0)     VALOR_PPV_DR
           , DECODE(SIGN(GXEL.TRANS_AMOUNT),-1, ABS(GXEL.TRANS_AMOUNT),0,0,0)  VALOR_PPV_CR 
           , GXEH.TRANSACTION_ID      
        FROM APPS.XLA_EVENTS XE
           , APPS.XLA_AE_HEADERS XAH
           , APPS.XLA_AE_LINES XAL
           , APPS.GMF_XLA_EXTRACT_HEADERS GXEH
           , APPS.GMF_XLA_EXTRACT_LINES GXEL
           , APPS.GL_CODE_COMBINATIONS_KFV GCC
           , APPS.XLE_ENTITY_PROFILES XEP
           , APPS.GMF_ORGANIZATION_DEFINITIONS GOD
     , ( SELECT DISTINCT EVENT_ID, ENCODED_MSG, AE_HEADER_ID, AE_LINE_NUM
           FROM APPS.XLA_ACCOUNTING_ERRORS XAE
          WHERE APPLICATION_ID = 555
            AND ROWID IN ( SELECT ROWID
                        FROM (SELECT ROWID, EVENT_ID
                                FROM APPS.XLA_ACCOUNTING_ERRORS
                               WHERE APPLICATION_ID = 555
                               ORDER BY AE_HEADER_ID, AE_LINE_NUM
                             )
                       WHERE ROWNUM = 1
                         AND EVENT_ID = XAE.EVENT_ID
                    )
        ) XAE
     , APPS.XLA_DISTRIBUTION_LINKS XDL
     , APPS.XLA_EVENT_CLASSES_VL XEC
     , APPS.XLA_EVENT_TYPES_VL XET
        WHERE XAH.LEDGER_ID             = GXEH.LEDGER_ID
          AND XAH.EVENT_ID              = GXEH.EVENT_ID
          AND XAH.EVENT_ID              = XE.EVENT_ID
          AND XAL.AE_HEADER_ID          = XAH.AE_HEADER_ID
          AND GXEH.EVENT_ID             = XE.EVENT_ID  
          AND XAE.EVENT_ID (+)          = XDL.EVENT_ID
          AND XAL.CODE_COMBINATION_ID   = GCC.CODE_COMBINATION_ID (+)
          AND XAH.EVENT_TYPE_CODE       = GXEH.EVENT_TYPE_CODE
          AND XEP.LEGAL_ENTITY_ID       = GXEH.LEGAL_ENTITY_ID
          AND XEP.LEGAL_ENTITY_ID       = GOD.LEGAL_ENTITY_ID
          AND GOD.LEGAL_ENTITY_ID       = GXEH.LEGAL_ENTITY_ID
          AND GOD.ORGANIZATION_ID       = GXEH.ORGANIZATION_ID  
          AND GOD.OPERATING_UNIT_ID     = GXEH.OPERATING_UNIT
          AND GXEL.HEADER_ID            = GXEH.HEADER_ID
          AND GXEL.EVENT_ID             = GXEH.EVENT_ID
          AND XDL.AE_HEADER_ID                 = XAL.AE_HEADER_ID
          AND XDL.AE_LINE_NUM                  = XAL.AE_LINE_NUM
          AND XDL.EVENT_ID                     = GXEH.EVENT_ID
          AND XDL.SOURCE_DISTRIBUTION_TYPE     = GXEH.ENTITY_CODE
          AND XDL.SOURCE_DISTRIBUTION_ID_NUM_1 = GXEL.LINE_ID
          AND XEC.EVENT_CLASS_CODE = GXEH.EVENT_CLASS_CODE
          AND XEC.ENTITY_CODE      = GXEH.ENTITY_CODE
          AND XET.ENTITY_CODE      = GXEH.ENTITY_CODE
          AND XET.EVENT_CLASS_CODE = GXEH.EVENT_CLASS_CODE
          AND XET.EVENT_TYPE_CODE  = GXEH.EVENT_TYPE_CODE    
          AND GXEL.JOURNAL_LINE_TYPE = 'PPV') PPV_SLA
WHERE CFEO.ORGANIZATION_ID           = CFI.ORGANIZATION_ID
  AND CFEO.OPERATION_ID              = CFI.OPERATION_ID  
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
  AND CFIL.ORGANIZATION_ID           = HAOU.ORGANIZATION_ID      
  AND MCBI.STRUCTURE_ID = MCSI.STRUCTURE_ID         
  AND MICI.CATEGORY_SET_ID = MCSI.CATEGORY_SET_ID
  AND MICI.INVENTORY_ITEM_ID = CFIL.ITEM_ID
  AND MICI.ORGANIZATION_ID = CFI.ORGANIZATION_ID
  AND MICI.CATEGORY_ID = MCBI.CATEGORY_ID      
  AND MCBC.STRUCTURE_ID = MCSC.STRUCTURE_ID       
  --AND UPPER(MCSC.CATEGORY_SET_NAME) IN ('CUSTO DO PROCESSO')
  AND MCSC.CATEGORY_SET_ID = (SELECT category_set_id FROM apps.mtl_default_category_sets WHERE functional_area_id = 19)
  AND MICC.CATEGORY_SET_ID = MCSC.CATEGORY_SET_ID
  AND MICC.INVENTORY_ITEM_ID = CFIL.ITEM_ID
  AND MICC.ORGANIZATION_ID = CFI.ORGANIZATION_ID
  AND MICC.CATEGORY_ID = MCBC.CATEGORY_ID      
  AND gps.calendar_code like '%'||to_char(CFEO.GL_DATE,'RRRR')||'%'
  AND gps.period_code  = to_char(CFEO.GL_DATE,'MM')        
  AND ccd.inventory_item_id  = MSIB.INVENTORY_ITEM_ID         
  AND ccd.organization_id = CFIL.ORGANIZATION_ID
  and gps.COST_TYPE_ID = PMAC.COST_TYPE_ID (+)
  and gps.period_id = ccd.period_id         
  AND gps2.calendar_code like '%'||to_char(CFEO.GL_DATE,'RRRR')||'%'
  AND gps2.period_code  = to_char(CFEO.GL_DATE,'MM')        
  AND ccd2.inventory_item_id  = MSIB.INVENTORY_ITEM_ID         
  AND ccd2.organization_id = CFIL.ORGANIZATION_ID
  and gps2.COST_TYPE_ID = STD.COST_TYPE_ID (+)
  and gps2.period_id = ccd2.period_id             
  AND PPV_SLA.TRANSACTION_ID (+) = PO_RCV.TRANSACTION_ID
  AND PO_RCV.PO_HEADER_ID (+) = PHA.PO_HEADER_ID                                    
  AND MCSI.CATEGORY_SET_ID = (SELECT category_set_id FROM apps.mtl_default_category_sets WHERE functional_area_id = 1)
GROUP BY PV.SEGMENT1       
       ,PV.VENDOR_NAME 
       ,HAOU.ORGANIZATION_ID 
       ,HAOU.NAME 
       ,MSIB.SEGMENT1 
       ,MSIB.PRIMARY_UOM_CODE 
       ,MSIB.DESCRIPTION 
       ,MCBC.SEGMENT1 
       ,MCBI.SEGMENT1 
       ,CFIU.UTILIZATION_CODE  
       ,CFIU.DESCRIPTION  
       ,CFIT.INVOICE_TYPE_CODE 
       ,CFIT.DESCRIPTION              
       ,CFFEA.DOCUMENT_NUMBER 
       ,CFI.INVOICE_DATE 
       ,PHA.SEGMENT1 
       ,CFI.INVOICE_NUM 
       ,CFIL.QUANTITY 
       ,NVL(CFI.INVOICE_AMOUNT,0) 
       ,NVL(CFI.ICMS_AMOUNT,0) 
       ,NVL(CFI.IPI_AMOUNT,0)   
       ,NVL(CFIL.PIS_BASE_AMOUNT,0) 
       ,NVL(CFIL.COFINS_BASE_AMOUNT,0) 
       ,NVL(CFI.GROSS_TOTAL_AMOUNT,0) 
       ,PHA.AUTHORIZATION_STATUS 
       ,PLLA.PROMISED_DATE                               
       ,ccd2.cmpnt_cost
       ,ccd.cmpnt_cost
       --,DECODE(STD.COST_TYPE_ID,NULL,'',to_char(ccd2.cmpnt_cost*CFIL.QUANTITY,'999G999G990D000000000'))
       --,DECODE(PMAC.COST_TYPE_ID,NULL,'',to_char(ccd.cmpnt_cost*CFIL.QUANTITY,'999G999G990D000000000'))
       --,to_char(((NVL(CFI.INVOICE_AMOUNT,0)) - (DECODE(STD.COST_TYPE_ID,NULL,0, ccd2.cmpnt_cost*CFIL.QUANTITY))),'999G999G990D000000000')  
	   ,gps.calendar_code
	   ,gps.period_code  
	   ,gps2.calendar_code
	   ,gps2.period_code  	   
       ,MCBI.SEGMENT2
       ,MCBI.SEGMENT3
       ,PPV_SLA.VALOR_PPV_DR
       ,PPV_SLA.VALOR_PPV_CR