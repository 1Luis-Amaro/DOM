SELECT * from APPS.HZ_PARTIES                PARTY where party_name like '%MAX PAC TERC%';

select * from apps.mtl_onhand_quantities inv where organization_id = 103;

select * from apps.mtl_parameters;

  SELECT TT.NAME, SUBSTR(PARTY.PARTY_NAME,1,5) || '.' || HCASA.GLOBAL_ATTRIBUTE3 "Endereco",
  
         
  
         oel.unit_selling_price,
         
         oel.reference_line_id,
         oel.reference_header_id,
         
         --oel.return_attibute1,
         --oel.return_attibute2,
         
         oel.split_from_line_id,
         oel.invoiced_quantity,
         rt.quantity,
         oel.reference_customer_trx_line_id,
         oel.line_set_id,
         oel.unit_cost,
         OEL.inventory_item_id,
         wdd.inventory_item_id,
         wdd.lot_number,
         mil.organization_id,
         OEL.SHIP_FROM_ORG_ID,
         oel.*
  
    FROM APPS.OE_ORDER_HEADERS_ALL      OEH, --Cabeçalho Ordem de Venda
         APPS.OE_ORDER_LINES_ALL        OEL, --Linhas Ordem de Venda
         APPS.MTL_PARAMETERS            MP,  --Organização de Inventário
         APPS.OE_TRANSACTION_TYPES_TL   TT,
         --APPS.OE_WORKFLOW_ASSIGNMENTS   WF,
         --APPS.WF_RUNNABLE_PROCESSES_V   WFD,
         APPS.HZ_LOCATIONS              HL,         
         APPS.HZ_CUST_SITE_USES_ALL     HCSUA,
         APPS.HZ_CUST_ACCT_SITES_ALL    HCASA,
         APPS.HZ_PARTY_SITES            HPS,
         APPS.HZ_CUST_ACCOUNTS          CUST_ACCT,
         APPS.HZ_PARTIES                PARTY,
         APPS.FND_USER                  USERS,
         
         
         APPS.RA_CUSTOMER_TRX_ALL H,
         APPS.RA_CUSTOMER_TRX_LINES_ALL L,
         APPS.RA_BATCH_SOURCES_ALL SOURCE,
         
         APPS.RCV_TRANSACTIONS RT,
         APPS.RCV_SHIPMENT_HEADERS SHIPM,
         APPS.CLL_F189_INVOICES INV,
         APPS.wsh_delivery_details wdd,
         apps.MTL_ITEM_LOCATIONS mil                  
         
   WHERE     OEH.CREATED_BY           = USERS.USER_ID
   
  -- AND oel.reference_line_id = 118057
   
         AND mil.description like SUBSTR(PARTY.PARTY_NAME,1,5) || '.' || HCASA.GLOBAL_ATTRIBUTE3 || '%'
         --AND mil.organization_id    = OEL.SHIP_FROM_ORG_ID
         
         AND OEL.SHIP_FROM_ORG_ID     = MP.ORGANIZATION_ID
         
         AND OEL.reference_LINE_id    = wdd.source_line_id
         
         AND H.CUSTOMER_TRX_ID        = L.CUSTOMER_TRX_ID
         AND L.CUSTOMER_TRX_LINE_ID   = OEL.REFERENCE_CUSTOMER_TRX_LINE_ID
         AND H.BATCH_SOURCE_ID        = SOURCE.BATCH_SOURCE_ID
         AND H.ORG_ID                 = SOURCE.ORG_ID
         
         
         AND RT.OE_ORDER_LINE_ID         = OEL.LINE_ID
        -- AND RT.SOURCE_DOCUMENT_CODE  = 'RMA'
         AND RT.TRANSACTION_TYPE      = 'RECEIVE'
         AND SHIPM.SHIPMENT_HEADER_ID = RT.SHIPMENT_HEADER_ID         
         AND SHIPM.RECEIPT_NUM        = INV.OPERATION_ID
         AND SHIPM.ORGANIZATION_ID    = INV.ORGANIZATION_ID
         AND HPS.LOCATION_ID          = HL.LOCATION_ID
         AND HCSUA.SITE_USE_CODE      = 'SHIP_TO'         
         AND HCSUA.CUST_ACCT_SITE_ID  = HCASA.CUST_ACCT_SITE_ID
         AND HCASA.PARTY_SITE_ID      = HPS.PARTY_SITE_ID
         AND HPS.PARTY_ID             = PARTY.PARTY_ID         
         AND OEH.SHIP_TO_ORG_ID       = HCSUA.SITE_USE_ID
         AND CUST_ACCT.PARTY_ID       = PARTY.PARTY_ID
         AND OEH.SOLD_TO_ORG_ID       = CUST_ACCT.CUST_ACCOUNT_ID
         AND OEH.HEADER_ID            = OEL.HEADER_ID
         AND OEL.LINE_TYPE_ID         = TT.TRANSACTION_TYPE_ID
         AND TT.LANGUAGE              = 'PTB'
         
         AND PARTY.party_name like '%MAX PAC TERC%'
         
        -- AND TT.NAME LIKE '%RMA%'
