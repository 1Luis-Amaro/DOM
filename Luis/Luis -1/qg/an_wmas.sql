         SELECT mp.organization_id
              , mp.attribute7             Cod_Estabelecimento
              , cffe.document_number      CNPJ_Estabelecimento
--              , DECODE(assa.global_attribute9,'1',assa.global_attribute10||assa.global_attribute12
--                                                 ,SUBSTR(assa.global_attribute10,2)||assa.global_attribute11||assa.global_attribute12)  CNPJ_CPF
              , cfi.series
              , cfeo.operation_id
              , cfi.invoice_num
              , cfi.invoice_id
              , cfil.line_location_id
              , cfit.operation_fiscal_type
              , cfi.gross_total_amount
              , cfi.invoice_amount
              , cfi.invoice_weight
              , cfi.invoice_date
--              , asu.segment1          vendor_number
--              , asu.vendor_name
--              , assa.address_line1||DECODE(assa.address_line2,Null,Null,',')||
--                assa.address_line2||DECODE(assa.address_line3,Null,Null,',')||
--                assa.address_line3    endereco
--              , assa.address_line4    bairro
--              , assa.city
--              , assa.state
--              , assa.zip
--              , assa.global_attribute13    IE
              , msib.segment1              Item_Code
              , msib.primary_uom_code
              , msi.attribute2                Endereco_Doca
              , msi.secondary_inventory_name  Subinventory_Code
--            , NVL(mtln.transaction_quantity, mmt.transaction_quantity) transaction_quantity
              , NVL(mtln.primary_quantity    , mmt.primary_quantity)     transaction_quantity     -- #02
              , DECODE(msib.lot_control_code,2,3,1)    tipo_Logistico
              , mtln.lot_number
              , cfil.total_amount   Line_Total_Amount
              , mmt.transaction_id
           FROM mtl_material_transactions    mmt
              , mtl_transaction_lot_numbers  mtln
              , mtl_secondary_inventories    msi
              , mtl_parameters               mp
              , hr_all_organization_units    haou
              , org_organization_definitions ood
              , cll_f189_fiscal_entities_all cffe
--              , rcv_transactions             rt
--              , rcv_shipment_headers         rsh
--              , rcv_shipment_lines           rsl
              , cll_f189_entry_operations    cfeo
              , cll_f189_invoices            cfi
              , cll_f189_invoice_lines       cfil
              , cll_f189_invoice_types       cfit
--              , ap_supplier_sites_all        assa
--              , ap_suppliers                 asu
              , mtl_system_items_b           msib
          WHERE mmt.source_code              = 'RCV'
            AND mtln.transaction_id (+)      = mmt.transaction_id
            AND mmt.subinventory_code        = msi.secondary_inventory_name
            AND mmt.organization_id          = msi.organization_id
            AND msi.attribute2              IS NOT NULL
            AND NVL(mmt.attribute15,'N')     = 'N'
            AND mp.organization_id           = mmt.organization_id
            AND haou.organization_id         = mmt.organization_id
            AND ood.organization_id          = haou.organization_id
            AND ood.operating_unit           = Fnd_Profile.Value('ORG_ID')
            AND cffe.location_id             = haou.location_id
            AND cffe.entity_type_lookup_code = 'LOCATION'
--            AND rt.transaction_id            = mmt.rcv_transaction_id
--            AND rsh.shipment_header_id       = rt.shipment_header_id
--            AND rsl.shipment_header_id       = rsh.shipment_header_id
--            AND rsl.shipment_line_id         = rt.shipment_line_id
            AND cfil.invoice_id              = cfi.invoice_id
--            AND cfil.line_location_id        = rsl.po_line_location_id
--            AND cfeo.operation_id            = TO_NUMBER(rsh.receipt_num)
--            AND cfeo.organization_id         = rsh.ship_to_org_id
            AND cfi.operation_id             = cfeo.operation_id
            AND cfi.organization_id          = cfeo.organization_id
            AND cfit.invoice_type_id         = cfi.invoice_type_id
            AND cfit.organization_id         = cfi.organization_id
