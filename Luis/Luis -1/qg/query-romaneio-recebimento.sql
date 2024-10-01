SELECT 'UNH+'||rownum||'+DESADV:D:02B:UN''' MESSAGE_HEADER,
        a.BEGINNING_MESSAGE,
        a.TOTAL_CONTROL,
        a.TRANSACTION_ID,
        a.INVOICE_TYPE,
        a.ENTITY,
        a.SUBINV
  FROM( SELECT cfi.operation_id BEGINNING_MESSAGE,
               (SELECT  'CNT+2:'||count(*)||''''
                  FROM APPS.rcv_transactions     rt2
                      ,APPS.rcv_shipment_headers rsh2
                      ,APPS.rcv_shipment_lines   rsl2
                      ,APPS.mtl_system_items_b   msi
                      ,APPS.mtl_material_transactions mmt
                      ,APPS.mtl_transaction_lot_numbers mtl
                 WHERE rsh2.shipment_header_id IN (SELECT shipment_header_id
                 FROM APPS.rcv_shipment_headers WHERE receipt_num=rsh.receipt_num)
                 AND rt2.shipment_header_id = rsh2.shipment_header_id
                   AND rsh2.shipment_header_id = rsl2.shipment_header_id
                   AND rt2.shipment_line_id = rsl2.shipment_line_id
                   AND rt2.shipment_header_id = rsh2.shipment_header_id
                   AND msi.organization_id = rt2.organization_id
                   AND msi.inventory_item_id = rsl2.item_id
                   AND mmt.inventory_item_id=msi.inventory_item_id
                   AND mmt.rcv_transaction_id=rt2.transaction_id
                   AND mmt.organization_id=msi.organization_id
                   AND mtl.transaction_id(+)=mmt.transaction_id) TOTAL_CONTROL,
                   
               rt.transaction_id                                                        TRANSACTION_ID,
               cfi.invoice_type_id                                                      INVOICE_TYPE,
               cfi.entity_id                                                            ENTITY,
               rt.subinventory                                                          SUBINV
       FROM APPS.rcv_transactions     rt
           ,APPS.rcv_shipment_headers rsh
           ,APPS.rcv_shipment_lines   rsl
           ,APPS.cll_f189_invoice_lines cfil
           ,APPS.cll_f189_invoices cfi
           ,APPS.HR_ORGANIZATION_UNITS_V hou
           ,APPS.ap_suppliers aps
      WHERE rt.shipment_header_id  = rsh.shipment_header_id
        AND rsh.shipment_header_id = rsl.shipment_header_id
        AND rt.shipment_line_id    = rsl.shipment_line_id
        AND rt.shipment_header_id  = rsh.shipment_header_id
        AND rt.transaction_type    = 'DELIVER'
        AND rt.destination_type_code = 'INVENTORY'
        AND rt.subinventory IN (SELECT flv.meaning
                                  FROM APPS.fnd_lookup_values flv
                                 WHERE flv.lookup_type = 'XPPGBR_SUBINVENTORY_DHL'
                                   AND flv.language = USERENV('LANG')
                                  -- AND flv.view_application_id = 1
                                   AND flv.enabled_flag = 'Y'
                                   AND SYSDATE BETWEEN NVL(flv.start_date_active, SYSDATE) AND NVL(end_date_active, SYSDATE)
                               )
        AND rt.organization_id = 92
        AND rt.source_document_code='PO'
        AND rt.organization_id=cfi.organization_id
        AND cfil.invoice_id=cfi.invoice_id
        AND cfil.line_location_id=rsl.po_line_location_id
        AND rt.location_id=hou.location_id
        AND rt.organization_id=hou.organization_id
        AND rsh.vendor_id=aps.vendor_id
       -- AND rt.attribute15 IS NULL        
     GROUP BY rsh.receipt_num ,rsh.shipment_num,rsh.ship_to_location_id,rt.transaction_id,aps.vendor_id,hou.location_id,cfi.operation_id 
             , cfi.invoice_type_id ,cfi.entity_id,subinventory)   a;
             
             
select * from APPS.rcv_transactions     rt             