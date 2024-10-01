SELECT TR.GL_ACCOUNT,
       TR.COMP_CODE,
       TR.COST_CENTER,
       TR.PL,
       TR.LOCATION,
       TR.ASSET_NUMBER,
       TR.DESCRIPTION,
       TR.START_DATE,
       TR.UNITS,
       SUM(TR.COST) COST,
       SUM(TR.DEPRN_RESERVE) DEPRN_RESERVE,
       TR.TRANSNUM,
       TR.BOOK,  
       TR.TRANSACTION_DATE_ENTERED
  FROM (SELECT AD.ASSET_NUMBER ASSET_NUMBER,
               AD.DESCRIPTION DESCRIPTION,
               TH.TRANSACTION_HEADER_ID TRANSNUM,
               DECODE(TH.TRANSACTION_HEADER_ID,
                      DH.TRANSACTION_HEADER_ID_IN,
                      1,
                      DH.TRANSACTION_HEADER_ID_OUT,
                      0) TO_FROM,
               ASCC.SEGMENT4 GL_ACCOUNT, -- ACCT_FLEX_ACCT_SEG
               ASCC.SEGMENT1 COMP_CODE, --ACCT_FLEX_BAL_SEG COMP_CODE,
               ASCC.SEGMENT5 COST_CENTER, --ACCT_FLEX_COST_SEG COST_CENTER,
               ASCC.SEGMENT6 PL,
               LOC.SEGMENT1 || '-' || LOC.SEGMENT2 LOCATION, --- LOC_FLEX_ALL_SEG      
               TH.TRANSACTION_DATE_ENTERED START_DATE,
               DH.ASSIGNED_TO ASSIGNED_TO,
               ASCC.CODE_COMBINATION_ID CCID,
               SUM(CADJ.ADJUSTMENT_AMOUNT *
                   DECODE(CADJ.DEBIT_CREDIT_FLAG, 'CR', -1, 'DR', 1)) COST,
               0 DEPRN_RESERVE,
               SUM(DISTINCT DECODE(TH.TRANSACTION_HEADER_ID,
                          DH.TRANSACTION_HEADER_ID_IN,
                          1,
                          DH.TRANSACTION_HEADER_ID_OUT,
                          -1) * DH.UNITS_ASSIGNED) UNITS   
                   ,TH.BOOK_TYPE_CODE  BOOK  
                   ,TH.TRANSACTION_DATE_ENTERED  --PERIOD1_POD
               --    ,TH.TRANSACTION_DATE_ENTERED  PERIOD1_PCD
          FROM APPS.FA_LOCATIONS            LOC,
               APPS.FA_ADDITIONS            AD,
               APPS.GL_CODE_COMBINATIONS    ASCC,
               APPS.FA_DISTRIBUTION_HISTORY DH,
               APPS.FA_TRANSACTION_HEADERS  TH,
               APPS.FA_ADJUSTMENTS          CADJ
         WHERE 1=1-- TH.BOOK_TYPE_CODE = 'BRPPG FISCAL' --P_BOOK
           AND TH.TRANSACTION_TYPE_CODE = 'TRANSFER'
       --    AND TH.TRANSACTION_DATE_ENTERED >=
       --        TO_DATE('01-jan-2017', 'dd-mon-rrrr') -- PERIOD1_POD
        --   AND TH.TRANSACTION_DATE_ENTERED <=
        --       TO_DATE('31-jan-2017', 'dd-mon-rrrr') --PERIOD1_PCD
           AND NVL(TH.MASS_REFERENCE_ID, 0) = NVL(TH.MASS_REFERENCE_ID, 0)
           AND (TH.TRANSACTION_HEADER_ID = DH.TRANSACTION_HEADER_ID_IN OR
               TH.TRANSACTION_HEADER_ID = DH.TRANSACTION_HEADER_ID_OUT)
           AND AD.ASSET_ID = TH.ASSET_ID
           AND LOC.LOCATION_ID = DH.LOCATION_ID
           AND ASCC.CODE_COMBINATION_ID = DH.CODE_COMBINATION_ID
           AND CADJ.BOOK_TYPE_CODE =  TH.BOOK_TYPE_CODE--'BRPPG FISCAL' --P_BOOK
           AND CADJ.ASSET_ID = TH.ASSET_ID
           AND CADJ.DISTRIBUTION_ID = DH.DISTRIBUTION_ID
           AND CADJ.TRANSACTION_HEADER_ID = TH.TRANSACTION_HEADER_ID
           AND CADJ.SOURCE_TYPE_CODE = 'TRANSFER'
           AND CADJ.ADJUSTMENT_TYPE IN ('COST', 'CIP COST') --LP_WHERE_CLAUSE1
         GROUP BY TH.TRANSACTION_HEADER_ID,
                  DECODE(TH.TRANSACTION_HEADER_ID,
                         DH.TRANSACTION_HEADER_ID_IN,
                         1,
                         DH.TRANSACTION_HEADER_ID_OUT,
                         0),
                  DH.DISTRIBUTION_ID,
                  ASCC.SEGMENT1,
                  ASCC.SEGMENT4,
                  ASCC.SEGMENT5,
                  ASCC.SEGMENT6,
                  AD.ASSET_NUMBER,
                  AD.DESCRIPTION,
                  TH.TRANSACTION_DATE_ENTERED,
                  DH.ASSIGNED_TO,
                  ASCC.CODE_COMBINATION_ID,
                  LOC.SEGMENT1,  
                  TH.BOOK_TYPE_CODE,  
                  TH.TRANSACTION_DATE_ENTERED, 
                  LOC.SEGMENT2
        UNION
        SELECT AD.ASSET_NUMBER ASSET_NUMBER,
               AD.DESCRIPTION DESCRIPTION,
               TH.TRANSACTION_HEADER_ID TRANSNUM,
               DECODE(TH.TRANSACTION_HEADER_ID,
                      DH.TRANSACTION_HEADER_ID_IN,
                      1,
                      DH.TRANSACTION_HEADER_ID_OUT,
                      0) TO_FROM,
               ASCC.SEGMENT4 GL_ACCOUNT, -- ACCT_FLEX_ACCT_SEG
               ASCC.SEGMENT1 COMP_CODE, --ACCT_FLEX_BAL_SEG COMP_CODE,
               ASCC.SEGMENT5 COST_CENTER, --ACCT_FLEX_COST_SEG COST_CENTER,
               ASCC.SEGMENT6 PL,
               LOC.SEGMENT1 || '-' || LOC.SEGMENT2 LOCATION, --- LOC_FLEX_ALL_SEG 
               TH.TRANSACTION_DATE_ENTERED START_DATE,
               DH.ASSIGNED_TO ASSIGNED_TO,
               ASCC.CODE_COMBINATION_ID CCID,
               0 COST,
               SUM(NVL(RADJ.ADJUSTMENT_AMOUNT, 0) *
                   DECODE(NVL(RADJ.DEBIT_CREDIT_FLAG, 'CR'),
                          'CR',
                          1,
                          'DR',
                          -1)) DEPRN_RESERVE,
               SUM(DISTINCT DECODE(TH.TRANSACTION_HEADER_ID,
                          DH.TRANSACTION_HEADER_ID_IN,
                          1,
                          DH.TRANSACTION_HEADER_ID_OUT,
                          -1) * DH.UNITS_ASSIGNED) UNITS
                   ,TH.BOOK_TYPE_CODE  BOOK  
                   ,TH.TRANSACTION_DATE_ENTERED  
           --        ,TH.TRANSACTION_DATE_ENTERED  PERIOD1_PCD
          FROM APPS.FA_LOCATIONS            LOC,
               APPS.FA_ADDITIONS            AD,
               APPS.GL_CODE_COMBINATIONS    ASCC,
               APPS.FA_DISTRIBUTION_HISTORY DH,
               APPS.FA_TRANSACTION_HEADERS  TH,
               APPS.FA_ADJUSTMENTS          RADJ
         WHERE 1=1 --TH.BOOK_TYPE_CODE = 'BRPPG FISCAL' --P_BOOK
           AND TH.TRANSACTION_TYPE_CODE = 'TRANSFER'
      --     AND TH.TRANSACTION_DATE_ENTERED >=
      --         TO_DATE('01-jan-2017', 'dd-mon-rrrr') --PERIOD1_POD
      --     AND TH.TRANSACTION_DATE_ENTERED <=
      --         TO_DATE('31-jan-2017', 'dd-mon-rrrr') -- PERIOD1_PCD
           AND NVL(TH.MASS_REFERENCE_ID, 0) = NVL(TH.MASS_REFERENCE_ID, 0)
              --       NVL(P_MASS_REF_ID, NVL(TH.MASS_REFERENCE_ID, 0))
           AND (TH.TRANSACTION_HEADER_ID = DH.TRANSACTION_HEADER_ID_IN OR
               TH.TRANSACTION_HEADER_ID = DH.TRANSACTION_HEADER_ID_OUT)
           AND AD.ASSET_ID = TH.ASSET_ID
           AND LOC.LOCATION_ID = DH.LOCATION_ID
           AND ASCC.CODE_COMBINATION_ID = DH.CODE_COMBINATION_ID
           AND RADJ.BOOK_TYPE_CODE = TH.BOOK_TYPE_CODE--'BRPPG FISCAL' --P_BOOK
           AND RADJ.ASSET_ID = TH.ASSET_ID
           AND RADJ.DISTRIBUTION_ID = DH.DISTRIBUTION_ID
           AND RADJ.SOURCE_TYPE_CODE = 'TRANSFER'
           AND RADJ.ADJUSTMENT_TYPE = 'RESERVE'
           AND RADJ.TRANSACTION_HEADER_ID = TH.TRANSACTION_HEADER_ID
         GROUP BY TH.TRANSACTION_HEADER_ID,
                  DECODE(TH.TRANSACTION_HEADER_ID,
                         DH.TRANSACTION_HEADER_ID_IN,
                         1,
                         DH.TRANSACTION_HEADER_ID_OUT,
                         0),
                  DH.DISTRIBUTION_ID,
                  ASCC.SEGMENT1,
                  ASCC.SEGMENT4,
                  ASCC.SEGMENT5,
                  ASCC.SEGMENT6,
                  AD.ASSET_NUMBER,
                  AD.DESCRIPTION,
                  TH.TRANSACTION_DATE_ENTERED,
                  DH.ASSIGNED_TO,
                  ASCC.CODE_COMBINATION_ID,
                  LOC.SEGMENT1,  
                  TH.BOOK_TYPE_CODE,  
                  TH.TRANSACTION_DATE_ENTERED, 
                  LOC.SEGMENT2) TR
 WHERE 1 = 1
 GROUP BY TR.GL_ACCOUNT,
          TR.COMP_CODE,
          TR.COST_CENTER,
          TR.LOCATION,
          TR.PL,
          TR.ASSET_NUMBER,
          TR.DESCRIPTION,
          TR.START_DATE,
          TR.UNITS,
          TRANSNUM,
          TR.BOOK,  
          TR.TRANSACTION_DATE_ENTERED
 ORDER BY 6, 7, 1, 2, 3, 4, 5, 8