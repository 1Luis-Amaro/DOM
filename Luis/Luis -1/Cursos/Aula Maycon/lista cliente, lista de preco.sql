Alter session set current_schema=apps;

BEGIN
         Fnd_Client_Info.SET_ORG_CONTEXT ( TO_CHAR(82) ) ;
         mo_global.set_policy_context    ( 'S', 82 ) ;
END;

select *
FROM apps.qp_secu_list_headers_v qp
where name = 'INAMVIAMSP'



COM
''



-------------------------------------------------------------------------
SELECT hp.party_name,
          SUBSTR (hcas.global_attribute3, 2, 9)
       || hcas.global_attribute4
       || hcas.global_attribute5
          cnpj,
       hl.state,
       hl.city,
       qp.attribute1 BU,
       qp.name                   lista_preco,
       qpl.product_attr_val_disp item,
       msi.description,
       qpl.PRODUCT_UOM_CODE,
       qpl.operand               valor,
       ROUND (
          apps.inv_convert.inv_um_convert (
             msi.inventory_item_id,
             msi.primary_uom_code,
             NVL (msi.secondary_uom_code, msi.primary_uom_code)),
          0)
          embalagem,
       qpl.last_update_date
  FROM apps.qp_secu_list_headers_v qp,
       apps.qp_list_lines_v        qpl,
       apps.mtl_system_items       msi,
       apps.hz_parties             hp,
       apps.hz_cust_accounts       hca,
       apps.HZ_CUST_ACCT_SITES_ALL hcas,
       apps.HZ_CUST_SITE_USES_ALL  hcsua,
       apps.hz_party_sites         hps,
       apps.hz_locations           hl
 WHERE     qp.attribute1 = 'IND'
       --and    qp.name in ('IN1046','PERTO182')
       AND qp.list_header_id = qpl.list_header_id
       AND msi.segment1 = qpl.product_attr_val_disp
       AND msi.organization_id = 87
       --   and qpl.product_attr_val_disp = 'PCT1G-4522B.4P'
       AND NVL (qp.end_date_active, SYSDATE) >= SYSDATE
       AND NVL (qpl.end_date_active, SYSDATE) >= SYSDATE
       AND qp.list_header_id = hcsua.price_list_id
       --AND hp.party_name like  'AGCO%'
       AND hp.party_id = hca.party_id
       AND hca.CUST_ACCOUNT_ID = hcas.CUST_ACCOUNT_ID
       AND hcsua.CUST_ACCT_SITE_ID = hcas.CUST_ACCT_SITE_ID
       AND hcsua.site_use_code = 'SHIP_TO'
       AND hps.party_id = hca.party_id
       AND hcas.party_site_id = hps.party_site_id
       AND hps.location_id = hl.location_id
--       AND hl.state NOT IN ('EX', 'ex')
--
UNION
--
SELECT NULL                      party_name,
       NULL                      cnpj,
       NULL                      state,
       NULL                      city,
       qp.attribute1 BU,
       qp.name                   lista_preco,
       qpl.product_attr_val_disp item,
       msi.description,
       qpl.PRODUCT_UOM_CODE,
       qpl.operand               valor,
       ROUND (
          apps.inv_convert.inv_um_convert (
             msi.inventory_item_id,
             msi.primary_uom_code,
             NVL (msi.secondary_uom_code, msi.primary_uom_code)),
          0)
          embalagem,
       qpl.last_update_date
  FROM apps.qp_secu_list_headers_v qp,
       apps.qp_list_lines_v        qpl,
       apps.mtl_system_items       msi
 WHERE     qp.attribute1 = 'IND'
       --qp.name in ('IN1046','PERTO182')
       AND qp.list_header_id = qpl.list_header_id
       AND msi.segment1 = qpl.product_attr_val_disp
       AND msi.organization_id = 87
       --   and qpl.product_attr_val_disp = 'PCT1G-4522B.4P'
       AND NVL (qp.end_date_active, SYSDATE) >= SYSDATE
       AND NVL (qpl.end_date_active, SYSDATE) >= SYSDATE
       AND NOT EXISTS
              (SELECT 1
                 FROM apps.HZ_CUST_SITE_USES_ALL hcsua
                WHERE qp.list_header_id = hcsua.price_list_id)
