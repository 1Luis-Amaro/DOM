           SELECT DISTINCT
                  msi.segment1 item,
                  inv.sbu,
                  msi.item_type,
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
                     pais
                  --
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
                (SELECT MIC.INVENTORY_ITEM_ID,
                        MIC.ORGANIZATION_ID,
                        MIC.SEGMENT1 TIPO,
                        MIC.SEGMENT2 SBU,
                        MIC.SEGMENT3 PL,
                        MIC.CATEGORY_SET_NAME,
                        MIC.CATEGORY_CONCAT_SEGS CATEGORIA
                   FROM APPS.MTL_ITEM_CATEGORIES_V MIC, APPS.MTL_CATEGORIES_V MC
                  WHERE MC.CATEGORY_ID      = MIC.CATEGORY_ID AND
                        MIC.CATEGORY_SET_id = 1) inv,
                  --
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
                  AND inv.organization_id = msi.organization_id
                  AND inv.inventory_item_id = msi.inventory_item_id
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
                                                          NVL (TO_DATE ('20170601', 'rrrr/mm/dd hh24:mi:ss'),
                                                               reo.receive_date))
                                                   AND TRUNC (
                                                          NVL (TO_DATE ('20181231', 'rrrr/mm/dd hh24:mi:ss'),
                                                               reo.receive_date))
                 -- AND  x1.segment1 IN ('Packaging', 'Raw Materials')
--                  AND  x1.segment1 NOT IN ('Packaging', 'Raw Materials')
         --
         ORDER BY msi.segment1;

select segment1, item_type, inventory_item_status_code from apps.mtl_system_items_b where organization_id = 87