    SELECT cfi.invoice_num         "Invoice Number",
           rsl.line_num            "Invoice Line",
           ph.segment1             "Purchase Order Number",
           pla.line_num            "Purchase Order Line",
           pv.vendor_name          "Supplier Name",
           pv.segment1             "Supplier Code",
           msi.segment1            "Part Number",
--           msi.description         "Description",
           
           translate(substr(msi.description,1,89),'ABCDEFGHIJKLMNOPQRSTUWVXYZabcdefghijklmnopqrstuwvxyz01234567890�����������������������|������������������������疺���.-!"''`#$%().:[/]{}�+???�;�&�*<>'
                                                  ,'ABCDEFGHIJKLMNOPQRSTUWVXYZabcdefghijklmnopqrstuwvxyz01234567890NAEIOUAEIOUAEIOUAOAEIOU!Cnaeiouaeiouaeiouaoaeiouc-')  "Description",
           
           translate(substr(inventario.categoria ,1,89),'ABCDEFGHIJKLMNOPQRSTUWVXYZabcdefghijklmnopqrstuwvxyz01234567890�����������������������|������������������������疺���.-!"''`#$%().:[/]{}�+???�;�&�*<>'
                                                       ,'ABCDEFGHIJKLMNOPQRSTUWVXYZabcdefghijklmnopqrstuwvxyz01234567890NAEIOUAEIOUAEIOUAOAEIOU!Cnaeiouaeiouaeiouaoaeiouc-') "Material Group",

           
--           inventario.categoria    "Material Group",
           trunc(cfi.invoice_date) "Invoice Date",
           
           
           TRUNC (ph.creation_date) "PO creation date",
           TRUNC (rt.transaction_date) "Invoice Receipt date",
           
           
           
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
           
           END "Quantity",
            
           
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
           
           END "UOM",
           
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
           
           END "Unit Price",  
           
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
              "Currency Code",
              
              
           CASE 
               WHEN cfi.attribute_category = 'SOFTWAY' THEN
                  (SELECT MAX(INV.EXCHANGE_RATE)
                     FROM AP.AP_INVOICES_ALL inv,
                          AP.AP_INVOICE_LINES_ALL LIN
                    WHERE EXISTS (SELECT 1
                                    FROM ap.ap_invoice_payments_all pay
                                   WHERE pay.invoice_id  = inv.invoice_id) AND
                          lin.po_line_id  = pll.po_line_id AND
                          lin.invoice_id  = inv.invoice_id AND
                          inv.vendor_id   = ph.vendor_id   AND       
                          inv.description like '%' || cfi.attribute3 || '%')
               ELSE
                  (SELECT MAX(INV.EXCHANGE_RATE)
                     FROM ap.ap_invoices_all inv,
                          ap.ap_invoice_lines_all lin
                    WHERE lin.invoice_id          = inv.invoice_id        AND
                          inv.invoice_num         = cfi.invoice_num_ap    AND
                          inv.vendor_id           = ph.vendor_id   AND 
                          lin.po_line_location_id = rt.po_line_location_id AND
                          EXISTS (SELECT 1
                                    FROM AP.AP_INVOICE_PAYMENTS_ALL PAY
                                   WHERE PAY.INVOICE_ID  = INV.INVOICE_ID))
           END "Exchange Rate",                      
              
           
           TO_CHAR (NVL (hr.location_code,hr1.location_code)) "LOCATION",
           
           nvl ((SELECT ACTION_DATE FROM(
                                  SELECT SEQUENCE_NUM,
                                         ACTION_DATE,
                                         ACTION_CODE_DSP,
                                         EMPLOYEE_NAME APROVADOR,
                                         OBJECT_ID          
                                    FROM APPS.PO_ACTION_HISTORY_V
                                   WHERE OBJECT_TYPE_CODE = 'REQUISITION' 
                                   ORDER BY OBJECT_ID, SEQUENCE_NUM DESC
                                   ) WHERE ROWNUM = 1 
                                      AND OBJECT_ID = prla.REQUISITION_HEADER_ID
                               ),'') "Requisition Approval Date",
           
                  
           CASE 
               WHEN cfi.attribute_category = 'SOFTWAY' THEN
                  (SELECT MAX(cks.check_date)
                     FROM ap.ap_invoices_all inv,
                          ap.ap_invoice_payments_all pay,
                          ap.ap_checks_all cks
                    WHERE pay.check_id    = cks.check_id       AND
                          pay.invoice_id  = inv.invoice_id     AND
                          inv.description like '%' || cfi.attribute3 || '%' AND
                          inv.vendor_id   = ph.vendor_id) 
               
               
               ELSE
               
                  (SELECT MAX(cks.check_date)
                     FROM ap.ap_invoices_all inv,
                          ap.ap_invoice_payments_all pay,
                          ap.ap_checks_all cks
                    WHERE pay.check_id    = cks.check_id       AND
                          pay.invoice_id  = inv.invoice_id     AND
                          inv.invoice_num = cfi.invoice_num_ap AND
                          inv.vendor_id   = ph.vendor_id)

           END  "Approved Payment Date",
           
                 
           CASE 
               WHEN (SELECT COUNT (*)
                           FROM apps.po_distributions_all pda
                          WHERE pda.po_line_id = pll.po_line_id) > 1 THEN
                           
                  ( (SELECT SUM(cfil.total_amount) 
                     FROM apps.cll_f189_invoice_lines cfil
                    WHERE cfil.invoice_id       = cfi.invoice_id AND
                          cfil.line_location_id = rt.po_line_location_id) /
                    
                  (SELECT SUM(rt1.quantity)
                     FROM po.rcv_transactions rt1
                    WHERE rt1.po_line_location_id = rt.po_line_location_id AND
                          rt1.shipment_header_id  = rt.shipment_header_id  AND
                          rt1.organization_id     = rt.organization_id     AND
                          rt1.transaction_type    = 'RECEIVE'))  * rt.quantity
               
                     
                    --rsl.quantity_received --* cfil.unit_price_uom_po    
                                    
