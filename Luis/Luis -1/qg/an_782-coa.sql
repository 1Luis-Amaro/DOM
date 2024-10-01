         SELECT LOT_NUMBER, DATE_DRAWN, ORIGINATION_DATE, SAMPLE_ID, SAMPLE_NO, EXPIRATION_DATE
           FROM(SELECT DISTINCT
                   LOT.LOT_NUMBER
                 , GS.DATE_DRAWN
                 , TO_CHAR(TRUNC(LOT.ORIGINATION_DATE),'DD/MM/YYYY') ORIGINATION_DATE
                 , GS.SAMPLE_ID
                 , GS.SAMPLE_NO
                 , TO_CHAR(TRUNC(LOT.EXPIRATION_DATE),'DD/MM/YYYY')  EXPIRATION_DATE
                 , NVL((select NVL2(GBGB.group_name,0,1) 
                          from GME_BATCH_GROUPS_ASSOCIATION GBGA,
                               GME_BATCH_GROUPS_B           GBGB,
                               GME_BATCH_GROUPS_ASSOCIATION GBGAS
                         where GBGA.BATCH_ID  = GBH.BATCH_ID  AND
                               GBGB.GROUP_ID  = GBGA.GROUP_ID AND
                               GBGAS.GROUP_ID = GBGA.GROUP_ID AND 
                               GBGAS.BATCH_ID = GS.BATCH_ID   AND
                               ROWNUM         = 1),1) GRUPO
              FROM MTL_TRANSACTION_LOT_NUMBERS      MTLN
                  ,MTL_SYSTEM_ITEMS_B               MSIB
                  ,MTL_LOT_NUMBERS                  LOT
                  ,MTL_MATERIAL_TRANSACTIONS        MMT
                  ,GME_BATCH_HEADER                 GBH
                  ,GMD_SAMPLES                      GS
                  ,GMD_SAMPLE_SPEC_DISP             GSSD
             WHERE MTLN.INVENTORY_ITEM_ID    = MSIB.INVENTORY_ITEM_ID
               AND MTLN.ORGANIZATION_ID      = MSIB.ORGANIZATION_ID
               AND MTLN.TRANSACTION_SOURCE_TYPE_ID IN ( 5,7 )  --Production - Transfer
               AND MSIB.ITEM_TYPE                  IN ('ACA','SEMI')
               AND MTLN.INVENTORY_ITEM_ID    = LOT.INVENTORY_ITEM_ID
               AND MTLN.ORGANIZATION_ID      = LOT.ORGANIZATION_ID
               AND MTLN.LOT_NUMBER           = LOT.LOT_NUMBER
               AND MTLN.TRANSACTION_ID       = MMT.TRANSACTION_ID
               AND MMT.TRANSACTION_SOURCE_ID = GBH.BATCH_ID
               AND NVL(GBH.BATCH_STATUS,2)         IN (2,3,4)
               AND LOT.LOT_NUMBER            = GS.LOT_NUMBER  (+)
               AND LOT.INVENTORY_ITEM_ID     = GS.INVENTORY_ITEM_ID (+)
               AND GS.SAMPLE_ID              = GSSD.SAMPLE_ID (+)
               AND GSSD.DELETE_MARK          = 0
               AND GSSD.DISPOSITION                IN ('4A', '5AV')
               AND MTLN.ORGANIZATION_ID      = 92
               AND MSIB.SEGMENT1             = 'PPG2004-899A'
               AND GBH.BATCH_NO              = 56730
            ORDER BY 7, 2 DESC);
         WHERE ROWNUM = 1;
         
         
