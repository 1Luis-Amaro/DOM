select rcta.trx_number, rbsa.name origem, rctta.NAME tipo, 
rcta.TRX_DATE DATA, rcta.INTERFACE_HEADER_ATTRIBUTE1 REFERENCIA, rtt.NAME "CONDICAO DE PAGTO" 

from apps.ra_batch_sources_all          rbsa
     ,apps.ra_customer_trx_all          rcta 
     ,APPS.RA_CUST_TRX_TYPES_ALL        rctta
     ,APPS.RA_TERMS_TL                  rtt
     
where rbsa.BATCH_SOURCE_ID            = rcta.BATCH_SOURCE_ID
and rcta.CUST_TRX_TYPE_ID             = rctta.CUST_TRX_TYPE_ID
and rcta.TRX_NUMBER                   = '516'
and rbsa.NAME                         = 'SUM_SERIE_SE_SERVICO_IMP'
--and rcta.INTERFACE_HEADER_ATTRIBUTE1  = '549203'
and rcta.TERM_ID                      = rtt.TERM_ID
and rtt.LANGUAGE                      = 'PTB';

--and rctta.NAME             = 'VENDA_SERVICO_FAT'



SELECT* FROM APPS.RA_CUST_TRX_TYPES_ALL;
SELECT * FROM APPS.ra_customer_trx_all;
SELECT * FROM APPS.RA_TERMS_TL;--tabela armazena condicoes de pagamento

select *
from all_tables
where table_name like '%TERMS%';

_______________________________________________________________________________________________________________

aula 20/09/2023

select rcta.trx_number, 
       rbsa.name origem, 
       rctta.NAME tipo, 
       rcta.TRX_DATE DATA, 
       rcta.INTERFACE_HEADER_ATTRIBUTE1 REFERENCIA, 
       rtt.NAME "CONDICAO DE PAGTO",
       hp.PARTY_NAME

from apps.ra_batch_sources_all          rbsa
     ,apps.ra_customer_trx_all          rcta 
     ,APPS.RA_CUST_TRX_TYPES_ALL        rctta
     ,APPS.RA_TERMS_TL                  rtt
     ,apps.hz_cust_accounts             hca
     ,apps.hz_parties                   hp
          
where rbsa.BATCH_SOURCE_ID            = rcta.BATCH_SOURCE_ID
and rcta.CUST_TRX_TYPE_ID             = rctta.CUST_TRX_TYPE_ID
and rcta.SHIP_TO_CUSTOMER_ID          = hca.CUST_ACCOUNT_ID
and hca.PARTY_ID                      = hp.PARTY_ID
and rcta.TERM_ID                      = rtt.TERM_ID
and rcta.TRX_NUMBER                   = '516'
and rbsa.NAME                         = 'SUM_SERIE_SE_SERVICO_IMP'
and rtt.LANGUAGE                      = 'PTB'
____________________________________________________________

pratica 29/09/2023



aula 29/09/2023

select rcta.trx_number, 
       rbsa.name origem, 
       rctta.NAME tipo, 
       rcta.TRX_DATE DATA, 
       rcta.INTERFACE_HEADER_ATTRIBUTE1 REFERENCIA, 
       rtt.NAME "CONDICAO DE PAGTO",
       hp.PARTY_NAME,
       hl.ADDRESS1,
       hl.ADDRESS2,
       hl.ADDRESS4,
       hl.CITY

from apps.ra_batch_sources_all          rbsa
     ,apps.ra_customer_trx_all          rcta 
     ,APPS.RA_CUST_TRX_TYPES_ALL        rctta
     ,APPS.RA_TERMS_TL                  rtt
     ,apps.hz_cust_accounts             hca
     ,apps.hz_parties                   hp
     ,apps.hz_cust_site_uses_all        hcsua
     ,apps.hz_cust_acct_sites_all       hcasa
     ,apps.hz_party_sites               hps
     ,apps.hz_locations                 hl
          