--                    ((SELECT MAX(lin.amount)
  --                      FROM ap.ap_invoices_all inv,
    --                         ap.ap_invoice_lines_all lin
      --                 WHERE lin.invoice_id          = inv.invoice_id        AND
        --                     inv.invoice_num         = cfi.invoice_num_ap    AND
          --                   inv.vendor_id           = rt.vendor_id          AND
            --                 lin.quantity_invoiced > 0                       AND  
              --               lin.po_line_location_id = cfil.line_location_id AND
                --             EXISTS (SELECT 1
                --                       FROM AP.AP_INVOICE_PAYMENTS_ALL PAY
                --                      WHERE PAY.INVOICE_ID  = INV.INVOICE_ID)) + cfil.ipi_amount) /
                --     (SELECT SUM(rt1.quantity)
                --        FROM po.rcv_transactions rt1
                --       WHERE rt1.shipment_header_id = rt.shipment_header_id AND
                --             rt1.transaction_type = 'RECEIVE') * rt.quantity
                      

                   
                   
                   
                   
                   --rt.quantity * rt.po_unit_price
                  
               WHEN cfi.attribute_category = 'SOFTWAY' THEN
                   (SELECT MAX(LIN.AMOUNT * INV.EXCHANGE_RATE)
                     FROM AP.AP_INVOICES_ALL inv,
                          AP.AP_INVOICE_LINES_ALL LIN
                    WHERE EXISTS (SELECT 1
                                    FROM ap.ap_invoice_payments_all pay
                                   WHERE pay.invoice_id  = inv.invoice_id) AND
                          lin.po_line_id  = pll.po_line_id AND
                          lin.invoice_id  = inv.invoice_id AND
                          inv.vendor_id   = ph.vendor_id   AND
                          lin.quantity_invoiced > 0 and       
                          inv.description like '%' || cfi.attribute3 || '%')
                          
               ELSE 
                   (SELECT MAX(lin.amount)
                     FROM ap.ap_invoices_all inv,
                          ap.ap_invoice_lines_all lin
                    WHERE lin.invoice_id          = inv.invoice_id         AND
                          inv.invoice_num         = cfi.invoice_num_ap     AND
                          inv.vendor_id           = ph.vendor_id           AND
                          lin.quantity_invoiced > 0                        AND  
                          lin.po_line_location_id = rt.po_line_location_id AND
                          EXISTS (SELECT 1
                                    FROM AP.AP_INVOICE_PAYMENTS_ALL PAY
                                   WHERE PAY.INVOICE_ID  = INV.INVOICE_ID))  +
                  (SELECT SUM(cfil.ipi_amount) 
                     FROM apps.cll_f189_invoice_lines cfil
                    WHERE line_location_id = rt.po_line_location_id)
                    
            END "Invoice Amount Paid"
            
