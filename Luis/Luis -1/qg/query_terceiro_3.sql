/**********************************************************/

  /********** Seleciona as notas de envio **********/
  SELECT mp.organization_code             "Org",
         party.party_name                 "Fornecedor",
         rcta.trx_number                  "NFS",
         rcta.trx_date                    "Data NF", 
         rctt.description                 "Tipo NF",
         msi.segment1                     "Item",
         ncm.categoria                    "NCM",
         wdd.lot_number                   "Lote Envio",
         oel.line_number  || '.' || oel.shipment_number  "Linha Ordem Venda", 
         wdd.shipped_quantity             "Qtd Envio",
         oel.unit_selling_price           "Preco Unitario",
--
         ---- Incluir
         (SELECT SUM(zx.tax_amt) FROM apps.ra_customer_trx_lines_all rctl,
                                      apps.ZX_LINES_V                zx
                                WHERE zx.trx_id              = rcta.customer_trx_id
                                  AND zx.trx_line_id         = rctl.customer_trx_line_id
                                  AND rctl.customer_trx_id   = rcta.customer_trx_id
                                  AND rctl.line_type         = 'LINE'
                                  AND rctl.inventory_item_id = msi.inventory_item_id
                                  AND zx.tax_rate_code    LIKE 'ICMS%_C') ICMS,
--
         (SELECT SUM(zx.tax_amt) FROM apps.ra_customer_trx_lines_all rctl,
                                      apps.ZX_LINES_V                zx
                                WHERE zx.trx_id              = rcta.customer_trx_id
                                  AND zx.trx_line_id         = rctl.customer_trx_line_id
                                  AND rctl.customer_trx_id   = rcta.customer_trx_id
                                  AND rctl.line_type         = 'LINE'
                                  AND rctl.inventory_item_id = msi.inventory_item_id
                                  AND zx.tax_rate_code    LIKE 'IPI%_C') IPI,
         ---- Incluir
         NULL                             "RMA",
         ''                               "Linha Ordem Venda RMA",
         NULL                             "Qtd Recebida",
         tt.name                          "Tipo Envio",
         ''                               "Tipo RMA",
         ''                               "Estado RMA",
         mil.description                  "Endereco",
--
--
--       
         ''                               "Numero RI",
         NULL                             "Nr NFE",
         ''                               "Serie",
         ''                               "Tipo NFE",
         NULL                             "Data Recebimento",
        (select max(ROUND((nvl(rtt.transaction_date,sysdate) - rcta.trx_date),0))
            from apps.rcv_transactions        rtt,
                 apps.oe_order_lines_all      oelrt
           where oelrt.header_id            = oeh.header_id      AND
                 oelrt.line_category_code    = 'RETURN'           AND
                 rtt.destination_context(+) = 'INVENTORY'        AND
                 rtt.oe_order_line_id(+)    = oelrt.line_id) "Tempo Decorrido",
--
        -- round(sysdate - rcta.trx_date,0) "Tempo Decorrido",
         mpt.organization_code            "Org terc",
        (SELECT SUM(ohq.transaction_quantity)
            FROM apps.mtl_onhand_quantities     ohq
           WHERE ohq.inventory_item_id = wdd.inventory_item_id     AND
                 ohq.lot_number        = wdd.lot_number            AND
                 ohq.organization_id   = mpt.organization_id       AND
                 ohq.locator_id        = mil.inventory_location_id) "Saldo Terceiro"
--  
    FROM apps.wsh_delivery_details      wdd,   --Tabela Embarque
         apps.oe_order_headers_all      oeh,   --Ordem de Venda
       --  apps.oe_order_headers_all      oehr,  --Ordem de Venda         
         apps.oe_order_lines_all        oel,   --Linhas Ordem de Venda
       --  apps.oe_order_lines_all        oelr,  --Linhas Ordem de Venda RMA
--         
         apps.hz_locations              hl,         
         apps.hz_cust_site_uses_all     hcsua,
         apps.hz_cust_acct_sites_all    hcasa,
         apps.hz_party_sites            hps,
         apps.hz_cust_accounts          cust_acct,
         apps.hz_parties                party,
