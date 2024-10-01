SELECT oha.ORDER_NUMBER,
       oha.ORDERED_DATE,
       ola.line_number || '.' || ola.shipment_number     LINE,
       ola.ordered_quantity,
       msi.segment1 item,                                     --cod item
       mp.ORGANIZATION_CODE
  FROM APPS.OE_ORDER_HEADERS_ALL  oha,
       APPS.OE_ORDER_LINES_ALL    ola,
       apps.mtl_system_items      msi,
       apps.mtl_parameters        mp
 WHERE oha.ORDER_NUMBER          = '551006'
       AND oha.HEADER_ID         = ola.HEADER_ID
       AND ola.inventory_item_id = msi.inventory_item_id
       AND ola.ship_from_org_id  = msi.organization_id
       AND msi.organization_id   = mp.organization_id
       AND mp.organization_code  = 'SUM';

CUST_TRX_TYPE_ID

CUSTOMER_TRX_ID



_____________________________________

12/09/2023

SELECT mp.organization_code
                  ,hp.party_name
                  ,rbsa.name
                  ,rcta.trx_number
                  ,rcta.customer_trx_id
                  ,rctla.customer_trx_line_id
                  ,msi.segment1
                  ,rctla.global_attribute2
                  ,rcta.*
FROM   apps.ra_customer_trx_all       rcta
                  ,apps.ra_customer_trx_lines_all rctla
                  ,apps.ra_batch_sources_all      rbsa
                  ,apps.mtl_system_items          msi
                  ,apps.mtl_parameters            mp
                  ,apps.hz_cust_accounts          hca
                  ,apps.hz_parties                hp

WHERE   RCTA.CUSTOMER_TRX_ID  =  RCTLA.CUSTOMER_TRX_ID
AND     RCTLA.BATCH_SOURCE_ID =  RCTA.BATCH_SOURCE_ID
AND     MSI.ORGANIZATION_ID   =  MP.ORGANIZATION_ID
AND     HCA.PARTY_ID          =  hp.PARTY_ID
AND    rctla.warehouse_id     = msi.organization_id
AND  rcta.sold_to_customer_id = hca.cust_account_id
















mtl_system_items


SELECT *
FROM APPS.OE_ORDER_HEADERS_ALL  --tabela cabecalho de ordem de venda
WHERE ORDER_NUMBER = '551006';

SELECT *
FROM APPS.OE_ORDER_LINES_ALL --tabela linha de ordem de venda
WHERE HEADER_ID = 2258710;

SELECT *
FROM APPS.mtl_system_items --tabela item
WHERE INVENTORY_ITEM_ID = 5140;

select *
from apps.mtl_parameters
where organization_id in (87,92,161)

_______________________________________________
13/09/2023
,apps.ra_customer_trx_lines_all rctla
                  ,apps.ra_batch_sources_all      rbsa
                  ,apps.mtl_system_items          msi
                  ,apps.mtl_parameters            mp
                  ,apps.hz_cust_accounts          hca
                  ,apps.hz_parties                hp
_____________________________________________