--;

--select RT.PO_LINE_LOCATION_ID
            
      FROM po.po_releases_all       pr,
           po.po_lines_all          pla,
           po.po_line_locations_all pll,
           po.po_headers_all        ph,
           
           ap.ap_suppliers          pv,
           ap.ap_supplier_sites_all pvs,
           
           apps.mtl_parameters      mp,
           apps.mtl_system_items    msi,
           
           po.rcv_shipment_lines    rsl,
           po.rcv_shipment_headers  rsh,
           po.rcv_transactions      rt,
           
           apps.po_requisition_lines_all prla,
           apps.hr_Locations hr,
           apps.hr_locations hr1,
           apps.hr_locations hr2,
           apps.ap_terms at,
           
           apps.cll_f189_entry_operations cfe,
           apps.cll_f189_invoices cfi,
           --apps.cll_f189_invoice_lines cfil,
           apps.hr_operating_units hou,
           (SELECT MIC.INVENTORY_ITEM_ID,
                   MIC.ORGANIZATION_ID,
                   MIC.CATEGORY_SET_NAME,
                   MIC.CATEGORY_CONCAT_SEGS CATEGORIA
              FROM APPS.MTL_ITEM_CATEGORIES_V MIC, APPS.MTL_CATEGORIES_V MC
             WHERE MC.CATEGORY_ID = MIC.CATEGORY_ID
               AND MIC.CATEGORY_SET_NAME IN ('Compras')) INVENTARIO
               
                       
     WHERE
/*           cfil.organization_id      = cfi.organization_id
       AND cfil.invoice_id           = cfi.invoice_id
       AND cfil.line_location_id     = rsl.po_line_location_id
       AND*/ cfi.operation_id          = rsh.receipt_num
       AND cfi.organization_id       = rt.organization_id
       AND cfe.reversion_flag       IS NULL
       AND cfe.operation_id          = rsh.receipt_num
       AND cfe.organization_id       = rt.organization_id
       
       ---
       and   
           CASE 
               WHEN cfi.attribute_category = 'SOFTWAY' THEN
                  (SELECT MAX(cks.check_date)
                     FROM ap.ap_invoices_all inv,
                          ap.ap_invoice_payments_all pay,
                          ap.ap_checks_all cks
                    WHERE pay.check_id    = cks.check_id       AND
                          pay.invoice_id  = inv.invoice_id     AND
                          inv.description like '%' || cfi.attribute3 || '%' AND
                          inv.vendor_id   = ph.vendor_id) 
               
               
               ELSE
               
                  (SELECT MAX(cks.check_date)
                     FROM ap.ap_invoices_all inv,
                          ap.ap_invoice_payments_all pay,
                          ap.ap_checks_all cks
                    WHERE pay.check_id    = cks.check_id       AND
                          pay.invoice_id  = inv.invoice_id     AND
                          inv.invoice_num = cfi.invoice_num_ap AND
                          inv.vendor_id   = ph.vendor_id)

           END is not null
       
       
       ---
       AND NOT EXISTS (select 1
                         FROM po.rcv_transactions rt1
                        WHERE rt1.shipment_line_id = rt.shipment_line_id AND
                              rt1.transaction_type = 'RETURN TO VENDOR')
                                
       
       AND rt.source_document_code   = 'PO'
