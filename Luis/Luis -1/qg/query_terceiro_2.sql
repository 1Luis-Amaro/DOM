/**********************************************************/

  SELECT --wdd.*, 
         mp.organization_code       "Org",
         party.party_name           "Fornecedor",
         rcta.trx_number            "NFS",
         rcta.trx_date              "Data NF", 
         msi.segment1               "Item",
         wdd.lot_number             "Lote Envio",
         oel.line_number  || '.' || oel.shipment_number  "Linha Ordem Venda", 
         wdd.shipped_quantity       "Qtd Envio",
         oeh.order_number           "RMA",
         oelr.line_number || '.' || oelr.shipment_number "Linha Ordem Venda RMA",
         rt.primary_quantity        "Qtd Recebida",
         oelr.ordered_quantity      "Qtd RMA",
         tt.name                    "Tipo Envio",
         ttr.name                   "Tipo RMA",
         mil.description            "Endereco",
         oel.unit_selling_price     "Preco Unitario",
         rsh.receipt_num            "Numero RI",
         cfi.invoice_num            "Nr NFE",
         cfi.series                 "Serie",
         TRUNC(rt.transaction_date) "Data Recebimento",
--         
         (select max(ROUND((rtt.transaction_date - rcta.trx_date),0))
            from apps.rcv_transactions            rtt,
                 apps.oe_order_lines_all          oelrt
           where oelrt.header_id            = oehr.header_id AND
                 rtt.destination_context(+) = 'INVENTORY' AND
                 rtt.oe_order_line_id(+)    = oelrt.line_id) "TEMPO MAX",
--
         ROUND((nvl(rt.transaction_date, sysdate) - rcta.trx_date),0) "Tempo Retorno",
         --
         rt.transaction_date,
         mpt.organization_code,
        (SELECT SUM(ohq.transaction_quantity)
            FROM apps.mtl_onhand_quantities     ohq
           WHERE ohq.inventory_item_id = wdd.inventory_item_id     AND
                 ohq.lot_number        = wdd.lot_number            AND
                 ohq.organization_id   = mpt.organization_id       AND
                 ohq.locator_id        = mil.inventory_location_id) "Saldo Terceiro"
    FROM apps.wsh_delivery_details        wdd,   --Tabela Embarque
         apps.oe_order_headers_all        oeh,   --Ordem de Venda
         apps.oe_order_headers_all        oehr,  --Ordem de Venda         
         apps.oe_order_lines_all          oel,   --Linhas Ordem de Venda
         apps.oe_order_lines_all          oelr,  --Linhas Ordem de Venda RMA
         apps.hz_locations                hl,         
         apps.hz_cust_site_uses_all       hcsua,
         apps.hz_cust_acct_sites_all      hcasa,
         apps.hz_party_sites              hps,
         apps.hz_cust_accounts            cust_acct,
         apps.hz_parties                  party,
         apps.oe_transaction_types_all    ott,
         apps.oe_transaction_types_tl     tt,    --Tipo Transacao Ordem de Venda
         apps.oe_transaction_types_tl     ttr,   --Tipo Transacao Ordem de Venda
         apps.mtl_system_items_b          msi,   --Tabela de Itens
         apps.mtl_parameters              mp,    --Tabela Organizacao de Inventarios
         apps.mtl_parameters              mpi,   --Tabela Organizacao de Inventários - intermediária
         apps.mtl_parameters              mpt,   --Tabela Organizacao de Inventários - Terceiros
         apps.rcv_transactions            rt,    --Tabela transacoes do recebimento
         apps.mtl_material_transactions   mtt,   --Tabela de movimentacao de estoque
         apps.mtl_transaction_lot_numbers mtl,   --Tabela de lotes da movimentacao de estoque
         apps.rcv_shipment_headers        rsh,   --Tabela de RI
         apps.cll_f189_invoices           cfi,   --Tabela de Notas Fiscais Recebimento
         apps.mtl_item_locations          mil,   --Tabela de enderecos de subinventario
         apps.wsh_delivery_assignments    wda,   --Tabela de delivery (entregas)
         apps.ra_customer_trx_all         rcta   --Tabela de Nota Fiscal(AR)
   WHERE     OEH.SHIP_TO_ORG_ID               = HCSUA.SITE_USE_ID
         AND mil.description               LIKE SUBSTR(PARTY.PARTY_NAME,1,5) || '.' ||
                                                HCASA.GLOBAL_ATTRIBUTE3 || '%' ||
                                                ott.attribute2
         AND mtl.lot_number                   = wdd.lot_number
         AND mtl.transaction_id               = mtt.transaction_id
         AND mtt.source_code                  = 'RCV'
         AND mtt.rcv_transaction_id           = rt.transaction_id
--AND rcta.trx_number = 150          
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
         --AND PARTY.party_name                 LIKE '%MAX PAC TERC%'
         order by rcta.trx_number, oel.line_number, oelr.line_id;