      SELECT DISTINCT 
             rct.customer_trx_id
            ,trx_number
            ,rct.trx_date
            ,hp.party_name
            ,ood.organization_code
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
            ,APPS.org_organization_definitions   ood 
            --
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
            --
            (select *
               from (SELECT GBH.BATCH_NO
                          , GBH.BATCH_ID
                          , MTLN.LOT_NUMBER
                          , msib.inventory_item_id
                          , msib.organization_id
                          , sum(mtln.primary_quantity) primary_quantity
                       FROM apps.MTL_TRANSACTION_LOT_NUMBERS      MTLN
                           ,apps.MTL_SYSTEM_ITEMS_B               MSIB
                           ,apps.MTL_LOT_NUMBERS                  MLN
                           ,apps.MTL_MATERIAL_TRANSACTIONS        MMT
                           ,apps.GME_BATCH_HEADER                 GBH
                           ,apps.GME_MATERIAL_DETAILS             GME
                      WHERE MTLN.INVENTORY_ITEM_ID    = MSIB.INVENTORY_ITEM_ID
                        AND MTLN.ORGANIZATION_ID      = MSIB.ORGANIZATION_ID
                        AND MTLN.TRANSACTION_SOURCE_TYPE_ID IN ( 5,7 )
                        AND MTLN.INVENTORY_ITEM_ID    = MLN.INVENTORY_ITEM_ID
                        AND MTLN.ORGANIZATION_ID      = MLN.ORGANIZATION_ID
                        AND MTLN.LOT_NUMBER           = MLN.LOT_NUMBER
                        AND MTLN.TRANSACTION_ID       = MMT.TRANSACTION_ID
                        AND MMT.TRANSACTION_SOURCE_ID = GBH.BATCH_ID (+)
                        AND GBH.BATCH_ID              = GME.BATCH_ID (+)
                        AND NVL(GBH.BATCH_STATUS,2) IN (2,3,4)
                        AND GME.INVENTORY_ITEM_ID     = MSIB.INVENTORY_ITEM_ID
                        AND GME.ORGANIZATION_ID       = MSIB.ORGANIZATION_ID
                        AND MSIB.ITEM_TYPE IN ('ACA','SEMI')
                        group by GBH.BATCH_NO
                          , GBH.BATCH_ID
                          , MTLN.LOT_NUMBER
                          , msib.inventory_item_id
                          , msib.organization_id)
                 where primary_quantity > 0 )              tab_batchno
           -- 
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
         AND mmt.inventory_item_id             = mtln.inventory_item_id (+)
         and tab_batchno.inventory_item_id (+) = mtln.inventory_item_id    
         and tab_batchno.lot_number (+)        = mtln.lot_number           
         --
         AND RCT.CUSTOMER_TRX_ID               = DELIV.CUSTOMER_TRX_ID
         AND RCL.CUSTOMER_TRX_LINE_ID          = DELIV.CUSTOMER_TRX_LINE_ID
         AND OOHA.ORDER_NUMBER                 = DELIV.ORDER_NUMBER
         AND NVL(MTLN.LOT_NUMBER,1)            = NVL(DELIV.LOT_NUMBER,1)   
         AND ood.organization_id               = rcl.warehouse_id 
         --
         AND trunc(RCT.TRX_DATE) > (trunc(sysdate) - 135)
         
        AND hp.party_name LIKE '%EQUIPE CORES%'
         --AND hp.party_name LIKE '%INTEGRAR%'
         --AND hp.party_name LIKE '%SIMILAR%'
         --AND hp.party_name LIKE '%FMC%'
         --AND hp.party_name LIKE '%SMARTCOAT%'
        --AND hp.party_name LIKE '%ODEBRECHT%'
         --AND hp.party_name LIKE '%ENGEBASA%'
         --AND hp.party_name LIKE '%TRANSOCEAN%'
         --AND hp.party_name LIKE '%IESA%'
         --
         AND exists (SELECT 1
                       FROM APPS.HZ_CONTACT_POINTS      HCP1
                          , APPS.HZ_PARTY_SITES         HPS1
                          , APPS.HZ_CUST_SITE_USES_ALL  HCSU1
                          , APPS.HZ_CUST_ACCT_SITES_ALL HCAS1
                      WHERE HCP1.OWNER_TABLE_NAME      = 'HZ_PARTY_SITES'
                        AND HCP1.CONTACT_POINT_TYPE    = 'EMAIL'
                        AND HCP1.CONTACT_POINT_PURPOSE = 'MAIL LAUDO'
                        AND HCP1.STATUS                = 'A'
                        AND HCP1.OWNER_TABLE_ID        = HPS1.PARTY_SITE_ID
                        AND HCSU1.CUST_ACCT_SITE_ID    = HCAS1.CUST_ACCT_SITE_ID
                        AND HCAS1.PARTY_SITE_ID        = HPS1.PARTY_SITE_ID
                        AND HPS1.PARTY_ID              = hp.party_id
                        AND HCSU1.SITE_USE_ID          = RCT.BILL_TO_SITE_USE_ID );

