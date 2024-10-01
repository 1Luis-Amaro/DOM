
SELECT DISTINCT rct.creation_date,
                rct.customer_trx_id,
                rct.trx_date,
                rct.trx_number,
                rbs.name,
                rctt.name,
                rctl.line_number,
                c.segment1,
                rctl.description,
                RCTL.EXTENDED_AMOUNT,
                --rctl.customer_trx_line_id,
                rctl.global_attribute7,
                zx.global_attribute2,
                zx.tax_rate_code,
                zx.tax_amt,
                zx.global_attribute2,
                jbc.electronic_inv_access_key,
                electronic_inv_protocol,
                jbc.electronic_inv_status
  FROM apps.ra_customer_trx_all rct,
        apps.ra_customer_trx_lines_all rctl,
       apps.ra_batch_sources_all rbs,
       APPS.JL_BR_CUSTOMER_TRX_EXTS JBC,
       apps.ra_cust_trx_types_all rctt,
       APPS.ar_payment_schedules_all a,
       apps.ZX_LINES_V zx,
       apps.mtl_system_items c
 WHERE     RCT.CUSTOMER_TRX_ID = JBC.CUSTOMER_TRX_ID(+)
   --  AND  TRUNC (rct.creation_date) >= TRUNC (SYSDATE -1 ) 
       AND rct.batch_source_id = rbs.batch_source_id
       AND rct.complete_flag = 'Y'
       AND rctt.cust_trx_type_id = rct.cust_trx_type_id
       AND rctt.global_attribute5 IS NOT NULL

       AND rct.customer_trx_id = a.customer_trx_id(+)
       AND rct.org_id = rbs.org_id
--and nvl(jbc.electronic_inv_status,'XX') <> '2'
--and rctt.name = 'VENDA_ST'
and rct.customer_trx_id = rctl.customer_trx_id
and rctl.line_type = 'LINE'
--and rctl.global_attribute7 = '10'
and rct.customer_trx_id = zx.trx_id
and rctl.customer_trx_line_id = zx.trx_line_id
and rct.trx_number IN ('40991','40992')
and zx.tax_rate_code like 'ICMS%ST%C'
and rctl.inventory_item_id = c.inventory_item_id
and rctl.warehouse_id = c.organization_id
ORDER BY 
                RCT.TRX_NUMBER,rctl.line_number,zx.tax_rate_code--rct.creation_date desc--customer_trx_id