--
         apps.oe_transaction_types_all  ott,
         apps.oe_transaction_types_tl   tt,    --Tipo Transacao Ordem de Venda
      -- apps.oe_transaction_types_tl   ttr,   --Tipo Transacao Ordem de Venda
--
         apps.mtl_system_items_b        msi,   --Tabela de Itens
         apps.mtl_parameters            mp,    --Tabela Organizacao de Inventarios
         apps.mtl_parameters            mpi,   --Tabela Organizacao de Inventários - intermediária
         apps.mtl_parameters            mpt,   --Tabela Organizacao de Inventários - Terceiros
--
         --apps.rcv_transactions          rt,    --Tabela transacoes do recebimento
         --apps.rcv_shipment_headers      rsh,   --Tabela de RI
         --apps.cll_f189_invoices         cfi,   --Tabela de Notas Fiscais Recebimento
--         
         apps.mtl_item_locations        mil,   --Tabela de enderecos de subinventario
--                 
         apps.wsh_delivery_assignments  wda,   --Tabela de delivery (entregas)
         apps.ra_customer_trx_all       rcta,   --Tabela de Nota Fiscal(AR)
         apps.ra_cust_trx_types_all     rctt,   --Tabela de Tipo de Nota Fiscal (AR)
--         
         (SELECT mic.inventory_item_id,
                 mic.organization_id,
                 mic.category_set_name,
                 mic.category_concat_segs categoria
            FROM apps.mtl_item_categories_v mic, apps.mtl_categories_v mc
           WHERE mc.category_id = mic.category_id
             AND mic.category_set_name IN ('FISCAL_CLASSIFICATION')) ncm
--
--        
   WHERE     OEH.SHIP_TO_ORG_ID               = HCSUA.SITE_USE_ID
         AND mil.description               LIKE SUBSTR(PARTY.PARTY_NAME,1,5) || '.' ||
                                                HCASA.GLOBAL_ATTRIBUTE3 || '%' ||
                                                ott.attribute2
--
         AND msi.organization_id              = ncm.organization_id(+)
         AND msi.inventory_item_id            = ncm.inventory_item_id(+)
--                                                
        --AND cfi.operation_id(+)              = rsh.receipt_num
        -- AND cfi.organization_id(+)           = rsh.organization_id 
        -- AND rsh.shipment_header_id(+)        = rt.shipment_header_id         
        -- AND rt.transaction_type(+)           = 'RECEIVE'   
        -- AND rt.oe_order_line_id(+)           = oelr.line_id
         AND rctt.cust_trx_type_id            = rcta.cust_trx_type_id
         AND rcta.interface_header_context    = 'ORDER ENTRY'
         AND rcta.interface_header_attribute3 = to_char(wda.delivery_id)
         AND wda.delivery_detail_id           = wdd.delivery_detail_id
         AND oel.line_id                      = wdd.source_line_id
         AND msi.organization_id(+)           = mpt.organization_id
         AND msi.inventory_item_id            = oel.inventory_item_id
         AND mpt.organization_code            = nvl(hcsua.attribute4,mpi.organization_code)
         AND mpi.organization_id              = mp.attribute6
         AND mp.organization_id               = oel.ship_from_org_id
      --   AND ttr.transaction_type_id          = oelr.line_type_id
      --   AND ttr.LANGUAGE                     = 'PTB'
         AND ott.attribute5                   is not null
         AND tt.transaction_type_id           = ott.transaction_type_id 
         AND tt.transaction_type_id           = oeh.order_type_id
         AND tt.LANGUAGE                      = 'PTB'
      --   AND oelr.reference_line_id           = oel.line_id
      --   AND oehr.header_id                   = oelr.header_id
         AND oeh.header_id                    = oel.header_id
         AND oeh.sold_to_org_id               = cust_acct.cust_account_id
         AND hps.location_id                  = hl.location_id
         AND hcsua.site_use_code              = 'SHIP_TO'         
         AND hcsua.cust_acct_site_id          = hcasa.cust_acct_site_id
         AND hcasa.party_site_id              = hps.party_site_id
         AND hps.party_id                     = party.party_id
         AND cust_acct.party_id               = party.party_id   
         --AND PARTY.party_name                 LIKE '%MAX PAC TERC%'
