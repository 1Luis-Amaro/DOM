/* Formatted on 16/9/2016 10:09:10 (QP5 v5.267.14150.38573) */
SELECT CUST_REC.CUSTOMER_ID,
       CUST_REC.SITE_USE_ID,
       CUST_REC.CUST_RECEIPT_METHOD_ID,
       cust.account_number,
       part.party_name,
          HL.ADDRESS1
       || '|'
       ||                                               -- direccion entrega 9
         HL.ADDRESS2
       || ' '
       ||                                       -- numero direccion entrega 10
         HL.ADDRESS4
       || ' '
       ||                                                 -- barrio entrega 11
         HL.ADDRESS3
       || ' '
       ||                                            -- complemento entrega 12
         HL.POSTAL_CODE
       || ' '
       ||                                                    -- CEP entrega 13
         ''
       || ' '
       ||                                       -- ponto referencia entrega 14
         HL.CITY
       || ' '
       ||                                                 -- cidade entrega 15
         HL.STATE
       || ' '
       ||                                                     -- UF entrega 16
         HL.COUNTRY
          endereco,
       REC.name,
       CUST_REC.primary_flag,CUST_REC.END_DATE
  FROM APPS.AR_RECEIPT_METHODS REC,
       apps.ra_cust_receipt_methods CUST_REC,
       apps.hz_cust_accounts cust,
       apps.hz_parties part,
       apps.hz_cust_site_uses_all hcsua,
       apps.hz_cust_acct_sites_all hcasa,
       apps.hz_party_sites hps,
       apps.HZ_LOCATIONS HL
 WHERE     REC.name IN ('BRASIL_5115_76104_ESCR')              --METODO ANTIGO
       AND REC.RECEIPT_METHOD_ID = CUST_REC.RECEIPT_METHOD_ID
       AND TRUNC (NVL (CUST_REC.END_DATE, SYSDATE)) >= TRUNC (SYSDATE)
       AND CUST_REC.customer_id = cust.cust_account_id
       AND cust.party_id = part.party_id
--       AND CUST_REC.CUSTOMER_ID IN (1059, 163160, 174154)
       AND CUST_REC.SITE_USE_ID = hcsua.SITE_USE_ID
       AND hcsua.cust_acct_site_id = hcasa.cust_acct_site_id
       AND hcasa.party_site_id = hps.party_site_id
       AND hps.party_id = part.party_id
       AND HPS.LOCATION_ID = HL.LOCATION_ID;