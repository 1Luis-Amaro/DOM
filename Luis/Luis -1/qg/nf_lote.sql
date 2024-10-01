  /********** Seleciona as notas de envio **********/
  SELECT mp.organization_code             "Org",
         rctt.description                 "Tipo NF",
         rcta.trx_date                    "Data NF", 
         msi.segment1                     "Item",
         wdd.lot_number                   "Lote Envio",
         (select to_char(mln.origination_date,'DD/MM/YYYY') 
            from apps.mtl_lot_numbers mln
           where mln.organization_id   = wdd.organization_id
             and mln.inventory_item_id = wdd.inventory_item_id
             and mln.lot_number        = wdd.lot_number) "Dt Fabricacao", 
         (select to_char(mln.expiration_date,'DD/MM/YYYY') 
            from apps.mtl_lot_numbers mln
           where mln.organization_id   = wdd.organization_id
             and mln.inventory_item_id = wdd.inventory_item_id
             and mln.lot_number        = wdd.lot_number) "Vencimento",
         party.party_name                 "Cliente",
         hl.address1                      "Endereco",
         hl.city                          "Cidade",
         rcta.trx_number                  "NFS",
         ncm.categoria                    "NCM",
         oel.line_number  || '.' || oel.shipment_number  "Linha Ordem Venda", 
         wdd.shipped_quantity             "Qtd Envio",
         oel.unit_selling_price           "Preco Unitario"
--
    FROM apps.wsh_delivery_details      wdd,   --Tabela Embarque
         apps.oe_order_headers_all      oeh,   --Ordem de Venda
         apps.oe_order_lines_all        oel,   --Linhas Ordem de Venda
--         
         apps.hz_locations              hl,         
         apps.hz_cust_site_uses_all     hcsua,
         apps.hz_cust_acct_sites_all    hcasa,
         apps.hz_party_sites            hps,
         apps.hz_cust_accounts          cust_acct,
         apps.hz_parties                party,
--
         apps.oe_transaction_types_all  ott,   --Tipo Transacao Ordem de Venda
         apps.oe_transaction_types_tl   tt,    --Traducao Tipo Transacao Ordem de Venda
         apps.mtl_system_items_b        msi,   --Tabela de Itens
         apps.mtl_parameters            mp,    --Tabela Organizacao de Inventarios
--                 
         apps.wsh_delivery_assignments  wda,   --Tabela de delivery (entregas)
         apps.ra_customer_trx_all       rcta,  --Tabela de Nota Fiscal(AR)
         apps.ra_cust_trx_types_all     rctt,  --Tabela de Tipo de Nota Fiscal (AR)
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
   WHERE OEH.SHIP_TO_ORG_ID               = HCSUA.SITE_USE_ID         AND
         msi.organization_id              = ncm.organization_id(+)    AND
         msi.inventory_item_id            = ncm.inventory_item_id(+)  AND
         rctt.cust_trx_type_id            = rcta.cust_trx_type_id     AND
         rcta.interface_header_context    = 'ORDER ENTRY'             AND
         rcta.interface_header_attribute3 = to_char(wda.delivery_id)  AND
         wda.delivery_detail_id           = wdd.delivery_detail_id    AND
         oel.line_id                      = wdd.source_line_id        AND
         msi.organization_id(+)           = mp.organization_id        AND
         msi.inventory_item_id            = oel.inventory_item_id     AND
         mp.organization_id               = oel.ship_from_org_id      AND
         tt.transaction_type_id           = ott.transaction_type_id   AND
         tt.transaction_type_id           = oeh.order_type_id         AND
         tt.LANGUAGE                      = 'PTB'                     AND
         oeh.header_id                    = oel.header_id             AND
         oeh.sold_to_org_id               = cust_acct.cust_account_id AND
         hps.location_id                  = hl.location_id            AND
         hcsua.site_use_code              = 'SHIP_TO'                 AND
         hcsua.cust_acct_site_id          = hcasa.cust_acct_site_id   AND
         hcasa.party_site_id              = hps.party_site_id         AND
         hps.party_id                     = party.party_id            AND
         cust_acct.party_id               = party.party_id            AND
         msi.segment1            = nvl('FIEE-00007.22',segment1) and
--         
         rcta.trx_date  >= sysdate -202;  


select * from apps.oe_transaction_types_all  ott;