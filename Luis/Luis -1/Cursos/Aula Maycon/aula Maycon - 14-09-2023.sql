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

 
 
