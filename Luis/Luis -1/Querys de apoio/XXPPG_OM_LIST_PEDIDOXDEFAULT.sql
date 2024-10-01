SELECT oh.*
      ,nvl(preco_lista_default, 0) - preco_venda_pedido dif_preco
      ,round((nvl(preco_lista_default, 0) - preco_venda_pedido) / (CASE
               WHEN preco_lista_default IS NULL OR preco_lista_default = 0 THEN
                (CASE
                  WHEN preco_venda_pedido = 0 THEN
                   1
                END)
               ELSE
                preco_lista_default
             END) * 100
            ,2) || '%' dif_percent
      ,(CASE
         WHEN preco_lista_default IS NULL THEN
          'Item nao existe na lista de preco Padrao'
         WHEN nvl(preco_lista_default, 0) - preco_venda_pedido < 0 THEN
          'Preco da Lista do Pedido maior que Preco da Lista Padrao'
         WHEN nvl(preco_lista_default, 0) - preco_venda_pedido > 0 THEN
          'Preco da Lista do Pedido Menor que Preco da Lista Padrao'
         ELSE
          'Preco da Lista do Pedido igual ao Preco da Lista Padrao'
       END) obs
FROM   (SELECT ooh.order_number numero_pedido
              ,ott.name tipo_transacao
              ,(SELECT hp.party_name
                FROM   apps.hz_parties hp, apps.hz_cust_accounts hca
                WHERE  hca.party_id = hp.party_id
                AND    hca.cust_account_id = ool.sold_to_org_id) cliente
              ,substr(hcsua.location, 1, instr(hcsua.location, '_', 1) - 1) cnpj
              ,(SELECT qph.name
                FROM   apps.qp_list_headers_all qph
                WHERE  list_header_id = hcsua.price_list_id) lista_preco_default
              ,(SELECT qph.name
                FROM   apps.qp_list_headers_all qph
                WHERE  list_header_id = ool.price_list_id) lista_preco_pedido
              ,trunc(ool.creation_date) data_criacao_pedido
              ,ooh.sales_channel_code canal_venda
              ,ool.ordered_item codigo_item
              ,msi.description descricao_item
              ,ool.unit_list_price preco_lista_pedido
              ,(SELECT qpl.operand
                FROM   apps.qp_list_headers_all   qph
                      ,apps.qp_list_lines         qpl
                      ,apps.qp_pricing_attributes qpa
                WHERE  qph.list_header_id = qpl.list_header_id
                AND    qpl.list_line_id = qpa.list_line_id
                AND    nvl(qpl.end_date_active, SYSDATE + 1) > SYSDATE
                AND    qph.list_header_id = hcsua.price_list_id
                AND    qpa.product_attr_value = ool.inventory_item_id
                AND    qpa.product_uom_code = ool.order_quantity_uom) preco_lista_default
              ,ool.unit_selling_price preco_venda_pedido
              ,decode(ooh.order_source_id
                     ,1002
                     ,'Dynamics'
                     ,1061
                     ,'Dynamics'
                     ,'Oracle') origem_pedido
        FROM   apps.oe_order_headers_all ooh
              ,apps.oe_order_lines_all ool
              ,(SELECT site_use_id
                      ,attribute1 canal
                      ,price_list_id
                      ,location
                FROM   apps.hz_cust_site_uses_all
                UNION
                SELECT site_use_id
                      ,sales_channel canal
                      ,price_list_id
                      ,(SELECT location
                        FROM   apps.hz_cust_site_uses_all
                        WHERE  site_use_id = xocba.site_use_id) location
                FROM   apps.xxppg_om_cross_bu_all xocba) hcsua
              ,apps.mtl_system_items msi
              ,apps.oe_transaction_types_tl ott
        WHERE  ooh.header_id = ool.header_id
        AND    ool.ship_to_org_id = hcsua.site_use_id
        AND    ool.price_list_id <>
               nvl(hcsua.price_list_id, ool.price_list_id)
        AND    ooh.sales_channel_code = hcsua.canal
        AND    msi.inventory_item_id = ool.inventory_item_id
        AND    msi.organization_id = ool.ship_from_org_id
        AND    ool.price_list_id NOT IN (7007, 7008)
        AND    ooh.order_type_id = ott.transaction_type_id
        AND    ott.language = 'PTB'
        AND    ott.name LIKE '%VENDA%'
        AND    ott.name NOT LIKE 'RMA%') oh
WHERE  1 = 1
AND    cliente <> 'PPG INDUSTRIAL DO BRASIL TINTAS E VERNIZES LTDA'
ORDER  BY 1, 3