--ORDER BY OEH.ORDER_NUMBER,OEL.LINE_NUMBER || '.' || OEL.SHIPMENT_NUMBER;
;

/* Formatted on 26/08/2016 11:06:44 (QP5 v5.227.12220.39724) */
SELECT ROWID,
       INVENTORY_LOCATION_ID,
       ORGANIZATION_ID,
       LAST_UPDATE_DATE,
       LAST_UPDATED_BY,
       CREATION_DATE,
       CREATED_BY,
       LAST_UPDATE_LOGIN,
       DESCRIPTION,
       inventory_location_type,
       DESCRIPTIVE_TEXT,
       STATUS_ID,
       SUBINVENTORY_CODE,
       PICKING_ORDER,
       DROPPING_ORDER,
       ALIAS,
       DISABLE_DATE,
       PHYSICAL_LOCATION_CODE,
       LOCATION_MAXIMUM_UNITS,
       LOCATION_CURRENT_UNITS,
       LOCATION_SUGGESTED_UNITS,
       LOCATION_AVAILABLE_UNITS,
       VOLUME_UOM_CODE,
       MAX_CUBIC_AREA,
       CURRENT_CUBIC_AREA,
       SUGGESTED_CUBIC_AREA,
       AVAILABLE_CUBIC_AREA,
       LOCATION_WEIGHT_UOM_CODE,
       MAX_WEIGHT,
       CURRENT_WEIGHT,
       SUGGESTED_WEIGHT,
       AVAILABLE_WEIGHT,
       PROJECT_ID,
       TASK_ID,
       INVENTORY_ACCOUNT_ID,
       SEGMENT1,
       SEGMENT2,
       SEGMENT3,
       SEGMENT4,
       SEGMENT5,
       SEGMENT6,
       SEGMENT7,
       SEGMENT8,
       SEGMENT9,
       SEGMENT10,
       SEGMENT11,
       SEGMENT12,
       SEGMENT13,
       SEGMENT14,
       SEGMENT15,
       SEGMENT16,
       SEGMENT17,
       SEGMENT18,
       SEGMENT19,
       SEGMENT20,
       SUMMARY_FLAG,
       ENABLED_FLAG,
       START_DATE_ACTIVE,
       END_DATE_ACTIVE,
       ATTRIBUTE_CATEGORY,
       ATTRIBUTE1,
       ATTRIBUTE2,
       ATTRIBUTE3,
       ATTRIBUTE4,
       ATTRIBUTE5,
       ATTRIBUTE6,
       ATTRIBUTE7,
       ATTRIBUTE8,
       ATTRIBUTE9,
       ATTRIBUTE10,
       ATTRIBUTE11,
       ATTRIBUTE12,
       ATTRIBUTE13,
       ATTRIBUTE14,
       ATTRIBUTE15,
       REQUEST_ID,
       PROGRAM_APPLICATION_ID,
       PROGRAM_ID,
       PROGRAM_UPDATE_DATE,
       PICK_UOM_CODE,
       DIMENSION_UOM_CODE,
       LENGTH,
       WIDTH,
       HEIGHT,
       X_COORDINATE,
       Y_COORDINATE,
       Z_COORDINATE
  FROM apps.MTL_ITEM_LOCATIONS
 WHERE (ORGANIZATION_ID = 103) and description like 'MAX P%';
 
 
 
 
          (SELECT H.TRX_NUMBER || ' - ' || SOURCE.NAME
            FROM APPS.RA_CUSTOMER_TRX_ALL H,
                 APPS.RA_CUSTOMER_TRX_LINES_ALL L,
                 APPS.RA_BATCH_SOURCES_ALL SOURCE
           WHERE     H.CUSTOMER_TRX_ID = L.CUSTOMER_TRX_ID
                 AND L.CUSTOMER_TRX_LINE_ID = OEL.REFERENCE_CUSTOMER_TRX_LINE_ID
                 AND H.BATCH_SOURCE_ID = SOURCE.BATCH_SOURCE_ID
                 AND H.ORG_ID          = SOURCE.ORG_ID
         (SELECT H.TRX_NUMBER || ' - ' || SOURCE.NAME
            FROM APPS.RA_CUSTOMER_TRX_ALL H,
                 APPS.RA_CUSTOMER_TRX_LINES_ALL L,
                 APPS.RA_BATCH_SOURCES_ALL SOURCE
           WHERE     H.CUSTOMER_TRX_ID = L.CUSTOMER_TRX_ID
                 AND L.INTERFACE_LINE_ATTRIBUTE6 = OEL.LINE_ID
                 AND L.LINE_TYPE                 = 'LINE'
                 AND TO_CHAR (OEH.ORDER_NUMBER)  = H.INTERFACE_HEADER_ATTRIBUTE1
                 AND H.INTERFACE_HEADER_CONTEXT  = 'NF ENTRADA AR'
                 AND H.BATCH_SOURCE_ID           = SOURCE.BATCH_SOURCE_ID
                 AND H.ORG_ID                    = SOURCE.ORG_ID) "NF RECUSA",
         (SELECT    'NUM RECEBIMENTO: '
                 || SHIPM.RECEIPT_NUM
                 || ' - NUM NF ENT: '
                 || INV.INVOICE_NUM
            FROM APPS.RCV_TRANSACTIONS RT,
                 APPS.RCV_SHIPMENT_HEADERS SHIPM,
                 APPS.CLL_F189_INVOICES INV
           WHERE     OE_ORDER_LINE_ID = OEL.LINE_ID
                 AND RT.SOURCE_DOCUMENT_CODE = 'RMA'
                 AND RT.TRANSACTION_TYPE = 'RECEIVE'
                 AND SHIPM.SHIPMENT_HEADER_ID = RT.SHIPMENT_HEADER_ID
                 AND SHIPM.RECEIPT_NUM = INV.OPERATION_ID
                 AND SHIPM.ORGANIZATION_ID = INV.ORGANIZATION_ID
                 AND ROWNUM = 1)                        "DETALHE REC FISCAL",
         (SELECT 'SIM'
            FROM APPS.RCV_TRANSACTIONS
           WHERE     OE_ORDER_LINE_ID = OEL.LINE_ID
                 AND SOURCE_DOCUMENT_CODE = 'RMA'
                 AND TRANSACTION_TYPE = 'DELIVER')
            "REC FISICO CONCLUIDO ?",
         (SELECT 'SIM'
            FROM APPS.RA_INTERFACE_LINES_ALL
           WHERE     INTERFACE_LINE_CONTEXT = 'ORDER ENTRY'
                 AND INTERFACE_LINE_ATTRIBUTE1 = TO_CHAR (OEH.ORDER_NUMBER)
                 AND INTERFACE_LINE_ATTRIBUTE2 = TT.NAME
                 AND INTERFACE_LINE_ATTRIBUTE6 = OEL.LINE_ID
                 AND SALES_ORDER = OEH.ORDER_NUMBER
                 AND LINE_TYPE = 'LINE')                "RMA INSERIDO INT NF ?",
         (SELECT H.TRX_NUMBER
            FROM APPS.RA_CUSTOMER_TRX_ALL H, APPS.RA_CUSTOMER_TRX_LINES_ALL L
           WHERE     H.CUSTOMER_TRX_ID = L.CUSTOMER_TRX_ID
                 AND L.INTERFACE_LINE_ATTRIBUTE6 = OEL.LINE_ID
                 AND L.LINE_TYPE = 'LINE'
                 AND TO_CHAR (OEH.ORDER_NUMBER) = H.INTERFACE_HEADER_ATTRIBUTE1
                 AND H.INTERFACE_HEADER_CONTEXT = 'ORDER ENTRY'
                 AND ROWNUM = 1)                        "NUM AVISO CREDITO"  
