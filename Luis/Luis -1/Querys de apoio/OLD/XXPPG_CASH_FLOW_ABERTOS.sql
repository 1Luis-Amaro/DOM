SELECT DISTINCT
  PS.GLOBAL_ATTRIBUTE10
  || PS.GLOBAL_ATTRIBUTE11
  || PS.GLOBAL_ATTRIBUTE12 CODIGO_FORNECEDOR, 
  PV.VENDOR_NAME RAZAO_SOCIAL ,  
  PV.ATTRIBUTE1 GRUPO, -- EXTERNO, INTERCOMPANY
  AIA.INVOICE_NUM NR_NF ,
AIA.invoice_currency_code moeda,
AIA.INVOICE_DATE EMISSAO, 
 aps.DUE_DATE VENCIMENTO,
 AIA.CREATION_DATE CRIACAO,
AIA.INVOICE_AMOUNT VALOR_NF,
  APS.AMOUNT_REMAINING SALDO_NF,

  AIA.EXCHANGE_RATE TAXA_CAMBIO_IMPL,
  (AIA.INVOICE_AMOUNT * NVL(AIA.EXCHANGE_RATE, 1)) VALOR_NF_BRL,
  (APS.AMOUNT_REMAINING * NVL(AIA.EXCHANGE_RATE,1)) SALDO_NF_BRL
   
  
FROM
  apps.AP_SUPPLIERS PV ,
  apps.AP_SUPPLIER_SITES_ALL PS ,
  apps.AP_INVOICES_ALL AIA ,
  apps.AP_PAYMENT_SCHEDULES_ALL APS
WHERE
  AIA.INVOICE_ID              = aps.INVOICE_ID
AND AIA.ORG_ID                = 82
AND AIA.VENDOR_SITE_ID  = PS.VENDOR_SITE_ID
AND PS.VENDOR_ID        = PV.VENDOR_ID
--AND AIA.INVOICE_CURRENCY_CODE != 'BRL'
AND AIA.INVOICE_AMOUNT != 0
AND APS.AMOUNT_REMAINING !=0