SELECT GBH.BATCH_NO, A.*
  FROM gme_batch_groups_association a,
       gme_batch_groups_b           b,
       GME_BATCH_HEADER             GBH
 WHERE a.GROUP_ID = b.GROUP_ID AND
       b.group_name LIKE 'PPG2004-899A/56739' AND
       A.BATCH_ID    = GBH.BATCH_ID         
         
         
         
                SELECT DISTINCT GBH.BATCH_NO, sum(mmt.transaction_quantity)
                  FROM MTL_TRANSACTION_LOT_NUMBERS      MTLN
                      ,MTL_SYSTEM_ITEMS_B               MSIB
                      ,MTL_LOT_NUMBERS                  MLN
                      ,MTL_MATERIAL_TRANSACTIONS        MMT
                      ,GME_BATCH_HEADER                 GBH
                      ,GME_MATERIAL_DETAILS             GME
                 WHERE MTLN.INVENTORY_ITEM_ID = MSIB.INVENTORY_ITEM_ID
                   AND MTLN.ORGANIZATION_ID = MSIB.ORGANIZATION_ID
                   AND MTLN.TRANSACTION_SOURCE_TYPE_ID IN ( 5,7 )  -- Production y Transfer
                   AND MTLN.INVENTORY_ITEM_ID = MLN.INVENTORY_ITEM_ID
                   AND MTLN.ORGANIZATION_ID = MLN.ORGANIZATION_ID
                   AND MTLN.LOT_NUMBER = MLN.LOT_NUMBER
                   AND MTLN.TRANSACTION_ID = MMT.TRANSACTION_ID
                   AND MMT.TRANSACTION_SOURCE_ID = GBH.BATCH_ID (+)
                   AND GBH.BATCH_ID = GME.BATCH_ID (+)
                   AND NVL(GBH.BATCH_STATUS,2) IN (2,3,4)
                   AND GME.INVENTORY_ITEM_ID = MSIB.INVENTORY_ITEM_ID
                   AND GME.ORGANIZATION_ID = MSIB.ORGANIZATION_ID
                   AND MSIB.ITEM_TYPE IN ('ACA','SEMI')
                   AND MTLN.ORGANIZATION_ID = 92
                   AND MSIB.SEGMENT1 = 'PPG2004-899A.49'
                   AND MTLN.LOT_NUMBER = 'SUM000124'
                HAVING sum(mmt.transaction_quantity) > 0   --Added BY OSS for Infra 3944371
                GROUP BY GBH.BATCH_NO;         
                
                
   SELECT DISTINCT --gs.*,
                   LOT.LOT_NUMBER
                 , GS.DATE_DRAWN
                 , TO_CHAR(TRUNC(LOT.ORIGINATION_DATE),'DD/MM/YYYY') ORIGINATION_DATE
                 , GS.SAMPLE_ID
                 , GS.SAMPLE_NO
                 , TO_CHAR(TRUNC(LOT.EXPIRATION_DATE),'DD/MM/YYYY')  EXPIRATION_DATE
                 , NVL((select NVL2(GBGB.group_name,0,1) 
                      from GME_BATCH_GROUPS_ASSOCIATION GBGA,
                           GME_BATCH_GROUPS_B           GBGB,
                           GME_BATCH_GROUPS_ASSOCIATION GBGAS
                     where GBGA.BATCH_ID  = GBH.BATCH_ID  AND
                           GBGB.GROUP_ID  = GBGA.GROUP_ID AND
                           GBGAS.GROUP_ID = GBGA.GROUP_ID AND 
                           GBGAS.BATCH_ID = GS.BATCH_ID),1) GRUPO
                 --, GBGB.group_name
              FROM MTL_TRANSACTION_LOT_NUMBERS      MTLN
                  ,MTL_SYSTEM_ITEMS_B               MSIB
                  ,MTL_LOT_NUMBERS                  LOT
                  ,MTL_MATERIAL_TRANSACTIONS        MMT
                  ,GME_BATCH_HEADER                 GBH
                  ,GMD_SAMPLES                      GS
                  ,GMD_SAMPLE_SPEC_DISP             GSSD
             WHERE MTLN.INVENTORY_ITEM_ID    = MSIB.INVENTORY_ITEM_ID
               AND MTLN.ORGANIZATION_ID      = MSIB.ORGANIZATION_ID
               AND MTLN.TRANSACTION_SOURCE_TYPE_ID IN ( 5,7 )  --Production - Transfer
               AND MSIB.ITEM_TYPE                  IN ('ACA','SEMI')
               AND MTLN.INVENTORY_ITEM_ID    = LOT.INVENTORY_ITEM_ID
               AND MTLN.ORGANIZATION_ID      = LOT.ORGANIZATION_ID
               AND MTLN.LOT_NUMBER           = LOT.LOT_NUMBER
               AND MTLN.TRANSACTION_ID       = MMT.TRANSACTION_ID
               AND MMT.TRANSACTION_SOURCE_ID = GBH.BATCH_ID
               AND NVL(GBH.BATCH_STATUS,2)  IN (2,3,4)
               AND LOT.LOT_NUMBER            = GS.LOT_NUMBER  (+)
               AND LOT.INVENTORY_ITEM_ID     = GS.INVENTORY_ITEM_ID (+)
               AND GS.SAMPLE_ID              = GSSD.SAMPLE_ID (+)
               AND GSSD.DELETE_MARK          = 0
               AND GSSD.DISPOSITION                IN ('4A', '5AV')
               AND MTLN.ORGANIZATION_ID      = 92
               AND MSIB.SEGMENT1             = 'PPG2004-899A'
               AND GBH.BATCH_NO              = 56730
            ORDER BY  2 DESC                
            
            
                    select GBGB.group_name 
                      from GME_BATCH_GROUPS_ASSOCIATION GBGA,
                           GME_BATCH_GROUPS_B           GBGB,
                           GME_BATCH_GROUPS_ASSOCIATION GBGAS
                     where GBGB.GROUP_ID  = GBGA.GROUP_ID AND
                           GBGB.GROUP_ID  = GBGA.GROUP_ID AND
                           GBGAS.GROUP_ID = GBGA.GROUP_ID AND 
                           GBGAS.BATCH_ID = GS.BATCH_ID;           