   SELECT DISTINCT
          --cfi.invoice_id,
          DECODE(
          DECODE (
             RSL.ROUTING_HEADER_ID,
             1, NVL (MTS.DESTINATION_TYPE_CODE, 'INVENTORY'),
             3, 'DIRECT',
             CASE
                WHEN (SELECT TRANSACTION_TYPE
                        FROM APPS.RCV_TRANSACTIONS
                       WHERE TRANSACTION_ID = MS.SUPPLY_SOURCE_ID) <>
                        'RECEIVE'
                THEN
                   'INVENTORY'
                ELSE
                   'RECEIVE'
             END),'EXPENSE','DESPESA','RECEIVE','QUALIDADE','INVENTORY','FISICO')
             TIPO,
          RSl.SHIPMENT_LINE_ID,
          OOD.ORGANIZATION_CODE ORG,
          OOD.ORGANIZATION_NAME ORGANIZACAO,
          CFEO.OPERATION_ID RECEBIMENTO,
          CFEO.RECEIVE_DATE DATA_RECEBIMENTO,
          CFEO.GL_DATE DATA_CONTABIL,
          CFI.INVOICE_NUM NOTA_FISCAL,
          NVL (MTS.TO_ORG_PRIMARY_QUANTITY, MS.TO_ORG_PRIMARY_QUANTITY) QTDE,
          CFEO.SOURCE ORIGEM,
          MSI.SEGMENT1 CODIGO_ITEM,
          MSI.PRIMARY_UOM_CODE,
          MSI.DESCRIPTION DESCRICAO_ITEM,
          MSI.ITEM_TYPE TIPO_ITEM,
          RSH.RECEIPT_SOURCE_CODE,
          RSL.SOURCE_DOCUMENT_CODE,
          RSL.QUANTITY_RECEIVED,
          RSL.UNIT_OF_MEASURE,
          RT.UOM_CODE,
          MSI.ITEM_TYPE,
          CFIT.INVOICE_TYPE_CODE,
          cfil.total_amount,
          cfil.cost_amount          
     FROM APPS.RCV_SUPPLY MS,
          APPS.MTL_SUPPLY MTS,
          APPS.RCV_TRANSACTIONS RT,
          APPS.RCV_SHIPMENT_HEADERS RSH,
          APPS.RCV_SHIPMENT_LINES RSL,
          APPS.MTL_SYSTEM_ITEMS_B MSI,
          APPS.PO_HEADERS_ALL PHA,
          APPS.ORG_ORGANIZATION_DEFINITIONS OOD,
          APPS.MTL_PARAMETERS MP,
          APPS.PO_LINES_ALL PLA,
          CLL.CLL_F189_ENTRY_OPERATIONS CFEO,
          CLL.CLL_F189_INVOICES CFI,
          CLL.CLL_F189_INVOICE_TYPES CFIT,--1336676
          apps.cll_f189_invoice_lines cfil
    WHERE     RSH.SHIPMENT_HEADER_ID = MS.SHIPMENT_HEADER_ID
          AND MS.SUPPLY_SOURCE_ID = MTS.SUPPLY_SOURCE_ID(+)
          AND RSH.SHIPMENT_HEADER_ID = RT.SHIPMENT_HEADER_ID
          AND MS.TO_ORGANIZATION_ID = MSI.ORGANIZATION_ID
          AND RT.SHIPMENT_LINE_ID = RSL.SHIPMENT_LINE_ID
          AND RT.TRANSACTION_ID = MS.SUPPLY_SOURCE_ID
          AND MSI.INVENTORY_ITEM_ID = RSL.ITEM_ID
          AND MS.TO_ORGANIZATION_ID = OOD.ORGANIZATION_ID
          AND MS.TO_ORGANIZATION_ID = MP.ORGANIZATION_ID
          AND RT.PO_HEADER_ID = PHA.PO_HEADER_ID(+)
          AND RT.PO_LINE_ID = PLA.PO_LINE_ID(+)
          AND TO_CHAR (CFEO.OPERATION_ID) =
                 (CASE
                     WHEN MP.WMS_ENABLED_FLAG = 'Y' THEN RSH.SHIPMENT_NUM
                     ELSE RSH.RECEIPT_NUM
                  END)
          AND CFEO.OPERATION_ID = CFI.OPERATION_ID(+)
          AND CFEO.ORGANIZATION_ID = CFI.ORGANIZATION_ID(+)
          AND CFI.INVOICE_TYPE_ID = CFIT.INVOICE_TYPE_ID(+)
          AND CFI.ORGANIZATION_ID = CFIT.ORGANIZATION_ID(+)
          AND MS.TO_ORGANIZATION_ID = CFEO.ORGANIZATION_ID(+)
          AND MS.QUANTITY > 0
          AND MS.SUPPLY_TYPE_CODE = 'RECEIVING'
          AND RT.TRANSACTION_TYPE IN ('ACCEPT',
                                      'MATCH',
                                      'RECEIVE',
                                      'REJECT',
                                      'RETURN TO RECEIVING',
                                      'TRANSFER')
          --
          AND cfil.invoice_id = cfi.invoice_id
          AND rsl.shipment_line_id = nvl(cfil.shipment_line_id(+),rsl.shipment_line_id)
          AND DECODE (RSL.SOURCE_DOCUMENT_CODE 
                        ,'REQ', RSL.REQUISITION_LINE_ID 
                        ,'PO' , RSL.PO_LINE_LOCATION_ID
                        ,'RMA', RSL.OE_ORDER_LINE_ID) = DECODE (RSL.SOURCE_DOCUMENT_CODE,'REQ',cfil.REQUISITION_LINE_ID 
                                                                                        ,'PO' ,cfil.line_location_id
                                                                                        ,'RMA',cfil.rma_interface_id)