--       AND (rt.transaction_type      = 'RECEIVE' OR
--            rt.transaction_type      = 'RETURN TO VENDOR')
            
       AND  rt.transaction_type      = 'RECEIVE'
            
       AND rsl.shipment_line_id      = rt.shipment_line_id
       AND rsh.shipment_header_id    = rt.shipment_header_id
       
       AND msi.inventory_item_id     = rsl.item_id
       AND msi.organization_id       = rt.organization_id
       AND mp.organization_id        = msi.organization_id
       AND ph.po_header_id           = rt.po_header_id
       AND pv.vendor_id              = ph.vendor_id
       AND pv.attribute1 not like '%INTERCOMPANY%'
       
      -- AND PV.vendor_name like 'WEST SIDE VIAGENS%'
       
       AND rt.location_id            = hr.location_Id (+)
       AND ph.vendor_id              = pvs.vendor_id
       AND rt.vendor_site_id         = pvs.vendor_site_Id
       and pla.po_line_id            = pll.po_line_id
       AND pll.line_location_id      = rt.po_line_location_id
       AND pr.po_release_id(+)       = rt.po_release_id
       AND PH.ORG_ID                 = hou.organization_id
     --  AND msi.STOCK_ENABLED_FLAG    = 'Y'
--       AND msi.consigned_flag        = 2
       AND rsl.ship_to_location_id   = hr1.location_id 
       AND pll.ship_to_location_id   = hr2.location_id
       AND ph.terms_id               = at.term_id
       AND MSI.ORGANIZATION_ID       = INVENTARIO.ORGANIZATION_ID(+)
       AND MSI.INVENTORY_ITEM_ID     = INVENTARIO.INVENTORY_ITEM_ID(+)
       
       --AND trunc(cfi.invoice_date)  >= to_date('01/jan/2015')
       --AND trunc(cfi.invoice_date)  <  to_date('01/jan/2016')
       
       --and cfi.invoice_num IN (76232) --(4045072,30808, 76249)
       --and cfi.invoice_id = 44238
      --and cfi.attribute3 = 'SUM0456/15'
       
       --AND trunc(rt.transaction_date) < to_date('01/jan/2016')
       
--       AND trunc(rt.transaction_date)  >= to_date('01/jan/2015')
--       AND trunc(rt.transaction_date)  <  to_date('01/jan/2016')
       
       AND trunc(cfi.invoice_date)  >= to_date('01/jan/2015')
       AND trunc(cfi.invoice_date)  <  to_date('01/jan/2016')
       
       AND prla.line_location_id(+)  = pll.line_location_id
      -- AND ap.po_line_location       = pll.line_location_id
      -- AND ap.nff(+)                 = cfi.invoice_num_ap; 
       
                 
          
          
          ;
          
          
