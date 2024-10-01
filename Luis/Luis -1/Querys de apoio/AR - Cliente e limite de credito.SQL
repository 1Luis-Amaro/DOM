select distinct 
HP.PARTY_NAME
,HCAS.global_attribute3 ||'.'|| HCAS.global_attribute4 ||'/'||HCAS.global_attribute5 CNPJ
, HCAS.global_attribute3 || HCAS.global_attribute4 CNPJ_RAIZ
,HCA.SALES_CHANNEL_CODE "CANAL VENDA"
, B.currency_code "MOEDA" 
, B.overall_credit_limit "LIM CRD ATUAL" 
, B.trx_credit_limit "LIM CRD ORD" ,HCA.cust_account_id,'-',HCAS.cust_account_id,'-',b.*
from APPS.HZ_CUSTOMER_PROFILES A 
, APPS.HZ_CUST_PROFILE_AMTS B 
, APPS.FND_CURRENCIES_VL C 
, APPS.HZ_PARTIES HP
, APPS.HZ_CUST_ACCOUNTS_ALL HCA
, APPS.hz_cust_acct_sites_all    HCAS
where A.CUST_ACCOUNT_PROFILE_ID = B.CUST_ACCOUNT_PROFILE_ID 
and B.CURRENCY_CODE = C.CURRENCY_CODE 
AND HP.PARTY_ID = A.PARTY_ID
AND HP.PARTY_ID = HCA.PARTY_ID
AND HCA.cust_account_id = HCAS.cust_account_id
AND HP.PARTY_NAME in ('MAGIA DAS CORES TINTAS LTDA','SOLAR COMERCIO E AGROINDUSTRIA LTDA')
--and A.PARTY_ID = 69645
ORDER BY 1
