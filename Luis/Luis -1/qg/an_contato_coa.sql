                     SELECT distinct rct.TRX_NUMBER,
                            RCT.TRX_DATE,
                            PARTY_NAME,
                            HCP1.EMAIL_ADDRESS,
                           -- MSI.SEGMENT1 ||'-'||RCL.CUSTOMER_TRX_LINE_ID||'-'||MTLN.LOT_NUMBER COA_FLAG,
                            HCP1.last_update_date,
                            COA.COA_FLAG
                       FROM APPS.HZ_CONTACT_POINTS           HCP1
                          , APPS.HZ_PARTY_SITES              HPS1
                          , APPS.HZ_CUST_SITE_USES_ALL       HCSU1
                          , APPS.HZ_CUST_ACCT_SITES_ALL      HCAS1
                          , APPS.HZ_PARTIES                  HP
                          , APPS.RA_CUSTOMER_TRX_ALL         RCT
                          , APPS.RA_CUSTOMER_TRX_LINES_ALL   RCL
                          , apps.XXPPG_COA_CTRL_EMISSAO      COA
                          , apps.mtl_system_items_b          msi
                          , APPS.MTL_MATERIAL_TRANSACTIONS   MMT
                          , APPS.MTL_TRANSACTION_LOT_NUMBERS MTLN
                          ,(SELECT WDA.DELIVERY_ID
                                 , DECODE(WDD.CURRENCY_CODE,'USD',WDD.DELIVERY_DETAIL_ID,NULL) DELIVERY_DETAIL_ID
                                 , WDD.ORGANIZATION_ID
                                 , WDD.INVENTORY_ITEM_ID
                                 , WDD.SOURCE_HEADER_ID
                                 , WDD.SOURCE_LINE_ID
                                 , WDD.SOURCE_HEADER_NUMBER ORDER_NUMBER
                                 , WDD.LOT_NUMBER
                                 , SUM(WDD.SHIPPED_QUANTITY)  SHIPPED_QUANTITY
                                  --
                              FROM APPS.WSH_DELIVERY_DETAILS      WDD
                                 , APPS.WSH_DELIVERY_ASSIGNMENTS  WDA
                                   --
                             WHERE WDD.REQUESTED_QUANTITY      > 0
                               AND NVL(WDD.SHIPPED_QUANTITY,0) > 0
                               AND WDD.DELIVERY_DETAIL_ID      = WDA.DELIVERY_DETAIL_ID
                               --AND WDA.DELIVERY_ID             = 29877021
                                   --
                             GROUP BY
                                  WDA.DELIVERY_ID
                                , DECODE(WDD.CURRENCY_CODE,'USD',WDD.DELIVERY_DETAIL_ID,NULL)
                                , WDD.ORGANIZATION_ID
                                , WDD.INVENTORY_ITEM_ID
                                , WDD.SOURCE_HEADER_ID
                                , WDD.SOURCE_LINE_ID
                                , WDD.SOURCE_HEADER_NUMBER
                                , WDD.LOT_NUMBER)           DELIV
                      WHERE HCP1.OWNER_TABLE_NAME      = 'HZ_PARTY_SITES'
                        AND HCP1.CONTACT_POINT_TYPE    = 'EMAIL'
                        AND HCP1.CONTACT_POINT_PURPOSE = 'MAIL LAUDO'
                        AND HCP1.STATUS                = 'A'
                        AND HCP1.OWNER_TABLE_ID        = HPS1.PARTY_SITE_ID
                        AND HCSU1.CUST_ACCT_SITE_ID    = HCAS1.CUST_ACCT_SITE_ID
                        AND HCAS1.PARTY_SITE_ID        = HPS1.PARTY_SITE_ID
                        AND HPS1.PARTY_ID              = hp.party_id
                        AND RCT.CUSTOMER_TRX_ID        = RCL.CUSTOMER_TRX_ID
                        AND HCSU1.SITE_USE_ID          = RCT.BILL_TO_SITE_USE_ID
                        and msi.inventory_item_id      = rcl.inventory_item_id
                        and msi.organization_id        = '92'
        AND RCL.INVENTORY_ITEM_ID             = DELIV.INVENTORY_ITEM_ID
        AND RCL.WAREHOUSE_ID                  = DELIV.ORGANIZATION_ID
        AND RCL.INTERFACE_LINE_ATTRIBUTE3     = DELIV.DELIVERY_ID
        AND RCL.INTERFACE_LINE_ATTRIBUTE1     = DELIV.ORDER_NUMBER
        AND RCL.INTERFACE_LINE_ATTRIBUTE6     = DELIV.SOURCE_LINE_ID
        --
        AND RCL.WAREHOUSE_ID                  = MMT.ORGANIZATION_ID
        AND RCL.INVENTORY_ITEM_ID             = MMT.INVENTORY_ITEM_ID
        --AND DELIV.DELIVERY_DETAIL_ID          = MMT.PICKING_LINE_ID
        AND DELIV.DELIVERY_ID                 = MMT.TRX_SOURCE_DELIVERY_ID
        AND MMT.TRANSACTION_ID                = MTLN.TRANSACTION_ID
        AND MMT.INVENTORY_ITEM_ID             = MTLN.INVENTORY_ITEM_ID
        AND MMT.ORGANIZATION_ID               = MTLN.ORGANIZATION_ID
                        and COA_KEY                 = MSI.SEGMENT1 ||'-'||RCL.CUSTOMER_TRX_LINE_ID||'-'||MTLN.LOT_NUMBER
                        AND HCSU1.SITE_USE_ID          = RCT.BILL_TO_SITE_USE_ID and HCP1.EMAIL_ADDRESS like '%;%'
                       -- AND rct.TRX_NUMBER = '325568'
                       --and msi.segment1 = 'FIRC-00020.22'
                      -- and UPPER(HCP1.EMAIL_ADDRESS) like '%DEERE%'
                      and party_name not like '%TOYOTA%'
                        and RCT.TRX_DATE >= sysdate - 1
                        order by 1;
                        
                        
                        
                         XCCE.COA_KEY = MSIB.SEGMENT1 ||'-'||RCL.CUSTOMER_TRX_LINE_ID||'-'||MTLN.LOT_NUMBER
                        
