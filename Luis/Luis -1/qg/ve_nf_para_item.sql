SELECT mtp.organization_code, RCT.CUSTOMER_TRX_ID
                   , RCL.CUSTOMER_TRX_LINE_ID
                   , rct.trx_number
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
                WHERE WDD.INVENTORY_ITEM_ID         = MSI.INVENTORY_ITEM_ID
                  AND WDD.ORGANIZATION_ID           = MSI.ORGANIZATION_ID
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
                  and msi.segment1 = '26800005L.01'
             GROUP BY RCT.CUSTOMER_TRX_ID
                    , RCL.CUSTOMER_TRX_LINE_ID
                    , rct.trx_number
                    , OHA.ORDER_NUMBER
                    , MSI.SEGMENT1
                    , WDD.LOT_NUMBER
                    , mtp.organization_code;