where rbsa.BATCH_SOURCE_ID            = rcta.BATCH_SOURCE_ID
and rcta.CUST_TRX_TYPE_ID             = rctta.CUST_TRX_TYPE_ID
and rcta.SHIP_TO_CUSTOMER_ID          = hca.CUST_ACCOUNT_ID
and hca.PARTY_ID                      = hp.PARTY_ID
and rcta.TERM_ID                      = rtt.TERM_ID
and hcasa.party_site_id               = hps.party_site_id
and hps.location_id                   = hl.location_id
and hcsua.CUST_ACCT_SITE_ID           = hcasa.CUST_ACCT_SITE_ID
and rcta.TRX_NUMBER                   = '516'
and rbsa.NAME                         = 'SUM_SERIE_SE_SERVICO_IMP'
and rtt.LANGUAGE                      = 'PTB'
and rcta.ship_to_SITE_USE_ID          = '3946'
and hcasa.CUST_ACCT_SITE_ID           = '2533'
and hcsua.SITE_USE_ID                 = '3946'
and hps.PARTY_SITE_ID                 = '11946'
and hl.location_id                    = '2307'
 _____________________________________________________

aula 06/10/2023

select rcta.trx_number, 
       rbsa.name origem, 
       rctta.NAME tipo, 
       rcta.TRX_DATE DATA, 
       rcta.INTERFACE_HEADER_ATTRIBUTE1 REFERENCIA, 
       rtt.NAME "CONDICAO DE PAGTO",
       hp.PARTY_NAME,
       hl.ADDRESS1,
       hl.ADDRESS2,
       hl.ADDRESS4,
       hl.CITY,
       --rctla.CUSTOMER_TRX_LINE_ID,
       rctla.DESCRIPTION "Item",
       rctla.QUANTITY_ORDERED "Quantidade Faturada",
       rctla.TAX_CLASSIFICATION_CODE Classificação
       
       
       
       
       
from apps.ra_batch_sources_all          rbsa
     ,apps.ra_customer_trx_all          rcta 
     ,APPS.RA_CUST_TRX_TYPES_ALL        rctta
     ,APPS.RA_TERMS_TL                  rtt
     ,apps.hz_cust_accounts             hca
     ,apps.hz_parties                   hp
     ,apps.hz_cust_site_uses_all        hcsua
     ,apps.hz_cust_acct_sites_all       hcasa
     ,apps.hz_party_sites               hps
     ,apps.hz_locations                 hl
     ,apps.ra_customer_trx_lines_all    rctla
          
where rbsa.BATCH_SOURCE_ID            = rcta.BATCH_SOURCE_ID
and rcta.CUST_TRX_TYPE_ID             = rctta.CUST_TRX_TYPE_ID
and rcta.SHIP_TO_CUSTOMER_ID          = hca.CUST_ACCOUNT_ID
and hca.PARTY_ID                      = hp.PARTY_ID
and rcta.TERM_ID                      = rtt.TERM_ID
and hcasa.party_site_id               = hps.party_site_id
and hps.location_id                   = hl.location_id
and hcsua.CUST_ACCT_SITE_ID           = hcasa.CUST_ACCT_SITE_ID
and rctla.customer_trx_id             = rcta.customer_trx_id
and rcta.TRX_NUMBER                   = '516'
and rbsa.NAME                         = 'SUM_SERIE_SE_SERVICO_IMP'
and rtt.LANGUAGE                      = 'PTB'
and rcta.ship_to_SITE_USE_ID          = '3946'
and hcasa.CUST_ACCT_SITE_ID           = '2533'
and hcsua.SITE_USE_ID                 = '3946'
and hps.PARTY_SITE_ID                 = '11946'
and hl.location_id                    = '2307'
and rctla.DESCRIPTION = 'SERVICO  HE NISSAN RESENDE'
--and rctla.customer_trx_line_id        = '549203'
--and rctla.customer_trx_id             = '89841'