select cfi.attribute3, rt.vendor_id, cfi.invoice_num_ap , '%' || cfi.attribute3 || '%', pll.po_line_id,
      (SELECT MAX(LIN.AMOUNT * INV.EXCHANGE_RATE)
         FROM AP.AP_INVOICES_ALL inv,
              AP.AP_INVOICE_LINES_ALL LIN,
              AP.AP_PAYMENT_SCHEDULES_ALL SCD,
              AP.AP_INVOICE_PAYMENTS_ALL PAY
        WHERE 
              LIN.PO_LINE_ID  = pll.po_line_id AND
              LIN.INVOICE_ID  = INV.INVOICE_ID AND
              SCD.INVOICE_ID  = INV.INVOICE_ID AND
              PAY.INVOICE_ID  = INV.INVOICE_ID AND
              INV.VENDOR_ID   = rt.vendor_id   AND       
              INV.DESCRIPTION like '%' || cfi.attribute3 || '%') VALOR_imp,
                         
              
      (SELECT MAX(INV.INVOICE_AMOUNT)
         FROM AP.AP_INVOICES_ALL inv,
              AP.AP_INVOICE_LINES_ALL LIN,
              AP.AP_PAYMENT_SCHEDULES_ALL SCD,
              AP.AP_INVOICE_PAYMENTS_ALL PAY
        WHERE LIN.PO_LINE_ID  = pll.po_line_id AND
              LIN.INVOICE_ID  = INV.INVOICE_ID AND
              SCD.INVOICE_ID  = INV.INVOICE_ID AND
              PAY.INVOICE_ID  = INV.INVOICE_ID AND
              INV.INVOICE_NUM = cfi.invoice_num_ap) VALOR
              
              
              
      FROM po.po_releases_all pr,
           po.po_lines_all pla,
           
           po.po_line_locations_all pll,
           po.po_headers_all ph,
           ap.ap_suppliers pv,
           ap.ap_supplier_sites_all pvs,
           apps.mtl_parameters mp,
           apps.mtl_system_items msi,
           
           po.rcv_shipment_lines rsl,
           po.rcv_shipment_headers rsh,
           po.rcv_transactions rt,
           apps.po_requisition_lines_all prla,
           apps.hr_Locations hr,
           apps.hr_locations hr1,
           apps.hr_locations hr2,
           apps.ap_terms at,
           apps.cll_f189_entry_operations cfe,
           apps.cll_f189_invoices cfi,
           apps.hr_operating_units hou,
           (SELECT MIC.INVENTORY_ITEM_ID,
                   MIC.ORGANIZATION_ID,
                   MIC.CATEGORY_SET_NAME,
                   MIC.CATEGORY_CONCAT_SEGS CATEGORIA
              FROM APPS.MTL_ITEM_CATEGORIES_V MIC, APPS.MTL_CATEGORIES_V MC
             WHERE MC.CATEGORY_ID = MIC.CATEGORY_ID
               AND MIC.CATEGORY_SET_NAME IN ('Compras')) INVENTARIO
               
                       
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
       --AND pv.attribute1 not like '%INTERCOMPANY%'
       
       AND PV.vendor_name like '%RENNER%'
       
       AND rt.location_id            = hr.location_Id (+)
       AND rt.vendor_id              = pvs.vendor_id
       AND rt.vendor_site_id         = pvs.vendor_site_Id
       and pla.po_line_id            = pll.po_line_id
       AND pll.line_location_id      = rt.po_line_location_id
       AND pr.po_release_id(+)       = rt.po_release_id
       AND PH.ORG_ID                 = hou.organization_id
       AND msi.STOCK_ENABLED_FLAG    = 'Y'
       AND msi.consigned_flag        = 2
       AND rsl.ship_to_location_id   = hr1.location_id 
       AND pll.ship_to_location_id   = hr2.location_id
       AND ph.terms_id               = at.term_id
       AND MSI.ORGANIZATION_ID       = INVENTARIO.ORGANIZATION_ID(+)
       AND MSI.INVENTORY_ITEM_ID     = INVENTARIO.INVENTORY_ITEM_ID(+)
       AND trunc(cfi.invoice_date)  >= to_date('01/jan/2015')
       AND trunc(cfi.invoice_date)  <  to_date('01/jan/2016')
       
       --and cfi.invoice_id = 14203 --2614
      -- and cfi.attribute3 = 'SUM0456/15'
       
       --AND trunc(rt.transaction_date) < to_date('01/jan/2016')
       AND prla.line_location_id(+)  = pll.line_location_id
      -- AND ap.po_line_location       = pll.line_location_id
      -- AND ap.nff(+)                 = cfi.invoice_num_ap; 
       
       