--         
UNION         
--
  /******* Seleciona os retornos com Lote ******/
  SELECT mp.organization_code       "Org",
         party.party_name           "Fornecedor",
         rcta.trx_number            "NFS",
         rcta.trx_date              "Data NF", 
         ''                         "Tipo NF",         
         msi.segment1               "Item",
         ncm.categoria              "NCM",
         mtl.lot_number             "Lote Envio",
         oel.line_number  || '.' || oel.shipment_number  "Linha Ordem Venda", 
         NULL                          "Qtd Envio",
         oel.unit_selling_price     "Preco Unitario",
         ---- Incluir
         (SELECT SUM(zx.tax_amt) FROM apps.ra_customer_trx_lines_all rctl,
                                      apps.ZX_LINES_V                zx
                                WHERE zx.trx_id              = rcta.customer_trx_id
                                  AND zx.trx_line_id         = rctl.customer_trx_line_id
                                  AND rctl.customer_trx_id   = rcta.customer_trx_id
                                  AND rctl.line_type         = 'LINE'
                                  AND rctl.inventory_item_id = msi.inventory_item_id
                                  AND zx.tax_rate_code    LIKE 'ICMS%_C') ICMS,
--
         (SELECT SUM(zx.tax_amt) FROM apps.ra_customer_trx_lines_all rctl,
                                      apps.ZX_LINES_V                zx
                                WHERE zx.trx_id              = rcta.customer_trx_id
                                  AND zx.trx_line_id         = rctl.customer_trx_line_id
                                  AND rctl.customer_trx_id   = rcta.customer_trx_id
                                  AND rctl.line_type         = 'LINE'
                                  AND rctl.inventory_item_id = msi.inventory_item_id
                                  AND zx.tax_rate_code    LIKE 'IPI%_C') IPI,
         oeh.order_number           "RMA",
         oelr.line_number || '.' || oelr.shipment_number "Linha Ordem Venda RMA",
         mtl.transaction_quantity   "Qtd Recebida",
         --oelr.ordered_quantity      "Qtd RMA",
         tt.name                    "Tipo Envio",
         ttr.name                   "Tipo RMA",
         oelr.flow_status_code      "Estado RMA",
         mil.description            "Endereco",
         ---- Incluir
         rsh.receipt_num            "Numero RI",
         cfi.invoice_num            "Nr NFE",
         cfi.series                 "Serie",
         cfit.description           "Tipo NFE",
         TRUNC(rt.transaction_date) "Data Recebimento",
         ROUND((nvl(rt.transaction_date, sysdate) - rcta.trx_date),0) "Tempo Decorrido",
         mpt.organization_code      "Org Terc",
         NULL                       "Saldo Terceiro"
--         
--        (SELECT SUM(ohq.transaction_quantity)
--            FROM apps.mtl_onhand_quantities     ohq
--           WHERE ohq.inventory_item_id = wdd.inventory_item_id     AND
--                 ohq.lot_number        = wdd.lot_number            AND
--                 ohq.organization_id   = mpt.organization_id       AND
--                 ohq.locator_id        = mil.inventory_location_id) "Saldo Terceiro"
--  
    FROM apps.wsh_delivery_details      wdd,   --Tabela Embarque
         apps.oe_order_headers_all      oeh,   --Ordem de Venda
         apps.oe_order_headers_all      oehr,  --Ordem de Venda         
         apps.oe_order_lines_all        oel,   --Linhas Ordem de Venda
         apps.oe_order_lines_all        oelr,  --Linhas Ordem de Venda RMA
--         
         apps.hz_locations              hl,         
         apps.hz_cust_site_uses_all     hcsua,
         apps.hz_cust_acct_sites_all    hcasa,
         apps.hz_party_sites            hps,
         apps.hz_cust_accounts          cust_acct,
         apps.hz_parties                party,
--
         apps.oe_transaction_types_all  ott,
         apps.oe_transaction_types_tl   tt,    --Tipo Transacao Ordem de Venda
         apps.oe_transaction_types_tl   ttr,   --Tipo Transacao Ordem de Venda
