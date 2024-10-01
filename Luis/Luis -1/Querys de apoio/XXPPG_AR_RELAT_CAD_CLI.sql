SELECT DISTINCT HCA.ACCOUNT_NUMBER "COD CLIENTE"
      ,HP.PARTY_NAME "NOME DO CLIENTE"                     
      ,HP.ATTRIBUTE2 "GRUPO DO CLIENTE"                     
      ,HCP.PHONE_AREA_CODE||' - '||HCP.PHONE_NUMBER FONE
      ,HL.CITY "CIDADE DE COBRANCA"      
      ,HL.ADDRESS1 ENDERECO1
      ,HL.ADDRESS2 ENDERECO2
      ,HL.ADDRESS3 ENDERECO3
      ,HL.ADDRESS4 ENDERECO4
      ,HL.CITY     CIDADE
      ,HL.STATE    ESTADO
      ,HL.POSTAL_CODE CEP      
      ,HCASA.GLOBAL_ATTRIBUTE3||HCASA.GLOBAL_ATTRIBUTE4||HCASA.GLOBAL_ATTRIBUTE5 CNPJ
      ,HL.STATE UF
      ,TO_CHAR(HCA.CREATION_DATE,'DD/MM/RRRR') "DATA IMPLANTACAO CLIENTE"      
      ,HCPROF.NEXT_CREDIT_REVIEW_DATE "DATA DO LIMITE DE CREDITO"
      ,HCPA.OVERALL_CREDIT_LIMIT "VALOR LIMITE CREDITO ATUAL"
      --DATA DA ULTIMA ALTERACAO(REVISAO) DO LIMITE
      --LIMITE ANTERIOR(QUERY ENVIADA)
      --USUARIO QUE ALTEROU(NA TABELA DE RECOMENDACAO TB)
      ,NVL((SELECT MIN(CREATION_DATE) 
                                  FROM  apps.OE_ORDER_HEADERS_ALL
                                  WHERE SOLD_TO_ORG_ID = HCA.CUST_ACCOUNT_ID),
                                  (SELECT MIN(CREATION_DATE)
                                    FROM apps.RA_CUSTOMER_TRX_ALL
                                    WHERE BILL_TO_CUSTOMER_ID = ACUS.CUSTOMER_ID)                                  
                                  ) "DATA PRIMEIRA COMPRA"
      ,NVL((SELECT MAX(CREATION_DATE) 
                                  FROM  apps.OE_ORDER_HEADERS_ALL
                                  WHERE SOLD_TO_ORG_ID = HCA.CUST_ACCOUNT_ID),
                                  (SELECT MAX(CREATION_DATE)
                                    FROM apps.RA_CUSTOMER_TRX_ALL
                                    WHERE BILL_TO_CUSTOMER_ID = ACUS.CUSTOMER_ID)                                  
                                  ) "DATA ULTIMA COMPRA"
                                  
     ,(SELECT NVL(SUM(EXTENDED_AMOUNT),0) 
                     FROM apps.RA_CUSTOMER_TRX_LINES_ALL
                    WHERE LINE_TYPE = 'LINE'
                      AND CUSTOMER_TRX_ID = (SELECT CUSTOMER_TRX_ID
                                               FROM apps.RA_CUSTOMER_TRX_ALL
                                              WHERE CREATION_DATE = (SELECT MIN(CREATION_DATE)
                                                                       FROM apps.RA_CUSTOMER_TRX_ALL
                                                                       WHERE BILL_TO_CUSTOMER_ID = ACUS.CUSTOMER_ID)
                                                AND BILL_TO_CUSTOMER_ID = ACUS.CUSTOMER_ID
                                                AND ROWNUM = 1)) "VALOR PRIMEIRA COMPRA"
     ,(SELECT NVL(SUM(EXTENDED_AMOUNT),0) 
                     FROM apps.RA_CUSTOMER_TRX_LINES_ALL
                    WHERE LINE_TYPE = 'LINE'
                      AND CUSTOMER_TRX_ID = (SELECT CUSTOMER_TRX_ID
                                               FROM apps.RA_CUSTOMER_TRX_ALL
                                              WHERE CREATION_DATE = (SELECT MAX(CREATION_DATE)
                                                                       FROM apps.RA_CUSTOMER_TRX_ALL
                                                                       WHERE BILL_TO_CUSTOMER_ID = ACUS.CUSTOMER_ID)
                                                AND BILL_TO_CUSTOMER_ID = ACUS.CUSTOMER_ID
                                                AND ROWNUM = 1)) "VALOR ULTIMA COMPRA"              
    ,HCPROF.CREDIT_CLASSIFICATION CATEGORIA                                                                                                                                                                                  
FROM apps.AR_CUSTOMERS              ACUS,         
          apps.HZ_CUST_ACCT_SITES_ALL    HCASA,                
          --apps.JTF_RS_SALESREPS JRS,
          --apps.JTF_RS_RESOURCE_EXTNS JRR,          
          apps.HZ_CUST_ACCOUNTS HCA,
          apps.HZ_PARTY_SITES HPS,
          apps.HZ_PARTIES HP,
          apps.HZ_LOCATIONS HL,
          apps.HZ_CONTACT_POINTS HCP,
          apps.HZ_CUST_SITE_USES_ALL HCSUA,
          apps.HZ_CUSTOMER_PROFILES HCPROF,   
          apps.HZ_CUST_PROFILE_AMTS HCPA       
WHERE HCASA.CUST_ACCOUNT_ID (+) = ACUS.CUSTOMER_ID   
  --AND RCTA.PRIMARY_SALESREP_ID = JRS.SALESREP_ID(+)
  --AND JRS.RESOURCE_ID = JRR.RESOURCE_ID(+)      
  AND HP.PARTY_ID = HCA.PARTY_ID
  AND HPS.PARTY_ID = HP.PARTY_ID
  AND HPS.LOCATION_ID = HL.LOCATION_ID
  AND HCP.OWNER_TABLE_NAME (+) = 'HZ_PARTIES'
  AND HCP.OWNER_TABLE_ID (+) = HP.PARTY_ID
  AND HCP.CONTACT_POINT_TYPE (+) = 'PHONE'  
  AND HCSUA.SITE_USE_CODE (+) = 'BILL_TO'
  AND HCSUA.CUST_ACCT_SITE_ID (+) = HCASA.CUST_ACCT_SITE_ID  
  AND HCPROF.PARTY_ID = HP.PARTY_ID
  AND HCPROF.CUST_ACCOUNT_ID = -1
  AND HCPA.CUST_ACCOUNT_PROFILE_ID = HCPROF.CUST_ACCOUNT_PROFILE_ID  
  AND HCA.CUST_ACCOUNT_ID = HCASA.CUST_ACCOUNT_ID
  AND HCASA.PARTY_SITE_ID = HPS.PARTY_SITE_ID