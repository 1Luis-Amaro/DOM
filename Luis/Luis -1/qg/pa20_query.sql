    SELECT --rt.*,
           TO_CHAR (rt.transaction_id) txt_receiptid,
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

       ---    pll.quantity*apps.XXINV_UOM_CONVERSION_MAIN.XXINV_UOM_CONVERSION_PA( rt.unit_of_measure) amt_polineqty,
           
           CASE
              WHEN rt.uom_code = 'kg' then
                   pll.quantity
              WHEN msi.primary_uom_code = 'kg' then
                  ROUND((rt.primary_quantity / rt.quantity) * pll.quantity,3)
              WHEN msi.secondary_uom_code = 'kg' then
                  ROUND((rt.secondary_quantity / rt.quantity) * pll.quantity,3)
              WHEN conv.to_uom_code = 'kg' THEN
                  ROUND(round(((rt.primary_quantity / rt.quantity) * pll.quantity) / conv.conversion_rate,3),3)
              WHEN msi.primary_uom_code = 'un' then
                  ROUND((rt.primary_quantity / rt.quantity) * pll.quantity,3)
              ELSE
                  ROUND(pll.quantity,3)
                   
           END amt_polineqty,
           
       --    rt.quantity*apps.XXINV_UOM_CONVERSION_MAIN.XXINV_UOM_CONVERSION_PA( rt.unit_of_measure)  amt_receiptqty,
           
           CASE
              WHEN rt.uom_code = 'kg' then
                   ROUND(rt.quantity,3)
              WHEN msi.primary_uom_code = 'kg' then
                   ROUND((rt.primary_quantity / rt.quantity) * rt.quantity,3)
              WHEN msi.secondary_uom_code = 'kg' then
                   ROUND((rt.secondary_quantity / rt.quantity) * rt.quantity,3)
              WHEN conv.to_uom_code = 'kg' THEN
                   ROUND(((rt.primary_quantity / rt.quantity) * rt.quantity) / conv.conversion_rate,3)
              WHEN msi.primary_uom_code = 'un' then
                   ROUND((rt.primary_quantity / rt.quantity) * rt.quantity,3)
              ELSE
                  ROUND(rt.quantity,3) 
           END  amt_receiptqty,
           
       --    apps.XXINV_UOM_CONVERSION_MAIN.XXINV_PA_TARGET_UOM(rt.unit_of_measure) txt_ofuom,
           
           CASE
              WHEN rt.uom_code = 'kg' THEN
                   rt.unit_of_measure
              WHEN msi.primary_uom_code = 'kg' THEN
                   msi.primary_unit_of_measure
              WHEN msi.secondary_uom_code = 'kg' THEN
                   conv.to_unit_of_measure
              WHEN conv.to_uom_code = 'kg' THEN
                   conv.to_unit_of_measure
              WHEN msi.primary_uom_code = 'un' THEN
                   msi.primary_unit_of_measure          
              ELSE
                  rt.unit_of_measure 
                   
           END txt_ofuom,
           
           
       --    rt.po_unit_price/apps.XXINV_UOM_CONVERSION_MAIN.XXINV_UOM_CONVERSION_PA( rt.unit_of_measure) amt_orderprice,
        /*   
           CASE
              WHEN rt.uom_code = 'kg' then
                   ROUND(rt.po_unit_price,4)
              WHEN msi.primary_uom_code = 'kg' then
                   ROUND(rt.po_unit_price / (rt.primary_quantity / rt.quantity),4)
              WHEN msi.secondary_uom_code = 'kg' then
                   ROUND(rt.po_unit_price / (rt.secondary_quantity / rt.quantity),4)
              WHEN conv.to_uom_code = 'kg' THEN
                   ROUND(rt.po_unit_price / round((rt.primary_quantity / rt.quantity) / conv.conversion_rate,3),4)
              WHEN msi.primary_uom_code = 'un' then
                   ROUND(rt.po_unit_price / (rt.primary_quantity / rt.quantity),4)
              ELSE
                   ROUND(rt.po_unit_price,4)
           END amt_orderprice,
          */
           
          rt.po_unit_price amt_orderprice,
          ----- 
          -----
           
           rt.currency_code txt_ordercurr,
           rt.currency_conversion_rate rte_exchgrate,
           TO_CHAR (ph.terms_id) Idt_Payterm,
           hr.location_code,
           at.name Cde_PayTerm,
           substr(nvl(at.description, at.name), 1, 50) dsc_payterm,
           
           (SELECT AVG(due_days)
              FROM ap_terms_lines atl
             WHERE atl.term_id = at.term_id) int_EquivDays,
             
           (SELECT AVG(discount_percent)
              FROM ap_terms_lines atl
             WHERE atl.term_id = at.term_id)  Pct_Discount
           

           --int_EquivDays, Pct_Discount       
           
              
      FROM mtl_uom_class_conversions conv,
           po.po_releases_all pr,
           po.po_line_locations_all pll,
           ap.ap_suppliers pv,
           ap.ap_supplier_sites_all pvs,
           po.po_headers_all ph,
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
         --  apps.mtl_item_sub_inventories MISV,
           apps.hr_operating_units hou,
        /* (SELECT TAG ORGN_CODE,DESCRIPTION SICODE FROM apps.fnd_lookup_values FLV
             WHERE lookup_type = 'XXINV_INC_PA20_ORG_SUBINV' 
               AND language = 'US'
               AND enabled_flag = 'Y'
              AND trunc(sysdate) between start_date_active and nvl(end_date_active,sysdate)) ORG_SUBINV ,*/
          (SELECT FFV.flex_value ORGN_CODE
             FROM apps.fnd_flex_value_sets ffvs,apps.fnd_flex_values ffv
            WHERE ffv.flex_value_set_id =ffvs.flex_value_set_id
              AND ffvs.flex_value_set_name = 'XXINV_PA20_ORGS') ORGNS
     WHERE rt.source_document_code = 'PO'
    --   AND rt.transaction_id  > #P1#
    --AND rt.unit_of_measure LIKE '%Gal%'
    
       AND cfi.operation_id          = rsh.receipt_num
       AND cfi.organization_id       = rt.organization_id
    
       AND cfe.reversion_flag       IS NULL
       AND cfe.operation_id          = rsh.receipt_num
       AND cfe.organization_id       = rt.organization_id
       
       AND conv.from_uom_code(+)     = msi.primary_uom_code
       AND conv.inventory_item_id(+) = msi.inventory_item_id
       AND conv.to_uom_code(+)       = 'kg'
       
       AND (rt.transaction_type       = 'RECEIVE') -- OR
            --rt.transaction_type       = 'RETURN TO VENDOR')
       
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
       AND msi.segment1 = 'PT-28-8881'
       and hr1.location_code = 'GRAVATAI'
       --and ph.segment1 = 'M103688';
;

shipment_header_id_1;

receipt_num;

parent_transaction_id = 94967;

select * from cll_f189_invoices; 

select * from cll_f189_entry_operations ;