--
         apps.mtl_system_items_b        msi,   --Tabela de Itens
         apps.mtl_parameters            mp,    --Tabela Organizacao de Inventarios
         apps.mtl_parameters            mpi,   --Tabela Organizacao de Inventários - intermediária
         apps.mtl_parameters            mpt,   --Tabela Organizacao de Inventários - Terceiros
--
         apps.rcv_transactions          rt,    --Tabela transacoes do recebimento
         apps.rcv_shipment_headers      rsh,   --Tabela de RI
         apps.cll_f189_invoices         cfi,   --Tabela de Notas Fiscais Recebimento
         apps.cll_f189_invoice_types    cfit,  --Tabela de Tipo de Notas Fiscais
--       
         apps.mtl_material_transactions   mtt,   --Tabela de movimentacao de estoque
         apps.mtl_transaction_lot_numbers mtl,   --Tabela de lotes da movimentacao de estoque
--
--         
         apps.mtl_item_locations        mil,   --Tabela de enderecos de subinventario
--                 
         apps.wsh_delivery_assignments  wda,   --Tabela de delivery (entregas)
         apps.ra_customer_trx_all       rcta,  --Tabela de Nota Fiscal(AR)
         (SELECT mic.inventory_item_id,
                 mic.organization_id,
                 mic.category_set_name,
                 mic.category_concat_segs categoria
            FROM apps.mtl_item_categories_v mic, apps.mtl_categories_v mc
           WHERE mc.category_id = mic.category_id
             AND mic.category_set_name IN ('FISCAL_CLASSIFICATION')) ncm
--         
--        
   WHERE     OEH.SHIP_TO_ORG_ID               = HCSUA.SITE_USE_ID
         AND mil.description               LIKE SUBSTR(PARTY.PARTY_NAME,1,5) || '.' ||
                                                HCASA.GLOBAL_ATTRIBUTE3 || '%' ||
                                                ott.attribute2
--
         AND msi.organization_id              = ncm.organization_id(+)
         AND msi.inventory_item_id            = ncm.inventory_item_id(+)
--                                                
         AND mtl.lot_number                   = wdd.lot_number
         AND mtl.transaction_id               = mtt.transaction_id
--      
         AND mtt.source_code                  = 'RCV'
         AND mtt.rcv_transaction_id(+)        = rt.transaction_id
--          
         AND cfit.organization_id(+)          = cfi.organization_id
         AND cfit.invoice_type_id(+)          = cfi.invoice_type_id                                      
         AND cfi.operation_id(+)              = rsh.receipt_num
         AND cfi.organization_id(+)           = rsh.organization_id 
         AND rsh.shipment_header_id(+)        = rt.shipment_header_id         
         AND rt.destination_context(+)        = 'INVENTORY'   
         AND rt.oe_order_line_id(+)           = oelr.line_id
         AND rcta.interface_header_context    = 'ORDER ENTRY'
         AND rcta.interface_header_attribute3 = to_char(wda.delivery_id)
         AND wda.delivery_detail_id           = wdd.delivery_detail_id
         AND oel.line_id                      = wdd.source_line_id
         AND msi.organization_id(+)           = mpt.organization_id
         AND msi.inventory_item_id            = oel.inventory_item_id
         AND mpt.organization_code            = nvl(hcsua.attribute4,mpi.organization_code)
         AND mpi.organization_id              = mp.attribute6
         AND mp.organization_id               = oel.ship_from_org_id
         AND ttr.transaction_type_id          = oelr.line_type_id
         AND ttr.LANGUAGE                     = 'PTB'
         AND ott.attribute5                   is not null
         AND tt.transaction_type_id           = ott.transaction_type_id 
         AND tt.transaction_type_id           = oeh.order_type_id
         AND tt.LANGUAGE                      = 'PTB'
         AND oelr.reference_line_id           = oel.line_id
         AND oehr.header_id                   = oelr.header_id
         AND oeh.header_id                    = oel.header_id
         AND oeh.sold_to_org_id               = cust_acct.cust_account_id
         AND hps.location_id                  = hl.location_id
         AND hcsua.site_use_code              = 'SHIP_TO'         
         AND hcsua.cust_acct_site_id          = hcasa.cust_acct_site_id
         AND hcasa.party_site_id              = hps.party_site_id
         AND hps.party_id                     = party.party_id
         AND cust_acct.party_id               = party.party_id        
        -- AND PARTY.party_name                 LIKE '%MAX PAC TERC%'
