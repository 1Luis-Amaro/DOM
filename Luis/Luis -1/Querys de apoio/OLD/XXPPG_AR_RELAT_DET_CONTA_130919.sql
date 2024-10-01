SELECT 
       GL_DATE "Data GL",
       CLASS "Classe",
       TRX_NUMBER "N�mero",
       TERMS_SEQUENCE_NUMBER "Seq",
       TRX_DATE "Data da Transa��o",
       DUE_DATE "Data de Vencimento",
       RAC_CUSTOMER_NAME "Nome do Cliente",
       AMOUNT_DUE_ORIGINAL "Original",
       AMOUNT_DUE_REMAINING "Saldo Devido",
       DAYS_PAST_DUE "Dias de Atraso",
       INVOICE_CURRENCY_CODE "Moeda", 
       AL_STATUS_MEANING "Status",         
       COMMENTS "Coment�rios",  
       AMOUNT_IN_DISPUTE "Quantia de de Contesta��o", 
       DISPUTE_DATE "Data de Contesta��o",  
       ATTRIBUTE3 "Historico com Cliente 1",
       ATTRIBUTE4 "Historico com Cliente 2",
       ATTRIBUTE5 "Historico com Cliente 3",    
       BILLING_DATE "Data do Faturamento"        
  FROM APPS.AR_PAYMENT_SCHEDULES_V
 WHERE status = 'OP'