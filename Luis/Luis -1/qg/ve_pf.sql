                  SELECT 'RCTA' nf_type,
                         mmt.organization_id,
                         mmt.inventory_item_id,
                         mmt.transaction_uom uom,
                         APPS.INV_CONVERT.inv_um_convert (mmt.INVENTORY_ITEM_ID,  	--Inventory Item Id
                                             2,                      --Precision
                                             1, 	                  --Quantity
                                             'l',                   --From UOM siempre es kg
                                             'kg',                		-- To UOM --SIEMPRE SE CONVIERTE A lt
                                             NULL,               		--From UOM Name
                                             NULL                    --To UOM Name
                         )DENSITY, --a lt
                         TO_NUMBER (NVL (rctla.interface_line_attribute6, 0), '999999999')
                            interface_line_attribute6,
                         mmt.transaction_type_id,
                         hps.party_id,
                         hps.party_site_id,
                            SUBSTR (hcasa.global_attribute3, 2, 2)
--                         || '.'
                         || SUBSTR (hcasa.global_attribute3, 4, 3)
--                         || '.'
                         || SUBSTR (hcasa.global_attribute3, 7, 3)
--                         || '/'
                         || hcasa.global_attribute4
--                         || '-'
                         || hcasa.global_attribute5
                            cnpj,
                         hp.party_name razao_social,
                         hl.address1 || ',' || hl.address2 || ',' || hl.address3 endereco,
                         hl.city,
                         hl.state,
                         'NF-S' esp,
                         TO_CHAR (rcta.TRX_NUMBER) num_nf,
                         rcta.customer_trx_id,
                         0,
                         TO_CHAR (TRUNC (rcta.trx_date), 'DD/MM/YYYY') data_nf,
                         TO_CHAR (TRUNC (rcta.trx_date), 'dd/mm/rrrr') data_gl,
                         SUM (mmt.primary_quantity) transaction_quantity,
                         trunc(mmt.transaction_date) transaction_date
                    --
                    FROM APPS.MTL_MATERIAL_TRANSACTIONS mmt,
                         apps.MTL_TRANSACTION_TYPES mtt,
                         APPS.MTL_SYSTEM_ITEMS_B msib,
                         APPS.xxppg_mtl_system_items_b xmsi,
                         APPS.OE_ORDER_LINES_all oola,
                         apps.oe_order_headers_all ooha,
                         --
                         (SELECT DISTINCT wdd.source_header_id,
                                          wdd.source_line_id,
                                          wdd.organization_id,
                                          wdd.inventory_item_id,
                                          wda.delivery_id
                            FROM apps.wsh_delivery_details wdd,
                                 apps.wsh_delivery_assignments wda,
                                 apps.wsh_new_deliveries wnd
                           WHERE     wdd.delivery_detail_id = wda.delivery_detail_id
                                 AND wda.delivery_id = wnd.delivery_id
                                 AND wdd.delivery_detail_id = wda.delivery_detail_id) wdd,
                         apps.ra_customer_trx_lines_all rctla,
                         apps.ra_customer_trx_all rcta,
                         apps.hz_cust_site_uses_all hcsua,
                         apps.hz_cust_acct_sites_all hcasa,
                         apps.hz_party_sites hps,
                         apps.hz_parties hp,
                         apps.hz_locations hl
                   --
                   WHERE     mmt.TRANSACTION_TYPE_ID  = mtt.TRANSACTION_TYPE_ID
                         AND mmt.organization_id      = msib.organization_id
                         AND mmt.inventory_item_id    = msib.inventory_item_id
                         AND msib.inventory_item_id   = xmsi.inventory_item_id(+)
                         AND (NVL (xmsi.attribute6, 'N') = 'CONTROLADO')
                        -- AND mmt.transaction_type_id  = 33
                         AND mmt.transaction_type_id  in (33,62)
                         --and rcta.TRX_NUMBER = 241995
                         AND mmt.trx_source_line_id   = oola.line_id
                         AND mmt.organization_id      = oola.ship_from_org_id
                        -- AND mmt.organization_id      = ooha.ship_from_org_id
                         AND ooha.header_id           = oola.header_id
                         AND ooha.org_id              = oola.org_id
                         AND wdd.inventory_item_id    = mmt.inventory_item_id
                         AND wdd.organization_id      = mmt.organization_id
                         AND oola.header_id           = wdd.source_header_id
                         AND oola.line_id             = wdd.source_line_id
                         AND to_char(wdd.delivery_id) = rctla.interface_line_attribute3
                         AND rctla.interface_line_context = 'ORDER ENTRY'
                         AND wdd.inventory_item_id    = rctla.inventory_item_id
                         AND wdd.organization_id      = rctla.warehouse_id
                         AND rctla.customer_trx_id    = rcta.customer_trx_id
                         AND rctla.line_type          = 'LINE'
                         AND rcta.status_trx         <> 'VD'
                         AND hcsua.site_use_id(+)     = rcta.ship_to_site_use_id
                         AND hcsua.org_id(+)          = rcta.org_id
                         AND hcsua.cust_acct_site_id  = hcasa.cust_acct_site_id
                         AND hcasa.org_id             = hcsua.org_id
                         AND hcasa.party_site_id      = hps.party_site_id
                         AND hps.party_id             = hp.party_id
                         AND hl.location_id           = hps.location_id
                         --
                         AND oola.line_id             = wdd.source_line_id
                        -- AND ooha.ship_from_org_id    = wdd.organization_id
                         AND oola.ship_from_org_id    = wdd.organization_id
                         AND mmt.organization_id      = 92
                         AND TRUNC (mmt.transaction_date) BETWEEN to_date('01-dec-2021')
                                                            AND to_date('31-dec-2021')
                --AND TRUNC (rcta.trx_date) BETWEEN p_data_inicial AND p_data_final
                GROUP BY mmt.organization_id,
                         mmt.inventory_item_id,
                         mmt.transaction_uom,
                         hps.party_id,
                         hps.party_site_id,
                         mmt.inventory_item_id,
                         mmt.transaction_type_id,
                         TO_NUMBER (NVL (rctla.interface_line_attribute6, 0), '999999999'),
                            SUBSTR (hcasa.global_attribute3, 2, 2)
--                         || '.'
                         || SUBSTR (hcasa.global_attribute3, 4, 3)
--                         || '.'
                         || SUBSTR (hcasa.global_attribute3, 7, 3)
--                         || '/'
                         || hcasa.global_attribute4
--                         || '-'
                         || hcasa.global_attribute5,
                         hp.party_name,
                         hl.address1 || ',' || hl.address2 || ',' || hl.address3,
                         hl.city,
                         hl.state,
                         'NF-S',
                         rcta.TRX_NUMBER,
                         rcta.customer_trx_id,
                         TO_CHAR (TRUNC (rcta.trx_date), 'DD/MM/YYYY'),
                         TO_CHAR (TRUNC (rcta.trx_date), 'dd/mm/rrrr'),
                         rctla.inventory_item_id,
                         trunc(mmt.transaction_date)
                  HAVING SUM (mmt.primary_quantity) <> 0
                  