--        
UNION
--
  SELECT mp.organization_code  as     "Org",
         party.party_name           "Fornecedor",
         rcta.trx_number            "NFS",
         rcta.trx_date              "Data NF", 
         ''                         "Tipo NF",         
         msi.segment1               "Item",
         ncm.categoria              "NCM",
         wdd.lot_number             "Lote Envio",
         oel.line_number  || '.' || oel.shipment_number  "Linha Ordem Venda", 
         NULL                       "Qtd Envio",
         oel.unit_selling_price     "Preco Unitario",
         ---- Incluir
         (SELECT SUM(zx.tax_amt) FROM apps.ra_customer_trx_lines_all rctl,
                                      apps.ZX_LINES_V                zx
                                WHERE zx.trx_id              = rcta.customer_trx_id
                                  AND zx.trx_line_id         = rctl.customer_trx_line_id
                                  AND rctl.customer_trx_id   = rcta.customer_trx_id
                                  AND rctl.line_type         = 'LINE'
                                  AND rctl.inventory_item_id = msi.inventory_item_id
                                  AND zx.tax_rate_code    LIKE 'ICMS%_C') ICMS,
--
         (SELECT SUM(zx.tax_amt) FROM apps.ra_customer_trx_lines_all rctl,
                                      apps.ZX_LINES_V                zx
                                WHERE zx.trx_id              = rcta.customer_trx_id
                                  AND zx.trx_line_id         = rctl.customer_trx_line_id
                                  AND rctl.customer_trx_id   = rcta.customer_trx_id
                                  AND rctl.line_type         = 'LINE'
                                  AND rctl.inventory_item_id = msi.inventory_item_id
                                  AND zx.tax_rate_code    LIKE 'IPI%_C') IPI,
         ---- Incluir
         oeh.order_number           "RMA",
         oelr.line_number || '.' || oelr.shipment_number "Linha Ordem Venda RMA",
         rt.primary_quantity        "Qtd Recebida",
         tt.name                    "Tipo Envio",
         ttr.name                   "Tipo RMA",
         oelr.flow_status_code      "Estado RMA",
         mil.description            "Endereco",
--         
         rsh.receipt_num            "Numero RI",
         cfi.invoice_num            "Nr NFE",
         cfi.series                 "Serie",
         cfit.description           "Tipo NFE",
         TRUNC(rt.transaction_date) "Data Recebimento",
         ROUND((nvl(rt.transaction_date, sysdate) - rcta.trx_date),0) "Tempo Decorrido",
         mpt.organization_code      "Org Terc",
         NULL                       "Saldo Terceiro"
--         
--        (SELECT SUM(ohq.transaction_quantity)
--            FROM apps.mtl_onhand_quantities     ohq
--           WHERE ohq.inventory_item_id = wdd.inventory_item_id     AND
--                 ohq.lot_number        = wdd.lot_number            AND
--                 ohq.organization_id   = mpt.organization_id       AND
--                 ohq.locator_id        = mil.inventory_location_id) "Saldo Terceiro"
--  
    FROM apps.wsh_delivery_details      wdd,   --Tabela Embarque
         apps.oe_order_headers_all      oeh,   --Ordem de Venda
         apps.oe_order_headers_all      oehr,  --Ordem de Venda         
         apps.oe_order_lines_all        oel,   --Linhas Ordem de Venda
         apps.oe_order_lines_all        oelr,  --Linhas Ordem de Venda RMA
--        
         apps.hz_locations              hl,         
         apps.hz_cust_site_uses_all     hcsua,
         apps.hz_cust_acct_sites_all    hcasa,
         apps.hz_party_sites            hps,
         apps.hz_cust_accounts          cust_acct,
         apps.hz_parties                party,
