SELECT PS.GLOBAL_ATTRIBUTE10 
       || PS.GLOBAL_ATTRIBUTE11 
       || PS.GLOBAL_ATTRIBUTE12 CODIGO_FORNECEDOR,  
       PV.VENDOR_NAME RAZAO_SOCIAL ,   
       PV.ATTRIBUTE1 GRUPO, 
       AIA.INVOICE_NUM NR_NF, 
       APS.PAYMENT_NUM PARCELA, 
       ACA.CHECK_NUMBER NR_PAGTO, 
       AIA.GL_DATE DATA_CONTABIL, 
       AIA.INVOICE_DATE DATA_EMISSAO, 
       APS.DUE_DATE DATA_VENCIMENTO, 
       ACA.CHECK_DATE DATA_PAGAMENTO,
       ACA.CURRENCY_CODE MOEDA,
       cc.segment1, 
       cc.segment2, 
       cc.segment3, 
       cc.segment4, 
       cc.segment5, 
       cc.segment6, 
       cc.segment7, 
       sum(nvl(AEL.ENTERED_DR, 0))  DEBITO_ENTRADA, 
       sum(nvl(AEL.ENTERED_CR,0))   CREDITO_ENTRADA, 
       sum(nvl(AEL.ACCOUNTED_DR,0)) DEBITO, 
       sum(nvl(AEL.ACCOUNTED_CR,0)) CREDITO,
       AEL.DESCRIPTION              DESCRICAO 
  FROM apps.AP_SUPPLIERS                    PV 
       ,apps.AP_SUPPLIER_SITES_ALL          PS 
       ,apps.AP_INVOICES_ALL                AIA 
       ,apps.AP_PAYMENT_SCHEDULES_ALL       APS  
       ,apps.AP_INVOICE_PAYMENTS_ALL        AIP 
       ,apps.AP_CHECKS_ALL                  ACA 
       ,APPS.XLA_AE_HEADERS                 AEH 
       ,APPS.XLA_AE_LINES                   AEL 
       ,APPS.GL_CODE_COMBINATIONS           CC 
 WHERE PV.VENDOR_ID           = PS.VENDOR_ID  
   AND PS.VENDOR_ID           = AIA.VENDOR_ID  
   AND PS.VENDOR_SITE_ID      = AIA.VENDOR_SITE_ID 
   AND AIA.INVOICE_ID         = APS.INVOICE_ID  
   AND APS.INVOICE_ID         = AIP.INVOICE_ID  
   --AND APS.PAYMENT_NUM        = AIP.PAYMENT_NUM 
   AND AIP.CHECK_ID           = ACA.CHECK_ID
   --AND AIP.REMIT_TO_SUPPLIER_ID = ACA.REMIT_TO_SUPPLIER_ID 
   --AND AIP.REMIT_TO_SUPPLIER_SITE_ID = ACA.REMIT_TO_SUPPLIER_SITE_ID 
   AND ACA.STATUS_LOOKUP_CODE = 'NEGOTIABLE'  
   AND AIP.ACCOUNTING_EVENT_ID= AEH.EVENT_ID 
   AND AEH.AE_HEADER_ID       = AEL.AE_HEADER_ID
   AND AEL.LEDGER_ID          = 2021 
   AND AEL.CODE_COMBINATION_ID= CC.CODE_COMBINATION_ID 
   AND ael.ledger_id          = 2021 
--AND AIA.INVOICE_NUM        = '21295'
--
AND nvl(AEL.ENTERED_DR,AEL.ENTERED_CR) = aps.gross_amount
--
group by PS.GLOBAL_ATTRIBUTE10 
       || PS.GLOBAL_ATTRIBUTE11 
       || PS.GLOBAL_ATTRIBUTE12 ,  
       PV.VENDOR_NAME  ,   
       PV.ATTRIBUTE1 , 
       AIA.INVOICE_NUM , 
       APS.PAYMENT_NUM , 
       ACA.CHECK_NUMBER , 
       AIA.GL_DATE , 
       AIA.INVOICE_DATE , 
       APS.DUE_DATE , 
       ACA.CHECK_DATE ,
       ACA.CURRENCY_CODE ,
       cc.segment1, 
       cc.segment2, 
       cc.segment3, 
       cc.segment4, 
       cc.segment5, 
       cc.segment6, 
       cc.segment7, 
       AEL.DESCRIPTION
ORDER BY PV.VENDOR_NAME, AIA.INVOICE_NUM