--            AND assa.vendor_site_id          = rsh.vendor_site_id
--            AND asu.vendor_id                = assa.vendor_id
            AND msib.inventory_item_id       = mmt.inventory_item_id
            AND msib.organization_id         = mmt.organization_id
            
            and cfeo.operation_id = 80789
            
         ORDER BY cfeo.organization_id, cfeo.operation_id, cfi.invoice_id, mmt.transaction_id, mtln.lot_number;
         
         
         
         SELECT mp.organization_id
              , mp.attribute7             Cod_Estabelecimento
              , cffe.document_number      CNPJ_Estabelecimento
              , DECODE(assa.global_attribute9,'1',assa.global_attribute10||assa.global_attribute12
                                                 ,SUBSTR(assa.global_attribute10,2)||assa.global_attribute11||assa.global_attribute12)  CNPJ_CPF
              , cfi.series
              , cfeo.operation_id
              , cfi.invoice_num
              , cfi.invoice_id
              , cfil.line_location_id
              , cfit.operation_fiscal_type
              , cfi.gross_total_amount
              , cfi.invoice_amount
              , cfi.invoice_weight
              , cfi.invoice_date
              , asu.segment1          vendor_number
              , asu.vendor_name
              , assa.address_line1||DECODE(assa.address_line2,Null,Null,',')||
                assa.address_line2||DECODE(assa.address_line3,Null,Null,',')||
                assa.address_line3    endereco
              , assa.address_line4    bairro
              , assa.city
              , assa.state
              , assa.zip
              , assa.global_attribute13    IE
              , msib.segment1              Item_Code
              , msib.primary_uom_code
--              , msi.attribute2                Endereco_Doca
--              , msi.secondary_inventory_name  Subinventory_Code
--            , NVL(mtln.transaction_quantity, mmt.transaction_quantity) transaction_quantity
              , NVL(mtln.primary_quantity    , mmt.primary_quantity)     transaction_quantity     -- #02
              , DECODE(msib.lot_control_code,2,3,1)    tipo_Logistico
              , mtln.lot_number
              , cfil.total_amount   Line_Total_Amount
              , mmt.transaction_id
           FROM mtl_material_transactions    mmt
              , mtl_transaction_lot_numbers  mtln
--              , mtl_secondary_inventories    msi
              , mtl_parameters               mp
              , hr_all_organization_units    haou
              , org_organization_definitions ood
              , cll_f189_fiscal_entities_all cffe
              , rcv_transactions             rt
              , rcv_shipment_headers         rsh
              , rcv_shipment_lines           rsl
              , cll_f189_entry_operations    cfeo
              , cll_f189_invoices            cfi
              , cll_f189_invoice_lines       cfil
              , cll_f189_invoice_types       cfit
              , ap_supplier_sites_all        assa
              , ap_suppliers                 asu
              , mtl_system_items_b           msib
          WHERE --mmt.source_code              = 'RCV'
             mtln.transaction_id (+)      = mmt.transaction_id
--            AND mmt.subinventory_code        = msi.secondary_inventory_name
--            AND mmt.organization_id          = msi.organization_id
  --          AND msi.attribute2              IS NOT NULL
           -- AND NVL(mmt.attribute15,'N')     = 'N'
            AND mp.organization_id           = mmt.organization_id
            AND haou.organization_id         = mmt.organization_id
            AND ood.organization_id          = haou.organization_id
--            AND ood.operating_unit           = Fnd_Profile.Value('ORG_ID')
            AND cffe.location_id             = haou.location_id
--            AND cffe.entity_type_lookup_code = 'LOCATION'
            AND rt.transaction_id            = mmt.rcv_transaction_id
            AND rsh.shipment_header_id       = rt.shipment_header_id
            AND rsl.shipment_header_id       = rsh.shipment_header_id
            AND rsl.shipment_line_id         = rt.shipment_line_id
--            AND cfil.line_location_id        = rsl.po_line_location_id
            AND cfeo.operation_id            = TO_NUMBER(rsh.receipt_num)
--            AND cfeo.organization_id         = rsh.ship_to_org_id
--            AND assa.vendor_site_id          = rsh.vendor_site_id
--            AND asu.vendor_id                = assa.vendor_id
            AND msib.inventory_item_id       = mmt.inventory_item_id
            AND msib.organization_id         = mmt.organization_id

            AND cfil.invoice_id              = cfi.invoice_id

            AND cfi.invoice_type_id          = cfit.invoice_type_id
            AND cfi.organization_id          = cfit.organization_id
            
            AND cfi.operation_id             = cfeo.operation_id
            AND cfi.organization_id          = cfeo.organization_id
            
            and cfeo.operation_id = 80789
            
         ORDER BY cfeo.organization_id, cfeo.operation_id, cfi.invoice_id, mmt.transaction_id, mtln.lot_number;         