--
         apps.oe_transaction_types_all  ott,
         apps.oe_transaction_types_tl   tt,    --Tipo Transacao Ordem de Venda
         apps.oe_transaction_types_tl   ttr,   --Tipo Transacao Ordem de Venda
--
         apps.mtl_system_items_b        msi,   --Tabela de Itens
         apps.mtl_parameters            mp,    --Tabela Organizacao de Inventarios
         apps.mtl_parameters            mpi,   --Tabela Organizacao de Inventários - intermediária
         apps.mtl_parameters            mpt,   --Tabela Organizacao de Inventários - Terceiros
--
         apps.rcv_transactions          rt,    --Tabela transacoes do recebimento
         apps.rcv_shipment_headers      rsh,   --Tabela de RI
         apps.cll_f189_invoices         cfi,   --Tabela de Notas Fiscais Recebimento
         apps.cll_f189_invoice_types    cfit,  --Tabela de Tipo de Notas Fiscais         
--         
         apps.mtl_item_locations        mil,   --Tabela de enderecos de subinventario
--                 
         apps.wsh_delivery_assignments  wda,   --Tabela de delivery (entregas)
         apps.ra_customer_trx_all       rcta,  --Tabela de Nota Fiscal(AR)
         (SELECT mic.inventory_item_id,
                 mic.organization_id,
                 mic.category_set_name,
                 mic.category_concat_segs categoria
            FROM apps.mtl_item_categories_v mic, apps.mtl_categories_v mc
           WHERE mc.category_id = mic.category_id
             AND mic.category_set_name IN ('FISCAL_CLASSIFICATION')) ncm
--         
--        
   WHERE     oeh.ship_to_org_id               = hcsua.site_use_id
         AND mil.description               LIKE SUBSTR(party.party_name,1,5) || '.' ||
                                                hcasa.global_attribute3 || '%' ||
                                                ott.attribute2
--                                                
         AND msi.organization_id              = ncm.organization_id(+)
         AND msi.inventory_item_id            = ncm.inventory_item_id(+)
--        
         AND wdd.lot_number                 IS NULL                                
--
         AND cfit.organization_id(+)          = cfi.organization_id
         AND cfit.invoice_type_id(+)          = cfi.invoice_type_id                                      
         AND cfi.operation_id(+)              = rsh.receipt_num
         AND cfi.organization_id(+)           = rsh.organization_id 
         AND rsh.shipment_header_id(+)        = rt.shipment_header_id         
         AND rt.destination_context(+)        = 'INVENTORY'   
         AND rt.oe_order_line_id(+)           = oelr.line_id
         AND rcta.interface_header_context    = 'ORDER ENTRY'
         AND rcta.interface_header_attribute3 = to_char(wda.delivery_id)
         AND wda.delivery_detail_id           = wdd.delivery_detail_id
         AND oel.line_id                      = wdd.source_line_id
         AND msi.organization_id(+)           = mpt.organization_id
         AND msi.inventory_item_id            = oel.inventory_item_id
         AND mpt.organization_code            = nvl(hcsua.attribute4,mpi.organization_code)
         AND mpi.organization_id              = mp.attribute6
         AND mp.organization_id               = oel.ship_from_org_id
         AND ttr.transaction_type_id          = oelr.line_type_id
         AND ttr.LANGUAGE                     = 'PTB'
         AND ott.attribute5                  is not null
         AND tt.transaction_type_id           = ott.transaction_type_id 
         AND tt.transaction_type_id           = oeh.order_type_id
         AND tt.LANGUAGE                      = 'PTB'
         AND oelr.reference_line_id           = oel.line_id
         AND oehr.header_id                   = oelr.header_id
         AND oeh.header_id                    = oel.header_id
         AND oeh.sold_to_org_id               = cust_acct.cust_account_id
         AND hps.location_id                  = hl.location_id
         AND hcsua.site_use_code              = 'SHIP_TO'         
         AND hcsua.cust_acct_site_id          = hcasa.cust_acct_site_id
         AND hcasa.party_site_id              = hps.party_site_id
         AND hps.party_id                     = party.party_id
         AND cust_acct.party_id               = party.party_id        
--        
--                 
         order by 1, 3, 7, 8
          

