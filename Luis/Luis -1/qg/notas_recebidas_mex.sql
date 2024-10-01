    SELECT TO_CHAR (rt.transaction_id) txt_receiptid,
           TO_CHAR (rt.po_line_location_id) txt_polineid,
           TO_CHAR (NVL (hr1.location_code,hr2.location_code))   txt_oflocid,
           ph.segment1 txt_orderno,
           pr.release_num int_releaseno,
           rsh.receipt_num || '-' || rsl.line_num txt_receiptno,
           TRUNC (ph.creation_date) dte_order,
           TRUNC (pr.creation_date) dte_release,
           TRUNC (rt.transaction_date) dte_receipt,
           TO_CHAR (pll.need_by_date, 'YYYY-MM-DD') dte_needby,
           TO_CHAR (pll.promised_date,'YYYY-MM-DD') dte_promised,
           msi.segment1 txt_itemcode,
           msi.description txt_itemdesc,
           pv.segment1 txt_vendorcode,
           pv.vendor_name txt_vendorname,
           CASE
              WHEN msi.item_type in ('ACARV','ACA','MP','INT') AND
                   inv_convert.inv_um_convert (item_id         => msi.inventory_item_id,
                                               precision       => NULL,
                                               from_quantity   => 1,
                                               from_unit       => rt.uom_code,
                                               to_unit         => 'kg',
                                               from_name       => NULL,
                                               to_name         => NULL) > 0 THEN
                   round(pll.quantity * inv_convert.inv_um_convert (item_id         => msi.inventory_item_id,
                                                              precision       => NULL,
                                                              from_quantity   => 1,
                                                              from_unit       => rt.uom_code,
                                                              to_unit         => 'kg',
                                                              from_name       => NULL,
                                                              to_name         => NULL),1)
              WHEN msi.item_type in ('ACARV','ACA','MP','INT') AND
                   inv_convert.inv_um_convert (item_id         => msi.inventory_item_id,
                                               precision       => NULL,
                                               from_quantity   => 1,
                                               from_unit       => rt.uom_code,
                                               to_unit         => 'un',
                                               from_name       => NULL,
                                               to_name         => NULL) > 0 THEN
                  round(pll.quantity * inv_convert.inv_um_convert (item_id         => msi.inventory_item_id,
                                                              precision       => NULL,
                                                              from_quantity   => 1,
                                                              from_unit       => rt.uom_code,
                                                              to_unit         => 'un',
                                                              from_name       => NULL,
                                                              to_name         => NULL),1)
              ELSE pll.quantity
           END amt_polineqty,
           CASE
              WHEN msi.item_type in ('ACARV','ACA','MP','INT') AND
                   rt.transaction_type = 'RECEIVE'       AND
                   inv_convert.inv_um_convert (item_id         => msi.inventory_item_id,
                                               precision       => NULL,
                                               from_quantity   => 1,
                                               from_unit       => rt.uom_code,
                                               to_unit         => 'kg',
                                               from_name       => NULL,
                                               to_name         => NULL) > 0 THEN
                   round(rt.quantity * inv_convert.inv_um_convert (item_id         => msi.inventory_item_id,
                                                              precision       => NULL,
                                                              from_quantity   => 1,
                                                              from_unit       => rt.uom_code,
                                                              to_unit         => 'kg',
                                                              from_name       => NULL,
                                                              to_name         => NULL),1)
              WHEN msi.item_type in ('ACARV','ACA','MP','INT')    AND
                   rt.transaction_type = 'RETURN TO VENDOR' AND
                   inv_convert.inv_um_convert (item_id         => msi.inventory_item_id,
                                               precision       => NULL,
                                               from_quantity   => 1,
                                               from_unit       => rt.uom_code,
                                               to_unit         => 'kg',
                                               from_name       => NULL,
                                               to_name         => NULL) > 0 THEN
                   round(rt.quantity * inv_convert.inv_um_convert (item_id         => msi.inventory_item_id,
                                                              precision       => NULL,
                                                              from_quantity   => 1,
                                                              from_unit       => rt.uom_code,
                                                              to_unit         => 'kg',
                                                              from_name       => NULL,
                                                              to_name         => NULL) * -1,1)
              WHEN msi.item_type in ('ACARV','ACA','MP','INT') AND
                   rt.transaction_type = 'RECEIVE'       AND
                   inv_convert.inv_um_convert (item_id         => msi.inventory_item_id,
                                               precision       => NULL,
                                               from_quantity   => 1,
                                               from_unit       => rt.uom_code,
                                               to_unit         => 'un',
                                               from_name       => NULL,
                                               to_name         => NULL) > 0 THEN
                  round(rt.quantity * inv_convert.inv_um_convert (item_id         => msi.inventory_item_id,
                                                                  precision       => NULL,
                                                                  from_quantity   => 1,
                                                                  from_unit       => rt.uom_code,
                                                                  to_unit         => 'un',
                                                                  from_name       => NULL,
                                                                  to_name         => NULL),1)
              WHEN msi.item_type in ('ACARV','ACA','MP','INT')    AND
                   rt.transaction_type = 'RETURN TO VENDOR' AND
                   inv_convert.inv_um_convert (item_id         => msi.inventory_item_id,
                                               precision       => NULL,
                                               from_quantity   => 1,
                                               from_unit       => rt.uom_code,
                                               to_unit         => 'un',
                                               from_name       => NULL,
                                               to_name         => NULL) > 0 THEN
                  round(rt.quantity * inv_convert.inv_um_convert (item_id         => msi.inventory_item_id,
                                                                  precision       => NULL,
                                                                  from_quantity   => 1,
                                                                  from_unit       => rt.uom_code,
                                                                  to_unit         => 'un',
                                                                  from_name       => NULL,
                                                                  to_name         => NULL) * -1,1)
              WHEN rt.transaction_type = 'RECEIVE' THEN
                   round(rt.quantity,1)
              ELSE round(rt.quantity * -1,1)
           END amt_receiptqty,
           CASE
              WHEN msi.item_type in ('ACARV','ACA','MP','INT') AND
                   inv_convert.inv_um_convert (item_id         => msi.inventory_item_id,
                                               precision       => NULL,
                                               from_quantity   => 1,
                                               from_unit       => rt.uom_code,
                                               to_unit         => 'kg',
                                               from_name       => NULL,
                                               to_name         => NULL) > 0 THEN
                  (select unit_of_measure from mtl_units_of_measure muom 
                      WHERE muom.uom_code = 'kg')
              WHEN msi.item_type in ('ACARV','ACA','MP','INT') AND
                   inv_convert.inv_um_convert (item_id         => msi.inventory_item_id,
                                               precision       => NULL,
                                               from_quantity   => 1,
                                               from_unit       => rt.uom_code,
                                               to_unit         => 'un',
                                               from_name       => NULL,
                                               to_name         => NULL) > 0 THEN
                  (select unit_of_measure from mtl_units_of_measure muom 
                      WHERE muom.uom_code = 'un')
              ELSE rt.unit_of_measure
           END txt_ofuom,
           CASE
              WHEN msi.item_type in ('ACARV','ACA','MP','INT') AND
                   inv_convert.inv_um_convert (item_id         => msi.inventory_item_id,
                                               precision       => NULL,
                                               from_quantity   => 1,
                                               from_unit       => rt.uom_code,
                                               to_unit         => 'kg',
                                               from_name       => NULL,
                                               to_name         => NULL) > 0 THEN
                   ROUND(TO_NUMBER (NVL((SELECT pll2.attribute2
                                   FROM apps.po_line_locations_all pll, apps.po_line_locations_all pll2, apps.po_lines_all pl
                                  WHERE pll.line_location_id = rsl.po_line_location_id
                                    AND pll2.po_line_id      = pll.from_line_id
                                    AND pl.po_line_id        = pll2.po_line_id
                                    AND pll2.attribute1 IS NOT NULL
                                    AND ROWNUM = 1),
                           NVL((SELECT pll2.price_override
                                  FROM apps.po_line_locations_all pll, apps.po_line_locations_all pll2, apps.po_lines_all pl
                                 WHERE pll.line_location_id = rsl.po_line_location_id
                                   AND pll2.po_line_id      = pll.from_line_id
                                   AND pl.po_line_id        = pll2.po_line_id
                                   AND pll2.attribute1 IS NOT NULL
                                   AND ROWNUM = 1),
                               (SELECT pl.unit_price
                                  FROM apps.po_line_locations_all pll, apps.po_lines_all pl
                                 WHERE pll.line_location_id = rsl.po_line_location_id
                                   AND pl.po_line_id        = pll.po_line_id
                                   AND ROWNUM = 1)))) / inv_convert.inv_um_convert (item_id         => msi.inventory_item_id,
                                                              precision       => NULL,
                                                              from_quantity   => 1,
                                                              from_unit       => rt.uom_code,
                                                              to_unit         => 'kg',
                                                              from_name       => NULL,
                                                              to_name         => NULL),3)
              WHEN msi.item_type in ('ACARV','ACA','MP') AND
                   inv_convert.inv_um_convert (item_id         => msi.inventory_item_id,
                                               precision       => NULL,
                                               from_quantity   => 1,
                                               from_unit       => rt.uom_code,
                                               to_unit         => 'un',
                                               from_name       => NULL,
                                               to_name         => NULL) > 0 THEN
                  ROUND(TO_NUMBER (NVL((SELECT pll2.attribute2
                                   FROM apps.po_line_locations_all pll, apps.po_line_locations_all pll2, apps.po_lines_all pl
                                  WHERE pll.line_location_id = rsl.po_line_location_id
                                    AND pll2.po_line_id = pll.from_line_id
                                    AND pl.po_line_id = pll2.po_line_id
                                    AND pll2.attribute1 IS NOT NULL
                                    AND ROWNUM = 1),
                           NVL((SELECT pll2.price_override
                                  FROM apps.po_line_locations_all pll, apps.po_line_locations_all pll2, apps.po_lines_all pl
                                 WHERE pll.line_location_id = rsl.po_line_location_id
                                   AND pll2.po_line_id = pll.from_line_id
                                   AND pl.po_line_id = pll2.po_line_id
                                   AND pll2.attribute1 IS NOT NULL
                                   AND ROWNUM = 1),
                               (SELECT pl.unit_price
                                  FROM apps.po_line_locations_all pll, apps.po_lines_all pl
                                 WHERE pll.line_location_id = rsl.po_line_location_id
                                   AND pl.po_line_id = pll.po_line_id
                                   AND ROWNUM = 1)))) / inv_convert.inv_um_convert (item_id         => msi.inventory_item_id,
                                                                  precision       => NULL,
                                                                  from_quantity   => 1,
                                                                  from_unit       => rt.uom_code,
                                                                  to_unit         => 'un',
                                                                  from_name       => NULL,
                                                                  to_name         => NULL),3)
              ELSE ROUND(TO_NUMBER (NVL((SELECT pll2.attribute2
                                   FROM apps.po_line_locations_all pll, apps.po_line_locations_all pll2, apps.po_lines_all pl
                                  WHERE pll.line_location_id = rsl.po_line_location_id
                                    AND pll2.po_line_id = pll.from_line_id
                                    AND pl.po_line_id = pll2.po_line_id
                                    AND pll2.attribute1 IS NOT NULL
                                    AND ROWNUM = 1),
                           NVL((SELECT pll2.price_override
                                  FROM apps.po_line_locations_all pll, apps.po_line_locations_all pll2, apps.po_lines_all pl
                                 WHERE pll.line_location_id = rsl.po_line_location_id
                                   AND pll2.po_line_id = pll.from_line_id
                                   AND pl.po_line_id = pll2.po_line_id
                                   AND pll2.attribute1 IS NOT NULL
                                   AND ROWNUM = 1),
                               (SELECT pl.unit_price
                                  FROM apps.po_line_locations_all pll, apps.po_lines_all pl
                                 WHERE pll.line_location_id = rsl.po_line_location_id
                                   AND pl.po_line_id = pll.po_line_id
                                   AND ROWNUM = 1)))),3) 
           END amt_orderprice,   
           NVL (
              (SELECT DISTINCT NVL (pla_bkt.attribute1, 'USD')
                 FROM apps.po_line_locations_all plla,
                      apps.po_line_locations_all          pla_bkt
                WHERE plla.from_line_id     = pla_bkt.po_line_id                                                          
                  AND plla.line_location_id = rsl.po_line_location_id
                  ),
              NVL ( (SELECT pha.currency_code
                       FROM apps.po_headers_all pha, apps.po_line_locations_all plla
                      WHERE plla.po_header_id = pha.po_header_id AND plla.line_location_id = rsl.po_line_location_id),
                   'BRL'))
              txt_ordercurr,
           NULL rte_exchgrate,
           TO_CHAR (ph.terms_id) Idt_Payterm,
           TO_CHAR (NVL (hr.location_code,hr1.location_code)) LOCATION_CODE,
           at.name Cde_PayTerm,
           substr(nvl(at.description, at.name), 1, 50) dsc_payterm,
           (SELECT AVG(due_days)
              FROM apps.ap_terms_lines atl
             WHERE atl.term_id = at.term_id) int_EquivDays,
           (SELECT AVG(discount_percent)
              FROM apps.ap_terms_lines atl
             WHERE atl.term_id = at.term_id)  Pct_Discount
      FROM po.po_releases_all pr,
           po.po_line_locations_all pll,
           po.po_headers_all ph,
           ap.ap_suppliers pv,
           ap.ap_supplier_sites_all pvs,
           apps.mtl_parameters mp,
           apps.mtl_system_items msi,
           po.rcv_shipment_lines rsl,
           po.rcv_shipment_headers rsh,
           po.rcv_transactions rt,
           apps.hr_Locations hr,
           apps.hr_locations hr1,
           apps.hr_locations hr2,
           apps.ap_terms at,
           apps.cll_f189_entry_operations cfe,
           apps.cll_f189_invoices cfi,
           apps.hr_operating_units hou,
          (SELECT FFV.flex_value ORGN_CODE
             FROM apps.fnd_flex_value_sets ffvs,apps.fnd_flex_values ffv
            WHERE ffv.flex_value_set_id =ffvs.flex_value_set_id
              AND ffvs.flex_value_set_name = 'XXINV_PA20_ORGS') ORGNS
     WHERE rt.source_document_code = 'PO'
       AND cfi.operation_id          = rsh.receipt_num
       AND cfi.organization_id       = rt.organization_id
       AND cfe.reversion_flag       IS NULL
       AND cfe.operation_id          = rsh.receipt_num
       AND cfe.organization_id       = rt.organization_id
       AND (rt.transaction_type      = 'RECEIVE' OR
            rt.transaction_type      = 'RETURN TO VENDOR')
       AND rsl.shipment_line_id      = rt.shipment_line_id
       AND rsh.shipment_header_id    = rt.shipment_header_id
       AND msi.inventory_item_id     = rsl.item_id
       AND msi.organization_id       = rsl.to_organization_id
       AND mp.organization_id        = msi.organization_id
       AND ph.po_header_id           = rt.po_header_id
       AND pv.vendor_id              = rt.vendor_id
       AND rt.location_id            = hr.location_Id (+)
       AND rt.vendor_id              = pvs.vendor_id
       AND rt.vendor_site_id         = pvs.vendor_site_Id
       AND pll.line_location_id      = rt.po_line_location_id
       AND pr.po_release_id(+)       = rt.po_release_id
       AND PH.ORG_ID                 = hou.organization_id
       AND mp.organization_code      = orgns.orgn_code
       AND msi.STOCK_ENABLED_FLAG    = 'Y'
       AND msi.consigned_flag        = 2
       AND rsl.ship_to_location_id   = hr1.location_id 
       AND pll.ship_to_location_id   = hr2.location_id
       AND ph.terms_id               = at.term_id
       and rt.transaction_date >= to_date('01/01/2017','dd/mm/yyyy')
