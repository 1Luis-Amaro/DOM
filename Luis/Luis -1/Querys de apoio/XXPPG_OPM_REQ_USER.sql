SELECT DISTINCT pv.vendor_name fornecedor                               -- 1
                , pvs.vendor_site_code cd_local_fornecedor                -- 2
                , DECODE (pvs.global_attribute9
                        , 2, (   LPAD (pvs.global_attribute10
                                     , 9
                                     , '0')
                              || '/'
                              || LPAD (pvs.global_attribute11
                                     , 4
                                     , '0')
                              || '-'
                              || LPAD (pvs.global_attribute12
                                     , 2
                                     , '0'))
                        , (   LPAD (pvs.global_attribute10
                                  , 8
                                  , '0')
                           || '-'
                           || LPAD (pvs.global_attribute12
                                  , 2
                                  , '0')))
                      cnpj                                                -- 3
                , pvs.global_attribute13 inscricao_estadual               -- 4
                , ph.segment1 nr_oc                                       -- 5
                , msi.segment1 cd_item                                    -- 6
                , ril.description ds_item                                 -- 7
                , NVL (pll.need_by_date, NULL) dt_necessidade_entrega_oc  -- 8
                , NVL (pll.promised_date, NULL) dt_prometida_entrega_oc   -- 9
                , NVL (pll.quantity, 0) qtde_entrega_oc                  -- 10
                , NVL (pll.quantity_received, 0) qtde_recebida_entrega_oc -- 11
                , NVL (pll.quantity_cancelled, 0) qtde_cancelada_entrega_oc -- 12
                , NVL (pl.unit_price, 0) vl_preco_unitario_oc            -- 13
                , ril.total_amount
                , reo.operation_id nr_recebimento                        -- 14
                , ri.invoice_num nr_nota_fiscal                          -- 15
                , ri.series cd_serie_nota_fiscal                         -- 16
                , ri.invoice_date dt_emissao_nota_fiscal
                , reo.receive_date dt_recebimento                        -- 17
                , ril.quantity qtde_recebida_nota_fiscal                 -- 18
                , ril.unit_price vl_preco_unitario_recebido              -- 19
                , rcv.shipment_header_id
                , msi.inventory_item_id
                , rcv.destination_type_code
                , gcc.concatenated_segments
                , fu.description
    FROM apps.rcv_transactions rcv
       , apps.rcv_shipment_lines rsl
       , apps.rcv_shipment_headers rsh
       , apps.cll_f189_entry_operations reo
       , apps.cll_f189_invoices ri
       , apps.cll_f189_invoice_lines ril
       , apps.cll_f189_fiscal_entities_all rfe
       , apps.po_vendor_sites_all pvs
       , apps.po_vendors pv
       , po.po_line_locations_all pll
       , po.po_lines_all pl
       , po.po_headers_all ph
       , inv.mtl_system_items_b msi
       , po.po_distributions_all pd
       , apps.gl_code_combinations_kfv gcc
       , apps.fnd_user fu
       , apps.po_req_distributions_all prd
       , apps.po_requisition_lines_all prl
       , apps.po_requisition_headers_all prh
   WHERE 1 = 1
     AND prd.distribution_id = pd.req_distribution_id
    --
     AND prh.requisition_header_id = prl.requisition_header_id
     AND prl.requisition_line_id = prd.requisition_line_id
     AND ph.po_header_id = pd.po_header_id
     AND pl.po_line_id = pd.po_line_id
     AND gcc.code_combination_id = pd.code_combination_id
     AND fu.user_id = prl.created_by
     AND rcv.shipment_header_id = rsl.shipment_header_id
     AND rcv.shipment_line_id = rsl.shipment_line_id
     AND rcv.organization_id = reo.organization_id
     AND rcv.po_header_id = rsl.po_header_id
     AND rcv.po_line_id = rsl.po_line_id
     AND rcv.po_line_location_id = rsl.po_line_location_id
     AND rcv.destination_type_code IN ('EXPENSE', 'INVENTORY')
     AND rsl.shipment_header_id = rsh.shipment_header_id
     AND rsl.item_id = ril.item_id
     AND rsl.po_header_id = pll.po_header_id
     AND rsl.po_line_id = pll.po_line_id
     AND rsl.po_line_location_id = pll.line_location_id
     AND rsl.to_organization_id = reo.organization_id
     AND rsh.vendor_id = pvs.vendor_id
     AND rsh.vendor_site_id = pvs.vendor_site_id
     AND TO_NUMBER (rsh.receipt_num) = reo.operation_id
     AND rsh.ship_to_org_id = reo.organization_id
     AND reo.status = 'COMPLETE'             -- somente recebimentos completos
     AND reo.reversion_flag IS NULL  -- somente os recebimentos não revertidos
     AND reo.operation_id = ri.operation_id
     AND reo.organization_id = ri.organization_id
     AND ri.invoice_id = ril.invoice_id
     AND ri.entity_id = rfe.entity_id
     AND rfe.vendor_site_id = pvs.vendor_site_id
     AND rfe.org_id = pvs.org_id
     AND pvs.vendor_id = pv.vendor_id
     AND ril.line_location_id = pll.line_location_id
     AND ri.organization_id = pll.ship_to_organization_id
     AND ril.item_id = msi.inventory_item_id
     AND ri.organization_id = msi.organization_id
     AND rfe.org_id = pll.org_id
     AND pll.po_line_id = pl.po_line_id
     AND pll.po_header_id = pl.po_header_id
     AND pll.org_id = pl.org_id
     AND pl.item_id = ril.item_id
     AND pl.po_header_id = ph.po_header_id
     AND pl.org_id = ph.org_id
-- and TRUNC ( reo . receive_date )             >= To_Date ( '01/03/15' , 'DD/MM/YY' )
--  and TRUNC ( reo . receive_date )             <  To_Date ( '31/03/15' , 'DD/MM/YY' )
ORDER BY 18
