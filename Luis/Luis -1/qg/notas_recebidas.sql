           SELECT DISTINCT
                  msi.segment1 item,
                  msi.description descricao,
                  --
                  (SELECT mc.concatenated_segments
                     FROM apps.mtl_item_categories mic, apps.mtl_categories_b_kfv mc, apps.mtl_category_sets_tl mcst
                    WHERE     mic.category_id = mc.category_id
                          AND mcst.language = 'US'
                          AND mic.category_set_id = mcst.category_set_id
                          AND mcst.category_set_name = 'Compras'
                          AND mic.organization_id = ri.organization_id
                          AND mic.inventory_item_id = ril.item_id)
                     grupocompra,
                  --
                  (SELECT mc.concatenated_segments
                     FROM apps.mtl_item_categories mic, apps.mtl_categories_b_kfv mc, apps.mtl_category_sets_tl mcst
                    WHERE     mic.category_id = mc.category_id
                          AND mcst.language = 'US'
                          AND mic.category_set_id = mcst.category_set_id
                          AND mcst.category_set_name = 'FISCAL_CLASSIFICATION'
                          AND mic.organization_id = ri.organization_id
                          AND mic.inventory_item_id = ril.item_id)
                     ncm,
                  --
                  ril.uom um,
                  --
                  pov.segment1 fornecedor,
                  pov.vendor_name razaosocial,
                  --
                  NVL (
                     pvsa.country,
                     (SELECT hz.country
                        FROM apps.po_line_locations_all pll,
                             apps.po_headers_all ph,
                             apps.po_vendors pov,
                             apps.hz_parties hz
                       WHERE     pll.line_location_id = ril.line_location_id
                             AND ph.po_header_id = pll.po_header_id
                             AND pov.vendor_id = ph.vendor_id
                             AND hz.party_id = pov.party_id))
                     pais,
                  --
                  ril.quantity quantidade,
                  ri.invoice_num notafiscal,
                  ri.series serie,
                  ri.invoice_date emissao,
                  reo.receive_date entrada,
                  ril.unit_price vlrunitario,
                  (ril.quantity * ril.unit_price) vlrrecebido,
                  ril.icms_amount vlricmsitem,
                  --
                  'BRL' moedarecebto,
                  --
                  mp.organization_code estabelec,
                  --
                  (SELECT NVL (apt.description, apt.name)
                     FROM apps.ap_terms apt, apps.po_line_locations_all pll, apps.po_headers_all ph
                    WHERE     apt.term_id = ph.terms_id
                          AND pll.line_location_id = ril.line_location_id
                          AND ph.po_header_id = pll.po_header_id
                          AND ROWNUM = 1)
                     condpagto,
                  --
                  (SELECT ph.fob_lookup_code
                     FROM apps.po_line_locations_all pll, apps.po_headers_all ph
                    WHERE pll.line_location_id = ril.line_location_id AND ph.po_header_id = pll.po_header_id AND ROWNUM = 1)
                     incoterm,
                  --
                  (SELECT pl.attribute1
                     FROM apps.po_line_locations_all pll, apps.po_line_locations_all pll2, apps.po_lines_all pl
                    WHERE     pll.line_location_id = ril.line_location_id
                          AND pll2.po_line_id = pll.from_line_id
                          AND pl.po_line_id = pll2.po_line_id
                          AND ROWNUM = 1)
                     taxafinanc,
                  --
                  30 diastaxa,
                  --
                  TO_NUMBER (
                     NVL (
                        (SELECT pll2.attribute2
                           FROM apps.po_line_locations_all pll, apps.po_line_locations_all pll2, apps.po_lines_all pl
                          WHERE     pll.line_location_id = ril.line_location_id
                                AND pll2.po_line_id = pll.from_line_id
                                AND pl.po_line_id = pll2.po_line_id
                                AND pll2.attribute1 IS NOT NULL
                                AND ROWNUM = 1),
                        NVL (
                           (SELECT pll2.price_override
                              FROM apps.po_line_locations_all pll, apps.po_line_locations_all pll2, apps.po_lines_all pl
                             WHERE     pll.line_location_id = ril.line_location_id
                                   AND pll2.po_line_id = pll.from_line_id
                                   AND pl.po_line_id = pll2.po_line_id
                                   AND pll2.attribute1 IS NOT NULL
                                   AND ROWNUM = 1),
                           (SELECT pl.unit_price
                              FROM apps.po_line_locations_all pll, apps.po_lines_all pl
                             WHERE     pll.line_location_id = ril.line_location_id
                                   AND pl.po_line_id = pll.po_line_id
                                   AND ROWNUM = 1))),
                     '999999999.000000000')
                     precopedmoedacimposto,
                  --
                  (SELECT REPLACE (pl.attribute5, ',', '.')
                     FROM apps.po_line_locations_all pll, apps.po_line_locations_all pll2, apps.po_lines_all pl
                    WHERE     pll.line_location_id = ril.line_location_id
                          AND pll2.po_line_id = pll.from_line_id
                          AND pl.po_line_id = pll2.po_line_id
                          AND ROWNUM = 1)
                     preco_net,
                  --
                  NVL (
                     (SELECT DISTINCT NVL (plla_bkt.attribute1, 'USD')
                        FROM apps.po_headers_all pha,
                             apps.po_headers_all pha_bkt,
                             apps.po_line_locations_all plla,
                             apps.po_line_locations_all plla_bkt,
                             apps.po_requisition_lines_all prla
                       WHERE     plla.po_header_id = pha.po_header_id
                             AND prla.line_location_id = plla.line_location_id
                             AND pha_bkt.po_header_id = prla.blanket_po_header_id
                             AND plla_bkt.po_header_id = prla.blanket_po_header_id
                             AND plla.line_location_id = ril.line_location_id),
                     NVL ( (SELECT pha.currency_code
                              FROM apps.po_headers_all pha, apps.po_line_locations_all plla
                             WHERE plla.po_header_id = pha.po_header_id AND plla.line_location_id = ril.line_location_id),
                          'BRL'))
                     moedapedido,
                  --
                  (SELECT ph.segment1
                     FROM apps.po_line_locations_all pll, apps.po_headers_all ph
                    WHERE pll.line_location_id = ril.line_location_id AND ph.po_header_id = pll.po_header_id AND ROWNUM = 1)
                     pedido,
                  --
                  (SELECT ph.creation_date
                     FROM apps.po_line_locations_all pll, apps.po_headers_all ph
                    WHERE pll.line_location_id = ril.line_location_id AND ph.po_header_id = pll.po_header_id AND ROWNUM = 1)
                     dtemispedido,
                  /*(select distinct pha_bkt.segment1
                         from apps.po_headers_all           pha
                             ,apps.po_headers_all           pha_bkt
                             ,apps.po_line_locations_all    plla
                             ,apps.po_line_locations_all    plla_bkt
                             ,apps.po_requisition_lines_all prla
                        where plla.po_header_id     = pha.po_header_id
                          and prla.line_location_id = plla.line_location_id
                          and pha_bkt.po_header_id  = prla.blanket_po_header_id
                          and plla_bkt.po_header_id = prla.blanket_po_header_id
                          and plla.line_location_id = ril.line_location_id)*/
                  (SELECT DISTINCT pha1.segment1
                     FROM apps.po_line_locations_all plla,
                          apps.po_lines_all pla,
                          apps.po_headers_all pha,
                          apps.po_headers_all pha1
                    WHERE     pha.po_header_id = plla.po_header_id
                          AND plla.line_location_id = ril.line_location_id
                          AND pla.po_header_id = pha.po_header_id
                          AND pla.po_line_id = plla.po_line_id
                          AND pha1.po_header_id = pla.from_header_id)
                     contrato,
                  (SELECT DISTINCT TO_CHAR (pha1.end_date, 'dd/mm/rrrr')
                     FROM apps.po_line_locations_all plla,
                          apps.po_lines_all pla,
                          apps.po_headers_all pha,
                          apps.po_headers_all pha1
                    WHERE     pha.po_header_id = plla.po_header_id
                          AND plla.line_location_id = ril.line_location_id
                          AND pla.po_header_id = pha.po_header_id
                          AND pla.po_line_id = plla.po_line_id
                          AND pha1.po_header_id = pla.from_header_id                                                       --
                                                                    /*select distinct trunc(pha_bkt.)
                                                                       from apps.po_headers_all            pha
                                                                           ,apps.po_headers_all            pha_bkt
                                                                           ,apps.po_line_locations_all     plla
                                                                           ,apps.po_line_locations_all     plla_bkt
                                                                           ,apps.po_requisition_lines_all  prla
                                                                           ,apps.gl_daily_conversion_types gdct
                                                                      where plla.po_header_id     = pha.po_header_id
                                                                        and prla.line_location_id = plla.line_location_id
                                                                        and pha_bkt.po_header_id  = prla.blanket_po_header_id
                                                                        and plla_bkt.po_header_id = prla.blanket_po_header_id
                                                                        and plla.line_location_id = ril.line_location_id
                                                                        and gdct.user_conversion_type = plla_bkt.attribute3*/
                  )
                     vlcontrato,
                  --
                  (SELECT DISTINCT plla1.attribute3
                     FROM apps.po_line_locations_all plla,
                          apps.po_line_locations_all plla1,
                          apps.po_lines_all pla,
                          apps.po_headers_all pha,
                          apps.po_headers_all pha1
                    WHERE     pha.po_header_id = plla.po_header_id
                          AND plla.line_location_id = ril.line_location_id
                          AND pla.po_header_id = pha.po_header_id
                          AND pla.po_line_id = plla.po_line_id
                          AND pha1.po_header_id = pla.from_header_id
                          AND plla1.po_header_id = pha1.po_header_id
                          AND plla1.attribute3 IS NOT NULL
                          and rownum = 1)
                     tipo_taxa,
                  --
                  NVL ( (SELECT 'SIM'
                           FROM apps.cll_f189_invoice_types rit
                          WHERE rit.invoice_type_id = ri.invoice_type_id AND rit.description LIKE '%CONSIG%'),
                       'NAO')
                     consignado,
                  --
                  --(SELECT pbv.full_name
                  --    FROM apps.po_line_locations_all pll, apps.po_headers_all ph, apps.po_buyers_v pbv
                  --    WHERE     pll.line_location_id = ril.line_location_id
                  --          AND ph.po_header_id = pll.po_header_id
                  --          AND pbv.employee_id = ph.agent_id
                  --          AND ROWNUM = 1)
                  --     comprador,
                  msi.attribute16 comprador,
                  --
                  (SELECT aps.due_date
                     FROM apps.cll_f189_fiscal_entities_all e, apps.ap_invoices_all aia, apps.ap_payment_schedules_all aps
                    WHERE     e.entity_id = ri.entity_id
                          AND aia.vendor_site_id = e.vendor_site_id
                          AND aia.invoice_num = NVL (ri.invoice_num_ap, ri.invoice_num)
                          AND aia.invoice_id = aps.invoice_id
                          AND aps.payment_num = '1')
                     dtvenctitulo,
                  ril.line_location_id
             --
             FROM apps.cll_f189_entry_operations reo,
                  apps.cll_f189_invoices ri,
                  apps.cll_f189_invoice_lines ril,
                  apps.cll_f189_invoice_types rit,
                  --
                  apps.cll_f189_fiscal_entities_all cfea,
                  apps.po_vendor_sites_all pvsa,
                  apps.po_vendors pov,
                  --
                  apps.mtl_system_items_b msi,
                  --
                  (SELECT DISTINCT mic.inventory_item_id, mic.organization_id, mc.segment1
                     FROM apps.mtl_item_categories mic, apps.mtl_categories_b_kfv mc, apps.mtl_category_sets_tl mcst
                    WHERE     mic.category_id = mc.category_id
                          AND mcst.language = 'US'
                          AND mic.category_set_id = mcst.category_set_id
                          AND mcst.category_set_name = 'Compras') x1,
                  --
                  apps.mtl_parameters mp
            --
            WHERE     reo.status NOT IN ('CANCELLED', 'IN HOLD', 'IN REVERSION')
                  --
                  --  and reo.receive_date < SYSDATE
                  --
                  AND ri.organization_id = reo.organization_id
                  AND ri.operation_id = reo.operation_id
                  AND ril.organization_id = ri.organization_id
                  AND ril.invoice_id = ri.invoice_id
                  AND rit.invoice_type_id = ri.invoice_type_id
                  AND rit.organization_id = ri.organization_id
                  AND rit.requisition_type != 'NA'
                  AND msi.organization_id = ril.organization_id
                  AND msi.inventory_item_id = ril.item_id
                  AND ri.organization_id = x1.organization_id
                  AND ril.item_id = x1.inventory_item_id
                  AND reo.reversion_flag IS NULL
                  --
                  AND cfea.entity_id = ri.entity_id
                  AND pvsa.vendor_site_id = cfea.vendor_site_id
                  AND pov.vendor_id = pvsa.vendor_id
                  AND mp.organization_id = ri.organization_id
                  --
                  /*------- Ciro 22/04/2015
                  AND 'INVENTORY' IN (SELECT destination_type_code
                                        FROM apps.po_distributions_all pda
                                       WHERE pda.line_location_id = ril.line_location_id
                                         AND ROWNUM = 1)
                                         -------*/
                  -- Parametros
                  --AND ri.organization_id = NVL (p_org_id, ri.organization_id)
                  AND TRUNC (reo.receive_date) BETWEEN TRUNC (
                                                          NVL (TO_DATE ('20151201', 'rrrr/mm/dd hh24:mi:ss'),
                                                               reo.receive_date))
                                                   AND TRUNC (
                                                          NVL (TO_DATE ('20151231', 'rrrr/mm/dd hh24:mi:ss'),
                                                               reo.receive_date))
                  AND  x1.segment1 IN ('Packaging', 'Raw Materials')
--                  AND  x1.segment1 NOT IN ('Packaging', 'Raw Materials')
         --
         ORDER BY msi.segment1, reo.receive_date;