select * from apps.XXPPG_COA_CTRL_EMISSAO where coa_key = 'PPG3825-806.C3--118629840-SUM000043';                        


                     SELECT distinct HCP1.EMAIL_ADDRESS,
                                     HCP1.last_update_date,
                                     HP.PARTY_NAME,
                                     HCP1.STATUS,
                                     HPS1.PARTY_SITE_NUMBER
                       FROM APPS.HZ_CONTACT_POINTS           HCP1
                          , APPS.HZ_PARTY_SITES              HPS1
                          , APPS.HZ_CUST_SITE_USES_ALL       HCSU1
                          , APPS.HZ_CUST_ACCT_SITES_ALL      HCAS1
                          , APPS.HZ_PARTIES                  HP
                      WHERE HCP1.OWNER_TABLE_NAME      = 'HZ_PARTY_SITES'
                        AND HCP1.CONTACT_POINT_TYPE    = 'EMAIL'
                        AND HCP1.CONTACT_POINT_PURPOSE = 'MAIL LAUDO'
                        AND HCP1.STATUS                = 'A'
                        AND HCP1.OWNER_TABLE_ID        = HPS1.PARTY_SITE_ID
                        AND HCSU1.CUST_ACCT_SITE_ID    = HCAS1.CUST_ACCT_SITE_ID
                        AND HCAS1.PARTY_SITE_ID        = HPS1.PARTY_SITE_ID
                        AND HPS1.PARTY_ID              = hp.party_id
                        AND HCP1.EMAIL_ADDRESS like '%;%';