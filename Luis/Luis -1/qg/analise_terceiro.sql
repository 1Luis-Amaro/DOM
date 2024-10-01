SELECT DISTINCT rct.trx_date,
                rct.trx_number,
                rbs.name origem,
                rbs.global_attribute3 serie_nf,
                rctt.name tipo_transacao,
                e.party_name                          razao_social_cliente,
                decode(acct.global_attribute2,'1','CPF','2','CNPJ','ESTRANGEIRO')     tipo_cliente,
                decode(acct.global_attribute2,'1',acct.global_attribute3||acct.global_attribute5,
                                              '2',acct.global_attribute3||acct.global_attribute4||acct.global_attribute5,
                                              '3',acct.global_attribute3)           cpf_cnpj_cliente,
                rctl.line_number,
                oehr.order_number           "RMA",
                oelr.line_number || '.' || oelr.shipment_number "Linha Ordem Venda RMA",
                oelr.flow_status_code      "Estado RMA",
                prh.segment1 Requisicao,
                c.segment1 item,
                rctl.description item_desc,
                rctl.global_attribute1 cfop,
                RCTL.EXTENDED_AMOUNT valor_linha,
                zx.global_attribute2 ncm,
                rctl.uom_code,
                rctl.quantity_invoiced,
                rctl.unit_selling_price,
                zx.tax_rate_code,
                zx.tax_amt valor_imp
              ,(SELECT sum(quantity_invoiced * unit_selling_price)
                  FROM apps.ra_customer_trx_lines_all rctl
                 WHERE rct.customer_trx_id = rctl.customer_trx_id) valor_nf
  FROM apps.ra_customer_trx_all        rct,
       apps.ra_customer_trx_lines_all  rctl,
       apps.ra_batch_sources_all       rbs,
       APPS.JL_BR_CUSTOMER_TRX_EXTS    JBC,
       apps.ra_cust_trx_types_all      rctt,
       APPS.ar_payment_schedules_all   a,
       apps.ZX_LINES_V                 zx,
       apps.mtl_system_items           c,
       apps.hz_locations               loc
      ,apps.hz_party_sites             party
      ,apps.hz_cust_site_uses_all      site
      ,apps.hz_cust_acct_sites_all     acct
      ,apps.hz_parties                 e
      ,apps.wsh_delivery_assignments   wda   --Tabela de delivery (entregas)
      ,apps.wsh_delivery_details       wdd   --Tabela Embarque      
      ,apps.oe_order_lines_all         oel   --Linhas Ordem de Venda
      ,apps.oe_order_lines_all         oelr  --Linhas Ordem de Venda RMA
      ,apps.oe_order_headers_all       oeh   --Ordem de Venda RMA
      ,apps.oe_order_headers_all       oehr  --Ordem de Venda RMA
      ,apps.po_requisition_headers_all prh
 WHERE     RCT.CUSTOMER_TRX_ID             = JBC.CUSTOMER_TRX_ID(+)
       AND rct.batch_source_id             = rbs.batch_source_id
       AND rct.complete_flag               = 'Y'
       AND rctt.cust_trx_type_id           = rct.cust_trx_type_id
       AND rctt.global_attribute5 IS NOT NULL
       AND rct.customer_trx_id             = a.customer_trx_id(+)
       AND rct.org_id                      = rbs.org_id
       and rct.customer_trx_id             = rctl.customer_trx_id
       and rctl.line_type                  = 'LINE'
       and rct.customer_trx_id             = zx.trx_id
       and rctl.customer_trx_line_id       = zx.trx_line_id
       and rct.trx_number IN ('271158')
       and rctl.inventory_item_id          = c.inventory_item_id
       and rctl.warehouse_id               = c.organization_id
       and rct.ship_to_site_use_id         = site.site_use_id
       and site.cust_acct_site_id          = acct.cust_acct_site_id
       and party.party_site_id             = acct.party_site_id
       and party.party_id                  = e.party_id
       and party.location_id               = loc.location_id
       and rct.org_id                      = rbs.org_id
       AND rct.interface_header_context    = 'ORDER ENTRY'
       AND rct.interface_header_attribute3 = to_char(wda.delivery_id)
       AND wda.delivery_detail_id          = wdd.delivery_detail_id
       AND oel.line_id                     = wdd.source_line_id
       AND oelr.reference_line_id(+)       = oel.line_id
       AND oehr.header_id(+)               = oelr.header_id
       and oeh.header_id(+)                = oel.header_id
       and prh.segment1(+)                 = oeh.orig_sys_document_ref
--       
       ORDER BY 2,9;


select * from po_requisition_headers_all;

apps.oe_order_headers_all      oeh,   --Ordem de Venda