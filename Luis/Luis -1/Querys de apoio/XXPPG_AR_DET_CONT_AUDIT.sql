SELECT 
  rctta.NAME 'TIPO',
  rctta.DESCRIPTION,
       APS.GL_DATE 'Data GL',
       APS.CLASS "Classe",
       APS.TRX_NUMBER "Número",
       APS.TERMS_SEQUENCE_NUMBER "Seq",
       APS.TRX_DATE "Data da Transação",
       APS.DUE_DATE "Data de Vencimento",
       APS.RAC_CUSTOMER_NAME "Nome do Cliente",
       APS.AMOUNT_DUE_ORIGINAL "Original",
       APS.AMOUNT_DUE_REMAINING "Saldo Devido",
       APS.DAYS_PAST_DUE "Dias de Atraso",
       APS.INVOICE_CURRENCY_CODE "Moeda", 
       APS.AL_STATUS_MEANING "Status",         
       APS.COMMENTS "Comentários",  
       APS.AMOUNT_IN_DISPUTE "Quantia de de Contestação", 
       APS.DISPUTE_DATE "Data de Contestação",  
       APS.ATTRIBUTE3 "Historico com Cliente 1",
       APS.ATTRIBUTE4 "Historico com Cliente 2",
       APS.ATTRIBUTE5 "Historico com Cliente 3",    
       APS.BILLING_DATE "Data do Faturamento"       
from APPS.AR_PAYMENT_SCHEDULES_V APS,
 apps.ra_cust_trx_types_all rctta  
  where APS.CLASS = 'CM'
  AND rctta.cust_trx_type_id = APS.cust_trx_type_id