ORDER BY 1,
         2,
         5,
         6;
         
-------------------------------------------------------------------------



/* Formatted on 7/7/2015 15:59:21 (QP5 v5.267.14150.38573) */
SELECT hp.party_name,
          SUBSTR (hcas.global_attribute3, 2, 9)
       || hcas.global_attribute4
       || hcas.global_attribute5
          cnpj,
       hl.state,
       hl.city,
       qp.name lista_preco,
       qpl.product_attr_val_disp item,
       msi.description,
       qpl.PRODUCT_UOM_CODE,
       qpl.operand valor,
       ROUND (
          apps.inv_convert.inv_um_convert (
             msi.inventory_item_id,
             msi.primary_uom_code,
             NVL (msi.secondary_uom_code, msi.primary_uom_code)),
          0)
          embalagem,qpl.last_update_date,qp.attribute1
  FROM apps.qp_secu_list_headers_v qp,
       apps.qp_list_lines_v qpl,
       apps.mtl_system_items msi,
       apps.hz_parties hp,
       apps.hz_cust_accounts hca,
       apps.HZ_CUST_ACCT_SITES_ALL hcas,
       apps.HZ_CUST_SITE_USES_ALL hcsua,
       apps.hz_party_sites hps,
       apps.hz_locations hl
 WHERE     qp.name LIKE 'IN%'
       and qp.list_header_id = qpl.list_header_id
       AND msi.segment1 = qpl.product_attr_val_disp
       AND msi.organization_id = 87
       --   and qpl.product_attr_val_disp = 'PCT1G-4522B.4P'
       AND NVL (qpl.end_date_active, SYSDATE) >= SYSDATE
       AND NVL (qpl.end_date_active, SYSDATE) >= SYSDATE
      AND qp.list_header_id = hcsua.price_list_id
       --AND hp.party_name like  'AGCO%'
       AND hp.party_id = hca.party_id
       AND hca.CUST_ACCOUNT_ID = hcas.CUST_ACCOUNT_ID
       AND hcsua.CUST_ACCT_SITE_ID = hcas.CUST_ACCT_SITE_ID
       AND hcsua.site_use_code = 'SHIP_TO'
       AND hps.party_id = hca.party_id
       AND hcas.party_site_id = hps.party_site_id
       AND hps.location_id = hl.location_id
       AND hl.state NOT IN ('EX', 'ex');
       
       select *
       from apps.qp_list_lines_v qpl
       
       
       SELECT 
       qp.name lista_preco,
       qpl.product_attr_val_disp item,
       msi.description,
       qpl.PRODUCT_UOM_CODE,
       qpl.operand valor,
       ROUND (
          apps.inv_convert.inv_um_convert (
             msi.inventory_item_id,
             msi.primary_uom_code,
             NVL (msi.secondary_uom_code, msi.primary_uom_code)),
          0)
          embalagem,qpl.last_update_date,qp.*
  FROM apps.qp_secu_list_headers_v qp,
       apps.qp_list_lines_v qpl,
       apps.mtl_system_items msi
 WHERE     qp.name LIKE 'IN1046%'
       and qp.list_header_id = qpl.list_header_id
       AND msi.segment1 = qpl.product_attr_val_disp
       AND msi.organization_id = 87


