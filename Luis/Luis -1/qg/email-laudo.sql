                  SELECT DISTINCT NVL2(OOLA.ITEM_RELATIONSHIP_TYPE,'COMP','ACA')        TIPO_ARTICULO
                        ,NVL2(OOLA.ITEM_RELATIONSHIP_TYPE,2,1)                          ORDEN
                        ,TO_NUMBER(SALES_ORDER_LINE)                                    ORDEN_LINEA
                        ,MSIB.SEGMENT1 ||'-'||RCT.TRX_NUMBER||'-'||MTLN.LOT_NUMBER      CLAVE
                        ,MSIB.SEGMENT1 ||'-'||RCT.TRX_NUMBER||'-'||MTLN.LOT_NUMBER      CLAVE_DEP
                        ,DECODE(MTLN.TRANSACTION_SOURCE_TYPE_ID,5,'PRODUCCION',7,'TRANSFERENCIA','OTRO') TIPO_OPERACION
                        ,MSIB.SEGMENT1
                        ,MSIB.DESCRIPTION                                               DESCRIPTION
                        ,NULL                                                           DAT_PROD
                        ,tab_batchno.batch_no --GBH.BATCH_NO  OSM 26/03/2015 #VERSION 31
                        ,tab_batchno.BATCH_ID --GBH.BATCH_ID  OSM 26/03/2015 #VERSION 31
                        ,tab_batchno.ORGANIZATION_ID --RCL.WAREHOUSE_ID OSM 26/03/2015 #VERSION 33
                        ,MTLN.LOT_NUMBER
                        ,NULL                                                           FEC_EXP
                        ,RCT.TRX_NUMBER                                                 NOT_FIS
                        ,TO_CHAR(RCT.TRX_DATE ,'DD/MM/YYYY')                            FEC_NFIS
                        ,RBSA.GLOBAL_ATTRIBUTE3                                         SERIE
                        ,ABS(NVL( DELIV.SHIPPED_QUANTITY, RCL.QUANTITY_INVOICED)) || ' ' || RCL.UOM_CODE     CANT
                        ,RCL.UOM_CODE                                                   UOM
                        ,HP.PARTY_NAME                                                  NOM_CLI
                        ,HCA.ACCOUNT_NUMBER                                             CUSTOMER_NUMBER
                        ,CASE
                            WHEN MSIB.PLANNING_MAKE_BUY_CODE = 2 THEN
                               ( SELECT ASSA.COUNTRY
                                  FROM APPS.MTL_MATERIAL_TRANSACTIONS MMT
                                     , APPS.RCV_TRANSACTIONS RT
                                     , APPS.PO_HEADERS_ALL PHA
                                     , APPS.AP_SUPPLIER_SITES_ALL ASSA
                                     , APPS.AP_SUPPLIERS APS
                                 WHERE MMT.RCV_TRANSACTION_ID = RT.TRANSACTION_ID
                                   AND RT.PO_HEADER_ID = PHA.PO_HEADER_ID
                                   AND PHA.VENDOR_SITE_ID = ASSA.VENDOR_SITE_ID
                                   AND PHA.VENDOR_ID = APS.VENDOR_ID
                                   AND APS.VENDOR_ID = ASSA.VENDOR_ID
                                   AND MMT.INVENTORY_ITEM_ID = MSIB.INVENTORY_ITEM_ID
                                   AND MMT.ORGANIZATION_ID = MSIB.ORGANIZATION_ID
                                   AND TRANSACTION_SOURCE_ID = RBSA.BATCH_SOURCE_ID
                                )
                            WHEN MSIB.PLANNING_MAKE_BUY_CODE = 1 THEN
                                NULL
                         END                                                            FABRIC
                        ,CASE
                            WHEN MSIB.PLANNING_MAKE_BUY_CODE = 2 THEN
                               ( SELECT APS.VENDOR_NAME
                                  FROM APPS.MTL_MATERIAL_TRANSACTIONS MMT
                                     , APPS.RCV_TRANSACTIONS RT
                                     , APPS.PO_HEADERS_ALL PHA
                                     , APPS.AP_SUPPLIER_SITES_ALL ASSA
                                     , APPS.AP_SUPPLIERS APS
                                 WHERE MMT.RCV_TRANSACTION_ID = RT.TRANSACTION_ID
                                   AND RT.PO_HEADER_ID = PHA.PO_HEADER_ID
                                   AND PHA.VENDOR_SITE_ID = ASSA.VENDOR_SITE_ID
                                   AND PHA.VENDOR_ID = APS.VENDOR_ID
                                   AND APS.VENDOR_ID = ASSA.VENDOR_ID
                                   AND MMT.INVENTORY_ITEM_ID = MSIB.INVENTORY_ITEM_ID
                                   AND MMT.ORGANIZATION_ID = MSIB.ORGANIZATION_ID
                                   AND TRANSACTION_SOURCE_ID = RBSA.BATCH_SOURCE_ID
                                )
                            WHEN MSIB.PLANNING_MAKE_BUY_CODE = 1 THEN
                                NULL
                         END                                                        LOCAL
                        ,RCT.CUSTOMER_TRX_ID                                        TRX_ID
                        ,RCL.CUSTOMER_TRX_LINE_ID                                   TRX_LINE_ID
                        ,OOHA.ORDER_NUMBER                                          NUM_ORDEN
                        ,HP.PARTY_ID                                                PARTY_ID
                        ,MSIB.INVENTORY_ITEM_ID                                     INVENTORY_ITEM_ID
                        ,RCT.TRX_DATE
                        ,RCT.BILL_TO_SITE_USE_ID
                    FROM APPS.RA_CUSTOMER_TRX_LINES_ALL      RCL
                        ,APPS.MTL_MATERIAL_TRANSACTIONS      MMT
                        ,APPS.RA_CUSTOMER_TRX_ALL            RCT
                        ,APPS.RA_BATCH_SOURCES_ALL           RBSA
                        ,APPS.MTL_SYSTEM_ITEMS_B             MSIB
                        ,APPS.OE_ORDER_LINES_ALL             OOLA
                        ,APPS.OE_ORDER_HEADERS_ALL           OOHA
                        ,APPS.JL_BR_CUSTOMER_TRX_EXTS        SEFAZ
                        ,APPS.HZ_CUST_ACCOUNTS               HCA
                        ,APPS.HZ_PARTIES                     HP
                        ,APPS.MTL_TRANSACTION_LOT_NUMBERS    MTLN
                        --/*
                        ,(SELECT RCT.CUSTOMER_TRX_ID
                               , RCL.CUSTOMER_TRX_LINE_ID
                               , OHA.ORDER_NUMBER
                               , MSI.SEGMENT1
                               , WDD.LOT_NUMBER
                               , SUM(WDD.SHIPPED_QUANTITY)  SHIPPED_QUANTITY
                            FROM APPS.MTL_SYSTEM_ITEMS_B        MSI
                            ,    APPS.WSH_DELIVERY_DETAILS      WDD
                            ,    APPS.WSH_DELIVERY_ASSIGNMENTS  WDA
                            ,    APPS.WSH_NEW_DELIVERIES        WND
                            ,    APPS.OE_ORDER_LINES_ALL        OOLA
                            ,    APPS.OE_ORDER_HEADERS_ALL      OHA
                            ,    APPS.MTL_PARAMETERS            MTP
                            ,    APPS.RA_CUSTOMER_TRX_ALL       RCT
                            ,    APPS.RA_CUSTOMER_TRX_LINES_ALL RCL
                            WHERE WDD.INVENTORY_ITEM_ID         = MSI.INVENTORY_ITEM_ID (+)
                              AND WDD.ORGANIZATION_ID           = MSI.ORGANIZATION_ID (+)
                              AND WDD.DELIVERY_DETAIL_ID        = WDA.DELIVERY_DETAIL_ID
                              AND WDA.DELIVERY_ID               = WND.DELIVERY_ID
                              AND WDD.SOURCE_LINE_ID            = OOLA.LINE_ID
                              AND WDD.SOURCE_HEADER_ID          = OOLA.HEADER_ID
                              AND OHA.HEADER_ID                 = OOLA.HEADER_ID
                              AND WDD.SOURCE_CODE               = 'OE'
                              AND MTP.ORGANIZATION_ID           = MSI.ORGANIZATION_ID
                              AND WDD.REQUESTED_QUANTITY > 0
                              AND NVL(WDD.SHIPPED_QUANTITY,0) > 0
                              AND RCT.CUSTOMER_TRX_ID           = RCL.CUSTOMER_TRX_ID
                              AND RCL.INTERFACE_LINE_ATTRIBUTE6 = OOLA.LINE_ID
                              AND OHA.HEADER_ID                 = OOLA.HEADER_ID
                         GROUP BY RCT.CUSTOMER_TRX_ID
                                , RCL.CUSTOMER_TRX_LINE_ID
                                , OHA.ORDER_NUMBER
                                , MSI.SEGMENT1
                                , WDD.LOT_NUMBER                    )           DELIV,
                        -- OSM 26/03/2015 Inicio  #VERSION 31
                        (SELECT DISTINCT
                                GBH.BATCH_NO
                              , GBH.BATCH_ID
                              , MTLN.LOT_NUMBER
                              , msib.inventory_item_id
                              , msib.organization_id
                           FROM apps.MTL_TRANSACTION_LOT_NUMBERS      MTLN
                               ,apps.MTL_SYSTEM_ITEMS_B               MSIB
                               ,apps.MTL_LOT_NUMBERS                  MLN
                               ,apps.MTL_MATERIAL_TRANSACTIONS        MMT
                               ,apps.GME_BATCH_HEADER                 GBH
                               ,apps.GME_MATERIAL_DETAILS             GME
                          WHERE MTLN.INVENTORY_ITEM_ID    = MSIB.INVENTORY_ITEM_ID
                            AND MTLN.ORGANIZATION_ID      = MSIB.ORGANIZATION_ID
                            AND MTLN.TRANSACTION_SOURCE_TYPE_ID IN ( 5,7 )  -- Production y Transfer
                            AND MTLN.INVENTORY_ITEM_ID    = MLN.INVENTORY_ITEM_ID
                            AND MTLN.ORGANIZATION_ID      = MLN.ORGANIZATION_ID
                            AND MTLN.LOT_NUMBER           = MLN.LOT_NUMBER
                            AND MTLN.TRANSACTION_ID       = MMT.TRANSACTION_ID
                            AND MMT.TRANSACTION_SOURCE_ID = GBH.BATCH_ID (+)
                            AND GBH.BATCH_ID              = GME.BATCH_ID (+)
                            AND NVL(GBH.BATCH_STATUS,2) IN (2,3,4)
                            AND GME.INVENTORY_ITEM_ID     = MSIB.INVENTORY_ITEM_ID
                            AND GME.ORGANIZATION_ID       = MSIB.ORGANIZATION_ID
                            AND MSIB.ITEM_TYPE IN ('ACA','SEMI') )              tab_batchno
                       -- OSM 26/03/2015 Fim   #VERSION 31
                  WHERE RCT.CUSTOMER_TRX_ID               = RCL.CUSTOMER_TRX_ID
                    AND RCL.LINE_TYPE                     = 'LINE'
                    AND RCT.BATCH_SOURCE_ID               = RBSA.BATCH_SOURCE_ID
                    AND RCT.ORG_ID                        = RBSA.ORG_ID
                    AND RCL.INVENTORY_ITEM_ID             = MSIB.INVENTORY_ITEM_ID
                    AND RCL.WAREHOUSE_ID                  = MSIB.ORGANIZATION_ID
                    AND RCL.INTERFACE_LINE_ATTRIBUTE6 IS NOT NULL
                    AND RCL.INTERFACE_LINE_ATTRIBUTE6     = OOLA.LINE_ID
                    AND OOLA.HEADER_ID                    = OOHA.HEADER_ID
                    AND RCL.WAREHOUSE_ID                  = MMT.ORGANIZATION_ID
                    AND RCL.INVENTORY_ITEM_ID             = MMT.INVENTORY_ITEM_ID
                    AND OOLA.LINE_ID                      = MMT.TRX_SOURCE_LINE_ID
                    AND MMT.SOURCE_CODE                   = 'ORDER ENTRY'
                    AND RCT.CUSTOMER_TRX_ID               = SEFAZ.CUSTOMER_TRX_ID
                    AND RCT.BILL_TO_CUSTOMER_ID           = HCA.CUST_ACCOUNT_ID
                    AND HCA.PARTY_ID                      = HP.PARTY_ID
                    AND MMT.TRANSACTION_ID                = MTLN.TRANSACTION_ID
                    --
                    AND mmt.inventory_item_id             = mtln.inventory_item_id (+) -- OSM 26/03/2015 #VERSION 31
                    and tab_batchno.inventory_item_id (+) = mtln.inventory_item_id     -- OSM 26/03/2015 #VERSION 31
                    and tab_batchno.lot_number (+)        = mtln.lot_number            -- OSM 26/03/2015 #VERSION 31
                    --
                    AND RCT.CUSTOMER_TRX_ID               = DELIV.CUSTOMER_TRX_ID
                    AND RCL.CUSTOMER_TRX_LINE_ID          = DELIV.CUSTOMER_TRX_LINE_ID
                    AND OOHA.ORDER_NUMBER                 = DELIV.ORDER_NUMBER
                    AND NVL(MTLN.LOT_NUMBER,1)            = NVL(DELIV.LOT_NUMBER,1)        -- OSM 26/03/2015 #VERSION 31
                    --
--                    AND RCL.WAREHOUSE_ID                  = G_ORG_ID
                    AND RCT.TRX_NUMBER                    = '213' --G_TRX_NUMBER
--                    AND MSIB.SEGMENT1                     = NVL(G_SEGMENT1, MSIB.SEGMENT1)
                  ORDER BY RCT.CUSTOMER_TRX_ID, TO_NUMBER(SALES_ORDER_LINE)  ;

            SELECT EMAIL_ADDRESS, NVL(HPS.IDENTIFYING_ADDRESS_FLAG,'N')  IDENTIFYING_ADDRESS_FLAG, hcp.*
             FROM APPS.HZ_CONTACT_POINTS        HCP
                , APPS.HZ_PARTY_SITES           HPS
                , APPS.HZ_CUST_SITE_USES_ALL    HCSU
                , APPS.HZ_CUST_ACCT_SITES_ALL   HCAS
            WHERE HCP.OWNER_TABLE_NAME = 'HZ_PARTY_SITES'
              AND HCP.CONTACT_POINT_TYPE = 'EMAIL'
              AND HCP.CONTACT_POINT_PURPOSE = 'MAIL LAUDO'
              AND HCP.OWNER_TABLE_ID = HPS.PARTY_SITE_ID
              AND HCSU.CUST_ACCT_SITE_ID = HCAS.CUST_ACCT_SITE_ID
              AND HCAS.PARTY_SITE_ID = HPS.PARTY_SITE_ID
              AND HPS.PARTY_ID       = 64528 --v_party_id
              AND HCSU.SITE_USE_ID   = 14082 --v_BILL_TO_SITE_USE_ID
            ORDER BY HPS.IDENTIFYING_ADDRESS_FLAG DESC;

