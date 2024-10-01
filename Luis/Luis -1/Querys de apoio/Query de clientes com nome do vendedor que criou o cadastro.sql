
SELECT PARTY_NAME NOME,
       HI.last_update_date,
       HI.Creation_date,
       SALES_CHANNEL_CODE BU,
       HE.ADDRESS1 ENDERECO,
       HE.ADDRESS2 NUMERO,
       HE.CITY CIDADE,
       HE.POSTAL_CODE CEP,
       SUBSTR(HUDD.GLOBAL_ATTRIBUTE3, 2) || (HUDD.GLOBAL_ATTRIBUTE4) ||
       (HUDD.GLOBAL_ATTRIBUTE5) CNPJ,
       HA.STATUS,
        (SELECT salesrep_number
            FROM apps.jtf_rs_salesreps
           WHERE salesrep_id = HUD.primary_salesrep_id)
            num_vendedor,
         (SELECT resource_name
            FROM apps.JTF_RS_DEFRESOURCES_V a, apps.jtf_rs_salesreps b
           WHERE     b.salesrep_id = HUD.primary_salesrep_id
                 AND b.resource_id = a.resource_id)
            nome_vendedor
  FROM APPS.HZ_CUST_ACCOUNTS       HA,
       APPS.HZ_LOCATIONS           HE,
       APPS.HZ_PARTIES             HI,
       APPS.HZ_PARTY_SITES         HO,
       APPS.HZ_CUST_SITE_USES_ALL  HUD,
       APPS.HZ_CUST_ACCT_SITES_ALL HUDD
 WHERE HA.PARTY_ID = HI.PARTY_ID
   AND HE.LOCATION_ID = HO.LOCATION_ID
   AND HO.PARTY_ID = HA.PARTY_ID
   AND PARTY_TYPE = 'ORGANIZATION'
   AND HUD.CUST_ACCT_SITE_ID = HUDD.CUST_ACCT_SITE_ID
   AND HO.PARTY_SITE_ID = HUDD.PARTY_SITE_ID
   AND HUD.SITE_USE_CODE = 'SHIP_TO';
   

