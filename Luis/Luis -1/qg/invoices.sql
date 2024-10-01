SELECT * from apps.cll_f189_invoice_types rit where RIT.INVOICE_TYPE_CODE = 'E_FAT CONSIG';

select * from apps.ap_invoices_all where invoice_num = '55046' and invoice_date >= to_date('2020/05/01', 'rrrr/mm/dd'); where invoice_id = 507124;

REFERENCE_KEY1 = ri.invoice_id


           SELECT DISTINCT
           ri.invoice_id,
           ri.invoice_num,
                  msi.segment1 item,
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
                  apps.ap_invoices_all ai,
                  --
                  apps.cll_f189_fiscal_entities_all cfea,
                  apps.po_vendor_sites_all pvsa,
                  apps.po_vendors pov,
                  --
                  apps.mtl_system_items_b msi,
                  apps.mtl_parameters mp
            --
            WHERE     reo.status NOT IN ('CANCELLED', 'IN HOLD', 'IN REVERSION')
                  AND RIT.INVOICE_TYPE_CODE = 'E_FAT CONSIG'
                  AND ri.organization_id = reo.organization_id
                  AND ri.operation_id = reo.operation_id
                  AND ai.REFERENCE_KEY1 = ri.invoice_id
                 -- AND ai.invoice_num    = to_char(ri.invoice_num)
                  AND ril.organization_id = ri.organization_id
                  AND ril.invoice_id = ri.invoice_id
                  AND rit.invoice_type_id = ri.invoice_type_id
                  AND rit.organization_id = ri.organization_id
                  AND msi.organization_id = ril.organization_id
                  AND msi.inventory_item_id = ril.item_id
                  AND reo.reversion_flag IS NULL
                  --
                  AND cfea.entity_id = ri.entity_id
                  AND pvsa.vendor_site_id = cfea.vendor_site_id
                  AND pov.vendor_id = pvsa.vendor_id
                  AND mp.organization_id = ri.organization_id
                  --and ri.invoice_num = '55046'
                  AND TRUNC (reo.receive_date) BETWEEN TRUNC (
                                                          NVL (TO_DATE ('20200601', 'rrrr/mm/dd hh24:mi:ss'),
                                                               reo.receive_date))
                                                   AND TRUNC (
                                                          NVL (TO_DATE ('20201231', 'rrrr/mm/dd hh24:mi:ss'),
                                                               reo.receive_date))
         --
         ORDER BY msi.segment1;