SELECT hp.party_name,
          SUBSTR (hcas.global_attribute3, 2, 9)
       || hcas.global_attribute4
       || hcas.global_attribute5
          cnpj,
       hl.state,
       hl.city,
       qp.name lista_preco,
       qpl.product_attr_val_disp item,
       cust_item.item_cliente,
       msi.description,
       qpl.operand valor,
       ROUND (
          apps.inv_convert.inv_um_convert (
             msi.inventory_item_id,
             msi.primary_uom_code,
             NVL (msi.secondary_uom_code, msi.primary_uom_code)),
          0)
          embalagem,qpl.last_update_date
  FROM apps.qp_secu_list_headers_v qp,
       apps.qp_list_lines_v qpl,
       apps.mtl_system_items msi,
       apps.hz_parties hp,
       apps.hz_cust_accounts hca,
       apps.HZ_CUST_ACCT_SITES_ALL hcas,
       apps.HZ_CUST_SITE_USES_ALL hcsua,
       apps.hz_party_sites hps,
       apps.hz_locations hl,
       (SELECT customer_item_number ITEM_CLIENTE,
       customer_name,
       customer_number,
       cnpj,
       CONCATENATED_SEGMENTS ITEM_PPG,
       ITEM_DESCRIPTION
  FROM APPS.MTL_CUSTOMER_ITEM_XREFS_V A,
       (SELECT DISTINCT
               hcasa.cust_acct_site_id,
               hp.party_name cliente,
               SUBSTR (hcsua.location, 1, INSTR (hcsua.location, '_', 1) - 1)
                  cnpj
          FROM apps.hz_parties hp,
               apps.hz_cust_accounts hca,
               apps.hz_cust_site_uses_all hcsua,
               apps.hz_cust_acct_sites_all hcasa,
               apps.hz_party_sites hps,
               apps.hz_locations hl
         WHERE     hcsua.cust_acct_site_id = hcasa.cust_acct_site_id
               AND hcasa.party_site_id = hps.party_site_id
               AND hps.party_id = hp.party_id
               AND hp.party_id = hca.party_id
               AND hps.location_id = hl.location_id
               AND hcsua.site_use_code = 'SHIP_TO') B
 WHERE A.ADDRESS_ID = B.cust_acct_site_id       
) cust_item
 WHERE --    qp.name LIKE 'IN%'
        qp.list_header_id = qpl.list_header_id
       AND msi.segment1 = qpl.product_attr_val_disp
       AND msi.organization_id = 87
       --   and qpl.product_attr_val_disp = 'PCT1G-4522B.4P'
       AND NVL (qpl.end_date_active, SYSDATE) >= SYSDATE
       AND NVL (qpl.end_date_active, SYSDATE) >= SYSDATE
       AND qp.list_header_id = hcsua.price_list_id
       AND hp.party_name like  'AGCO%'
       AND hp.party_id = hca.party_id
       AND hca.CUST_ACCOUNT_ID = hcas.CUST_ACCOUNT_ID
       AND hcsua.CUST_ACCT_SITE_ID = hcas.CUST_ACCT_SITE_ID
       AND hcsua.site_use_code = 'SHIP_TO'
       AND hps.party_id = hca.party_id
       AND hcas.party_site_id = hps.party_site_id
       AND hps.location_id = hl.location_id
       AND hl.state NOT IN ('EX', 'ex')
       and hca.account_number = cust_item.customer_number(+)
       and msi.segment1 = cust_item.item_ppg(+);


              
       select
       apps.inv_convert.inv_um_convert(msi.inventory_item_id,msi.primary_uom_code,msi.secondary_uom_code)
       from apps.mtl_system_items msi
       where segment1 = 'LT0001SDD.50'
       AND msi.organization_id = 87

select hp.party_name,hca.party_id,hcas.*--,hcsua.price_list_id,substr(hcas.global_attribute3,2,9)||hcas.global_attribute4||hcas.global_attribute5 cnpj,hl.state,hl.city,hps.*
from apps.hz_parties hp,
    apps.hz_cust_accounts hca,
    apps.HZ_CUST_ACCT_SITES_ALL hcas,
    apps.HZ_CUST_SITE_USES_ALL hcsua,
    apps.hz_party_sites hps--,
    --apps.hz_locations hl
where hp.party_name = 'ELECTROLUX DO BRASIL SA'
and hp.party_id = hca.party_id
and hca.CUST_ACCOUNT_ID = hcas.CUST_ACCOUNT_ID
and hcsua.CUST_ACCT_SITE_ID = hcas.CUST_ACCT_SITE_ID
and hcsua.site_use_code = 'SHIP_TO'
and hps.party_id = hca.party_id
and hcas.party_site_id = hps.party_site_id
and hps.location_id = hl.location_id

select *
from apps.hz_party_sites hps
where party_id = 74142

select hl.state,hl.city
from apps.hz_locations hl
where hl.location_id in (--6430,
3090)--= 8763

select *
from 

select *--product_attr_val_disp,operand valor
from apps.qp_secu_list_headers_v--qp_list_lines_v qpl
where list_header_id = 11336
and product_attr_val_disp = 'PCT1G-4522B.4P'


select *
from apps.mtl_parameters
where organizatioN_code = 'ITM'
