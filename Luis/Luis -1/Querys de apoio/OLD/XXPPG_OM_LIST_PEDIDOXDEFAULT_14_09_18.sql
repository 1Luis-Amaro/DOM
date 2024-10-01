SELECT oh.*
  ,nvl(PRECO_LISTA_DEFAULT,0) - PRECO_VENDA_PEDIDO                      DIF_PRECO
  ,round((nvl(PRECO_LISTA_DEFAULT,0) - PRECO_VENDA_PEDIDO)/(CASE WHEN PRECO_LISTA_DEFAULT is null or PRECO_LISTA_DEFAULT = 0 THEN PRECO_VENDA_PEDIDO ELSE PRECO_LISTA_DEFAULT END)*100,2)||'%'  DIF_PERCENT
  ,(CASE WHEN PRECO_LISTA_DEFAULT IS NULL THEN 'Item nao existe na lista de preco Padrao' 
         WHEN nvl(PRECO_LISTA_DEFAULT,0) - PRECO_VENDA_PEDIDO < 0 THEN 'Preco da Lista do Pedido maior que Preco da Lista Padrao'
         WHEN nvl(PRECO_LISTA_DEFAULT,0) - PRECO_VENDA_PEDIDO > 0 THEN 'Preco da Lista do Pedido Menor que Preco da Lista Padrao'
    ELSE 'Preco da Lista do Pedido igual ao Preco da Lista Padrao' END) OBS
  FROM (SELECT ooh.order_number NUMERO_PEDIDO,
               ott.name TIPO_TRANSACAO,
               (SELECT hp.party_name
                  FROM apps.hz_parties hp, apps.hz_cust_accounts hca
                 WHERE     hca.party_id = hp.party_id
                       AND hca.cust_account_id = ool.sold_to_org_id)
                  CLIENTE,
               SUBSTR (hcsua.location, 1, INSTR (hcsua.location, '_', 1) - 1)
                  CNPJ,
               (SELECT qph.name
                  FROM apps.qp_list_headers_all qph
                 WHERE list_header_id = hcsua.price_list_id)
                  LISTA_PRECO_DEFAULT,
               (SELECT qph.name
                  FROM apps.qp_list_headers_all qph
                 WHERE list_header_id = ool.price_list_id)
                  LISTA_PRECO_PEDIDO,
               TRUNC (ool.creation_date) DATA_CRIACAO_PEDIDO,
               ooh.sales_channel_code CANAL_VENDA,
               ool.ordered_item CODIGO_ITEM,
               msi.description DESCRICAO_ITEM,
               ool.unit_list_price PRECO_LISTA_PEDIDO,
               (SELECT QPL.OPERAND
                  FROM APPS.QP_LIST_HEADERS_ALL QPH,
                       APPS.QP_LIST_LINES QPL,
                       APPS.QP_PRICING_ATTRIBUTES QPA
                 WHERE     QPH.LIST_HEADER_ID = QPL.LIST_HEADER_ID
                       AND QPL.LIST_LINE_ID = QPA.LIST_LINE_ID
                       AND NVL (QPL.END_DATE_ACTIVE, SYSDATE + 1) > SYSDATE
                       AND QPH.LIST_HEADER_ID = HCSUA.PRICE_LIST_ID
                       AND QPA.PRODUCT_ATTR_VALUE = OOL.INVENTORY_ITEM_ID
                       AND QPA.product_uom_code = ool.ORDER_QUANTITY_UOM
                       )
                  PRECO_LISTA_DEFAULT,
               ool.unit_selling_price PRECO_VENDA_PEDIDO               
          FROM apps.oe_order_headers_all ooh,
               apps.oe_order_lines_all ool,
               (select site_use_id,attribute1 canal,price_list_id,location from apps.hz_cust_site_uses_all
                   union
                select site_use_id,sales_channel canal,price_list_id,(select location 
                                                                        from apps.hz_cust_site_uses_all
                                                                          where site_use_id = xocba.site_use_id) location
                 from apps.xxppg_om_cross_bu_all xocba
               ) hcsua,
               apps.mtl_system_items msi,
               APPS.OE_TRANSACTION_TYPES_TL ott               
         WHERE     ooh.header_id = ool.header_id
               AND ool.ship_to_org_id = hcsua.site_use_id
               AND ool.price_list_id <> NVL (hcsua.price_list_id, ool.price_list_id)
               AND ooh.sales_channel_code = hcsua.canal
               AND msi.inventory_item_id = ool.inventory_item_id
               AND msi.organization_id = ool.ship_from_org_id
               AND ool.price_list_id NOT IN (7007, 7008)
               AND ooh.order_type_id = ott.transaction_type_id
               AND ott.LANGUAGE = 'PTB'
               and ott.name like '%VENDA%' and ott.name not like 'RMA%'
               ) oh
 WHERE 1=1
   and cliente <> 'PPG INDUSTRIAL DO BRASIL TINTAS E VERNIZES LTDA'
 ORDER BY 1,3