SELECT DISTINCT
         mtp.organization_code,
         oel.ship_from_org_id,
         oeh.header_id,
         oel.line_id,
         oeh.order_source_id,
         oos.name origem,
         TO_NUMBER (wdd_1.delivery_id, '999999999999') nro_embarque,
         ottt.name tipo_ordem,
         TO_CHAR (TRUNC (oeh.creation_date), 'dd/mm/rrrr') data_criacao,
         oeh.sales_channel_code canal_de_venda,
         oel.ordered_item,
         oeh.order_number pedido,
         CASE
            WHEN oeh.flow_status_code = 'BOOKED'
            THEN
               'Aprovado'
            WHEN oeh.flow_status_code NOT IN ('BOOKED', 'CLOSED', 'CANCELLED')
            THEN
               'Nao Avaliado'
         END
            credito,
         CASE
            WHEN     oeh.flow_status_code NOT IN
                        ('CANCELLED',
                         'CLOSED',
                         'AWAITING_SHIPPING',
                         'BOOKED',
                         'INVOICE_INCOMPLETE',
                         'AWAITING_RETURN')
                 AND oel.flow_status_code NOT IN
                        ('CANCELLED',
                         'CLOSED',
                         'AWAITING_SHIPPING',
                         'BOOKED',
                         'INVOICE_INCOMPLETE',
                         'AWAITING_RETURN')
            THEN
               'Completo'
            WHEN     oeh.flow_status_code IN
                        ('CANCELLED',
                         'CLOSED',
                         'AWAITING_SHIPPING',
                         'BOOKED',
                         'INVOICE_INCOMPLETE',
                         'AWAITING_RETURN')
                 AND oel.flow_status_code IN
                        ('CANCELLED',
                         'CLOSED',
                         'AWAITING_SHIPPING',
                         'BOOKED',
                         'INVOICE_INCOMPLETE',
                         'AWAITING_RETURN')
            THEN
               'Incompleto'
         END
            completo,
         (SELECT flv.meaning
            FROM apps.fnd_lookup_values flv
           WHERE     lookup_type = 'FLOW_STATUS'
                 AND flv.language = 'PTB'
                 AND flv.lookup_code = oeh.flow_status_code)
            status_pedido,
         (SELECT flv.meaning
            FROM apps.fnd_lookup_values flv
           WHERE     lookup_type = 'LINE_FLOW_STATUS'
                 AND flv.language = 'PTB'
                 AND flv.lookup_code = oel.flow_status_code)
            status_linha,
         e.party_number cod_cli,
            hcasa.global_attribute3
         || hcasa.global_attribute4
         || hcasa.global_attribute5
            cnpj,
         e.party_name nome_abr,
         hl.city,
         hl.state,
         (SELECT DISTINCT hcp.credit_classification
            FROM ar.hz_customer_profiles hcp
           WHERE hcp.party_id = e.party_id AND hcp.cust_account_id = -1)
            perfil_cliente,
         e.attribute1 perfil_porte,
         oel.salesrep_id,
         jrs.salesrep_number,
         APPS.XXPPG_QP_SOURCING_FIELDS_PKG.Get_SALESREP_MANAGER (
            oel.salesrep_id,
            'nvl(srex.source_mgr_name, srex.source_name)')
            gerente,
         APPS.XXPPG_QP_SOURCING_FIELDS_PKG.GET_SALESREP_INFO (
            OEL.SALESREP_ID,
            'SREP.SALESREP_NUMBER||''|''||SREX.SOURCE_NAME',
            'SREP.SALESREP_ID')
            REP_INF,
         APPS.XXPPG_QP_SOURCING_FIELDS_PKG.GET_SALESREP_MANAGER_INFO (
            OEL.SALESREP_ID)
            GER_TERR,
         rat.name || ' - ' || rat.description name,
         (select name from apps.qp_list_headers_all where list_header_id = oeh.price_list_id) tabela_preco,
         --
         --
         oel.unit_selling_price,
         nvl(wdd_1.requested_quantity,ordered_quantity) ordered_quantity,   -- Ciro 09/04/2015
         -- oel.ordered_quantity
         --
         --NVL (oel.ordered_quantity, 0) * NVL (oel.unit_selling_price, 0) -- Ciro 09/04/2015
                 nvl(wdd_1.requested_quantity,ordered_quantity) * NVL (oel.unit_selling_price, 0)
            vlr_pedido,
         --
         CASE                                                           -- # 1
            WHEN nvl(WDD_1.RELEASED_STATUS,'ZZ') IN( 'B','R','ZZ') THEN 0
            ELSE nvl(wdd_1.requested_quantity,ordered_quantity)               -- Ciro 09/04/2015
         END
            requested_quantity,
         wdd_1.shipped_quantity,
         -- oel.ordered_quantity    -- Ciro 09/04/2015
         --
         NVL (wdd_1.shipped_quantity, 0) * NVL (oel.unit_selling_price, 0)
            vlr_faturado,
         --
         TO_CHAR (oeh.creation_date, 'DD/MM/rrrr') dt_pedido,
         TO_CHAR (oel.schedule_ship_date, 'dd/mm/rrrr') dt_entrega,
         --
         WDD_1.seal_code sit_embarque,
         oel.shipment_priority_code,
         TO_CHAR ((select creation_date from apps.wsh_new_deliveries where delivery_id = wdd_1.delivery_id), 'dd/mm/rrrr') dt_embarque,
         --
         oel.cancelled_quantity,
         oel.cancelled_quantity *NVL (oel.unit_selling_price, 0)  valor_cancelado,
         --
         CASE                                                           -- # 1
            WHEN WDD_1.RELEASED_STATUS IN('B','R') THEN nvl(wdd_1.requested_quantity,ordered_quantity)
            ELSE 0
         END
            qtd_saldo_item,     -- Ciro 09/04/2015
           --(  oel.ordered_quantity
          --  - (NVL (oel.cancelled_quantity, 0) + NVL (oel.shipped_quantity, 0)))
        -- - wdd_1.requested_quantity
        --    qtd_saldo_item,
         --
         --
         --
         -- (  oel.ordered_quantity
         --  - (NVL (oel.cancelled_quantity, 0) + NVL (oel.shipped_quantity, 0)))
         nvl(wdd_1.requested_quantity,ordered_quantity)                           -- Ciro 09/04/2015
                                 * NVL (oel.unit_selling_price, 0)
            vlr_mercadoria,
         --+=============================================
         -- oel.unit_selling_price,
         --+=============================================
         e.attribute3 ramo_atividade,                       --  Ramo Atividade
         hps.attribute17 regiao_demanda,                  -- regiao de demanda
         hps.attribute16 sub_ramo_ativ,               -- sub ramo de atividade
         CASE                                                           -- # 1
            WHEN nvl(WDD_1.RELEASED_STATUS,'ZZ') IN( 'B','R','ZZ')
            THEN
               0
            ELSE
                 nvl(wdd_1.requested_quantity,ordered_quantity)
               - NVL (WDD_1.CANCELLED_QUANTITY, oel.cancelled_quantity)
         END
            qtde_item_alocado,
         /*-- NVL (wdd_1.requested_quantity, 0) qtde_item_alocado,
         NVL (wdd_1.requested_quantity, 0)
       - NVL (WDD_1.CANCELLED_QUANTITY, 0)
          qtde_item_alocado,
          --*/
         --
         CASE                                                           -- # 1
            WHEN nvl(WDD_1.RELEASED_STATUS,'ZZ') IN( 'B','R','ZZ')
            THEN
               0
            ELSE
               (  (  nvl(wdd_1.requested_quantity,ordered_quantity)
                   - NVL (WDD_1.CANCELLED_QUANTITY, oel.CANCELLED_QUANTITY))
                * NVL (oel.unit_selling_price, 0))
         END
            vlr_merc_alocado,
         --
         --
         CASE                                                           -- # 1
            WHEN nvl(WDD_1.RELEASED_STATUS,'ZZ') IN( 'B','R','ZZ')
            THEN
               -- (  NVL (oel.ordered_quantity, 0)
               --  - (NVL (oel.cancelled_quantity, 0))
               nvl(wdd_1.requested_quantity,ordered_quantity)            -- Ciro 09/04/2015
            --  - NVL (wdd_1.cancelled_quantity, 0))
            ELSE
               0
         END
            qtde_item_nao_aloc,
         --
         /*--
          (  NVL (oel.ordered_quantity, 0)
           - (NVL (oel.cancelled_quantity, 0))
           - (  NVL (wdd_1.requested_quantity, 0)
              - NVL (wdd_1.cancelled_quantity, 0)))
             qtde_item_nao_aloc,
            --*/
         --
         CASE                                                           -- # 1
            WHEN nvl(WDD_1.RELEASED_STATUS,'ZZ') IN( 'B','R','ZZ')
            THEN
                 --  (  NVL (oel.ordered_quantity, 0) --- - (  NVL (wdd_1.requested_quantity, 0)
                 --   - NVL (wdd_1.cancelled_quantity, 0))
                 nvl(wdd_1.requested_quantity,ordered_quantity)          -- Ciro 09/04/2015
               * NVL (oel.unit_selling_price, 0)
            ELSE
               0
         END
            vlr_merc_nao_alocado,
         --
         /* --
          (  NVL (oel.ordered_quantity, 0)
           - (  NVL (wdd_1.requested_quantity, 0)
              - NVL (wdd_1.cancelled_quantity, 0)))
        * NVL (oel.unit_selling_price, 0)
           vlr_merc_nao_alocado,
           --*/
         --
         oel.unit_list_price,
         --       
         round( ((NVL (oel.unit_list_price, 0)-NVL (oel.unit_selling_price, 0)) / CASE WHEN (NVL(oel.unit_list_price, 1) = 0) THEN 1 ELSE NVL(oel.unit_list_price, 1) END   )*100    ,2)
         /*100 - CASE
            WHEN NVL (oel.unit_list_price, 0) > NVL (oel.unit_selling_price, 0)
            THEN
                 100
               - TRUNC (
                    (  (  1
                        -   (  NVL (oel.unit_selling_price, 0)
                             / NVL (oel.unit_list_price, 0))
                          * 100)
                     + 100),
                    2)
         END*/
            percent_desc_item,
        --
         --
         oeh.freight_carrier_code,
         --rctla.global_attribute1 nat_op,
         --rctta.description tipo_nat_op,
         --rcta.ship_via,
         (SELECT wcs.ship_method_meaning
            FROM apps.wsh_carrier_services wcs
           WHERE wcs.ship_method_code = wdd_1.ship_method_code)
            metodo_entrega,
         msib.inventory_item_id,
         msib.primary_uom_code,
         msib.unit_weight,
         --NVL (ROUND (1 / mucc.CONVERSION_RATE, 2), 0) CONVERSION_RATE,
         (inv_convert.inv_um_convert(msib.inventory_item_id,5,1,msib.primary_uom_code,oel.ordered_quantity_uom2,null,null)) CONVERSION_RATE,
         --
         -- Volume Faturado
         apps.inv_convert.inv_um_convert (
            msib.inventory_item_id,
            0,
            nvl(wdd_1.shipped_quantity,0),
            msib.primary_uom_code,
            NVL ('l', msib.primary_uom_code),
            NULL,
            NULL)
            volume_faturado,
         --
         -- Quantidade Pedida em Litros
         apps.inv_convert.inv_um_convert (
            msib.inventory_item_id,
            0,
            nvl(wdd_1.requested_quantity,ordered_quantity),  -- Ciro 09/04/2015
            ----oel.ordered_quantity,         
            msib.primary_uom_code,
            NVL ('l', msib.primary_uom_code),
            NULL,
            NULL)
            volume_pedido_lts,
         --
                     CASE                                                        -- # 1
               WHEN nvl(WDD_1.RELEASED_STATUS,'ZZ') IN( 'B','R','ZZ')
               THEN
                  0
               ELSE
                    nvl(wdd_1.requested_quantity,ordered_quantity)
                  - NVL (WDD_1.CANCELLED_QUANTITY, oel.cancelled_quantity)
            END
        ---- NVL (wdd_1.requested_quantity, 0) - NVL (WDD_1.CANCELLED_QUANTITY, 0)
            qtde_atendida,
         --
         -- Quantidade Alocada em Litros
         apps.inv_convert.inv_um_convert (
            msib.inventory_item_id,
            0,
            CASE                                                        -- # 1
               WHEN nvl(WDD_1.RELEASED_STATUS,'ZZ') IN('B','R','ZZ')
               THEN
                  0
               ELSE
                    nvl(wdd_1.requested_quantity,ordered_quantity)
                  - NVL (WDD_1.CANCELLED_QUANTITY, oel.cancelled_quantity)
            END,
            ----     NVL (wdd_1.requested_quantity, 0)
            ----   - NVL (WDD_1.CANCELLED_QUANTITY, 0),
            msib.primary_uom_code,
            NVL ('l', msib.primary_uom_code),
            NULL,
            NULL)
            volume_alocado_lts,
         --
         -- Saldo em Litros
        apps.inv_convert.inv_um_convert (
            msib.inventory_item_id,
            0,
            CASE                                                        -- # 1
               WHEN nvl(WDD_1.RELEASED_STATUS,'ZZ') IN('B','R','ZZ')
               THEN
                  nvl(wdd_1.requested_quantity,ordered_quantity)
                  - NVL (WDD_1.CANCELLED_QUANTITY, oel.cancelled_quantity)
               ELSE
                   0
            END,
            ----     NVL (wdd_1.requested_quantity, 0)
            ----   - NVL (WDD_1.CANCELLED_QUANTITY, 0),
            msib.primary_uom_code,
            NVL ('l', msib.primary_uom_code),
            NULL,
            NULL)
            volume_saldo_lts,
         --
            round(CASE                                                           -- # 1
            WHEN nvl(WDD_1.RELEASED_STATUS,'ZZ') IN( 'B','R','ZZ')
            THEN
               -- (  NVL (oel.ordered_quantity, 0)
               --  - (NVL (oel.cancelled_quantity, 0))
               nvl(wdd_1.requested_quantity,ordered_quantity)            -- Ciro 09/04/2015
            --  - NVL (wdd_1.cancelled_quantity, 0))
            ELSE
               0
            END
            * nvl(oel.unit_selling_price,0) ,2)        
            vlr_saldo_lts,
         --
         -- Saldo não alocado em Litros
         apps.inv_convert.inv_um_convert (
            msib.inventory_item_id,
            0,
            CASE                                                        -- # 1
               WHEN nvl(WDD_1.RELEASED_STATUS,'ZZ') IN('B','R','ZZ')
               THEN
                  nvl(wdd_1.requested_quantity,ordered_quantity)
                  - NVL (WDD_1.CANCELLED_QUANTITY, oel.cancelled_quantity)
               ELSE
                   0
            END,
            ----     NVL (wdd_1.requested_quantity, 0)
            ----   - NVL (WDD_1.CANCELLED_QUANTITY, 0),
            msib.primary_uom_code,
            NVL ('l', msib.primary_uom_code),
            NULL,
            NULL)
            volume_nao_alocado_lts
         --
         --
         ,(SELECT MEANING
               FROM apps.FND_LOOKUP_VALUES FLV_RELEASED
              WHERE     FLV_RELEASED.LOOKUP_TYPE = 'PICK_STATUS'
                    AND FLV_RELEASED.LOOKUP_CODE = WDD_1.RELEASED_STATUS
                    AND FLV_RELEASED.LANGUAGE = 'PTB'   
                    AND FLV_RELEASED.VIEW_APPLICATION_ID = 665
                    AND FLV_RELEASED.SECURITY_GROUP_ID = 0) Released_status_name,
            (SELECT DISTINCT cli.fat_min
               FROM ont.oe_order_headers_all oha 
                ,(select site_use_id, attribute1 sales_channel_code, to_number(nvl(attribute8,0)) fat_min
                    from apps.hz_cust_site_uses_all 
                  union
                  select site_use_id,sales_channel sales_channel_code, nvl(minimum_invoice_value,0) fat_min
                    from apps.xxppg_om_cross_bu_all
                  ) cli
              WHERE  1 = 1
                AND oha.ship_to_org_id = cli.site_use_id
                AND oha.sales_channel_code = cli.sales_channel_code 
                AND oha.order_number = oeh.order_number
                AND ROWNUM = 1) fat_min
           ,delivery_detail_id
           ,(SELECT   hd.NAME
                 FROM apps.OE_HOLD_SOURCES_ALL hs,
                      apps.OE_HOLD_DEFINITIONS hd,
                      apps.FND_USER fu,
                      apps.FND_LOOKUP_VALUES flv
                WHERE     hs.HOLD_ID = hd.HOLD_ID
                      AND hs.HOLD_RELEASE_ID IS NULL
                      AND hs.created_by = fu.USER_ID
                      AND flv.lookup_code = hs.hold_entity_code
                      AND flv.lookup_type = 'HOLD_ENTITY_DESC'
                      AND flv.LANGUAGE = USERENV ('LANG')
                      AND flv.VIEW_APPLICATION_ID = 660
                      AND hs.HOLD_ENTITY_ID = to_char(oeh.header_id)
                      AND ROWNUM=1) Retencao
              ,(SELECT max(oer.creation_date)
                 FROM apps.OE_HOLD_SOURCES_ALL hs,
                      apps.OE_HOLD_DEFINITIONS hd,
                      apps.oe_hold_releases oer,
                      apps.FND_USER fu,
                      apps.FND_LOOKUP_VALUES flv
                WHERE     hs.HOLD_ID = hd.HOLD_ID
                      --AND hs.HOLD_RELEASE_ID IS NULL
                      AND hs.created_by = fu.USER_ID
                      AND flv.lookup_code = hs.hold_entity_code
                      AND hs.hold_release_id = oer.hold_release_id(+)
                      AND flv.lookup_type = 'HOLD_ENTITY_DESC'
                      AND flv.LANGUAGE = USERENV ('LANG')
                      AND flv.VIEW_APPLICATION_ID = 660
                      AND hs.HOLD_ENTITY_ID = to_char(oeh.header_id)          
                      ) data_liberacao_credito
              ,oeh.orig_sys_document_ref
              ,wdd_1.shipment_priority_code prioridade_shipping
              ,oel.last_update_date
    --
    FROM apps.oe_order_headers_all oeh,
         apps.oe_order_lines_all oel,
         apps.hz_cust_site_uses_all b,
         apps.hz_parties e,
         apps.hz_party_sites hps,
         apps.hz_cust_acct_sites_all hcasa,
         apps.hz_cust_accounts_all hcaa,
         apps.hz_locations hl,
         apps.mtl_parameters mtp,
         apps.ra_terms rat,
         apps.oe_order_sources oos,
         --
         apps.jtf_rs_salesreps jrs,
         --
         apps.oe_transaction_types_tl ottt,
         --
         apps.mtl_system_items_b msib,
         apps.wsh_deliverables_v wdd_1
--
   WHERE     1=1
         AND oel.header_id = oeh.header_id
         AND wdd_1.source_header_id = oel.header_id
         AND wdd_1.source_line_id = oel.line_id
         --AND oel.flow_status_code not in ('CANCELLED')
         AND oel.flow_status_code in ('CANCELLED')
         --
         AND b.site_use_id = oeh.ship_to_org_id
         AND b.cust_acct_site_id = hcasa.cust_acct_site_id
         AND hcaa.cust_account_id = hcasa.cust_account_id
         AND e.party_id = hcaa.party_id
         AND hcasa.party_site_id = hps.party_site_id
         AND hps.location_id(+) = hl.location_id
         --                  
         AND mtp.organization_id = oel.ship_from_org_id
         AND rat.term_id = oeh.payment_term_id
         AND oeh.order_source_id = oos.order_source_id
         --
         AND ottt.language = 'PTB'
         AND ottt.transaction_type_id = oeh.order_type_id
         --
         AND wdd_1.inventory_item_id = msib.inventory_item_id 
         AND wdd_1.organization_id  = msib.organization_id
         --
         AND oel.salesrep_id = jrs.salesrep_id(+)
         --
         --and TRUNC(oel.last_update_date) between '01-JUN-2016' and '31-OCT-2016'
         --
         --AND oeh.order_number = 113667
         -- AND oel.line_id = 222897
         --
         AND wdd_1.organization_id in(select organization_id from apps.mtl_parameters where organization_code IN('GVT')) --NVL (86, oeh.ship_from_org_id)
     --and ordered_item = 'HR-82-3454'
     --and WDD_1.RELEASED_STATUS is null
ORDER BY mtp.organization_code, oeh.order_number, oel.line_id